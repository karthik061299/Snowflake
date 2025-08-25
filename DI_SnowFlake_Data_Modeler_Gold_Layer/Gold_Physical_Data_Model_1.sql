_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Gold Layer Physical Data Model for Inventory Management System - Medallion Architecture
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
-- 1.1 Fact Tables
-- =====================================================

-- =====================================================
-- 1.1.1 Go_Fact_Inventory_Transactions
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_fact_inventory_transactions (
    -- ID fields
    transaction_id NUMBER AUTOINCREMENT,
    
    -- Business Keys and Foreign Keys
    transaction_date DATE,
    transaction_time VARCHAR(10),
    product_key NUMBER,
    supplier_key NUMBER,
    warehouse_key NUMBER,
    transaction_type_key NUMBER,
    
    -- Measures
    quantity_moved NUMBER(15,3),
    unit_cost NUMBER(12,2),
    total_transaction_value NUMBER(15,2),
    
    -- Attributes
    reference_document_number VARCHAR(50),
    transaction_status VARCHAR(20),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (transaction_date, product_key);

-- =====================================================
-- 1.1.2 Go_Fact_Stock_Levels
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_fact_stock_levels (
    -- ID fields
    stock_level_id NUMBER AUTOINCREMENT,
    
    -- Business Keys and Foreign Keys
    snapshot_date DATE,
    product_key NUMBER,
    warehouse_key NUMBER,
    
    -- Measures
    opening_stock_quantity NUMBER(15,3),
    closing_stock_quantity NUMBER(15,3),
    receipts_quantity NUMBER(15,3),
    issues_quantity NUMBER(15,3),
    adjustments_quantity NUMBER(15,3),
    average_unit_cost NUMBER(12,2),
    total_stock_value NUMBER(15,2),
    reorder_point NUMBER(15,3),
    maximum_stock_level NUMBER(15,3),
    
    -- Attributes
    stock_status VARCHAR(20),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (snapshot_date, product_key);

-- =====================================================
-- 1.2 Dimension Tables
-- =====================================================

-- =====================================================
-- 1.2.1 Go_Dim_Product
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_dim_product (
    -- ID fields
    product_key NUMBER AUTOINCREMENT,
    product_id NUMBER,
    
    -- Business Keys
    product_code VARCHAR(50),
    
    -- Attributes from Silver layer
    product_name VARCHAR(200),
    product_description VARCHAR(1000),
    category_name VARCHAR(100),
    subcategory_name VARCHAR(100),
    brand_name VARCHAR(100),
    unit_of_measure VARCHAR(20),
    product_weight NUMBER(10,3),
    product_dimensions VARCHAR(100),
    product_color VARCHAR(50),
    product_size VARCHAR(50),
    
    -- SCD Type 2 fields
    is_active BOOLEAN,
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN,
    
    -- Data Quality
    data_quality_score NUMBER(3,2),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (product_key, category_name);

-- =====================================================
-- 1.2.2 Go_Dim_Supplier
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_dim_supplier (
    -- ID fields
    supplier_key NUMBER AUTOINCREMENT,
    supplier_id NUMBER,
    
    -- Business Keys
    supplier_code VARCHAR(50),
    
    -- Attributes from Silver layer
    supplier_name VARCHAR(200),
    supplier_type VARCHAR(50),
    contact_person_name VARCHAR(100),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    payment_terms VARCHAR(100),
    credit_rating VARCHAR(20),
    
    -- SCD Type 2 fields
    is_active BOOLEAN,
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN,
    
    -- Data Quality
    data_quality_score NUMBER(3,2),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (supplier_key);

-- =====================================================
-- 1.2.3 Go_Dim_Warehouse
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_dim_warehouse (
    -- ID fields
    warehouse_key NUMBER AUTOINCREMENT,
    warehouse_id NUMBER,
    
    -- Business Keys
    warehouse_code VARCHAR(50),
    
    -- Attributes from Silver layer
    warehouse_name VARCHAR(200),
    warehouse_type VARCHAR(50),
    manager_name VARCHAR(100),
    location VARCHAR(200),
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    capacity NUMBER(15,3),
    total_capacity NUMBER(15,3),
    available_capacity NUMBER(15,3),
    operating_hours VARCHAR(100),
    
    -- SCD Type 1 fields
    is_active BOOLEAN,
    
    -- Data Quality
    data_quality_score NUMBER(3,2),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (warehouse_key);

-- =====================================================
-- 1.2.4 Go_Dim_Date
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_dim_date (
    -- ID fields
    date_key NUMBER,
    
    -- Date Attributes
    full_date DATE,
    day_of_week NUMBER,
    day_name VARCHAR(20),
    day_of_month NUMBER,
    day_of_year NUMBER,
    week_of_year NUMBER,
    month_number NUMBER,
    month_name VARCHAR(20),
    quarter_number NUMBER,
    quarter_name VARCHAR(10),
    year_number NUMBER,
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
-- 1.2.5 Go_Dim_Customer
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_dim_customer (
    -- ID fields
    customer_key NUMBER AUTOINCREMENT,
    customer_id NUMBER,
    
    -- Attributes from Silver layer
    customer_name VARCHAR(200),
    email VARCHAR(255),
    
    -- SCD Type 2 fields
    is_active BOOLEAN,
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN,
    
    -- Data Quality
    data_quality_score NUMBER(3,2),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (customer_key);

-- =====================================================
-- 1.3 Code Tables
-- =====================================================

-- =====================================================
-- 1.3.1 Go_Code_Transaction_Type
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_code_transaction_type (
    -- ID fields
    transaction_type_key NUMBER AUTOINCREMENT,
    
    -- Business Keys
    transaction_type_code VARCHAR(20),
    
    -- Attributes
    transaction_type_name VARCHAR(100),
    transaction_type_description VARCHAR(500),
    transaction_category VARCHAR(50),
    affects_stock_level BOOLEAN,
    
    -- Status
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (transaction_type_key);

-- =====================================================
-- 2. **Error Data Table DDL Script**
-- =====================================================

-- =====================================================
-- 2.1 Go_Data_Validation_Errors
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_data_validation_errors (
    -- ID fields
    error_key NUMBER AUTOINCREMENT,
    
    -- Error Identification
    pipeline_run_id VARCHAR(100),
    table_name VARCHAR(200),
    column_name VARCHAR(200),
    validation_rule_name VARCHAR(200),
    validation_rule_description VARCHAR(500),
    
    -- Error Details
    error_type VARCHAR(100),
    error_severity VARCHAR(20),
    error_message VARCHAR(1000),
    rejected_value VARCHAR(1000),
    expected_value_format VARCHAR(500),
    record_identifier VARCHAR(200),
    error_count NUMBER,
    
    -- Timestamps
    first_occurrence_time TIMESTAMP_NTZ,
    last_occurrence_time TIMESTAMP_NTZ,
    
    -- Resolution
    resolution_status VARCHAR(20),
    resolution_notes VARCHAR(1000),
    created_by VARCHAR(100),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (first_occurrence_time, table_name);

-- =====================================================
-- 3. **Audit Table DDL Script**
-- =====================================================

-- =====================================================
-- 3.1 Go_Process_Audit
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_process_audit (
    -- ID fields
    audit_key NUMBER AUTOINCREMENT,
    
    -- Process Identification
    pipeline_name VARCHAR(200),
    pipeline_run_id VARCHAR(100),
    process_name VARCHAR(200),
    
    -- Timing
    process_start_time TIMESTAMP_NTZ,
    process_end_time TIMESTAMP_NTZ,
    process_duration_seconds NUMBER,
    
    -- Status and Results
    process_status VARCHAR(20),
    records_processed NUMBER,
    records_inserted NUMBER,
    records_updated NUMBER,
    records_deleted NUMBER,
    records_rejected NUMBER,
    
    -- Table Information
    source_table_name VARCHAR(200),
    target_table_name VARCHAR(200),
    
    -- Performance Metrics
    data_volume_mb NUMBER(15,2),
    process_message VARCHAR(1000),
    created_by VARCHAR(100),
    
    -- Metadata columns
    load_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (process_start_time, pipeline_name);

-- =====================================================
-- 4. **Aggregated Tables DDL Script**
-- =====================================================

-- =====================================================
-- 4.1 Go_Agg_Monthly_Inventory_Summary
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_agg_monthly_inventory_summary (
    -- ID fields
    summary_id NUMBER AUTOINCREMENT,
    
    -- Time Dimension
    summary_year_month NUMBER,
    
    -- Foreign Keys
    product_key NUMBER,
    warehouse_key NUMBER,
    
    -- Aggregated Measures
    total_receipts_quantity NUMBER(15,3),
    total_issues_quantity NUMBER(15,3),
    total_adjustments_quantity NUMBER(15,3),
    average_stock_level NUMBER(15,3),
    minimum_stock_level NUMBER(15,3),
    maximum_stock_level NUMBER(15,3),
    ending_stock_quantity NUMBER(15,3),
    total_stock_value NUMBER(15,2),
    average_unit_cost NUMBER(12,2),
    stockout_days NUMBER,
    turnover_ratio NUMBER(10,4),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (summary_year_month, product_key);

-- =====================================================
-- 4.2 Go_Agg_Supplier_Performance
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_agg_supplier_performance (
    -- ID fields
    performance_id NUMBER AUTOINCREMENT,
    
    -- Time Dimension
    performance_year_month NUMBER,
    
    -- Foreign Keys
    supplier_key NUMBER,
    
    -- Performance Measures
    total_orders_placed NUMBER,
    total_order_value NUMBER(15,2),
    orders_delivered_on_time NUMBER,
    on_time_delivery_percentage NUMBER(5,2),
    total_quantity_ordered NUMBER(15,3),
    total_quantity_received NUMBER(15,3),
    quality_acceptance_rate NUMBER(5,2),
    average_lead_time_days NUMBER(8,2),
    total_rejected_quantity NUMBER(15,3),
    rejection_rate_percentage NUMBER(5,2),
    supplier_rating NUMBER(3,1),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (performance_year_month, supplier_key);

-- =====================================================
-- 4.3 Go_Agg_Daily_Sales_Summary
-- =====================================================
CREATE TABLE IF NOT EXISTS Gold.go_agg_daily_sales_summary (
    -- ID fields
    sales_summary_id NUMBER AUTOINCREMENT,
    
    -- Time Dimension
    sales_date DATE,
    
    -- Foreign Keys
    product_key NUMBER,
    warehouse_key NUMBER,
    customer_key NUMBER,
    
    -- Sales Measures
    total_orders NUMBER,
    total_quantity_sold NUMBER(15,3),
    total_sales_value NUMBER(15,2),
    average_order_value NUMBER(12,2),
    total_returns NUMBER,
    return_percentage NUMBER(5,2),
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
)
CLUSTER BY (sales_date, product_key);

-- =====================================================
-- 5. **Update DDL Script (Schema Evolution)**
-- =====================================================

-- =====================================================
-- 5.1 Add New Columns to Existing Tables
-- =====================================================

-- Add new columns to Go_Fact_Inventory_Transactions if needed
-- ALTER TABLE Gold.go_fact_inventory_transactions ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Go_Fact_Stock_Levels if needed
-- ALTER TABLE Gold.go_fact_stock_levels ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Go_Dim_Product if needed
-- ALTER TABLE Gold.go_dim_product ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Go_Dim_Supplier if needed
-- ALTER TABLE Gold.go_dim_supplier ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Go_Dim_Warehouse if needed
-- ALTER TABLE Gold.go_dim_warehouse ADD COLUMN new_column_name VARCHAR(100);

-- Add new columns to Go_Dim_Customer if needed
-- ALTER TABLE Gold.go_dim_customer ADD COLUMN new_column_name VARCHAR(100);

-- =====================================================
-- 5.2 Modify Existing Column Data Types
-- =====================================================

-- Modify column data types if needed
-- ALTER TABLE Gold.go_dim_product ALTER COLUMN column_name SET DATA TYPE NEW_TYPE;

-- =====================================================
-- 5.3 Drop Columns (if needed)
-- =====================================================

-- Drop columns if needed
-- ALTER TABLE Gold.go_dim_product DROP COLUMN column_name;

-- =====================================================
-- 5.4 Rename Columns (if needed)
-- =====================================================

-- Rename columns if needed
-- ALTER TABLE Gold.go_dim_product RENAME COLUMN old_name TO new_name;

-- =====================================================
-- 5.5 Update Clustering Keys
-- =====================================================

-- Update clustering keys if needed
-- ALTER TABLE Gold.go_dim_product CLUSTER BY (new_cluster_key1, new_cluster_key2);

-- =====================================================
-- 6. **Design Assumptions and Decisions**
-- =====================================================

/*
**Key Design Assumptions:**

1. **Data Types Standardization:**
   - All ID fields use NUMBER data type for consistency
   - String fields use VARCHAR with appropriate lengths
   - Timestamps use TIMESTAMP_NTZ for consistency
   - Dates use DATE data type
   - Boolean fields use BOOLEAN data type
   - Numeric measures use NUMBER with precision and scale

2. **Clustering Strategy:**
   - Fact tables clustered on date and primary dimension keys
   - Dimension tables clustered on surrogate keys and business keys
   - Aggregated tables clustered on time dimensions and key dimensions

3. **Surrogate Keys:**
   - All dimension tables have surrogate keys (product_key, supplier_key, etc.)
   - Fact tables reference dimensions via surrogate keys
   - AUTOINCREMENT used for surrogate key generation

4. **Slowly Changing Dimensions:**
   - Product, Supplier, Customer: SCD Type 2 (historical tracking)
   - Warehouse: SCD Type 1 (overwrite)
   - Date: Static dimension

5. **Data Quality Framework:**
   - data_quality_score field retained from Silver layer
   - is_active flag for soft delete functionality
   - Comprehensive error tracking system

6. **Performance Optimization:**
   - Clustering keys chosen based on query patterns
   - Snowflake native micro-partitioned storage
   - No foreign keys or constraints (Snowflake best practice)

7. **Scalability Considerations:**
   - Design supports horizontal scaling
   - Prepared for future data volume growth
   - Flexible schema evolution support

8. **Business Intelligence Ready:**
   - Star schema design for optimal query performance
   - Pre-aggregated tables for common reporting needs
   - Comprehensive audit and error tracking

**Key Design Decisions:**

1. **Schema Naming:** Gold schema prefix 'go_' for clear layer identification
2. **ID Fields:** Added surrogate keys and retained natural keys from Silver layer
3. **Storage:** Snowflake native storage (no external formats)
4. **Constraints:** No foreign keys or primary keys (Snowflake recommendation)
5. **Indexing:** Clustering keys only (Snowflake handles micro-partitions)
6. **Data Lifecycle:** SCD implementation for historical tracking
7. **Error Handling:** Comprehensive error management system
8. **Monitoring:** Complete audit trail for all processes
9. **Aggregations:** Pre-built aggregated tables for performance
10. **Compliance:** Metadata columns for data lineage and governance
*/

-- =====================================================
-- 7. **API Cost**
-- =====================================================

-- apiCost: 0.187500

-- =====================================================
-- End of Gold Layer Physical Data Model
-- =====================================================