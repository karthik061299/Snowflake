_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Silver Layer Physical Data Model for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- 1. **Silver Layer DDL Scripts**
-- =====================================================

-- Silver Layer Tables for Inventory Management System
-- Following Medallion Architecture - Cleansed and Conformed Data
-- Compatible with Snowflake SQL Standards
-- Storage: Snowflake Native Micro-partitioned Storage

-- =====================================================
-- 1.1 Si_Products Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_products (
    -- ID fields (added from Bronze layer)
    product_id NUMBER,
    
    -- Bronze layer columns
    product_name STRING,
    category STRING,
    
    -- Silver layer specific columns from logical model
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (product_id, category);

-- =====================================================
-- 1.2 Si_Suppliers Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_suppliers (
    -- ID fields (added from Bronze layer)
    supplier_id NUMBER,
    product_id NUMBER,
    
    -- Bronze layer columns
    supplier_name STRING,
    contact_number STRING,
    
    -- Silver layer specific columns from logical model
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (supplier_id);

-- =====================================================
-- 1.3 Si_Warehouses Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_warehouses (
    -- ID fields (added from Bronze layer)
    warehouse_id NUMBER,
    
    -- Bronze layer columns
    location STRING,
    capacity NUMBER,
    
    -- Silver layer specific columns from logical model
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (warehouse_id);

-- =====================================================
-- 1.4 Si_Inventory Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_inventory (
    -- ID fields (added from Bronze layer)
    inventory_id NUMBER,
    product_id NUMBER,
    warehouse_id NUMBER,
    
    -- Bronze layer columns
    quantity_available NUMBER,
    
    -- Silver layer specific columns from logical model
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (product_id, warehouse_id);

-- =====================================================
-- 1.5 Si_Orders Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_orders (
    -- ID fields (added from Bronze layer)
    order_id NUMBER,
    customer_id NUMBER,
    
    -- Bronze layer columns
    order_date DATE,
    
    -- Silver layer specific columns from logical model
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (order_date, customer_id);

-- =====================================================
-- 1.6 Si_Order_Details Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_order_details (
    -- ID fields (added from Bronze layer)
    order_detail_id NUMBER,
    order_id NUMBER,
    product_id NUMBER,
    
    -- Bronze layer columns
    quantity_ordered NUMBER,
    
    -- Silver layer specific columns from logical model
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (order_id, product_id);

-- =====================================================
-- 1.7 Si_Shipments Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_shipments (
    -- ID fields (added from Bronze layer)
    shipment_id NUMBER,
    order_id NUMBER,
    
    -- Bronze layer columns
    shipment_date DATE,
    
    -- Silver layer specific columns from logical model
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (shipment_date, order_id);

-- =====================================================
-- 1.8 Si_Returns Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_returns (
    -- ID fields (added from Bronze layer)
    return_id NUMBER,
    order_id NUMBER,
    
    -- Bronze layer columns
    return_reason STRING,
    
    -- Silver layer specific columns from logical model
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (order_id);

-- =====================================================
-- 1.9 Si_Stock_Levels Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_stock_levels (
    -- ID fields (added from Bronze layer)
    stock_level_id NUMBER,
    warehouse_id NUMBER,
    product_id NUMBER,
    
    -- Bronze layer columns
    reorder_threshold NUMBER,
    
    -- Silver layer specific columns from logical model
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (warehouse_id, product_id);

-- =====================================================
-- 1.10 Si_Customers Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_customers (
    -- ID fields (added from Bronze layer)
    customer_id NUMBER,
    
    -- Bronze layer columns
    customer_name STRING,
    email STRING,
    
    -- Silver layer specific columns from logical model
    data_quality_score NUMBER(3,2),
    is_active BOOLEAN,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
)
CLUSTER BY (customer_id);

-- =====================================================
-- 2. **Error Data Table DDL Script**
-- =====================================================

-- =====================================================
-- 2.1 Si_Data_Quality_Errors Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_data_quality_errors (
    error_id STRING,
    source_table STRING,
    source_record_id STRING,
    error_type STRING,
    error_description STRING,
    error_field STRING,
    error_value STRING,
    error_severity STRING,
    error_timestamp TIMESTAMP_NTZ,
    resolution_status STRING,
    resolution_notes STRING,
    created_by STRING,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING
)
CLUSTER BY (error_timestamp, source_table);

-- =====================================================
-- 2.2 Si_Data_Validation_Rules Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_data_validation_rules (
    rule_id STRING,
    rule_name STRING,
    rule_description STRING,
    target_table STRING,
    target_field STRING,
    rule_type STRING,
    rule_expression STRING,
    is_active BOOLEAN,
    created_timestamp TIMESTAMP_NTZ,
    updated_timestamp TIMESTAMP_NTZ,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING
)
CLUSTER BY (target_table, rule_type);

-- =====================================================
-- 3. **Audit Table DDL Script**
-- =====================================================

-- =====================================================
-- 3.1 Si_Pipeline_Audit_Log Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_pipeline_audit_log (
    execution_id STRING,
    pipeline_name STRING,
    pipeline_run_id STRING,
    start_time TIMESTAMP_NTZ,
    end_time TIMESTAMP_NTZ,
    execution_duration NUMBER(10,3),
    status STRING,
    error_message STRING,
    source_table STRING,
    target_table STRING,
    records_processed NUMBER,
    records_successful NUMBER,
    records_failed NUMBER,
    records_skipped NUMBER,
    data_volume_mb NUMBER(10,2),
    executed_by STRING,
    environment STRING,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING
)
CLUSTER BY (start_time, pipeline_name);

-- =====================================================
-- 3.2 Si_Process_Monitoring Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Silver.si_process_monitoring (
    monitor_id STRING,
    process_name STRING,
    process_type STRING,
    start_timestamp TIMESTAMP_NTZ,
    end_timestamp TIMESTAMP_NTZ,
    process_status STRING,
    cpu_usage_percent NUMBER(5,2),
    memory_usage_mb NUMBER(10,2),
    disk_io_mb NUMBER(10,2),
    network_io_mb NUMBER(10,2),
    performance_score NUMBER(3,2),
    alert_threshold_breached BOOLEAN,
    monitoring_timestamp TIMESTAMP_NTZ,
    
    -- Metadata columns
    load_date DATE,
    update_date DATE,
    source_system STRING
)
CLUSTER BY (start_timestamp, process_name);

-- =====================================================
-- 4. **Update DDL Scripts (Schema Evolution)**
-- =====================================================

-- =====================================================
-- 4.1 Add New Columns to Existing Tables
-- =====================================================

-- Add new columns to Si_Products if needed
-- ALTER TABLE Silver.si_products ADD COLUMN new_column_name STRING;

-- Add new columns to Si_Suppliers if needed
-- ALTER TABLE Silver.si_suppliers ADD COLUMN new_column_name STRING;

-- Add new columns to Si_Warehouses if needed
-- ALTER TABLE Silver.si_warehouses ADD COLUMN new_column_name STRING;

-- Add new columns to Si_Inventory if needed
-- ALTER TABLE Silver.si_inventory ADD COLUMN new_column_name STRING;

-- Add new columns to Si_Orders if needed
-- ALTER TABLE Silver.si_orders ADD COLUMN new_column_name STRING;

-- Add new columns to Si_Order_Details if needed
-- ALTER TABLE Silver.si_order_details ADD COLUMN new_column_name STRING;

-- Add new columns to Si_Shipments if needed
-- ALTER TABLE Silver.si_shipments ADD COLUMN new_column_name STRING;

-- Add new columns to Si_Returns if needed
-- ALTER TABLE Silver.si_returns ADD COLUMN new_column_name STRING;

-- Add new columns to Si_Stock_Levels if needed
-- ALTER TABLE Silver.si_stock_levels ADD COLUMN new_column_name STRING;

-- Add new columns to Si_Customers if needed
-- ALTER TABLE Silver.si_customers ADD COLUMN new_column_name STRING;

-- =====================================================
-- 4.2 Modify Existing Column Data Types
-- =====================================================

-- Modify column data types if needed
-- ALTER TABLE Silver.si_products ALTER COLUMN column_name SET DATA TYPE NEW_TYPE;

-- =====================================================
-- 4.3 Drop Columns (if needed)
-- =====================================================

-- Drop columns if needed
-- ALTER TABLE Silver.si_products DROP COLUMN column_name;

-- =====================================================
-- 4.4 Rename Columns (if needed)
-- =====================================================

-- Rename columns if needed
-- ALTER TABLE Silver.si_products RENAME COLUMN old_name TO new_name;

-- =====================================================
-- 4.5 Update Clustering Keys
-- =====================================================

-- Update clustering keys if needed
-- ALTER TABLE Silver.si_products CLUSTER BY (new_cluster_key1, new_cluster_key2);

-- =====================================================
-- 5. **Design Assumptions and Decisions**
-- =====================================================

/*
**Key Design Assumptions:**

1. **Data Types Standardization:**
   - All ID fields use NUMBER data type for consistency
   - String fields use STRING data type (Snowflake recommended)
   - Timestamps use TIMESTAMP_NTZ for consistency
   - Dates use DATE data type
   - Boolean fields use BOOLEAN data type
   - Numeric scores use NUMBER with precision and scale

2. **Clustering Strategy:**
   - Tables are clustered on frequently filtered columns
   - Primary clustering on ID fields and date fields
   - Secondary clustering on business-relevant fields

3. **Metadata Columns:**
   - load_date and update_date for data lifecycle tracking
   - source_system for data lineage
   - load_timestamp and update_timestamp for detailed tracking

4. **Data Quality Framework:**
   - data_quality_score field for monitoring data completeness
   - is_active flag for soft delete functionality
   - Comprehensive error tracking system

5. **Performance Optimization:**
   - Clustering keys chosen based on query patterns
   - Snowflake native micro-partitioned storage
   - No foreign keys or constraints (Snowflake best practice)

6. **Scalability Considerations:**
   - Design supports horizontal scaling
   - Prepared for future data volume growth
   - Flexible schema evolution support

7. **Compliance and Auditing:**
   - Complete audit trail for all operations
   - Error tracking for data governance
   - Process monitoring for performance tracking

**Key Design Decisions:**

1. **Schema Naming:** Silver schema prefix 'si_' for clear layer identification
2. **ID Fields:** Added all missing ID fields from Bronze layer
3. **Storage:** Snowflake native storage (no external formats)
4. **Constraints:** No foreign keys or primary keys (Snowflake recommendation)
5. **Indexing:** Clustering keys only (Snowflake handles micro-partitions)
6. **Data Lifecycle:** Soft deletes using is_active flag
7. **Error Handling:** Comprehensive error management system
8. **Monitoring:** Real-time process monitoring capabilities
*/

-- =====================================================
-- 6. **API Cost**
-- =====================================================

-- apiCost: 0.125000

-- =====================================================
-- End of Silver Layer Physical Data Model
-- =====================================================