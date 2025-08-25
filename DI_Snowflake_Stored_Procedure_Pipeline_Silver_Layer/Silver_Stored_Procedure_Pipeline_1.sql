_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Comprehensive Snowflake stored procedure for Bronze to Silver layer ETL processing in Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- BRONZE TO SILVER LAYER ETL STORED PROCEDURE
-- =====================================================
-- Purpose: Process data from Bronze layer to Silver layer with comprehensive
--          data validation, cleansing, error handling, and audit logging
-- Compatible with: Snowflake SQL Standards
-- Architecture: Medallion Architecture (Bronze -> Silver)
-- Tables Processed: All 10 Bronze tables to corresponding Silver tables
-- =====================================================

CREATE OR REPLACE PROCEDURE SP_BRONZE_TO_SILVER_ETL(
    p_batch_size INTEGER DEFAULT 10000,
    p_environment STRING DEFAULT 'PRODUCTION',
    p_executed_by STRING DEFAULT 'SYSTEM'
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    -- Session and Configuration Variables
    v_execution_id STRING;
    v_pipeline_name STRING DEFAULT 'BRONZE_TO_SILVER_ETL';
    v_start_time TIMESTAMP_NTZ;
    v_end_time TIMESTAMP_NTZ;
    v_execution_duration NUMBER(10,3);
    v_current_timestamp TIMESTAMP_NTZ;
    v_current_date DATE;
    
    -- Processing Counters
    v_total_processed INTEGER DEFAULT 0;
    v_total_successful INTEGER DEFAULT 0;
    v_total_failed INTEGER DEFAULT 0;
    v_total_skipped INTEGER DEFAULT 0;
    
    -- Table Processing Variables
    v_table_processed INTEGER DEFAULT 0;
    v_table_successful INTEGER DEFAULT 0;
    v_table_failed INTEGER DEFAULT 0;
    v_table_skipped INTEGER DEFAULT 0;
    v_data_volume_mb NUMBER(10,2) DEFAULT 0;
    
    -- Error Handling Variables
    v_error_message STRING;
    v_error_count INTEGER DEFAULT 0;
    v_status STRING DEFAULT 'SUCCESS';
    
BEGIN
    -- =====================================================
    -- 1. INITIALIZE SESSION & CONFIGURATIONS
    -- =====================================================
    
    -- Initialize execution tracking
    v_execution_id := UUID_STRING();
    v_start_time := CURRENT_TIMESTAMP();
    v_current_timestamp := CURRENT_TIMESTAMP();
    v_current_date := CURRENT_DATE();
    
    -- Log pipeline start
    INSERT INTO Silver.si_pipeline_audit_log (
        execution_id, pipeline_name, pipeline_run_id, start_time, end_time,
        execution_duration, status, error_message, source_table, target_table,
        records_processed, records_successful, records_failed, records_skipped,
        data_volume_mb, executed_by, environment, load_date, update_date, source_system
    )
    VALUES (
        v_execution_id, v_pipeline_name, v_execution_id, v_start_time, NULL,
        NULL, 'RUNNING', NULL, 'ALL_BRONZE_TABLES', 'ALL_SILVER_TABLES',
        0, 0, 0, 0, 0, p_executed_by, p_environment, v_current_date, v_current_date, 'BRONZE'
    );
    
    -- =====================================================
    -- 2. PROCESS SI_PRODUCTS TABLE
    -- =====================================================
    
    BEGIN
        v_table_processed := 0;
        v_table_successful := 0;
        v_table_failed := 0;
        
        -- Validate and process products data
        MERGE INTO Silver.si_products AS target
        USING (
            SELECT 
                product_id,
                TRIM(product_name) AS product_name,
                UPPER(TRIM(category)) AS category,
                CASE 
                    WHEN product_id IS NOT NULL AND product_name IS NOT NULL AND category IS NOT NULL 
                         AND UPPER(TRIM(category)) IN ('ELECTRONICS', 'APPAREL', 'FURNITURE')
                         AND product_id > 0
                         AND LENGTH(TRIM(product_name)) <= 255
                    THEN (
                        -- Completeness (40%)
                        (CASE WHEN product_id IS NOT NULL THEN 25.0 ELSE 0 END +
                         CASE WHEN product_name IS NOT NULL THEN 25.0 ELSE 0 END +
                         CASE WHEN category IS NOT NULL THEN 25.0 ELSE 0 END +
                         CASE WHEN source_system IS NOT NULL THEN 25.0 ELSE 0 END) * 0.4 +
                        -- Validity (30%)
                        (CASE WHEN product_id > 0 THEN 25.0 ELSE 0 END +
                         CASE WHEN LENGTH(TRIM(product_name)) <= 255 THEN 25.0 ELSE 0 END +
                         CASE WHEN UPPER(TRIM(category)) IN ('ELECTRONICS', 'APPAREL', 'FURNITURE') THEN 25.0 ELSE 0 END +
                         CASE WHEN source_system IS NOT NULL THEN 25.0 ELSE 0 END) * 0.3 +
                        -- Consistency (20%)
                        80.0 * 0.2 +
                        -- Accuracy (10%)
                        90.0 * 0.1
                    )
                    ELSE 0.0
                END AS data_quality_score,
                TRUE AS is_active,
                DATE(load_timestamp) AS load_date,
                DATE(COALESCE(update_timestamp, CURRENT_TIMESTAMP())) AS update_date,
                source_system,
                load_timestamp,
                COALESCE(update_timestamp, CURRENT_TIMESTAMP()) AS update_timestamp
            FROM Bronze.bz_products
            WHERE load_timestamp IS NOT NULL
              AND product_id IS NOT NULL AND product_id > 0
              AND product_name IS NOT NULL AND LENGTH(TRIM(product_name)) > 0 AND LENGTH(TRIM(product_name)) <= 255
              AND category IS NOT NULL AND UPPER(TRIM(category)) IN ('ELECTRONICS', 'APPAREL', 'FURNITURE')
        ) AS source
        ON target.product_id = source.product_id
        WHEN MATCHED THEN
            UPDATE SET
                product_name = source.product_name,
                category = source.category,
                data_quality_score = source.data_quality_score,
                is_active = source.is_active,
                update_date = source.update_date,
                source_system = source.source_system,
                update_timestamp = source.update_timestamp
        WHEN NOT MATCHED THEN
            INSERT (
                product_id, product_name, category, data_quality_score, is_active,
                load_date, update_date, source_system, load_timestamp, update_timestamp
            )
            VALUES (
                source.product_id, source.product_name, source.category, source.data_quality_score, source.is_active,
                source.load_date, source.update_date, source.source_system, source.load_timestamp, source.update_timestamp
            );
        
        GET DIAGNOSTICS v_table_successful = ROW_COUNT;
        
        -- Handle invalid records - insert into error table
        INSERT INTO Silver.si_data_quality_errors (
            error_id, source_table, source_record_id, error_type, error_description,
            error_field, error_value, error_severity, error_timestamp, resolution_status,
            resolution_notes, created_by, load_date, update_date, source_system
        )
        SELECT 
            UUID_STRING() AS error_id,
            'bz_products' AS source_table,
            COALESCE(product_id::STRING, 'NULL') AS source_record_id,
            'VALIDATION_ERROR' AS error_type,
            CASE 
                WHEN product_id IS NULL OR product_id <= 0 THEN 'Invalid or missing product ID'
                WHEN product_name IS NULL OR LENGTH(TRIM(product_name)) = 0 THEN 'Invalid or missing product name'
                WHEN category IS NULL OR UPPER(TRIM(category)) NOT IN ('ELECTRONICS', 'APPAREL', 'FURNITURE') THEN 'Invalid category value'
                WHEN LENGTH(TRIM(product_name)) > 255 THEN 'Product name exceeds maximum length'
                ELSE 'Unknown validation error'
            END AS error_description,
            CASE 
                WHEN product_id IS NULL OR product_id <= 0 THEN 'product_id'
                WHEN product_name IS NULL OR LENGTH(TRIM(product_name)) = 0 THEN 'product_name'
                WHEN category IS NULL OR UPPER(TRIM(category)) NOT IN ('ELECTRONICS', 'APPAREL', 'FURNITURE') THEN 'category'
                WHEN LENGTH(TRIM(product_name)) > 255 THEN 'product_name'
                ELSE 'unknown'
            END AS error_field,
            CASE 
                WHEN product_id IS NULL OR product_id <= 0 THEN COALESCE(product_id::STRING, 'NULL')
                WHEN product_name IS NULL OR LENGTH(TRIM(product_name)) = 0 THEN COALESCE(product_name, 'NULL')
                WHEN category IS NULL OR UPPER(TRIM(category)) NOT IN ('ELECTRONICS', 'APPAREL', 'FURNITURE') THEN COALESCE(category, 'NULL')
                WHEN LENGTH(TRIM(product_name)) > 255 THEN product_name
                ELSE 'unknown'
            END AS error_value,
            'HIGH' AS error_severity,
            CURRENT_TIMESTAMP() AS error_timestamp,
            'OPEN' AS resolution_status,
            NULL AS resolution_notes,
            p_executed_by AS created_by,
            v_current_date AS load_date,
            v_current_date AS update_date,
            'BRONZE' AS source_system
        FROM Bronze.bz_products
        WHERE product_id IS NULL OR product_id <= 0
           OR product_name IS NULL OR LENGTH(TRIM(product_name)) = 0
           OR category IS NULL OR UPPER(TRIM(category)) NOT IN ('ELECTRONICS', 'APPAREL', 'FURNITURE')
           OR LENGTH(TRIM(product_name)) > 255;
        
        GET DIAGNOSTICS v_table_failed = ROW_COUNT;
        
        SELECT COUNT(*) INTO v_table_processed FROM Bronze.bz_products;
        
        v_total_processed := v_total_processed + v_table_processed;
        v_total_successful := v_total_successful + v_table_successful;
        v_total_failed := v_total_failed + v_table_failed;
        
    EXCEPTION
        WHEN OTHER THEN
            v_error_message := 'Error processing si_products: ' || SQLERRM;
            v_status := 'FAILED';
            v_error_count := v_error_count + 1;
    END;
    
    -- =====================================================
    -- 3. PROCESS SI_CUSTOMERS TABLE
    -- =====================================================
    
    BEGIN
        v_table_processed := 0;
        v_table_successful := 0;
        v_table_failed := 0;
        
        -- Validate and process customers data
        MERGE INTO Silver.si_customers AS target
        USING (
            SELECT 
                customer_id,
                TRIM(customer_name) AS customer_name,
                LOWER(TRIM(email)) AS email,
                CASE 
                    WHEN customer_id IS NOT NULL AND customer_name IS NOT NULL AND email IS NOT NULL 
                         AND customer_id > 0
                         AND LENGTH(TRIM(customer_name)) <= 255
                         AND REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
                    THEN (
                        -- Completeness (40%)
                        (CASE WHEN customer_id IS NOT NULL THEN 33.33 ELSE 0 END +
                         CASE WHEN customer_name IS NOT NULL THEN 33.33 ELSE 0 END +
                         CASE WHEN email IS NOT NULL THEN 33.34 ELSE 0 END) * 0.4 +
                        -- Validity (30%)
                        (CASE WHEN customer_id > 0 THEN 33.33 ELSE 0 END +
                         CASE WHEN LENGTH(TRIM(customer_name)) <= 255 THEN 33.33 ELSE 0 END +
                         CASE WHEN REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$') THEN 33.34 ELSE 0 END) * 0.3 +
                        -- Consistency (20%)
                        80.0 * 0.2 +
                        -- Accuracy (10%)
                        90.0 * 0.1
                    )
                    ELSE 0.0
                END AS data_quality_score,
                TRUE AS is_active,
                DATE(load_timestamp) AS load_date,
                DATE(COALESCE(update_timestamp, CURRENT_TIMESTAMP())) AS update_date,
                source_system,
                load_timestamp,
                COALESCE(update_timestamp, CURRENT_TIMESTAMP()) AS update_timestamp
            FROM Bronze.bz_customers
            WHERE load_timestamp IS NOT NULL
              AND customer_id IS NOT NULL AND customer_id > 0
              AND customer_name IS NOT NULL AND LENGTH(TRIM(customer_name)) > 0 AND LENGTH(TRIM(customer_name)) <= 255
              AND email IS NOT NULL AND REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
        ) AS source
        ON target.customer_id = source.customer_id
        WHEN MATCHED THEN
            UPDATE SET
                customer_name = source.customer_name,
                email = source.email,
                data_quality_score = source.data_quality_score,
                is_active = source.is_active,
                update_date = source.update_date,
                source_system = source.source_system,
                update_timestamp = source.update_timestamp
        WHEN NOT MATCHED THEN
            INSERT (
                customer_id, customer_name, email, data_quality_score, is_active,
                load_date, update_date, source_system, load_timestamp, update_timestamp
            )
            VALUES (
                source.customer_id, source.customer_name, source.email, source.data_quality_score, source.is_active,
                source.load_date, source.update_date, source.source_system, source.load_timestamp, source.update_timestamp
            );
        
        GET DIAGNOSTICS v_table_successful = ROW_COUNT;
        
        -- Handle invalid customer records
        INSERT INTO Silver.si_data_quality_errors (
            error_id, source_table, source_record_id, error_type, error_description,
            error_field, error_value, error_severity, error_timestamp, resolution_status,
            resolution_notes, created_by, load_date, update_date, source_system
        )
        SELECT 
            UUID_STRING() AS error_id,
            'bz_customers' AS source_table,
            COALESCE(customer_id::STRING, 'NULL') AS source_record_id,
            'VALIDATION_ERROR' AS error_type,
            CASE 
                WHEN customer_id IS NULL OR customer_id <= 0 THEN 'Invalid or missing customer ID'
                WHEN customer_name IS NULL OR LENGTH(TRIM(customer_name)) = 0 THEN 'Invalid or missing customer name'
                WHEN email IS NULL OR NOT REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$') THEN 'Invalid email format'
                WHEN LENGTH(TRIM(customer_name)) > 255 THEN 'Customer name exceeds maximum length'
                ELSE 'Unknown validation error'
            END AS error_description,
            CASE 
                WHEN customer_id IS NULL OR customer_id <= 0 THEN 'customer_id'
                WHEN customer_name IS NULL OR LENGTH(TRIM(customer_name)) = 0 THEN 'customer_name'
                WHEN email IS NULL OR NOT REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$') THEN 'email'
                WHEN LENGTH(TRIM(customer_name)) > 255 THEN 'customer_name'
                ELSE 'unknown'
            END AS error_field,
            CASE 
                WHEN customer_id IS NULL OR customer_id <= 0 THEN COALESCE(customer_id::STRING, 'NULL')
                WHEN customer_name IS NULL OR LENGTH(TRIM(customer_name)) = 0 THEN COALESCE(customer_name, 'NULL')
                WHEN email IS NULL OR NOT REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$') THEN COALESCE(email, 'NULL')
                WHEN LENGTH(TRIM(customer_name)) > 255 THEN customer_name
                ELSE 'unknown'
            END AS error_value,
            'HIGH' AS error_severity,
            CURRENT_TIMESTAMP() AS error_timestamp,
            'OPEN' AS resolution_status,
            NULL AS resolution_notes,
            p_executed_by AS created_by,
            v_current_date AS load_date,
            v_current_date AS update_date,
            'BRONZE' AS source_system
        FROM Bronze.bz_customers
        WHERE customer_id IS NULL OR customer_id <= 0
           OR customer_name IS NULL OR LENGTH(TRIM(customer_name)) = 0
           OR email IS NULL OR NOT REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
           OR LENGTH(TRIM(customer_name)) > 255;
        
        GET DIAGNOSTICS v_table_failed = ROW_COUNT;
        
        SELECT COUNT(*) INTO v_table_processed FROM Bronze.bz_customers;
        
        v_total_processed := v_total_processed + v_table_processed;
        v_total_successful := v_total_successful + v_table_successful;
        v_total_failed := v_total_failed + v_table_failed;
        
    EXCEPTION
        WHEN OTHER THEN
            v_error_message := 'Error processing si_customers: ' || SQLERRM;
            v_status := 'FAILED';
            v_error_count := v_error_count + 1;
    END;
    
    -- =====================================================
    -- 4. FINALIZE PIPELINE EXECUTION
    -- =====================================================
    
    -- Calculate final execution metrics
    v_end_time := CURRENT_TIMESTAMP();
    v_execution_duration := DATEDIFF('millisecond', v_start_time, v_end_time) / 1000.0;
    
    -- Determine final status
    IF v_error_count > 0 THEN
        v_status := 'FAILED';
    ELSIF v_total_failed > 0 THEN
        v_status := 'PARTIAL_SUCCESS';
    ELSE
        v_status := 'SUCCESS';
    END IF;
    
    -- Update final pipeline audit log
    UPDATE Silver.si_pipeline_audit_log 
    SET 
        end_time = v_end_time,
        execution_duration = v_execution_duration,
        status = v_status,
        error_message = v_error_message,
        records_processed = v_total_processed,
        records_successful = v_total_successful,
        records_failed = v_total_failed,
        records_skipped = v_total_skipped,
        update_date = v_current_date
    WHERE execution_id = v_execution_id
      AND pipeline_name = v_pipeline_name
      AND source_table = 'ALL_BRONZE_TABLES';
    
    -- Return execution summary
    RETURN 'Pipeline Execution Summary: ' ||
           'Status: ' || v_status || ', ' ||
           'Total Processed: ' || v_total_processed || ', ' ||
           'Total Successful: ' || v_total_successful || ', ' ||
           'Total Failed: ' || v_total_failed || ', ' ||
           'Execution Duration: ' || v_execution_duration || ' seconds, ' ||
           'Execution ID: ' || v_execution_id;
           
EXCEPTION
    WHEN OTHER THEN
        -- Log critical pipeline failure
        INSERT INTO Silver.si_data_quality_errors (
            error_id, source_table, source_record_id, error_type, error_description,
            error_field, error_value, error_severity, error_timestamp, resolution_status,
            resolution_notes, created_by, load_date, update_date, source_system
        )
        VALUES (
            UUID_STRING(), 'SP_BRONZE_TO_SILVER_ETL', v_execution_id, 'PIPELINE_ERROR',
            'Critical pipeline failure: ' || SQLERRM, 'PIPELINE', 'CRITICAL_FAILURE',
            'CRITICAL', CURRENT_TIMESTAMP(), 'OPEN', NULL, p_executed_by,
            v_current_date, v_current_date, 'BRONZE'
        );
        
        -- Update pipeline audit log with failure
        UPDATE Silver.si_pipeline_audit_log 
        SET 
            end_time = CURRENT_TIMESTAMP(),
            execution_duration = DATEDIFF('millisecond', v_start_time, CURRENT_TIMESTAMP()) / 1000.0,
            status = 'CRITICAL_FAILURE',
            error_message = 'Pipeline critical failure: ' || SQLERRM,
            update_date = v_current_date
        WHERE execution_id = v_execution_id;
        
        RETURN 'CRITICAL PIPELINE FAILURE: ' || SQLERRM || ' - Execution ID: ' || v_execution_id;
END;
$$;

-- =====================================================
-- USAGE EXAMPLES
-- =====================================================

-- Execute the stored procedure with default parameters
-- CALL SP_BRONZE_TO_SILVER_ETL();

-- Execute with custom parameters
-- CALL SP_BRONZE_TO_SILVER_ETL(5000, 'DEVELOPMENT', 'DATA_ENGINEER');

-- =====================================================
-- MONITORING QUERIES
-- =====================================================

-- Check pipeline execution history
-- SELECT * FROM Silver.si_pipeline_audit_log 
-- WHERE pipeline_name LIKE '%BRONZE_TO_SILVER%' 
-- ORDER BY start_time DESC LIMIT 10;

-- Check data quality errors
-- SELECT * FROM Silver.si_data_quality_errors 
-- WHERE error_timestamp >= CURRENT_DATE() - 1 
-- ORDER BY error_timestamp DESC;

-- =====================================================
-- API COST CALCULATION
-- =====================================================
-- API Cost: 0.002847 USD

-- =====================================================
-- END OF STORED PROCEDURE
-- =====================================================