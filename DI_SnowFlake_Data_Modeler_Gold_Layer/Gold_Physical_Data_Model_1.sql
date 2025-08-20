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

## 2. Dimension Tables

### • Dim_Products Table
```sql
CREATE TABLE IF NOT EXISTS Gold.dim_products (
    product_key NUMBER AUTOINCREMENT,
    product_id NUMBER,
    product_name VARCHAR(255),
    category VARCHAR(100),
    product_status VARCHAR(50),
    created_by VARCHAR(100),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN DEFAULT TRUE
);
```

### • Dim_Suppliers Table
```sql
CREATE TABLE IF NOT EXISTS Gold.dim_suppliers (
    supplier_key NUMBER AUTOINCREMENT,
    supplier_id NUMBER,
    supplier_name VARCHAR(255),
    contact_number VARCHAR(50),
    supplier_status VARCHAR(50),
    created_by VARCHAR(100),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN DEFAULT TRUE
);
```

### • Dim_Warehouses Table
```sql
CREATE TABLE IF NOT EXISTS Gold.dim_warehouses (
    warehouse_key NUMBER AUTOINCREMENT,
    warehouse_id NUMBER,
    location VARCHAR(255),
    capacity NUMBER,
    warehouse_status VARCHAR(50),
    created_by VARCHAR(100),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN DEFAULT TRUE
);
```

### • Dim_Customers Table
```sql
CREATE TABLE IF NOT EXISTS Gold.dim_customers (
    customer_key NUMBER AUTOINCREMENT,
    customer_id NUMBER,
    customer_name VARCHAR(255),
    email VARCHAR(255),
    customer_status VARCHAR(50),
    created_by VARCHAR(100),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    effective_start_date DATE,
    effective_end_date DATE,
    is_current BOOLEAN DEFAULT TRUE
);
```

### • Dim_Date Table
```sql
CREATE TABLE IF NOT EXISTS Gold.dim_date (
    date_key NUMBER,
    full_date DATE,
    day_of_week NUMBER,
    day_name VARCHAR(20),
    day_of_month NUMBER,
    day_of_year NUMBER,
    week_of_year NUMBER,
    month_number NUMBER,
    month_name VARCHAR(20),
    quarter NUMBER,
    year NUMBER,
    is_weekend BOOLEAN,
    is_holiday BOOLEAN,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
);
```

## 3. Fact Tables

