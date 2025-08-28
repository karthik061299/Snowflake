_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Gold Layer Physical Data Model for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- 1. **Gold Layer DDL Scripts (Fact and Dimension Tables)**
-- =====================================================

-- Gold Layer Tables for Inventory Management System
-- Following Medallion Architecture - Business-Ready Analytical Data
-- Compatible with Snowflake SQL Standards
-- Storage: Snowflake Native Micro-partitioned Storage

-- =====================================================
-- 1.1 **Fact Tables**
-- =====================================================

-- =====================================================
-- 1.1.1 Go_Inventory_Facts Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_inventory_facts (
    -- ID fields
    inventory_fact_id NUMBER AUTOINCREMENT,
    inventory_id NUMBER,
    product_id NUMBER,
    warehouse_id NUMBER,
    
    -- Fact measures from Silver layer
    quantity_available NUMBER,
    reorder_threshold NUMBER,
    
    -- Calculated measures
    inventory_value NUMBER(15,2),
    days_of_supply NUMBER(10,2),
    stock_turnover_rate NUMBER(10,4),
    
    -- Data quality metrics
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (product_id, warehouse_id, load_date);

-- =====================================================
-- 1.1.2 Go_Order_Facts Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_order_facts (
    -- ID fields
    order_fact_id NUMBER AUTOINCREMENT,
    order_id NUMBER,
    order_detail_id NUMBER,
    customer_id NUMBER,
    product_id NUMBER,
    
    -- Fact measures from Silver layer
    quantity_ordered NUMBER,
    
    -- Calculated measures
    unit_price NUMBER(10,2),
    line_total NUMBER(15,2),
    discount_amount NUMBER(10,2),
    tax_amount NUMBER(10,2),
    net_amount NUMBER(15,2),
    
    -- Date keys for dimensional modeling
    order_date DATE,
    
    -- Data quality metrics
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (order_date, customer_id, product_id);

-- =====================================================
-- 1.1.3 Go_Shipment_Facts Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_shipment_facts (
    -- ID fields
    shipment_fact_id NUMBER AUTOINCREMENT,
    shipment_id NUMBER,
    order_id NUMBER,
    
    -- Fact measures
    shipment_date DATE,
    delivery_days NUMBER,
    shipping_cost NUMBER(10,2),
    weight_kg NUMBER(10,3),
    
    -- Calculated measures
    on_time_delivery BOOLEAN,
    shipping_efficiency_score NUMBER(3,2),
    
    -- Data quality metrics
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (shipment_date, order_id);

-- =====================================================
-- 1.1.4 Go_Returns_Facts Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_returns_facts (
    -- ID fields
    return_fact_id NUMBER AUTOINCREMENT,
    return_id NUMBER,
    order_id NUMBER,
    
    -- Fact measures from Silver layer
    return_reason VARCHAR(500),
    
    -- Calculated measures
    return_date DATE,
    return_quantity NUMBER,
    return_amount NUMBER(15,2),
    processing_days NUMBER,
    refund_amount NUMBER(15,2),
    
    -- Data quality metrics
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (return_date, order_id);

-- =====================================================
-- 1.2 **Dimension Tables**
-- =====================================================

-- =====================================================
-- 1.2.1 Go_Product_Dimension Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_product_dimension (
    -- ID fields
    product_dim_id NUMBER AUTOINCREMENT,
    product_id NUMBER,
    
    -- Product attributes from Silver layer
    product_name VARCHAR(500),
    category VARCHAR(200),
    
    -- Enhanced attributes
    subcategory VARCHAR(200),
    brand VARCHAR(200),
    product_description VARCHAR(2000),
    unit_of_measure VARCHAR(50),
    product_status VARCHAR(50),
    launch_date DATE,
    discontinue_date DATE,
    
    -- Data quality metrics
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- SCD Type 2 fields
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (product_id, is_current);

-- =====================================================
-- 1.2.2 Go_Supplier_Dimension Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_supplier_dimension (
    -- ID fields
    supplier_dim_id NUMBER AUTOINCREMENT,
    supplier_id NUMBER,
    
    -- Supplier attributes from Silver layer
    supplier_name VARCHAR(500),
    contact_number VARCHAR(50),
    
    -- Enhanced attributes
    supplier_address VARCHAR(1000),
    supplier_city VARCHAR(200),
    supplier_state VARCHAR(200),
    supplier_country VARCHAR(200),
    supplier_postal_code VARCHAR(20),
    supplier_email VARCHAR(255),
    supplier_website VARCHAR(500),
    supplier_type VARCHAR(100),
    supplier_rating NUMBER(3,2),
    
    -- Data quality metrics
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- SCD Type 2 fields
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (supplier_id, is_current);

-- =====================================================
-- 1.2.3 Go_Warehouse_Dimension Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_warehouse_dimension (
    -- ID fields
    warehouse_dim_id NUMBER AUTOINCREMENT,
    warehouse_id NUMBER,
    
    -- Warehouse attributes from Silver layer
    location VARCHAR(500),
    capacity NUMBER,
    
    -- Enhanced attributes
    warehouse_name VARCHAR(200),
    warehouse_type VARCHAR(100),
    address VARCHAR(1000),
    city VARCHAR(200),
    state VARCHAR(200),
    country VARCHAR(200),
    postal_code VARCHAR(20),
    manager_name VARCHAR(200),
    phone_number VARCHAR(50),
    operating_hours VARCHAR(100),
    
    -- Data quality metrics
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- SCD Type 2 fields
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (warehouse_id, is_current);

-- =====================================================
-- 1.2.4 Go_Customer_Dimension Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_customer_dimension (
    -- ID fields
    customer_dim_id NUMBER AUTOINCREMENT,
    customer_id NUMBER,
    
    -- Customer attributes from Silver layer
    customer_name VARCHAR(500),
    email VARCHAR(255),
    
    -- Enhanced attributes
    first_name VARCHAR(200),
    last_name VARCHAR(200),
    phone_number VARCHAR(50),
    address VARCHAR(1000),
    city VARCHAR(200),
    state VARCHAR(200),
    country VARCHAR(200),
    postal_code VARCHAR(20),
    customer_type VARCHAR(100),
    customer_segment VARCHAR(100),
    registration_date DATE,
    last_order_date DATE,
    
    -- Data quality metrics
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- SCD Type 2 fields
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (customer_id, is_current);

-- =====================================================
-- 1.2.5 Go_Date_Dimension Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_date_dimension (
    -- ID fields
    date_dim_id NUMBER AUTOINCREMENT,
    date_key DATE,
    
    -- Date attributes
    year_number NUMBER(4),
    quarter_number NUMBER(1),
    month_number NUMBER(2),
    week_number NUMBER(2),
    day_number NUMBER(2),
    day_of_week NUMBER(1),
    day_of_year NUMBER(3),
    
    -- Formatted date fields
    year_month VARCHAR(7),
    year_quarter VARCHAR(7),
    month_name VARCHAR(20),
    day_name VARCHAR(20),
    
    -- Business calendar fields
    is_weekend BOOLEAN,
    is_holiday BOOLEAN,
    is_business_day BOOLEAN,
    fiscal_year NUMBER(4),
    fiscal_quarter NUMBER(1),
    fiscal_month NUMBER(2),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
)
CLUSTER BY (date_key);

-- =====================================================
-- 1.3 **Code Tables**
-- =====================================================

-- =====================================================
-- 1.3.1 Go_Order_Status_Codes Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_order_status_codes (
    -- ID fields
    status_code_id NUMBER AUTOINCREMENT,
    status_code VARCHAR(50),
    
    -- Status attributes
    status_description VARCHAR(500),
    status_category VARCHAR(100),
    is_final_status BOOLEAN,
    display_order NUMBER,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
);

-- =====================================================
-- 1.3.2 Go_Return_Reason_Codes Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_return_reason_codes (
    -- ID fields
    reason_code_id NUMBER AUTOINCREMENT,
    reason_code VARCHAR(50),
    
    -- Reason attributes
    reason_description VARCHAR(500),
    reason_category VARCHAR(100),
    requires_inspection BOOLEAN,
    refund_eligible BOOLEAN,
    display_order NUMBER,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
);

-- =====================================================
-- 1.3.3 Go_Product_Category_Codes Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_product_category_codes (
    -- ID fields
    category_code_id NUMBER AUTOINCREMENT,
    category_code VARCHAR(50),
    
    -- Category attributes
    category_name VARCHAR(200),
    category_description VARCHAR(500),
    parent_category_code VARCHAR(50),
    category_level NUMBER,
    is_leaf_category BOOLEAN,
    display_order NUMBER,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
);

-- =====================================================
-- 2. **Error Data Table DDL Script**
-- =====================================================

-- =====================================================
-- 2.1 Go_Data_Quality_Errors Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_data_quality_errors (
    -- ID fields
    error_id VARCHAR(100),
    
    -- Error details
    source_table VARCHAR(200),
    source_record_id VARCHAR(100),
    error_type VARCHAR(100),
    error_description VARCHAR(2000),
    error_field VARCHAR(200),
    error_value VARCHAR(1000),
    error_severity VARCHAR(50),
    error_timestamp TIMESTAMP_NTZ,
    
    -- Resolution tracking
    resolution_status VARCHAR(50),
    resolution_notes VARCHAR(2000),
    resolved_by VARCHAR(200),
    resolved_timestamp TIMESTAMP_NTZ,
    
    -- Process tracking
    created_by VARCHAR(200),
    pipeline_run_id VARCHAR(100),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
)
CLUSTER BY (error_timestamp, source_table);

-- =====================================================
-- 2.2 Go_Data_Validation_Rules Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_data_validation_rules (
    -- ID fields
    rule_id VARCHAR(100),
    
    -- Rule definition
    rule_name VARCHAR(200),
    rule_description VARCHAR(1000),
    target_table VARCHAR(200),
    target_field VARCHAR(200),
    rule_type VARCHAR(100),
    rule_expression VARCHAR(2000),
    
    -- Rule configuration
    severity_level VARCHAR(50),
    is_active BOOLEAN,
    execution_order NUMBER,
    
    -- Audit fields
    created_by VARCHAR(200),
    created_timestamp TIMESTAMP_NTZ,
    updated_by VARCHAR(200),
    updated_timestamp TIMESTAMP_NTZ,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
)
CLUSTER BY (target_table, rule_type);

-- =====================================================
-- 3. **Audit Table DDL Script**
-- =====================================================

-- =====================================================
-- 3.1 Go_Pipeline_Audit_Log Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_pipeline_audit_log (
    -- ID fields
    audit_id VARCHAR(100),
    execution_id VARCHAR(100),
    
    -- Pipeline details
    pipeline_name VARCHAR(200),
    pipeline_run_id VARCHAR(100),
    pipeline_version VARCHAR(50),
    
    -- Execution timing
    start_time TIMESTAMP_NTZ,
    end_time TIMESTAMP_NTZ,
    execution_duration NUMBER(10,3),
    
    -- Execution status
    status VARCHAR(50),
    error_message VARCHAR(2000),
    warning_count NUMBER,
    
    -- Data processing metrics
    source_table VARCHAR(200),
    target_table VARCHAR(200),
    records_processed NUMBER,
    records_successful NUMBER,
    records_failed NUMBER,
    records_skipped NUMBER,
    
    -- Performance metrics
    data_volume_mb NUMBER(10,2),
    cpu_usage_percent NUMBER(5,2),
    memory_usage_mb NUMBER(10,2),
    
    -- Environment details
    executed_by VARCHAR(200),
    environment VARCHAR(100),
    server_name VARCHAR(200),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
)
CLUSTER BY (start_time, pipeline_name);

-- =====================================================
-- 3.2 Go_Process_Monitoring Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_process_monitoring (
    -- ID fields
    monitor_id VARCHAR(100),
    
    -- Process details
    process_name VARCHAR(200),
    process_type VARCHAR(100),
    process_category VARCHAR(100),
    
    -- Timing information
    start_timestamp TIMESTAMP_NTZ,
    end_timestamp TIMESTAMP_NTZ,
    process_duration NUMBER(10,3),
    
    -- Status tracking
    process_status VARCHAR(50),
    status_message VARCHAR(1000),
    
    -- Performance metrics
    cpu_usage_percent NUMBER(5,2),
    memory_usage_mb NUMBER(10,2),
    disk_io_mb NUMBER(10,2),
    network_io_mb NUMBER(10,2),
    
    -- Quality metrics
    performance_score NUMBER(3,2),
    efficiency_rating VARCHAR(20),
    
    -- Alert management
    alert_threshold_breached BOOLEAN,
    alert_level VARCHAR(50),
    alert_message VARCHAR(1000),
    
    -- Monitoring metadata
    monitoring_timestamp TIMESTAMP_NTZ,
    monitored_by VARCHAR(200),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
)
CLUSTER BY (start_timestamp, process_name);

-- =====================================================
-- 4. **Aggregated Tables DDL Script**
-- =====================================================

-- =====================================================
-- 4.1 Go_Inventory_Summary_Daily Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_inventory_summary_daily (
    -- ID fields
    summary_id NUMBER AUTOINCREMENT,
    
    -- Dimension keys
    summary_date DATE,
    warehouse_id NUMBER,
    product_id NUMBER,
    
    -- Aggregated metrics
    total_quantity_available NUMBER,
    total_inventory_value NUMBER(15,2),
    avg_days_of_supply NUMBER(10,2),
    min_stock_level NUMBER,
    max_stock_level NUMBER,
    
    -- Calculated KPIs
    stock_turnover_rate NUMBER(10,4),
    inventory_accuracy_percent NUMBER(5,2),
    stockout_risk_score NUMBER(3,2),
    
    -- Count metrics
    total_products NUMBER,
    low_stock_products NUMBER,
    out_of_stock_products NUMBER,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
)
CLUSTER BY (summary_date, warehouse_id);

-- =====================================================
-- 4.2 Go_Product_Performance_Monthly Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_product_performance_monthly (
    -- ID fields
    performance_id NUMBER AUTOINCREMENT,
    
    -- Dimension keys
    performance_month DATE,
    product_id NUMBER,
    category VARCHAR(200),
    
    -- Sales metrics
    total_orders NUMBER,
    total_quantity_sold NUMBER,
    total_revenue NUMBER(15,2),
    avg_order_value NUMBER(10,2),
    
    -- Performance metrics
    units_per_order NUMBER(10,2),
    return_rate_percent NUMBER(5,2),
    customer_satisfaction_score NUMBER(3,2),
    
    -- Ranking metrics
    revenue_rank NUMBER,
    quantity_rank NUMBER,
    growth_rate_percent NUMBER(8,4),
    
    -- Inventory metrics
    avg_inventory_level NUMBER,
    inventory_turnover NUMBER(10,4),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
)
CLUSTER BY (performance_month, category);

-- =====================================================
-- 4.3 Go_Supplier_Performance_Quarterly Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_supplier_performance_quarterly (
    -- ID fields
    supplier_performance_id NUMBER AUTOINCREMENT,
    
    -- Dimension keys
    performance_quarter DATE,
    supplier_id NUMBER,
    
    -- Delivery metrics
    total_deliveries NUMBER,
    on_time_deliveries NUMBER,
    on_time_delivery_rate NUMBER(5,2),
    avg_delivery_days NUMBER(5,2),
    
    -- Quality metrics
    total_products_supplied NUMBER,
    defective_products NUMBER,
    quality_score NUMBER(3,2),
    return_rate_percent NUMBER(5,2),
    
    -- Financial metrics
    total_purchase_value NUMBER(15,2),
    avg_unit_cost NUMBER(10,2),
    cost_variance_percent NUMBER(8,4),
    
    -- Performance ratings
    overall_rating NUMBER(3,2),
    reliability_score NUMBER(3,2),
    cost_competitiveness_score NUMBER(3,2),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
)
CLUSTER BY (performance_quarter, supplier_id);

-- =====================================================
-- 4.4 Go_Customer_Analytics_Monthly Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_customer_analytics_monthly (
    -- ID fields
    analytics_id NUMBER AUTOINCREMENT,
    
    -- Dimension keys
    analytics_month DATE,
    customer_id NUMBER,
    customer_segment VARCHAR(100),
    
    -- Order metrics
    total_orders NUMBER,
    total_order_value NUMBER(15,2),
    avg_order_value NUMBER(10,2),
    order_frequency NUMBER(5,2),
    
    -- Product metrics
    unique_products_purchased NUMBER,
    total_quantity_purchased NUMBER,
    favorite_category VARCHAR(200),
    
    -- Behavioral metrics
    days_since_last_order NUMBER,
    customer_lifetime_value NUMBER(15,2),
    churn_risk_score NUMBER(3,2),
    
    -- Return metrics
    total_returns NUMBER,
    return_rate_percent NUMBER(5,2),
    return_value NUMBER(15,2),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
)
CLUSTER BY (analytics_month, customer_segment);

-- =====================================================
-- 5. **Update DDL Script (Schema Evolution)**
-- =====================================================

-- =====================================================
-- 5.1 Add New Columns to Existing Tables
-- =====================================================

-- Add new columns to Fact tables if needed
-- ALTER TABLE Gold.go_inventory_facts ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_order_facts ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_shipment_facts ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_returns_facts ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Dimension tables if needed
-- ALTER TABLE Gold.go_product_dimension ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_supplier_dimension ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_warehouse_dimension ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_customer_dimension ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_date_dimension ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Code tables if needed
-- ALTER TABLE Gold.go_order_status_codes ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_return_reason_codes ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_product_category_codes ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Aggregated tables if needed
-- ALTER TABLE Gold.go_inventory_summary_daily ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_product_performance_monthly ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_supplier_performance_quarterly ADD COLUMN new_column_name VARCHAR(100);
-- ALTER TABLE Gold.go_customer_analytics_monthly ADD COLUMN new_column_name VARCHAR(100);

-- =====================================================
-- 5.2 Modify Existing Column Data Types
-- =====================================================

-- Modify column data types if needed
-- ALTER TABLE Gold.go_inventory_facts ALTER COLUMN column_name SET DATA TYPE NEW_TYPE;
-- ALTER TABLE Gold.go_order_facts ALTER COLUMN column_name SET DATA TYPE NEW_TYPE;

-- =====================================================
-- 5.3 Drop Columns (if needed)
-- =====================================================

-- Drop columns if needed (use with caution)
-- ALTER TABLE Gold.go_inventory_facts DROP COLUMN column_name;
-- ALTER TABLE Gold.go_order_facts DROP COLUMN column_name;

-- =====================================================
-- 5.4 Rename Columns (if needed)
-- =====================================================

-- Rename columns if needed
-- ALTER TABLE Gold.go_inventory_facts RENAME COLUMN old_name TO new_name;
-- ALTER TABLE Gold.go_order_facts RENAME COLUMN old_name TO new_name;

-- =====================================================
-- 5.5 Update Clustering Keys
-- =====================================================

-- Update clustering keys if needed for performance optimization
-- ALTER TABLE Gold.go_inventory_facts CLUSTER BY (new_cluster_key1, new_cluster_key2);
-- ALTER TABLE Gold.go_order_facts CLUSTER BY (new_cluster_key1, new_cluster_key2);

-- =====================================================
-- 5.6 Create New Tables for Schema Evolution
-- =====================================================

-- Template for creating new fact tables
/*
CREATE TABLE IF NOT EXISTS Gold.go_new_facts (
    -- ID fields
    new_fact_id NUMBER AUTOINCREMENT,
    
    -- Dimension keys
    dimension_key1 NUMBER,
    dimension_key2 NUMBER,
    
    -- Fact measures
    measure1 NUMBER(15,2),
    measure2 NUMBER(10,4),
    
    -- Data quality metrics
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (dimension_key1, load_date);
*/

-- Template for creating new dimension tables
/*
CREATE TABLE IF NOT EXISTS Gold.go_new_dimension (
    -- ID fields
    new_dim_id NUMBER AUTOINCREMENT,
    business_key NUMBER,
    
    -- Dimension attributes
    attribute1 VARCHAR(200),
    attribute2 VARCHAR(500),
    
    -- Data quality metrics
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    \