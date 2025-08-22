_____________________________________________
## *Author*: AAVA
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

### • Si_Products Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_products (
    product_id NUMBER,
    Product_Name STRING,
    Category STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    data_quality_score NUMBER(3,2),
    is_valid BOOLEAN
);
```

### • Si_Suppliers Table
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
    update_timestamp TIMESTAMP_NTZ,
    data_quality_score NUMBER(3,2),
    is_valid BOOLEAN
);
```

### • Si_Warehouses Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_warehouses (
    warehouse_id NUMBER,
    Location STRING,
    Capacity NUMBER,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    data_quality_score NUMBER(3,2),
    is_valid BOOLEAN
);
```

### • Si_Inventory Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_inventory (
    inventory_id NUMBER,
    product_id NUMBER,
    warehouse_id NUMBER,
    Quantity_Available NUMBER,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    data_quality_score NUMBER(3,2),
    is_valid BOOLEAN
);
```

### • Si_Orders Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_orders (
    order_id NUMBER,
    customer_id NUMBER,
    Order_Date DATE,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    data_quality_score NUMBER(3,2),
    is_valid BOOLEAN
);
```

### • Si_Order_Details Table
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
    update_timestamp TIMESTAMP_NTZ,
    data_quality_score NUMBER(3,2),
    is_valid BOOLEAN
);
```

### • Si_Shipments Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_shipments (
    shipment_id NUMBER,
    order_id NUMBER,
    Shipment_Date DATE,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    data_quality_score NUMBER(3,2),
    is_valid BOOLEAN
);
```

### • Si_Returns Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_returns (
    return_id NUMBER,
    order_id NUMBER,
    Return_Reason STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    data_quality_score NUMBER(3,2),
    is_valid BOOLEAN
);
```

### • Si_Stock_Levels Table
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
    update_timestamp TIMESTAMP_NTZ,
    data_quality_score NUMBER(3,2),
    is_valid BOOLEAN
);
```

### • Si_Customers Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_customers (
    customer_id NUMBER,
    Customer_Name STRING,
    Email STRING,
    load_date DATE,
    update_date DATE,
    source_system STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    data_quality_score NUMBER(3,2),
    is_valid BOOLEAN
);
```

## 2. Error Data Table DDL Script

### • Si_Data_Quality_Errors Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_data_quality_errors (
    error_id NUMBER AUTOINCREMENT,
    table_name STRING,
    column_name STRING,
    error_type STRING,
    error_description STRING,
    record_count NUMBER,
    severity_level STRING,
    detection_timestamp TIMESTAMP_NTZ,
    source_system STRING,
    pipeline_run_id STRING,
    load_date DATE,
    update_date DATE
);
```

## 3. Audit Table DDL Script

### • Si_Pipeline_Audit Table
```sql
CREATE TABLE IF NOT EXISTS Silver.si_pipeline_audit (
    execution_id NUMBER AUTOINCREMENT,
    pipeline_name STRING,
    start_time TIMESTAMP_NTZ,
    end_time TIMESTAMP_NTZ,
    status STRING,
    error_message STRING,
    execution_start_time TIMESTAMP_NTZ,
    execution_end_time TIMESTAMP_NTZ,
    execution_status STRING,
    records_processed NUMBER,
    records_passed NUMBER,
    records_failed NUMBER,
    transformation_rules_applied STRING,
    error_summary STRING,
    source_system STRING,
    target_table STRING,
    load_date DATE,
    update_date DATE
);
```

## 4. Update DDL Scripts

### • Schema Evolution Scripts
```sql
-- Add new columns to existing tables if needed
ALTER TABLE Silver.si_products ADD COLUMN IF NOT EXISTS product_status STRING DEFAULT 'ACTIVE';
ALTER TABLE Silver.si_products ADD COLUMN IF NOT EXISTS created_by STRING DEFAULT 'SYSTEM';

ALTER TABLE Silver.si_suppliers ADD COLUMN IF NOT EXISTS supplier_status STRING DEFAULT 'ACTIVE';
ALTER TABLE Silver.si_suppliers ADD COLUMN IF NOT EXISTS created_by STRING DEFAULT 'SYSTEM';

ALTER TABLE Silver.si_warehouses ADD COLUMN IF NOT EXISTS warehouse_status STRING DEFAULT 'ACTIVE';
ALTER TABLE Silver.si_warehouses ADD COLUMN IF NOT EXISTS created_by STRING DEFAULT 'SYSTEM';

ALTER TABLE Silver.si_inventory ADD COLUMN IF NOT EXISTS last_updated_by STRING DEFAULT 'SYSTEM';
ALTER TABLE Silver.si_inventory ADD COLUMN IF NOT EXISTS inventory_status STRING DEFAULT 'ACTIVE';