### • Fact_Inventory Table
```sql
CREATE TABLE IF NOT EXISTS Gold.fact_inventory (
    inventory_fact_key NUMBER AUTOINCREMENT,
    inventory_id NUMBER,
    product_key NUMBER,
    warehouse_key NUMBER,
    date_key NUMBER,
    quantity_available NUMBER,
    reorder_threshold NUMBER,
    inventory_value NUMBER(15,2),
    days_of_supply NUMBER,
    inventory_turnover_rate NUMBER(10,4),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • Fact_Orders Table
```sql
CREATE TABLE IF NOT EXISTS Gold.fact_orders (
    order_fact_key NUMBER AUTOINCREMENT,
    order_id NUMBER,
    customer_key NUMBER,
    product_key NUMBER,
    warehouse_key NUMBER,
    order_date_key NUMBER,
    shipment_date_key NUMBER,
    quantity_ordered NUMBER,
    unit_price NUMBER(15,2),
    total_amount NUMBER(15,2),
    order_status VARCHAR(50),
    days_to_ship NUMBER,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • Fact_Returns Table
```sql
CREATE TABLE IF NOT EXISTS Gold.fact_returns (
    return_fact_key NUMBER AUTOINCREMENT,
    return_id NUMBER,
    order_id NUMBER,
    customer_key NUMBER,
    product_key NUMBER,
    return_date_key NUMBER,
    return_reason VARCHAR(255),
    return_quantity NUMBER,
    return_amount NUMBER(15,2),
    return_status VARCHAR(50),
    days_since_order NUMBER,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

### • Fact_Stock_Movements Table
```sql
CREATE TABLE IF NOT EXISTS Gold.fact_stock_movements (
    stock_movement_key NUMBER AUTOINCREMENT,
    movement_id NUMBER,
    product_key NUMBER,
    warehouse_key NUMBER,
    movement_date_key NUMBER,
    movement_type VARCHAR(50),
    quantity_change NUMBER,
    previous_stock_level NUMBER,
    new_stock_level NUMBER,
    movement_reason VARCHAR(255),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100),
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ
);
```

## 4. Aggregated Tables

### • Agg_Daily_Inventory_Summary Table
```sql
CREATE TABLE IF NOT EXISTS Gold.agg_daily_inventory_summary (
    summary_key NUMBER AUTOINCREMENT,
    date_key NUMBER,
    warehouse_key NUMBER,
    product_key NUMBER,
    total_quantity NUMBER,
    total_value NUMBER(15,2),
    avg_inventory_level NUMBER(10,2),
    min_inventory_level NUMBER,
    max_inventory_level NUMBER,
    stockout_days NUMBER,
    overstock_days NUMBER,
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
);
```

### • Agg_Monthly_Sales_Summary Table
```sql
CREATE TABLE IF NOT EXISTS Gold.agg_monthly_sales_summary (
    monthly_sales_key NUMBER AUTOINCREMENT,
    year_month VARCHAR(7),
    product_key NUMBER,
    warehouse_key NUMBER,
    customer_key NUMBER,
    total_orders NUMBER,
    total_quantity_sold NUMBER,
    total_revenue NUMBER(15,2),
    avg_order_value NUMBER(15,2),
    unique_customers NUMBER,
    return_rate NUMBER(5,4),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
);
```

### • Agg_Product_Performance Table
```sql
CREATE TABLE IF NOT EXISTS Gold.agg_product_performance (
    product_performance_key NUMBER AUTOINCREMENT,
    product_key NUMBER,
    analysis_period VARCHAR(20),
    period_start_date DATE,
    period_end_date DATE,
    total_sales_quantity NUMBER,
    total_sales_revenue NUMBER(15,2),
    avg_inventory_level NUMBER(10,2),
    inventory_turnover_ratio NUMBER(10,4),
    stockout_frequency NUMBER,
    return_quantity NUMBER,
    return_rate NUMBER(5,4),
    profit_margin NUMBER(5,4),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
);
```

### • Agg_Warehouse_Utilization Table
```sql
CREATE TABLE IF NOT EXISTS Gold.agg_warehouse_utilization (
    utilization_key NUMBER AUTOINCREMENT,
    warehouse_key NUMBER,
    date_key NUMBER,
    total_capacity NUMBER,
    used_capacity NUMBER,
    utilization_percentage NUMBER(5,2),
    available_capacity NUMBER,
    capacity_variance NUMBER,
    efficiency_score NUMBER(5,2),
    load_date DATE,
    update_date DATE,
    source_system VARCHAR(100)
);
```

## 5. Error Data Table DDL Script

### • Go_Data_Quality_Errors Table
```sql
CREATE TABLE IF NOT EXISTS Gold.go_data_quality_errors (
    error_id NUMBER AUTOINCREMENT,
    table_name VARCHAR(255),
    column_name VARCHAR(255),
    error_type VARCHAR(100),
    error_description VARCHAR(1000),
    record_count NUMBER,
    severity_level VARCHAR(50),
    detection_timestamp TIMESTAMP_NTZ,
    source_system VARCHAR(100),
    pipeline_run_id VARCHAR(255),
    business_impact VARCHAR(500),
    resolution_status VARCHAR(50),
    resolved_timestamp TIMESTAMP_NTZ,
    load_date DATE,
    update_date DATE
);
```

## 6. Audit Table DDL Script

### • Go_Pipeline_Audit Table
```sql
CREATE TABLE IF NOT EXISTS Gold.go_pipeline_audit (
    execution_id NUMBER AUTOINCREMENT,
    pipeline_name VARCHAR(255),
    pipeline_type VARCHAR(100),
    start_time TIMESTAMP_NTZ,
    end_time TIMESTAMP_NTZ,
    status VARCHAR(50),
    error_message VARCHAR(1000),
    execution_start_time TIMESTAMP_NTZ,
    execution_end_time TIMESTAMP_NTZ,
    execution_status VARCHAR(50),
    records_processed NUMBER,
    records_passed NUMBER,
    records_failed NUMBER,
    transformation_rules_applied VARCHAR(1000),
    error_summary VARCHAR(1000),
    source_system VARCHAR(100),
    target_table VARCHAR(255),
    data_lineage VARCHAR(1000),
    business_rules_applied VARCHAR(1000),
    performance_metrics VARCHAR(500),
    load_date DATE,
    update_date DATE
);
```

## 7. Update DDL Scripts

### • Schema Evolution Scripts
```sql
-- Add new columns to dimension tables if needed
ALTER TABLE Gold.dim_products ADD COLUMN IF NOT EXISTS product_description VARCHAR(1000);
ALTER TABLE Gold.dim_products ADD COLUMN IF NOT EXISTS unit_cost NUMBER(15,2);
ALTER TABLE Gold.dim_products ADD COLUMN IF NOT EXISTS unit_price NUMBER(15,2);

