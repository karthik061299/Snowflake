_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Gold Layer Physical Data Model for Inventory Management System medallion architecture
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- **Gold Layer Physical Data Model**
-- Inventory Management System - Medallion Architecture
-- Compatible with Snowflake SQL Standards
-- Storage: Snowflake Native Micro-partitioned Storage
-- =====================================================

-- =====================================================
-- **1. FACT TABLES**
-- =====================================================

-- =====================================================
-- 1.1 Go_Fact_Inventory_Transactions
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_fact_inventory_transactions (
    -- ID fields
    transaction_id NUMBER AUTOINCREMENT,
    product_id NUMBER,
    warehouse_id NUMBER,
    customer_id NUMBER,
    supplier_id NUMBER,
    order_id NUMBER,
    
    -- Fact columns from logical model
    transaction_date DATE,
    transaction_type VARCHAR(50),
    quantity_change NUMBER,
    unit_cost NUMBER(10,2),
    total_transaction_value NUMBER(15,2),
    product_name VARCHAR(255),
    warehouse_location VARCHAR(255),
    customer_name VARCHAR(255),
    supplier_name VARCHAR(255),
    order_date DATE,
    shipment_date DATE,
    return_reason VARCHAR(500),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (transaction_date, product_id);

-- =====================================================
-- 1.2 Go_Fact_Order_Performance
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_fact_order_performance (
    -- ID fields
    performance_id NUMBER AUTOINCREMENT,
    order_id NUMBER,
    product_id NUMBER,
    customer_id NUMBER,
    warehouse_id NUMBER,
    
    -- Fact columns from logical model
    order_date DATE,
    shipment_date DATE,
    fulfillment_days NUMBER,
    quantity_ordered NUMBER,
    quantity_shipped NUMBER,
    fulfillment_rate NUMBER(5,2),
    order_value NUMBER(15,2),
    product_name VARCHAR(255),
    product_category VARCHAR(100),
    customer_name VARCHAR(255),
    warehouse_location VARCHAR(255),
    is_returned BOOLEAN,
    return_reason VARCHAR(500),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (order_date, customer_id);

-- =====================================================
-- **2. DIMENSION TABLES**
-- =====================================================

-- =====================================================
-- 2.1 Go_Dim_Products
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_dim_products (
    -- ID fields
    product_key NUMBER AUTOINCREMENT,
    product_id NUMBER,
    
    -- Dimension columns from logical model
    product_name VARCHAR(255),
    product_category VARCHAR(100),
    product_description VARCHAR(1000),
    product_status VARCHAR(50),
    category_hierarchy_level1 VARCHAR(100),
    category_hierarchy_level2 VARCHAR(100),
    category_hierarchy_level3 VARCHAR(100),
    
    -- SCD Type 2 columns
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (product_id, is_current);

-- =====================================================
-- 2.2 Go_Dim_Customers
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_dim_customers (
    -- ID fields
    customer_key NUMBER AUTOINCREMENT,
    customer_id NUMBER,
    
    -- Dimension columns from logical model
    customer_name VARCHAR(255),
    customer_email VARCHAR(255),
    customer_segment VARCHAR(100),
    customer_status VARCHAR(50),
    registration_date DATE,
    last_order_date DATE,
    total_orders NUMBER,
    total_order_value NUMBER(15,2),
    average_order_value NUMBER(10,2),
    return_rate NUMBER(5,2),
    
    -- SCD Type 2 columns
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (customer_id, is_current);

-- =====================================================
-- 2.3 Go_Dim_Warehouses
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_dim_warehouses (
    -- ID fields
    warehouse_key NUMBER AUTOINCREMENT,
    warehouse_id NUMBER,
    
    -- Dimension columns from logical model
    warehouse_location VARCHAR(255),
    warehouse_name VARCHAR(200),
    warehouse_type VARCHAR(100),
    total_capacity NUMBER,
    available_capacity NUMBER,
    capacity_utilization_percent NUMBER(5,2),
    warehouse_status VARCHAR(50),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (warehouse_id);

-- =====================================================
-- 2.4 Go_Dim_Suppliers
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_dim_suppliers (
    -- ID fields
    supplier_key NUMBER AUTOINCREMENT,
    supplier_id NUMBER,
    
    -- Dimension columns from logical model
    supplier_name VARCHAR(255),
    supplier_contact_number VARCHAR(20),
    supplier_email VARCHAR(255),
    supplier_category VARCHAR(100),
    supplier_status VARCHAR(50),
    supplier_rating NUMBER(3,2),
    contract_start_date DATE,
    contract_end_date DATE,
    payment_terms VARCHAR(100),
    lead_time_days NUMBER,
    quality_score NUMBER(5,2),
    delivery_performance_score NUMBER(5,2),
    total_products_supplied NUMBER,
    
    -- SCD Type 2 columns
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (supplier_id, is_current);

-- =====================================================
-- 2.5 Go_Dim_Date
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_dim_date (
    -- ID fields
    date_key DATE,
    
    -- Dimension columns from logical model
    year NUMBER,
    quarter NUMBER,
    month NUMBER,
    month_name VARCHAR(20),
    month_abbr VARCHAR(3),
    day_of_month NUMBER,
    day_of_week NUMBER,
    day_name VARCHAR(20),
    day_abbr VARCHAR(3),
    week_of_year NUMBER,
    is_weekend BOOLEAN,
    is_holiday BOOLEAN,
    fiscal_year NUMBER,
    fiscal_quarter NUMBER,
    fiscal_month NUMBER,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (date_key);

-- =====================================================
-- **3. CODE TABLES**
-- =====================================================

-- =====================================================
-- 3.1 Go_Code_Transaction_Types
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_code_transaction_types (
    -- ID fields
    transaction_type_id NUMBER AUTOINCREMENT,
    
    -- Code table columns from logical model
    transaction_type_code VARCHAR(20),
    transaction_type_name VARCHAR(100),
    transaction_type_description VARCHAR(500),
    transaction_category VARCHAR(50),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (transaction_type_code);

-- =====================================================
-- 3.2 Go_Code_Return_Reasons
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_code_return_reasons (
    -- ID fields
    return_reason_id NUMBER AUTOINCREMENT,
    
    -- Code table columns from logical model
    return_reason_code VARCHAR(20),
    return_reason_name VARCHAR(100),
    return_reason_description VARCHAR(500),
    return_category VARCHAR(50),
    impact_on_inventory VARCHAR(50),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (return_reason_code);

-- =====================================================
-- **4. AGGREGATED TABLES**
-- =====================================================

-- =====================================================
-- 4.1 Go_Agg_Daily_Inventory_Summary
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_agg_daily_inventory_summary (
    -- ID fields
    summary_id NUMBER AUTOINCREMENT,
    product_id NUMBER,
    warehouse_id NUMBER,
    
    -- Aggregated columns from logical model
    summary_date DATE,
    product_name VARCHAR(255),
    product_category VARCHAR(100),
    warehouse_location VARCHAR(255),
    opening_inventory_quantity NUMBER,
    closing_inventory_quantity NUMBER,
    total_inbound_quantity NUMBER,
    total_outbound_quantity NUMBER,
    total_returned_quantity NUMBER,
    net_inventory_change NUMBER,
    reorder_threshold NUMBER,
    days_of_supply NUMBER(5,2),
    stock_status VARCHAR(50),
    total_order_count NUMBER,
    total_order_quantity NUMBER,
    fulfillment_rate_percent NUMBER(5,2),
    average_fulfillment_days NUMBER(5,2),
    inventory_turnover_rate NUMBER(8,4),
    carrying_cost_amount NUMBER(12,2),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (summary_date, product_id);

-- =====================================================
-- 4.2 Go_Agg_Monthly_Customer_Performance
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_agg_monthly_customer_performance (
    -- ID fields
    performance_id NUMBER AUTOINCREMENT,
    customer_id NUMBER,
    
    -- Aggregated columns from logical model
    performance_year_month VARCHAR(7),
    customer_name VARCHAR(255),
    customer_segment VARCHAR(100),
    total_orders_count NUMBER,
    total_order_value NUMBER(15,2),
    average_order_value NUMBER(10,2),
    total_quantity_ordered NUMBER,
    unique_products_ordered NUMBER,
    total_returns_count NUMBER,
    total_returned_value NUMBER(15,2),
    return_rate_percent NUMBER(5,2),
    average_fulfillment_days NUMBER(5,2),
    customer_satisfaction_score NUMBER(3,2),
    repeat_purchase_indicator BOOLEAN,
    preferred_product_category VARCHAR(100),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (performance_year_month, customer_id);

-- =====================================================
-- 4.3 Go_Agg_Supplier_Performance_Summary
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_agg_supplier_performance_summary (
    -- ID fields
    summary_id NUMBER AUTOINCREMENT,
    supplier_id NUMBER,
    
    -- Aggregated columns from logical model
    performance_year_quarter VARCHAR(7),
    supplier_name VARCHAR(255),
    supplier_category VARCHAR(100),
    total_products_supplied NUMBER,
    total_supply_volume NUMBER,
    total_supply_value NUMBER(15,2),
    average_lead_time_days NUMBER(5,2),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (performance_year_quarter, supplier_id);

-- =====================================================
-- **5. ERROR DATA TABLES**
-- =====================================================

-- =====================================================
-- 5.1 Go_Data_Validation_Errors
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_data_validation_errors (
    -- ID fields
    error_id NUMBER AUTOINCREMENT,
    
    -- Error tracking columns from logical model
    validation_error_key VARCHAR(50),
    source_table_name VARCHAR(100),
    source_record_identifier VARCHAR(100),
    target_table_name VARCHAR(100),
    error_type_code VARCHAR(50),
    error_description_text VARCHAR(1000),
    error_field_name VARCHAR(100),
    error_field_value VARCHAR(500),
    expected_value_format VARCHAR(200),
    error_severity_level VARCHAR(20),
    error_detection_timestamp TIMESTAMP_NTZ,
    validation_rule_name VARCHAR(200),
    validation_rule_expression VARCHAR(1000),
    resolution_status VARCHAR(50),
    resolution_action_taken VARCHAR(1000),
    resolution_timestamp TIMESTAMP_NTZ,
    resolved_by_user VARCHAR(100),
    business_impact_assessment VARCHAR(500),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (error_detection_timestamp, source_table_name);

-- =====================================================
-- 5.2 Go_Data_Quality_Issues
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_data_quality_issues (
    -- ID fields
    issue_id NUMBER AUTOINCREMENT,
    
    -- Quality issue tracking columns from logical model
    quality_issue_key VARCHAR(50),
    issue_category VARCHAR(100),
    affected_table_name VARCHAR(100),
    affected_field_name VARCHAR(100),
    issue_description VARCHAR(1000),
    issue_detection_method VARCHAR(100),
    issue_detection_timestamp TIMESTAMP_NTZ,
    affected_record_count NUMBER,
    data_quality_score_impact NUMBER(5,2),
    business_criticality VARCHAR(20),
    issue_status VARCHAR(50),
    assigned_to_user VARCHAR(100),
    root_cause_analysis VARCHAR(1000),
    corrective_action_plan VARCHAR(1000),
    preventive_measures VARCHAR(1000),
    resolution_timestamp TIMESTAMP_NTZ,
    verification_timestamp TIMESTAMP_NTZ,
    verified_by_user VARCHAR(100),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (issue_detection_timestamp, affected_table_name);

-- =====================================================
-- **6. AUDIT TABLES**
-- =====================================================

-- =====================================================
-- 6.1 Go_Process_Audit_Log
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_process_audit_log (
    -- ID fields
    audit_id NUMBER AUTOINCREMENT,
    
    -- Audit columns from logical model
    audit_log_key VARCHAR(50),
    pipeline_name VARCHAR(200),
    pipeline_run_identifier VARCHAR(100),
    execution_start_timestamp TIMESTAMP_NTZ,
    execution_end_timestamp TIMESTAMP_NTZ,
    execution_duration_seconds NUMBER(10,3),
    execution_status VARCHAR(50),
    source_table_name VARCHAR(100),
    target_table_name VARCHAR(100),
    records_processed_count NUMBER,
    records_successful_count NUMBER,
    records_failed_count NUMBER,
    records_skipped_count NUMBER,
    data_volume_processed_mb NUMBER(10,2),
    error_message_text VARCHAR(2000),
    executed_by_user VARCHAR(100),
    execution_environment VARCHAR(50),
    pipeline_version VARCHAR(20),
    configuration_parameters VARCHAR(2000),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (execution_start_timestamp, pipeline_name);

-- =====================================================
-- 6.2 Go_Process_Performance_Metrics
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_process_performance_metrics (
    -- ID fields
    metric_id NUMBER AUTOINCREMENT,
    
    -- Performance metrics columns from logical model
    performance_metric_key VARCHAR(50),
    process_name VARCHAR(200),
    process_type VARCHAR(100),
    metric_timestamp TIMESTAMP_NTZ,
    cpu_usage_percentage NUMBER(5,2),
    memory_usage_mb NUMBER(10,2),
    disk_io_read_mb NUMBER(10,2),
    disk_io_write_mb NUMBER(10,2),
    network_io_mb NUMBER(10,2),
    query_execution_time_ms NUMBER(10,3),
    throughput_records_per_second NUMBER(10,2),
    performance_score NUMBER(3,2),
    threshold_breach_indicator BOOLEAN,
    alert_level VARCHAR(20),
    resource_contention_indicator BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (metric_timestamp, process_name);

-- =====================================================
-- **7. UPDATE DDL SCRIPTS (Schema Evolution)**
-- =====================================================

-- =====================================================
-- 7.1 Add New Columns to Existing Tables
-- =====================================================

-- Add new columns to Fact tables if needed
-- ALTER TABLE Gold.go_fact_inventory_transactions ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_fact_order_performance ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Dimension tables if needed
-- ALTER TABLE Gold.go_dim_products ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_dim_customers ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_dim_warehouses ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_dim_suppliers ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_dim_date ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Code tables if needed
-- ALTER TABLE Gold.go_code_transaction_types ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_code_return_reasons ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Aggregated tables if needed
-- ALTER TABLE Gold.go_agg_daily_inventory_summary ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_agg_monthly_customer_performance ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_agg_supplier_performance_summary ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Error tables if needed
-- ALTER TABLE Gold.go_data_validation_errors ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_data_quality_issues ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Audit tables if needed
-- ALTER TABLE Gold.go_process_audit_log ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_process_performance_metrics ADD COLUMN new_column_name VARCHAR(100);

-- =====================================================
-- 7.2 Modify Existing Column Data Types
-- =====================================================

-- Modify column data types if needed
-- ALTER TABLE Gold.go_fact_inventory_transactions ALTER COLUMN column_name SET DATA TYPE NEW_TYPE;
-- ALTER TABLE Gold.go_dim_products ALTER COLUMN column_name SET DATA TYPE NEW_TYPE;

-- =====================================================
-- 7.3 Drop Columns (if needed)
-- =====================================================

-- Drop columns if needed
-- ALTER TABLE Gold.go_fact_inventory_transactions DROP COLUMN column_name;
-- ALTER TABLE Gold.go_dim_products DROP COLUMN column_name;

-- =====================================================
-- 7.4 Rename Columns (if needed)
-- =====================================================

-- Rename columns if needed
-- ALTER TABLE Gold.go_fact_inventory_transactions RENAME COLUMN old_name TO new_name;
-- ALTER TABLE Gold.go_dim_products RENAME COLUMN old_name TO new_name;

-- =====================================================
-- 7.5 Update Clustering Keys
-- =====================================================

-- Update clustering keys if needed
-- ALTER TABLE Gold.go_fact_inventory_transactions CLUSTER BY (new_cluster_key1, new_cluster_key2);
-- ALTER TABLE Gold.go_dim_products CLUSTER BY (new_cluster_key1, new_cluster_key2);

-- =====================================================
-- **8. DESIGN ASSUMPTIONS AND DECISIONS**
-- =====================================================

/*
**Key Design Assumptions:**

1. **Data Types Standardization:**
   - All ID fields use NUMBER data type for consistency
   - String fields use VARCHAR with appropriate lengths
   - Timestamps use TIMESTAMP_NTZ for consistency
   - Dates use DATE data type
   - Boolean fields use BOOLEAN data type
   - Numeric fields use NUMBER with precision and scale

2. **Clustering Strategy:**
   - Fact tables clustered on date and primary dimension keys
   - Dimension tables clustered on business keys and SCD flags
   - Aggregated tables clustered on time periods and key dimensions
   - Error and audit tables clustered on timestamps

3. **Slowly Changing Dimensions (SCD):**
   - Products: Type 2 for category and attribute changes
   - Customers: Type 2 for segment and status changes
   - Suppliers: Type 2 for performance and contract changes
   - Warehouses: Type 1 for capacity and operational updates
   - Date: Type 1 (static reference data)

4. **Fact Table Design:**
   - Inventory Transactions: Transaction-level granularity
   - Order Performance: Order-level performance metrics
   - Both include degenerate dimensions for efficiency

5. **Aggregated Tables:**
   - Daily inventory summaries for operational reporting
   - Monthly customer performance for business analysis
   - Quarterly supplier performance for vendor management

6. **Error and Audit Framework:**
   - Comprehensive error tracking with resolution workflow
   - Data quality monitoring with impact assessment
   - Process audit logging for pipeline monitoring
   - Performance metrics for system optimization

7. **Metadata Columns:**
   - load_date and update_date for data lifecycle tracking
   - source_system for data lineage
   - Consistent across all tables

8. **Performance Optimization:**
   - Clustering keys chosen based on query patterns
   - AUTOINCREMENT for surrogate keys
   - Snowflake native micro-partitioned storage
   - No foreign keys or constraints (Snowflake best practice)

**Key Design Decisions:**

1. **Schema Naming:** Gold schema prefix 'go_' for clear layer identification
2. **ID Fields:** Added surrogate keys with AUTOINCREMENT for all tables
3. **Storage:** Snowflake native storage (no external formats)
4. **Constraints:** No foreign keys or primary keys (Snowflake recommendation)
5. **Indexing:** Clustering keys only (Snowflake handles micro-partitions)
6. **Data Types:** Used Snowflake-supported types (VARCHAR, NUMBER, BOOLEAN, DATE, TIMESTAMP_NTZ)
7. **SCD Implementation:** Type 2 for critical dimensions, Type 1 for reference data
8. **Aggregation Strategy:** Pre-calculated aggregates for common reporting needs
9. **Error Handling:** Comprehensive error management with business impact tracking
10. **Audit Trail:** Complete process monitoring and performance tracking

**Snowflake Compliance:**

1. **Avoided Unsupported Features:**
   - No GENERATED ALWAYS AS IDENTITY (used AUTOINCREMENT)
   - No UNIQUE constraints
   - No TEXT data type (used VARCHAR)
   - No DATETIME data type (used DATE/TIMESTAMP_NTZ)
   - No foreign key constraints
   - No primary key constraints

2. **Used Snowflake Best Practices:**
   - Clustering on frequently filtered columns
   - Appropriate data types for Snowflake
   - Micro-partitioned storage
   - Time-based partitioning through clustering
   - Efficient aggregation strategies
*/

-- =====================================================
-- **9. API Cost**
-- =====================================================

-- apiCost: 0.187500

-- =====================================================
-- End of Gold Layer Physical Data Model
-- =====================================================