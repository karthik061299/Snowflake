_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Silver Layer Physical Data Model for Inventory Management System following Medallion Architecture
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Silver Layer Physical Data Model - Inventory Management System

## 1. Silver Layer DDL Scripts

### • Create Silver Schema
```sql
CREATE SCHEMA IF NOT EXISTS Silver;
```

### • 1.1 Si_Products Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_products (
    product_id NUMBER,
    Product_Name STRING,
    Category STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • 1.2 Si_Suppliers Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_suppliers (
    supplier_id NUMBER,
    Supplier_Name STRING,
    Contact_Number STRING,
    product_id NUMBER,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • 1.3 Si_Warehouses Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_warehouses (
    warehouse_id NUMBER,
    Location STRING,
    Capacity NUMBER,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • 1.4 Si_Inventory Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_inventory (
    inventory_id NUMBER,
    product_id NUMBER,
    Quantity_Available NUMBER,
    warehouse_id NUMBER,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • 1.5 Si_Orders Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_orders (
    order_id NUMBER,
    customer_id NUMBER,
    Order_Date DATE,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • 1.6 Si_Order_Details Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_order_details (
    order_detail_id NUMBER,
    order_id NUMBER,
    product_id NUMBER,
    Quantity_Ordered NUMBER,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • 1.7 Si_Shipments Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_shipments (
    shipment_id NUMBER,
    order_id NUMBER,
    Shipment_Date DATE,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • 1.8 Si_Returns Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_returns (
    return_id NUMBER,
    order_id NUMBER,
    Return_Reason STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • 1.9 Si_Stock_Levels Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_stock_levels (
    stock_level_id NUMBER,
    warehouse_id NUMBER,
    product_id NUMBER,
    Reorder_Threshold NUMBER,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • 1.10 Si_Customers Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_customers (
    customer_id NUMBER,
    Customer_Name STRING,
    Email STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

## 2. Error Data Table DDL Script

### • 2.1 Si_Data_Quality_Errors Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_data_quality_errors (
    error_id NUMBER,
    error_timestamp TIMESTAMP_NTZ,
    source_table STRING,
    error_type STRING,
    error_severity STRING,
    error_description STRING,
    failed_record_count NUMBER,
    error_column STRING,
    error_value STRING,
    expected_format STRING,
    resolution_status STRING,
    resolution_timestamp TIMESTAMP_NTZ,
    processed_by STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING
);
```

### • 2.2 Si_Validation_Rules_Log Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_validation_rules_log (
    validation_log_id NUMBER,
    validation_timestamp TIMESTAMP_NTZ,
    rule_name STRING,
    target_table STRING,
    target_column STRING,
    rule_description STRING,
    records_processed NUMBER,
    records_passed NUMBER,
    records_failed NUMBER,
    pass_rate_percentage NUMBER(5,2),
    rule_execution_time NUMBER(10,3),
    rule_status STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING
);
```

## 3. Audit Table DDL Script

### • 3.1 Si_Pipeline_Audit_Log Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_pipeline_audit_log (
    audit_id NUMBER,
    execution_id STRING,
    pipeline_name STRING,
    start_time TIMESTAMP_NTZ,
    end_time TIMESTAMP_NTZ,
    status STRING,
    error_message STRING,
    pipeline_run_id STRING,
    execution_start_time TIMESTAMP_NTZ,
    execution_end_time TIMESTAMP_NTZ,
    execution_duration NUMBER(10,3),
    pipeline_status STRING,
    source_table STRING,
    target_table STRING,
    records_read NUMBER,
    records_processed NUMBER,
    records_inserted NUMBER,
    records_updated NUMBER,
    records_rejected NUMBER,
    error_count NUMBER,
    warning_count NUMBER,
    processed_by STRING,
    pipeline_version STRING,
    configuration_parameters STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING
);
```

### • 3.2 Si_Process_Performance_Metrics Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_process_performance_metrics (
    metric_id NUMBER,
    metric_timestamp TIMESTAMP_NTZ,
    process_name STRING,
    metric_type STRING,
    metric_value NUMBER(15,4),
    metric_unit STRING,
    table_name STRING,
    record_count NUMBER,
    cpu_usage_percentage NUMBER(5,2),
    memory_usage_mb NUMBER(10,2),
    io_operations NUMBER,
    network_usage_mb NUMBER(10,2),
    optimization_recommendations STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING
);
```

## 4. Update DDL Scripts (for schema evolution)

### • 4.1 Add New Columns to Existing Tables
```sql
-- Example: Add new column to si_products table
ALTER TABLE Silver.si_products ADD COLUMN product_description STRING;
ALTER TABLE Silver.si_products ADD COLUMN unit_price NUMBER(10,2);

-- Example: Add new column to si_customers table
ALTER TABLE Silver.si_customers ADD COLUMN phone_number STRING;
ALTER TABLE Silver.si_customers ADD COLUMN address STRING;

-- Example: Add new column to si_orders table
ALTER TABLE Silver.si_orders ADD COLUMN order_status STRING;
ALTER TABLE Silver.si_orders ADD COLUMN total_amount NUMBER(12,2);
```

### • 4.2 Modify Existing Column Data Types
```sql
-- Example: Modify column data types for better precision
ALTER TABLE Silver.si_inventory ALTER COLUMN Quantity_Available SET DATA TYPE NUMBER(12,0);
ALTER TABLE Silver.si_warehouses ALTER COLUMN Capacity SET DATA TYPE NUMBER(15,0);
```

### • 4.3 Create Indexes for Performance Optimization
```sql
-- Create clustering keys for better query performance
ALTER TABLE Silver.si_products CLUSTER BY (product_id, Category);
ALTER TABLE Silver.si_inventory CLUSTER BY (product_id, warehouse_id);
ALTER TABLE Silver.si_orders CLUSTER BY (customer_id, Order_Date);
ALTER TABLE Silver.si_order_details CLUSTER BY (order_id, product_id);
```

## 5. Conceptual Data Model Diagram in Tabular Form

| Source Entity | Target Entity | Relationship Key Field | Relationship Type | Description |
|---------------|---------------|----------------------|-------------------|-------------|
| si_products | si_inventory | product_id | One-to-Many | Each product can have multiple inventory records across warehouses |
| si_products | si_order_details | product_id | One-to-Many | Each product can appear in multiple order details |
| si_products | si_stock_levels | product_id | One-to-Many | Each product can have stock levels in multiple warehouses |
| si_products | si_suppliers | product_id | Many-to-One | Multiple products can be supplied by one supplier |
| si_warehouses | si_inventory | warehouse_id | One-to-Many | Each warehouse can store multiple products |
| si_warehouses | si_stock_levels | warehouse_id | One-to-Many | Each warehouse can have multiple stock level configurations |
| si_orders | si_order_details | order_id | One-to-Many | Each order can have multiple order detail lines |
| si_orders | si_shipments | order_id | One-to-One | Each order can have one shipment record |
| si_orders | si_returns | order_id | One-to-One | Each order can have one return record |
| si_customers | si_orders | customer_id | One-to-Many | Each customer can place multiple orders |
| si_data_quality_errors | All Si_Tables | source_table | Monitoring | Error tracking for all Silver layer tables |
| si_validation_rules_log | All Si_Tables | target_table | Monitoring | Validation rule tracking for all Silver layer tables |
| si_pipeline_audit_log | All Si_Tables | target_table | Audit | Pipeline execution audit for all Silver layer tables |
| si_process_performance_metrics | All Si_Tables | table_name | Performance | Performance metrics tracking for all Silver layer tables |

## 6. Data Quality and Business Rules Implementation

### • 6.1 Data Validation Rules
```sql
-- Validation for non-negative quantities
CREATE OR REPLACE VIEW Silver.vw_inventory_validation AS
SELECT *,
       CASE WHEN Quantity_Available < 0 THEN 'INVALID_QUANTITY' ELSE 'VALID' END AS validation_status
FROM Silver.si_inventory;

-- Validation for proper date sequences
CREATE OR REPLACE VIEW Silver.vw_shipment_date_validation AS
SELECT s.*, o.Order_Date,
       CASE WHEN s.Shipment_Date < o.Order_Date THEN 'INVALID_DATE_SEQUENCE' ELSE 'VALID' END AS validation_status
FROM Silver.si_shipments s
JOIN Silver.si_orders o ON s.order_id = o.order_id;
```

### • 6.2 Data Cleansing Procedures
```sql
-- Standardize product names
CREATE OR REPLACE PROCEDURE Silver.sp_standardize_product_names()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    UPDATE Silver.si_products 
    SET Product_Name = TRIM(UPPER(Product_Name)),
        update_date = CURRENT_DATE(),
        update_timestamp = CURRENT_TIMESTAMP();
    
    RETURN 'Product names standardized successfully';
END;
$$;

-- Validate and format contact numbers
CREATE OR REPLACE PROCEDURE Silver.sp_validate_contact_numbers()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    UPDATE Silver.si_suppliers 
    SET Contact_Number = REGEXP_REPLACE(Contact_Number, '[^0-9+()-]', ''),
        update_date = CURRENT_DATE(),
        update_timestamp = CURRENT_TIMESTAMP()
    WHERE Contact_Number IS NOT NULL;
    
    RETURN 'Contact numbers validated and formatted successfully';
END;
$$;
```

## 7. Performance Optimization Features

### • 7.1 Micro-partitioning Strategy
```sql
-- Snowflake automatically handles micro-partitioning
-- Tables are optimized for the following query patterns:
-- - si_orders: Partitioned by Order_Date for time-based queries
-- - si_inventory: Partitioned by product_id and warehouse_id for inventory lookups
-- - si_shipments: Partitioned by Shipment_Date for shipping analytics
```

### • 7.2 Clustering Keys for Large Tables
```sql
-- Set clustering keys for frequently queried large tables
ALTER TABLE Silver.si_orders CLUSTER BY (Order_Date, customer_id);
ALTER TABLE Silver.si_inventory CLUSTER BY (product_id, warehouse_id);
ALTER TABLE Silver.si_order_details CLUSTER BY (order_id, product_id);
```

## 8. Security and Compliance Features

### • 8.1 Row-Level Security Setup
```sql
-- Create row access policy for customer data
CREATE OR REPLACE ROW ACCESS POLICY Silver.customer_data_policy AS (customer_id NUMBER) RETURNS BOOLEAN ->
    CURRENT_ROLE() IN ('ADMIN_ROLE', 'DATA_ANALYST_ROLE') OR 
    CURRENT_USER() = 'CUSTOMER_SERVICE_USER';

-- Apply policy to customer-related tables
ALTER TABLE Silver.si_customers ADD ROW ACCESS POLICY Silver.customer_data_policy ON (customer_id);
ALTER TABLE Silver.si_orders ADD ROW ACCESS POLICY Silver.customer_data_policy ON (customer_id);
```

### • 8.2 Column-Level Security for PII
```sql
-- Create masking policy for email addresses
CREATE OR REPLACE MASKING POLICY Silver.email_mask AS (val STRING) RETURNS STRING ->
    CASE
        WHEN CURRENT_ROLE() IN ('ADMIN_ROLE', 'COMPLIANCE_ROLE') THEN val
        ELSE REGEXP_REPLACE(val, '.+@', '*****@')
    END;

-- Apply masking policy to email columns
ALTER TABLE Silver.si_customers ALTER COLUMN Email SET MASKING POLICY Silver.email_mask;
```

## 9. Data Lineage and Metadata Management

### • 9.1 Data Lineage Tracking
```sql
CREATE TABLE IF NOT EXISTS Silver.si_data_lineage (
    lineage_id NUMBER,
    source_schema STRING,
    source_table STRING,
    source_column STRING,
    target_schema STRING,
    target_table STRING,
    target_column STRING,
    transformation_logic STRING,
    created_timestamp TIMESTAMP_NTZ,
    created_by STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING
);
```

### • 9.2 Table and Column Metadata
```sql
CREATE TABLE IF NOT EXISTS Silver.si_table_metadata (
    metadata_id NUMBER,
    schema_name STRING,
    table_name STRING,
    column_name STRING,
    data_type STRING,
    is_nullable BOOLEAN,
    column_description STRING,
    business_definition STRING,
    data_classification STRING,
    created_timestamp TIMESTAMP_NTZ,
    modified_timestamp TIMESTAMP_NTZ,
    load_date DATE,
    update_date DATE,
    source_system STRING
);
```

## 10. apiCost

**Cost consumed by the API for this call (in USD):** 0.285000