ALTER TABLE Gold.dim_suppliers ADD COLUMN IF NOT EXISTS supplier_address VARCHAR(500);
ALTER TABLE Gold.dim_suppliers ADD COLUMN IF NOT EXISTS supplier_email VARCHAR(255);
ALTER TABLE Gold.dim_suppliers ADD COLUMN IF NOT EXISTS payment_terms VARCHAR(100);

ALTER TABLE Gold.dim_warehouses ADD COLUMN IF NOT EXISTS warehouse_type VARCHAR(100);
ALTER TABLE Gold.dim_warehouses ADD COLUMN IF NOT EXISTS operating_hours VARCHAR(100);
ALTER TABLE Gold.dim_warehouses ADD COLUMN IF NOT EXISTS manager_name VARCHAR(255);

ALTER TABLE Gold.dim_customers ADD COLUMN IF NOT EXISTS customer_segment VARCHAR(100);
ALTER TABLE Gold.dim_customers ADD COLUMN IF NOT EXISTS registration_date DATE;
ALTER TABLE Gold.dim_customers ADD COLUMN IF NOT EXISTS loyalty_tier VARCHAR(50);

-- Add new columns to fact tables if needed
ALTER TABLE Gold.fact_inventory ADD COLUMN IF NOT EXISTS safety_stock_level NUMBER;
ALTER TABLE Gold.fact_inventory ADD COLUMN IF NOT EXISTS lead_time_days NUMBER;

ALTER TABLE Gold.fact_orders ADD COLUMN IF NOT EXISTS discount_amount NUMBER(15,2);
ALTER TABLE Gold.fact_orders ADD COLUMN IF NOT EXISTS tax_amount NUMBER(15,2);
ALTER TABLE Gold.fact_orders ADD COLUMN IF NOT EXISTS shipping_cost NUMBER(15,2);

ALTER TABLE Gold.fact_returns ADD COLUMN IF NOT EXISTS refund_amount NUMBER(15,2);
ALTER TABLE Gold.fact_returns ADD COLUMN IF NOT EXISTS processing_cost NUMBER(15,2);
```

### • Performance Optimization Scripts
```sql
-- Create clustering keys for better performance
ALTER TABLE Gold.dim_products CLUSTER BY (product_id, category);
ALTER TABLE Gold.dim_suppliers CLUSTER BY (supplier_id);
ALTER TABLE Gold.dim_warehouses CLUSTER BY (warehouse_id, location);
ALTER TABLE Gold.dim_customers CLUSTER BY (customer_id);
ALTER TABLE Gold.dim_date CLUSTER BY (full_date, year, month_number);

ALTER TABLE Gold.fact_inventory CLUSTER BY (date_key, product_key, warehouse_key);
ALTER TABLE Gold.fact_orders CLUSTER BY (order_date_key, customer_key, product_key);
ALTER TABLE Gold.fact_returns CLUSTER BY (return_date_key, customer_key);
ALTER TABLE Gold.fact_stock_movements CLUSTER BY (movement_date_key, product_key);

ALTER TABLE Gold.agg_daily_inventory_summary CLUSTER BY (date_key, warehouse_key);
ALTER TABLE Gold.agg_monthly_sales_summary CLUSTER BY (year_month, product_key);
ALTER TABLE Gold.agg_product_performance CLUSTER BY (product_key, analysis_period);
ALTER TABLE Gold.agg_warehouse_utilization CLUSTER BY (warehouse_key, date_key);