ALTER TABLE Silver.si_orders ADD COLUMN IF NOT EXISTS order_status STRING DEFAULT 'PENDING';
ALTER TABLE Silver.si_orders ADD COLUMN IF NOT EXISTS created_by STRING DEFAULT 'SYSTEM';

ALTER TABLE Silver.si_order_details ADD COLUMN IF NOT EXISTS line_status STRING DEFAULT 'ACTIVE';
ALTER TABLE Silver.si_order_details ADD COLUMN IF NOT EXISTS created_by STRING DEFAULT 'SYSTEM';

ALTER TABLE Silver.si_shipments ADD COLUMN IF NOT EXISTS shipment_status STRING DEFAULT 'PENDING';
ALTER TABLE Silver.si_shipments ADD COLUMN IF NOT EXISTS created_by STRING DEFAULT 'SYSTEM';

ALTER TABLE Silver.si_returns ADD COLUMN IF NOT EXISTS return_status STRING DEFAULT 'PENDING';
ALTER TABLE Silver.si_returns ADD COLUMN IF NOT EXISTS created_by STRING DEFAULT 'SYSTEM';

ALTER TABLE Silver.si_stock_levels ADD COLUMN IF NOT EXISTS threshold_status STRING DEFAULT 'ACTIVE';
ALTER TABLE Silver.si_stock_levels ADD COLUMN IF NOT EXISTS created_by STRING DEFAULT 'SYSTEM';

ALTER TABLE Silver.si_customers ADD COLUMN IF NOT EXISTS customer_status STRING DEFAULT 'ACTIVE';
ALTER TABLE Silver.si_customers ADD COLUMN IF NOT EXISTS created_by STRING DEFAULT 'SYSTEM';
```

### • Performance Optimization Scripts
```sql
-- Create clustering keys for better performance
ALTER TABLE Silver.si_products CLUSTER BY (product_id, Category);
ALTER TABLE Silver.si_suppliers CLUSTER BY (supplier_id, product_id);
ALTER TABLE Silver.si_warehouses CLUSTER BY (warehouse_id, Location);
ALTER TABLE Silver.si_inventory CLUSTER BY (product_id, warehouse_id);
ALTER TABLE Silver.si_orders CLUSTER BY (order_id, customer_id, Order_Date);
ALTER TABLE Silver.si_order_details CLUSTER BY (order_id, product_id);
ALTER TABLE Silver.si_shipments CLUSTER BY (order_id, Shipment_Date);
ALTER TABLE Silver.si_returns CLUSTER BY (order_id, return_id);
ALTER TABLE Silver.si_stock_levels CLUSTER BY (warehouse_id, product_id);
ALTER TABLE Silver.si_customers CLUSTER BY (customer_id);
ALTER TABLE Silver.si_data_quality_errors CLUSTER BY (detection_timestamp, severity_level);
ALTER TABLE Silver.si_pipeline_audit CLUSTER BY (start_time, pipeline_name);
```

### • Data Retention Scripts
```sql
-- Set data retention policies
ALTER TABLE Silver.si_data_quality_errors SET DATA_RETENTION_TIME_IN_DAYS = 90;
ALTER TABLE Silver.si_pipeline_audit SET DATA_RETENTION_TIME_IN_DAYS = 365;
```

## 5. Design Decisions and Assumptions

### • **Design Decisions:**
1. **ID Fields Added:** All tables include appropriate ID fields (product_id, supplier_id, etc.) as they were missing in the logical model
2. **Metadata Columns:** Added load_date, update_date, and source_system as required metadata columns
3. **Data Quality Columns:** Included data_quality_score and is_valid for data quality tracking
4. **Snowflake Datatypes:** Used Snowflake-native datatypes (STRING, NUMBER, BOOLEAN, DATE, TIMESTAMP_NTZ)
5. **No Constraints:** Following requirements, no primary keys, foreign keys, or constraints are defined
6. **Clustering Keys:** Added clustering keys for performance optimization on frequently queried columns
7. **Auto-increment:** Used AUTOINCREMENT for system-generated IDs in audit and error tables

### • **Assumptions:**
1. **Bronze Integration:** All Bronze layer columns are preserved in Silver layer with additional cleansing metadata
2. **Data Quality:** Silver layer focuses on data cleansing and validation with quality scoring
3. **Audit Trail:** Comprehensive audit trail maintained for pipeline execution and data quality issues
4. **Performance:** Clustering keys chosen based on typical query patterns for inventory management
5. **Retention:** Different retention policies for operational vs audit data
6. **Schema Evolution:** Provision for adding new columns without breaking existing processes

## 6. API Cost

• **apiCost**: 0.425000
