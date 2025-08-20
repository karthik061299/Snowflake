_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Gold Layer Physical Data Model for Inventory Management System following Medallion Architecture
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Gold Layer Physical Data Model - Inventory Management System

## 1. Gold Layer DDL Scripts

### • Create Gold Schema
```sql
CREATE SCHEMA IF NOT EXISTS Gold;
```

## 2. Dimension Tables DDL Scripts

### • Go_Dim_Products Table (SCD Type 2)
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Dim_Products (
    product_key VARCHAR(50),
    product_id NUMBER,
    product_name VARCHAR(200),
    product_code VARCHAR(50),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    brand VARCHAR(100),
    product_description VARCHAR(1000),
    standard_cost NUMBER(12,2),
    list_price NUMBER(12,2),
    unit_of_measure VARCHAR(20),
    weight NUMBER(8,2),
    dimensions VARCHAR(50),
    color VARCHAR(30),
    size VARCHAR(20),
    is_active BOOLEAN,
    effective_date DATE,
    expiry_date DATE,
    is_current BOOLEAN,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Dim_Suppliers Table (SCD Type 2)
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Dim_Suppliers (
    supplier_key VARCHAR(50),
    supplier_id NUMBER,
    supplier_name VARCHAR(200),
    supplier_code VARCHAR(50),
    contact_name VARCHAR(100),
    contact_number VARCHAR(20),
    email_address VARCHAR(100),
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    supplier_type VARCHAR(50),
    supplier_rating NUMBER(3,2),
    payment_terms VARCHAR(50),
    is_active BOOLEAN,
    effective_date DATE,
    expiry_date DATE,
    is_current BOOLEAN,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Dim_Warehouses Table (SCD Type 1)
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Dim_Warehouses (
    warehouse_key VARCHAR(50),
    warehouse_id NUMBER,
    warehouse_name VARCHAR(200),
    warehouse_code VARCHAR(50),
    location VARCHAR(200),
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    capacity NUMBER(12,0),
    manager_name VARCHAR(100),
    contact_number VARCHAR(20),
    warehouse_type VARCHAR(50),
    is_active BOOLEAN,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Dim_Customers Table (SCD Type 2)
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Dim_Customers (
    customer_key VARCHAR(50),
    customer_id NUMBER,
    customer_name VARCHAR(200),
    customer_code VARCHAR(50),
    customer_type VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    credit_limit NUMBER(15,2),
    payment_terms VARCHAR(50),
    customer_segment VARCHAR(50),
    registration_date DATE,
    is_active BOOLEAN,
    effective_date DATE,
    expiry_date DATE,
    is_current BOOLEAN,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Dim_Date Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Dim_Date (
    date_key VARCHAR(50),
    full_date DATE,
    day_of_week NUMBER(1,0),
    day_name VARCHAR(10),
    day_of_month NUMBER(2,0),
    day_of_year NUMBER(3,0),
    week_of_year NUMBER(2,0),
    month_number NUMBER(2,0),
    month_name VARCHAR(10),
    month_abbrev VARCHAR(3),
    quarter_number NUMBER(1,0),
    quarter_name VARCHAR(2),
    year_number NUMBER(4,0),
    is_weekend BOOLEAN,
    is_holiday BOOLEAN,
    holiday_name VARCHAR(100),
    fiscal_year NUMBER(4,0),
    fiscal_quarter NUMBER(1,0),
    fiscal_month NUMBER(2,0),
    season VARCHAR(10),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

## 3. Code Tables DDL Scripts

### • Go_Code_Product_Categories Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Code_Product_Categories (
    category_id NUMBER,
    category_code VARCHAR(20),
    category_name VARCHAR(100),
    category_description VARCHAR(500),
    parent_category VARCHAR(20),
    category_level NUMBER(2,0),
    sort_order NUMBER(4,0),
    is_active BOOLEAN,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Code_Return_Reasons Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Code_Return_Reasons (
    reason_id NUMBER,
    reason_code VARCHAR(20),
    reason_name VARCHAR(100),
    reason_description VARCHAR(500),
    reason_category VARCHAR(50),
    is_restockable BOOLEAN,
    refund_eligible BOOLEAN,
    sort_order NUMBER(4,0),
    is_active BOOLEAN,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Code_Order_Status Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Code_Order_Status (
    status_id NUMBER,
    status_code VARCHAR(20),
    status_name VARCHAR(100),
    status_description VARCHAR(500),
    status_sequence NUMBER(3,0),
    is_final_status BOOLEAN,
    allows_modification BOOLEAN,
    sort_order NUMBER(4,0),
    is_active BOOLEAN,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Code_Stock_Status Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Code_Stock_Status (
    status_id NUMBER,
    status_code VARCHAR(20),
    status_name VARCHAR(100),
    status_description VARCHAR(500),
    min_threshold_pct NUMBER(5,2),
    max_threshold_pct NUMBER(5,2),
    alert_required BOOLEAN,
    sort_order NUMBER(4,0),
    is_active BOOLEAN,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

## 4. Fact Tables DDL Scripts

### • Go_Fact_Inventory_Transactions Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Fact_Inventory_Transactions (
    transaction_id NUMBER,
    transaction_date DATE,
    product_key VARCHAR(50),
    warehouse_key VARCHAR(50),
    supplier_key VARCHAR(50),
    transaction_type VARCHAR(50),
    transaction_reference VARCHAR(100),
    quantity_change NUMBER(12,0),
    unit_cost NUMBER(12,4),
    total_value NUMBER(15,2),
    transaction_reason VARCHAR(100),
    reference_number VARCHAR(100),
    batch_number VARCHAR(50),
    expiry_date DATE,
    created_by VARCHAR(100),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Fact_Orders Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Fact_Orders (
    order_id NUMBER,
    order_date DATE,
    customer_key VARCHAR(50),
    order_number VARCHAR(100),
    order_status VARCHAR(50),
    order_priority VARCHAR(20),
    total_quantity NUMBER(12,0),
    total_amount NUMBER(15,2),
    discount_amount NUMBER(12,2),
    tax_amount NUMBER(12,2),
    shipping_cost NUMBER(10,2),
    payment_method VARCHAR(50),
    fulfillment_date DATE,
    is_fulfilled BOOLEAN,
    days_to_fulfill NUMBER(6,0),
    sales_channel VARCHAR(50),
    created_by VARCHAR(100),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Fact_Shipments Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Fact_Shipments (
    shipment_id NUMBER,
    shipment_date DATE,
    order_id NUMBER,
    warehouse_key VARCHAR(50),
    customer_key VARCHAR(50),
    shipment_number VARCHAR(100),
    carrier_name VARCHAR(100),
    tracking_number VARCHAR(100),
    shipment_method VARCHAR(50),
    shipment_weight NUMBER(10,2),
    shipment_cost NUMBER(12,2),
    estimated_delivery_date DATE,
    delivery_date DATE,
    days_in_transit NUMBER(4,0),
    is_delivered BOOLEAN,
    delivery_status VARCHAR(50),
    created_by VARCHAR(100),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Fact_Returns Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Fact_Returns (
    return_id NUMBER,
    return_date DATE,
    order_id NUMBER,
    product_key VARCHAR(50),
    customer_key VARCHAR(50),
    warehouse_key VARCHAR(50),
    return_number VARCHAR(100),
    return_reason_code VARCHAR(20),
    return_quantity NUMBER(10,0),
    return_value NUMBER(12,2),
    refund_amount NUMBER(12,2),
    restocking_fee NUMBER(10,2),
    is_restockable BOOLEAN,
    condition_received VARCHAR(50),
    days_since_purchase NUMBER(6,0),
    processed_by VARCHAR(100),
    created_by VARCHAR(100),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Fact_Stock_Levels Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Fact_Stock_Levels (
    stock_level_id NUMBER,
    snapshot_date DATE,
    product_key VARCHAR(50),
    warehouse_key VARCHAR(50),
    quantity_on_hand NUMBER(12,0),
    quantity_available NUMBER(12,0),
    quantity_reserved NUMBER(12,0),
    quantity_on_order NUMBER(12,0),
    reorder_point NUMBER(10,0),
    reorder_quantity NUMBER(10,0),
    maximum_stock_level NUMBER(12,0),
    minimum_stock_level NUMBER(10,0),
    stock_status VARCHAR(20),
    days_of_supply NUMBER(6,2),
    unit_cost NUMBER(12,4),
    total_value NUMBER(15,2),
    last_movement_date DATE,
    created_by VARCHAR(100),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

## 5. Aggregate Tables DDL Scripts

### • Go_Agg_Daily_Inventory_Summary Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Agg_Daily_Inventory_Summary (
    summary_id NUMBER,
    summary_date DATE,
    product_key VARCHAR(50),
    warehouse_key VARCHAR(50),
    opening_quantity NUMBER(12,0),
    receipts_quantity NUMBER(12,0),
    issues_quantity NUMBER(12,0),
    adjustments_quantity NUMBER(12,0),
    closing_quantity NUMBER(12,0),
    average_quantity NUMBER(12,2),
    minimum_quantity NUMBER(12,0),
    maximum_quantity NUMBER(12,0),
    total_value NUMBER(15,2),
    turnover_rate NUMBER(8,4),
    movement_frequency NUMBER(6,0),
    stockout_duration NUMBER(6,2),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Agg_Monthly_Product_Performance Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Agg_Monthly_Product_Performance (
    performance_id NUMBER,
    performance_month DATE,
    product_key VARCHAR(50),
    total_orders NUMBER(8,0),
    total_quantity_ordered NUMBER(12,0),
    total_revenue NUMBER(15,2),
    average_order_quantity NUMBER(10,2),
    return_quantity NUMBER(10,0),
    return_rate NUMBER(5,4),
    gross_margin NUMBER(15,2),
    margin_percentage NUMBER(5,2),
    demand_ranking NUMBER(6,0),
    inventory_turnover NUMBER(8,4),
    stockout_days NUMBER(4,0),
    backorder_quantity NUMBER(10,0),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Agg_Warehouse_Utilization Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Agg_Warehouse_Utilization (
    utilization_id NUMBER,
    utilization_month DATE,
    warehouse_key VARCHAR(50),
    total_capacity NUMBER(12,0),
    average_utilization NUMBER(12,0),
    peak_utilization NUMBER(12,0),
    utilization_percentage NUMBER(5,2),
    available_capacity NUMBER(12,0),
    capacity_variance NUMBER(10,2),
    products_stored NUMBER(8,0),
    inventory_value NUMBER(15,2),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Agg_Supplier_Performance Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Agg_Supplier_Performance (
    performance_id NUMBER,
    performance_month DATE,
    supplier_key VARCHAR(50),
    products_supplied NUMBER(8,0),
    total_receipts NUMBER(12,0),
    total_value NUMBER(15,2),
    on_time_deliveries NUMBER(8,0),
    total_deliveries NUMBER(8,0),
    on_time_percentage NUMBER(5,2),
    quality_issues NUMBER(6,0),
    quality_rate NUMBER(5,4),
    average_lead_time NUMBER(6,2),
    single_source_products NUMBER(6,0),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

### • Go_Agg_Customer_Analytics Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Agg_Customer_Analytics (
    analytics_id NUMBER,
    analytics_month DATE,
    customer_key VARCHAR(50),
    total_orders NUMBER(8,0),
    total_quantity NUMBER(12,0),
    total_revenue NUMBER(15,2),
    average_order_value NUMBER(12,2),
    return_orders NUMBER(6,0),
    return_quantity NUMBER(10,0),
    return_frequency NUMBER(5,4),
    days_since_last_order NUMBER(6,0),
    customer_lifetime_value NUMBER(15,2),
    order_frequency NUMBER(6,2),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

## 6. Error Data Table DDL Script

### • Go_Data_Quality_Errors Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Data_Quality_Errors (
    error_key VARCHAR(50),
    pipeline_run_id VARCHAR(50),
    error_timestamp TIMESTAMP_NTZ,
    source_table VARCHAR(100),
    target_table VARCHAR(100),
    column_name VARCHAR(100),
    error_type VARCHAR(50),
    error_category VARCHAR(50),
    error_code VARCHAR(20),
    error_description VARCHAR(1000),
    error_severity VARCHAR(20),
    business_impact VARCHAR(500),
    affected_records NUMBER(10,0),
    sample_values VARCHAR(1000),
    expected_format VARCHAR(200),
    actual_format VARCHAR(200),
    validation_rule VARCHAR(500),
    business_rule VARCHAR(500),
    suggested_action VARCHAR(500),
    resolution_status VARCHAR(20),
    resolution_notes VARCHAR(1000),
    resolved_by VARCHAR(100),
    resolved_timestamp TIMESTAMP_NTZ,
    recurrence_count NUMBER(6,0),
    first_occurrence TIMESTAMP_NTZ,
    last_occurrence TIMESTAMP_NTZ,
    data_source VARCHAR(100),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

## 7. Audit Table DDL Script

### • Go_Process_Audit Table
```sql
CREATE TABLE IF NOT EXISTS Gold.Go_Process_Audit (
    audit_key VARCHAR(50),
    pipeline_name VARCHAR(100),
    pipeline_type VARCHAR(50),
    execution_start_time TIMESTAMP_NTZ,
    execution_end_time TIMESTAMP_NTZ,
    execution_duration_seconds NUMBER(10,0),
    execution_status VARCHAR(20),
    source_tables VARCHAR(1000),
    target_tables VARCHAR(1000),
    records_read NUMBER(15,0),
    records_processed NUMBER(15,0),
    records_inserted NUMBER(15,0),
    records_updated NUMBER(15,0),
    records_deleted NUMBER(15,0),
    records_rejected NUMBER(10,0),
    data_quality_score NUMBER(5,4),
    transformation_rules_applied VARCHAR(1000),
    business_rules_validated VARCHAR(1000),
    error_count NUMBER(8,0),
    warning_count NUMBER(8,0),
    error_summary VARCHAR(1000),
    performance_metrics VARCHAR(1000),
    resource_utilization VARCHAR(1000),
    checkpoint_data VARCHAR(1000),
    configuration_parameters VARCHAR(1000),
    data_lineage_info VARCHAR(1000),
    created_by VARCHAR(100),
    environment VARCHAR(20),
    version VARCHAR(20),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(50)
);
```

## 8. Update DDL Scripts

### • Schema Evolution Scripts
```sql
-- Add new columns to existing tables if needed
ALTER TABLE Gold.Go_Dim_Products ADD COLUMN IF NOT EXISTS product_lifecycle_stage VARCHAR(50) DEFAULT 'ACTIVE';
ALTER TABLE Gold.Go_Dim_Products ADD COLUMN IF NOT EXISTS created_by VARCHAR(100) DEFAULT 'SYSTEM';

ALTER TABLE Gold.Go_Dim_Suppliers ADD COLUMN IF NOT EXISTS supplier_tier VARCHAR(20) DEFAULT 'STANDARD';
ALTER TABLE Gold.Go_Dim_Suppliers ADD COLUMN IF NOT EXISTS created_by VARCHAR(100) DEFAULT 'SYSTEM';

ALTER TABLE Gold.Go_Dim_Warehouses ADD COLUMN IF NOT EXISTS warehouse_tier VARCHAR(20) DEFAULT 'STANDARD';
ALTER TABLE Gold.Go_Dim_Warehouses ADD COLUMN IF NOT EXISTS created_by VARCHAR(100) DEFAULT 'SYSTEM';

ALTER TABLE Gold.Go_Dim_Customers ADD COLUMN IF NOT EXISTS customer_tier VARCHAR(20) DEFAULT 'STANDARD';
ALTER TABLE Gold.Go_Dim_Customers ADD COLUMN IF NOT EXISTS created_by VARCHAR(100) DEFAULT 'SYSTEM';

ALTER TABLE Gold.Go_Fact_Inventory_Transactions ADD COLUMN IF NOT EXISTS transaction_status VARCHAR(20) DEFAULT 'COMPLETED';
ALTER TABLE Gold.Go_Fact_Orders ADD COLUMN IF NOT EXISTS order_source VARCHAR(50) DEFAULT 'ONLINE';
ALTER TABLE Gold.Go_Fact_Shipments ADD COLUMN IF NOT EXISTS shipment_priority VARCHAR(20) DEFAULT 'STANDARD';
ALTER TABLE Gold.Go_Fact_Returns ADD COLUMN IF NOT EXISTS return_status VARCHAR(20) DEFAULT 'PENDING';
ALTER TABLE Gold.Go_Fact_Stock_Levels ADD COLUMN IF NOT EXISTS stock_valuation_method VARCHAR(20) DEFAULT 'FIFO';
```

### • Performance Optimization Scripts
```sql
-- Create clustering keys for better performance
ALTER TABLE Gold.Go_Dim_Products CLUSTER BY (product_key, category);
ALTER TABLE Gold.Go_Dim_Suppliers CLUSTER BY (supplier_key, supplier_type);
ALTER TABLE Gold.Go_Dim_Warehouses CLUSTER BY (warehouse_key, location);
ALTER TABLE Gold.Go_Dim_Customers CLUSTER BY (customer_key, customer_type);
ALTER TABLE Gold.Go_Dim_Date CLUSTER BY (full_date, year_number);

ALTER TABLE Gold.Go_Fact_Inventory_Transactions CLUSTER BY (transaction_date, product_key, warehouse_key);
ALTER TABLE Gold.Go_Fact_Orders CLUSTER BY (order_date, customer_key);
ALTER TABLE Gold.Go_Fact_Shipments CLUSTER BY (shipment_date, warehouse_key);
ALTER TABLE Gold.Go_Fact_Returns CLUSTER BY (return_date, customer_key);
ALTER TABLE Gold.Go_Fact_Stock_Levels CLUSTER BY (snapshot_date, product_key, warehouse_key);

ALTER TABLE Gold.Go_Agg_Daily_Inventory_Summary CLUSTER BY (summary_date, product_key);
ALTER TABLE Gold.Go_Agg_Monthly_Product_Performance CLUSTER BY (performance_month, product_key);
ALTER TABLE Gold.Go_Agg_Warehouse_Utilization CLUSTER BY (utilization_month, warehouse_key);
ALTER TABLE Gold.Go_Agg_Supplier_Performance CLUSTER BY (performance_month, supplier_key);
ALTER TABLE Gold.Go_Agg_Customer_Analytics CLUSTER BY (analytics_month, customer_key);

ALTER TABLE Gold.Go_Data_Quality_Errors CLUSTER BY (error_timestamp, error_severity);
ALTER TABLE Gold.Go_Process_Audit CLUSTER BY (execution_start_time, pipeline_name);
```

### • Data Retention Scripts
```sql
-- Set data retention policies
ALTER TABLE Gold.Go_Data_Quality_Errors SET DATA_RETENTION_TIME_IN_DAYS = 365;
ALTER TABLE Gold.Go_Process_Audit SET DATA_RETENTION_TIME_IN_DAYS = 1095;
ALTER TABLE Gold.Go_Fact_Inventory_Transactions SET DATA_RETENTION_TIME_IN_DAYS = 2555;
ALTER TABLE Gold.Go_Fact_Orders SET DATA_RETENTION_TIME_IN_DAYS = 2555;
ALTER TABLE Gold.Go_Fact_Shipments SET DATA_RETENTION_TIME_IN_DAYS = 2555;
ALTER TABLE Gold.Go_Fact_Returns SET DATA_RETENTION_TIME_IN_DAYS = 2555;
ALTER TABLE Gold.Go_Fact_Stock_Levels SET DATA_RETENTION_TIME_IN_DAYS = 1095;
```

## 9. Design Decisions and Assumptions

### • **Design Decisions:**
1. **ID Fields Added:** All tables include appropriate ID fields and key fields as they were missing in the logical model
2. **Dimensional Modeling:** Implemented star schema with fact tables, dimension tables, and code tables
3. **SCD Implementation:** Applied SCD Type 2 for Products, Suppliers, and Customers; SCD Type 1 for Warehouses
4. **Metadata Columns:** Added load_date, update_date, and source_system as required metadata columns
5. **Snowflake Datatypes:** Used Snowflake-native datatypes (VARCHAR, NUMBER, BOOLEAN, DATE, TIMESTAMP_NTZ)
6. **No Constraints:** Following requirements, no primary keys, foreign keys, or constraints are defined
7. **Clustering Keys:** Added clustering keys for performance optimization on frequently queried columns
8. **Aggregate Tables:** Pre-built aggregate tables for common reporting and analytics needs
9. **Code Tables:** Separate code tables for standardized reference data
10. **Comprehensive Audit:** Enhanced audit trail for Gold layer pipeline execution and data quality

### • **Assumptions:**
1. **Silver Integration:** All relevant Silver layer data is transformed and loaded into Gold layer dimensional model
2. **Business Intelligence:** Gold layer optimized for reporting, analytics, and business intelligence workloads
3. **Data Quality:** Comprehensive data quality monitoring and error tracking implemented
4. **Performance:** Clustering keys and aggregations designed for optimal query performance
5. **Retention:** Different retention policies based on data criticality and compliance requirements
6. **Schema Evolution:** Provision for adding new columns and tables without breaking existing processes
7. **Scalability:** Design supports high-volume transactional and analytical workloads
8. **Data Lineage:** Full traceability from Bronze through Silver to Gold layers

## 10. API Cost

• **apiCost**: 0.875000