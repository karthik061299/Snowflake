_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Bronze Layer Stored Procedure Pipeline for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- Bronze Layer Ingestion Stored Procedure Pipeline
-- Inventory Management System - Medallion Architecture
-- =====================================================

-- =====================================================
-- 1. AUDIT TABLE CREATION
-- =====================================================

CREATE TABLE IF NOT EXISTS Bronze.bz_ingestion_audit (
    ingestion_id NUMBER AUTOINCREMENT PRIMARY KEY,
    source_system STRING NOT NULL,
    table_name STRING NOT NULL,
    start_timestamp TIMESTAMP_NTZ NOT NULL,
    end_timestamp TIMESTAMP_NTZ,
    records_ingested NUMBER DEFAULT 0,
    records_failed NUMBER DEFAULT 0,
    execution_status STRING NOT NULL, -- 'SUCCESS', 'FAILED', 'RUNNING'
    user_identity STRING NOT NULL,
    error_message STRING,
    processing_time_seconds NUMBER,
    created_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- 2. ERROR TABLE CREATION
-- =====================================================

CREATE TABLE IF NOT EXISTS Bronze.bz_ingestion_errors (
    error_id NUMBER AUTOINCREMENT PRIMARY KEY,
    ingestion_id NUMBER,
    source_table STRING NOT NULL,
    error_type STRING NOT NULL, -- 'DATA_TYPE_MISMATCH', 'NULL_CONSTRAINT', 'VALIDATION_ERROR'
    error_description STRING,
    rejected_record VARIANT,
    error_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- 3. UTILITY PROCEDURE - LOG AUDIT EVENT
-- =====================================================

CREATE OR REPLACE PROCEDURE Bronze.log_audit_event(
    p_source_system STRING,
    p_table_name STRING,
    p_status STRING,
    p_records_ingested NUMBER DEFAULT 0,
    p_records_failed NUMBER DEFAULT 0,
    p_error_message STRING DEFAULT NULL
)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
DECLARE
    v_ingestion_id NUMBER;
    v_user_identity STRING;
BEGIN
    -- Get current user
    v_user_identity := CURRENT_USER();
    
    -- Insert audit record
    INSERT INTO Bronze.bz_ingestion_audit (
        source_system,
        table_name,
        start_timestamp,
        end_timestamp,
        records_ingested,
        records_failed,
        execution_status,
        user_identity,
        error_message,
        processing_time_seconds
    )
    VALUES (
        p_source_system,
        p_table_name,
        CURRENT_TIMESTAMP(),
        CURRENT_TIMESTAMP(),
        p_records_ingested,
        p_records_failed,
        p_status,
        v_user_identity,
        p_error_message,
        0
    );
    
    SELECT LAST_INSERT_ID() INTO v_ingestion_id;
    RETURN v_ingestion_id;
END;
$$;

-- =====================================================
-- 4. UTILITY PROCEDURE - LOG ERROR
-- =====================================================

CREATE OR REPLACE PROCEDURE Bronze.log_error(
    p_ingestion_id NUMBER,
    p_source_table STRING,
    p_error_type STRING,
    p_error_description STRING,
    p_rejected_record VARIANT DEFAULT NULL
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    INSERT INTO Bronze.bz_ingestion_errors (
        ingestion_id,
        source_table,
        error_type,
        error_description,
        rejected_record
    )
    VALUES (
        p_ingestion_id,
        p_source_table,
        p_error_type,
        p_error_description,
        p_rejected_record
    );
    
    RETURN 'Error logged successfully';
END;
$$;

-- =====================================================
-- 5. MAIN BRONZE INGESTION STORED PROCEDURE
-- =====================================================

CREATE OR REPLACE PROCEDURE Bronze.ingest_inventory_data(
    p_source_database STRING DEFAULT 'SOURCE_DB',
    p_source_schema STRING DEFAULT 'INVENTORY_MGMT',
    p_load_type STRING DEFAULT 'FULL' -- 'FULL' or 'INCREMENTAL'
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_start_time TIMESTAMP_NTZ;
    v_end_time TIMESTAMP_NTZ;
    v_processing_time NUMBER;
    v_total_records NUMBER DEFAULT 0;
    v_total_errors NUMBER DEFAULT 0;
    v_result_message STRING;
    v_ingestion_id NUMBER;
    v_records_processed NUMBER;
    v_sql_statement STRING;
    v_error_message STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    
    -- Log start of overall process
    CALL Bronze.log_audit_event('INVENTORY_MGMT', 'ALL_TABLES', 'RUNNING', 0, 0, NULL);
    
    -- =====================================================
    -- INGEST PRODUCTS TABLE
    -- =====================================================
    BEGIN
        IF p_load_type = 'FULL' THEN
            TRUNCATE TABLE Bronze.bz_products;
        END IF;
        
        INSERT INTO Bronze.bz_products (
            product_id, product_name, category,
            load_timestamp, update_timestamp, source_system
        )
        SELECT 
            Product_ID, Product_Name, Category,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Products');
        
        GET DIAGNOSTICS v_records_processed = ROW_COUNT;
        v_total_records := v_total_records + v_records_processed;
        
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_products', 'SUCCESS', v_records_processed, 0, NULL);
        
    EXCEPTION
        WHEN OTHER THEN
            GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
            v_total_errors := v_total_errors + 1;
            CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_products', 'FAILED', 0, 1, v_error_message);
    END;
    
    -- =====================================================
    -- INGEST SUPPLIERS TABLE
    -- =====================================================
    BEGIN
        IF p_load_type = 'FULL' THEN
            TRUNCATE TABLE Bronze.bz_suppliers;
        END IF;
        
        INSERT INTO Bronze.bz_suppliers (
            supplier_id, supplier_name, contact_number, product_id,
            load_timestamp, update_timestamp, source_system
        )
        SELECT 
            Supplier_ID, Supplier_Name, Contact_Number, Product_ID,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Suppliers');
        
        GET DIAGNOSTICS v_records_processed = ROW_COUNT;
        v_total_records := v_total_records + v_records_processed;
        
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_suppliers', 'SUCCESS', v_records_processed, 0, NULL);
        
    EXCEPTION
        WHEN OTHER THEN
            GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
            v_total_errors := v_total_errors + 1;
            CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_suppliers', 'FAILED', 0, 1, v_error_message);
    END;
    
    -- =====================================================
    -- INGEST WAREHOUSES TABLE
    -- =====================================================
    BEGIN
        IF p_load_type = 'FULL' THEN
            TRUNCATE TABLE Bronze.bz_warehouses;
        END IF;
        
        INSERT INTO Bronze.bz_warehouses (
            warehouse_id, location, capacity,
            load_timestamp, update_timestamp, source_system
        )
        SELECT 
            Warehouse_ID, Location, Capacity,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Warehouses');
        
        GET DIAGNOSTICS v_records_processed = ROW_COUNT;
        v_total_records := v_total_records + v_records_processed;
        
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_warehouses', 'SUCCESS', v_records_processed, 0, NULL);
        
    EXCEPTION
        WHEN OTHER THEN
            GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
            v_total_errors := v_total_errors + 1;
            CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_warehouses', 'FAILED', 0, 1, v_error_message);
    END;
    
    -- =====================================================
    -- INGEST INVENTORY TABLE
    -- =====================================================
    BEGIN
        IF p_load_type = 'FULL' THEN
            TRUNCATE TABLE Bronze.bz_inventory;
        END IF;
        
        INSERT INTO Bronze.bz_inventory (
            inventory_id, product_id, quantity_available, warehouse_id,
            load_timestamp, update_timestamp, source_system
        )
        SELECT 
            Inventory_ID, Product_ID, Quantity_Available, Warehouse_ID,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Inventory');
        
        GET DIAGNOSTICS v_records_processed = ROW_COUNT;
        v_total_records := v_total_records + v_records_processed;
        
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_inventory', 'SUCCESS', v_records_processed, 0, NULL);
        
    EXCEPTION
        WHEN OTHER THEN
            GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
            v_total_errors := v_total_errors + 1;
            CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_inventory', 'FAILED', 0, 1, v_error_message);
    END;
    
    -- =====================================================
    -- INGEST ORDERS TABLE
    -- =====================================================
    BEGIN
        IF p_load_type = 'FULL' THEN
            TRUNCATE TABLE Bronze.bz_orders;
        END IF;
        
        INSERT INTO Bronze.bz_orders (
            order_id, customer_id, order_date,
            load_timestamp, update_timestamp, source_system
        )
        SELECT 
            Order_ID, Customer_ID, Order_Date,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Orders');
        
        GET DIAGNOSTICS v_records_processed = ROW_COUNT;
        v_total_records := v_total_records + v_records_processed;
        
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_orders', 'SUCCESS', v_records_processed, 0, NULL);
        
    EXCEPTION
        WHEN OTHER THEN
            GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
            v_total_errors := v_total_errors + 1;
            CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_orders', 'FAILED', 0, 1, v_error_message);
    END;
    
    -- =====================================================
    -- INGEST ORDER_DETAILS TABLE
    -- =====================================================
    BEGIN
        IF p_load_type = 'FULL' THEN
            TRUNCATE TABLE Bronze.bz_order_details;
        END IF;
        
        INSERT INTO Bronze.bz_order_details (
            order_detail_id, order_id, product_id, quantity_ordered,
            load_timestamp, update_timestamp, source_system
        )
        SELECT 
            Order_Detail_ID, Order_ID, Product_ID, Quantity_Ordered,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Order_Details');
        
        GET DIAGNOSTICS v_records_processed = ROW_COUNT;
        v_total_records := v_total_records + v_records_processed;
        
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_order_details', 'SUCCESS', v_records_processed, 0, NULL);
        
    EXCEPTION
        WHEN OTHER THEN
            GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
            v_total_errors := v_total_errors + 1;
            CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_order_details', 'FAILED', 0, 1, v_error_message);
    END;
    
    -- =====================================================
    -- INGEST SHIPMENTS TABLE
    -- =====================================================
    BEGIN
        IF p_load_type = 'FULL' THEN
            TRUNCATE TABLE Bronze.bz_shipments;
        END IF;
        
        INSERT INTO Bronze.bz_shipments (
            shipment_id, order_id, shipment_date,
            load_timestamp, update_timestamp, source_system
        )
        SELECT 
            Shipment_ID, Order_ID, Shipment_Date,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Shipments');
        
        GET DIAGNOSTICS v_records_processed = ROW_COUNT;
        v_total_records := v_total_records + v_records_processed;
        
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_shipments', 'SUCCESS', v_records_processed, 0, NULL);
        
    EXCEPTION
        WHEN OTHER THEN
            GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
            v_total_errors := v_total_errors + 1;
            CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_shipments', 'FAILED', 0, 1, v_error_message);
    END;
    
    -- =====================================================
    -- INGEST RETURNS TABLE
    -- =====================================================
    BEGIN
        IF p_load_type = 'FULL' THEN
            TRUNCATE TABLE Bronze.bz_returns;
        END IF;
        
        INSERT INTO Bronze.bz_returns (
            return_id, order_id, return_reason,
            load_timestamp, update_timestamp, source_system
        )
        SELECT 
            Return_ID, Order_ID, Return_Reason,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Returns');
        
        GET DIAGNOSTICS v_records_processed = ROW_COUNT;
        v_total_records := v_total_records + v_records_processed;
        
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_returns', 'SUCCESS', v_records_processed, 0, NULL);
        
    EXCEPTION
        WHEN OTHER THEN
            GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
            v_total_errors := v_total_errors + 1;
            CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_returns', 'FAILED', 0, 1, v_error_message);
    END;
    
    -- =====================================================
    -- INGEST STOCK_LEVELS TABLE
    -- =====================================================
    BEGIN
        IF p_load_type = 'FULL' THEN
            TRUNCATE TABLE Bronze.bz_stock_levels;
        END IF;
        
        INSERT INTO Bronze.bz_stock_levels (
            stock_level_id, warehouse_id, product_id, reorder_threshold,
            load_timestamp, update_timestamp, source_system
        )
        SELECT 
            Stock_Level_ID, Warehouse_ID, Product_ID, Reorder_Threshold,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Stock_Levels');
        
        GET DIAGNOSTICS v_records_processed = ROW_COUNT;
        v_total_records := v_total_records + v_records_processed;
        
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_stock_levels', 'SUCCESS', v_records_processed, 0, NULL);
        
    EXCEPTION
        WHEN OTHER THEN
            GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
            v_total_errors := v_total_errors + 1;
            CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_stock_levels', 'FAILED', 0, 1, v_error_message);
    END;
    
    -- =====================================================
    -- INGEST CUSTOMERS TABLE
    -- =====================================================
    BEGIN
        IF p_load_type = 'FULL' THEN
            TRUNCATE TABLE Bronze.bz_customers;
        END IF;
        
        INSERT INTO Bronze.bz_customers (
            customer_id, customer_name, email,
            load_timestamp, update_timestamp, source_system
        )
        SELECT 
            Customer_ID, Customer_Name, Email,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Customers');
        
        GET DIAGNOSTICS v_records_processed = ROW_COUNT;
        v_total_records := v_total_records + v_records_processed;
        
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_customers', 'SUCCESS', v_records_processed, 0, NULL);
        
    EXCEPTION
        WHEN OTHER THEN
            GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
            v_total_errors := v_total_errors + 1;
            CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_customers', 'FAILED', 0, 1, v_error_message);
    END;
    
    -- =====================================================
    -- FINAL PROCESSING AND SUMMARY
    -- =====================================================
    v_end_time := CURRENT_TIMESTAMP();
    v_processing_time := DATEDIFF(SECOND, v_start_time, v_end_time);
    
    -- Log final summary
    IF v_total_errors = 0 THEN
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'ALL_TABLES', 'SUCCESS', v_total_records, v_total_errors, NULL);
        v_result_message := 'Bronze ingestion completed successfully. Total records processed: ' || v_total_records || '. Processing time: ' || v_processing_time || ' seconds.';
    ELSE
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'ALL_TABLES', 'PARTIAL_SUCCESS', v_total_records, v_total_errors, 'Some tables failed to load');
        v_result_message := 'Bronze ingestion completed with errors. Total records processed: ' || v_total_records || '. Total errors: ' || v_total_errors || '. Processing time: ' || v_processing_time || ' seconds.';
    END IF;
    
    RETURN v_result_message;
    
EXCEPTION
    WHEN OTHER THEN
        GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'ALL_TABLES', 'FAILED', 0, 1, v_error_message);
        RETURN 'Bronze ingestion failed: ' || v_error_message;
END;
$$;

-- =====================================================
-- 6. INCREMENTAL INGESTION PROCEDURE (USING MERGE)
-- =====================================================

CREATE OR REPLACE PROCEDURE Bronze.ingest_inventory_data_incremental(
    p_source_database STRING DEFAULT 'SOURCE_DB',
    p_source_schema STRING DEFAULT 'INVENTORY_MGMT',
    p_table_name STRING
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_records_processed NUMBER;
    v_error_message STRING;
BEGIN
    -- Example for Products table using MERGE
    IF p_table_name = 'PRODUCTS' THEN
        MERGE INTO Bronze.bz_products AS target
        USING (
            SELECT Product_ID, Product_Name, Category 
            FROM IDENTIFIER(p_source_database || '.' || p_source_schema || '.Products')
        ) AS source
        ON target.product_id = source.Product_ID
        WHEN MATCHED THEN UPDATE SET
            product_name = source.Product_Name,
            category = source.Category,
            update_timestamp = CURRENT_TIMESTAMP()
        WHEN NOT MATCHED THEN INSERT (
            product_id, product_name, category, 
            load_timestamp, update_timestamp, source_system
        )
        VALUES (
            source.Product_ID, source.Product_Name, source.Category,
            CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'INVENTORY_MGMT'
        );
    END IF;
    
    GET DIAGNOSTICS v_records_processed = ROW_COUNT;
    
    CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_' || LOWER(p_table_name), 'SUCCESS', v_records_processed, 0, NULL);
    
    RETURN 'Incremental ingestion completed for ' || p_table_name || '. Records processed: ' || v_records_processed;
    
EXCEPTION
    WHEN OTHER THEN
        GET DIAGNOSTICS EXCEPTION v_error_message = MESSAGE_TEXT;
        CALL Bronze.log_audit_event('INVENTORY_MGMT', 'bz_' || LOWER(p_table_name), 'FAILED', 0, 1, v_error_message);
        RETURN 'Incremental ingestion failed for ' || p_table_name || ': ' || v_error_message;
END;
$$;

-- =====================================================
-- 7. PERFORMANCE OPTIMIZATION RECOMMENDATIONS
-- =====================================================

/*
PERFORMANCE OPTIMIZATION RECOMMENDATIONS:

1. CLUSTERING KEYS:
   - Apply clustering on frequently queried columns
   - Example: ALTER TABLE Bronze.bz_orders CLUSTER BY (order_date, customer_id);
   - Example: ALTER TABLE Bronze.bz_inventory CLUSTER BY (warehouse_id, product_id);

2. WAREHOUSE SIZING:
   - Use XS or S warehouses for Bronze ingestion
   - Scale up only for large batch loads
   - Enable auto-suspend and auto-resume

3. MICRO-PARTITIONING:
   - Snowflake automatically micro-partitions data
   - Order data by commonly filtered columns during ingestion
   - Consider date-based partitioning for time-series data

4. STREAMS AND TASKS FOR INCREMENTAL LOADING:
   - Create streams on source tables for change data capture
   - Use tasks to schedule incremental loads
   - Example:
     CREATE STREAM products_stream ON TABLE SOURCE_DB.INVENTORY_MGMT.Products;
     CREATE TASK bronze_products_task
     WAREHOUSE = 'BRONZE_WH'
     SCHEDULE = 'USING CRON 0 */4 * * * UTC'
     AS CALL Bronze.ingest_inventory_data_incremental('SOURCE_DB', 'INVENTORY_MGMT', 'PRODUCTS');

5. QUERY OPTIMIZATION:
   - Use appropriate WHERE clauses to leverage clustering
   - Avoid SELECT * in production queries
   - Use LIMIT for development and testing

6. STORAGE OPTIMIZATION:
   - Use TRANSIENT tables for temporary processing
   - Implement data retention policies
   - Monitor storage usage and costs

7. SECURITY BEST PRACTICES:
   - Use role-based access control
   - Implement row-level security where needed
   - Use secure views for sensitive data
   - Store credentials in Snowflake secrets or external key management
*/

-- =====================================================
-- 8. USAGE EXAMPLES
-- =====================================================

/*
USAGE EXAMPLES:

1. Full Load (Initial Setup):
   CALL Bronze.ingest_inventory_data('SOURCE_DB', 'INVENTORY_MGMT', 'FULL');

2. Incremental Load:
   CALL Bronze.ingest_inventory_data('SOURCE_DB', 'INVENTORY_MGMT', 'INCREMENTAL');

3. Single Table Incremental:
   CALL Bronze.ingest_inventory_data_incremental('SOURCE_DB', 'INVENTORY_MGMT', 'PRODUCTS');

4. Check Audit Logs:
   SELECT * FROM Bronze.bz_ingestion_audit 
   WHERE start_timestamp >= CURRENT_DATE() 
   ORDER BY start_timestamp DESC;

5. Check Error Logs:
   SELECT * FROM Bronze.bz_ingestion_errors 
   WHERE error_timestamp >= CURRENT_DATE() 
   ORDER BY error_timestamp DESC;

6. Monitor Processing Performance:
   SELECT 
       table_name,
       AVG(processing_time_seconds) as avg_processing_time,
       SUM(records_ingested) as total_records,
       COUNT(*) as execution_count
   FROM Bronze.bz_ingestion_audit 
   WHERE start_timestamp >= DATEADD(day, -7, CURRENT_DATE())
   GROUP BY table_name
   ORDER BY avg_processing_time DESC;
*/

-- =====================================================
-- 9. MONITORING AND ALERTING QUERIES
-- =====================================================

/*
MONITORING QUERIES:

1. Failed Ingestions in Last 24 Hours:
   SELECT * FROM Bronze.bz_ingestion_audit 
   WHERE execution_status = 'FAILED' 
   AND start_timestamp >= DATEADD(hour, -24, CURRENT_TIMESTAMP());

2. Data Freshness Check:
   SELECT 
       table_name,
       MAX(end_timestamp) as last_successful_load,
       DATEDIFF(hour, MAX(end_timestamp), CURRENT_TIMESTAMP()) as hours_since_last_load
   FROM Bronze.bz_ingestion_audit 
   WHERE execution_status = 'SUCCESS'
   GROUP BY table_name
   HAVING hours_since_last_load > 24;

3. Error Rate by Table:
   SELECT 
       table_name,
       COUNT(*) as total_executions,
       SUM(CASE WHEN execution_status = 'FAILED' THEN 1 ELSE 0 END) as failed_executions,
       (failed_executions / total_executions * 100) as error_rate_percent
   FROM Bronze.bz_ingestion_audit 
   WHERE start_timestamp >= DATEADD(day, -30, CURRENT_DATE())
   GROUP BY table_name
   ORDER BY error_rate_percent DESC;
*/

-- =====================================================
-- 10. API COST CALCULATION
-- =====================================================
-- apiCost: 0.075

-- =====================================================
-- End of Bronze Layer Stored Procedure Pipeline
-- =====================================================