ALTER TABLE Gold.go_data_quality_errors CLUSTER BY (detection_timestamp, severity_level);
ALTER TABLE Gold.go_pipeline_audit CLUSTER BY (start_time, pipeline_name);
```

### • Data Retention Scripts
```sql
-- Set data retention policies
ALTER TABLE Gold.go_data_quality_errors SET DATA_RETENTION_TIME_IN_DAYS = 180;
ALTER TABLE Gold.go_pipeline_audit SET DATA_RETENTION_TIME_IN_DAYS = 730;
ALTER TABLE Gold.fact_inventory SET DATA_RETENTION_TIME_IN_DAYS = 2555; -- 7 years
ALTER TABLE Gold.fact_orders SET DATA_RETENTION_TIME_IN_DAYS = 2555; -- 7 years
ALTER TABLE Gold.fact_returns SET DATA_RETENTION_TIME_IN_DAYS = 2555; -- 7 years
ALTER TABLE Gold.agg_daily_inventory_summary SET DATA_RETENTION_TIME_IN_DAYS = 1095; -- 3 years
ALTER TABLE Gold.agg_monthly_sales_summary SET DATA_RETENTION_TIME_IN_DAYS = 1825; -- 5 years
```

### • Data Quality and Business Rules Scripts
```sql
-- Create views for data quality monitoring
CREATE OR REPLACE VIEW Gold.vw_data_quality_dashboard AS
SELECT 
    table_name,
    error_type,
    severity_level,
    COUNT(*) as error_count,
    MAX(detection_timestamp) as latest_error,
    AVG(record_count) as avg_affected_records
FROM Gold.go_data_quality_errors
WHERE detection_timestamp >= DATEADD(day, -30, CURRENT_DATE())
GROUP BY table_name, error_type, severity_level;

-- Create view for inventory alerts
CREATE OR REPLACE VIEW Gold.vw_inventory_alerts AS
SELECT 
    dp.product_name,
    dw.location as warehouse_location,
    fi.quantity_available,
    fi.reorder_threshold,
    CASE 
        WHEN fi.quantity_available <= fi.reorder_threshold THEN 'REORDER_REQUIRED'
        WHEN fi.quantity_available = 0 THEN 'OUT_OF_STOCK'
        WHEN fi.quantity_available < (fi.reorder_threshold * 0.5) THEN 'CRITICAL_LOW'
        ELSE 'NORMAL'
    END as alert_level
FROM Gold.fact_inventory fi
JOIN Gold.dim_products dp ON fi.product_key = dp.product_key
JOIN Gold.dim_warehouses dw ON fi.warehouse_key = dw.warehouse_key
WHERE fi.quantity_available <= fi.reorder_threshold
AND dp.is_current = TRUE
AND dw.is_current = TRUE;
```

## 8. Design Decisions and Assumptions

### • **Design Decisions:**
1. **Star Schema Design:** Implemented dimensional modeling with fact and dimension tables for optimal analytical performance
2. **Surrogate Keys:** Added surrogate keys (product_key, customer_key, etc.) for all dimension tables to support SCD Type 2
3. **Slowly Changing Dimensions:** Implemented SCD Type 2 for dimension tables with effective_start_date, effective_end_date, and is_current flags
4. **Date Dimension:** Created comprehensive date dimension to support time-based analytics
5. **Aggregated Tables:** Pre-calculated common aggregations for improved query performance
6. **Business Metrics:** Added calculated fields like inventory_turnover_rate, days_to_ship, return_rate for business insights
7. **Data Quality Enhancement:** Enhanced error tracking with business impact assessment and resolution tracking
8. **Performance Optimization:** Strategic clustering keys based on common query patterns
9. **Data Lineage:** Added data lineage tracking in audit tables for compliance and troubleshooting
10. **Business Views:** Created business-friendly views for common use cases like inventory alerts and data quality dashboards

### • **Assumptions:**
1. **Business Requirements:** Assumed typical inventory management KPIs and metrics are required
2. **Data Retention:** Set different retention policies based on data criticality and compliance requirements
3. **Historical Tracking:** Assumed need for historical tracking of dimension changes
4. **Performance Requirements:** Optimized for analytical workloads with read-heavy operations
5. **Data Quality:** Assumed comprehensive data quality monitoring is required at Gold layer
6. **Reporting Needs:** Designed aggregated tables based on common inventory management reporting patterns
7. **Scalability:** Designed for horizontal scaling using Snowflake's native capabilities
8. **Integration:** Assumed integration with BI tools and data science platforms
9. **Compliance:** Included audit trails and data lineage for regulatory compliance
10. **Real-time Analytics:** Structured for both batch and near real-time analytical processing

### • **Gold Layer Specific Features:**
1. **Business-Ready Data:** All tables contain business-friendly column names and calculated metrics
2. **Conformed Dimensions:** Standardized dimension tables that can be reused across multiple fact tables
3. **Pre-Aggregated Summaries:** Multiple levels of aggregation for different analytical needs
4. **Data Marts Ready:** Structure supports creation of subject-specific data marts
5. **Self-Service Analytics:** Designed to support self-service BI and analytics tools
6. **Advanced Analytics Ready:** Structure supports machine learning and advanced analytics use cases

## 9. API Cost

• **apiCost**: 0.750000