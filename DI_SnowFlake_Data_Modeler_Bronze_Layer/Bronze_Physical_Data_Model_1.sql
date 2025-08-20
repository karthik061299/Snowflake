_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Bronze Layer Physical Data Model for Inventory Management System following Snowflake SQL standards and Medallion architecture principles
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- BRONZE LAYER PHYSICAL DATA MODEL
-- INVENTORY MANAGEMENT SYSTEM
-- =====================================================

-- =====================================================
-- 1. Bronze Layer DDL Script
-- =====================================================

-- 1.1 Products Table
CREATE TABLE IF NOT EXISTS Bronze.bz_products (
    product_id STRING,
    product_name STRING,
    category STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 1.2 Suppliers Table
CREATE TABLE IF NOT EXISTS Bronze.bz_suppliers (
    supplier_id STRING,
    supplier_name STRING,
    contact_number STRING, -- PII: Indirect PII
    product_id STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 1.3 Warehouses Table
CREATE TABLE IF NOT EXISTS Bronze.bz_warehouses (
    warehouse_id STRING,
    location STRING,
    capacity NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 1.4 Inventory Table
CREATE TABLE IF NOT EXISTS Bronze.bz_inventory (
    inventory_id STRING,
    product_id STRING,
    quantity_available NUMBER,
    warehouse_id STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 1.5 Orders Table
CREATE TABLE IF NOT EXISTS Bronze.bz_orders (
    order_id STRING,
    customer_id STRING,
    order_date DATE,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 1.6 Order Details Table
CREATE TABLE IF NOT EXISTS Bronze.bz_order_details (
    order_detail_id STRING,
    order_id STRING,
    product_id STRING,
    quantity_ordered NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 1.7 Shipments Table
CREATE TABLE IF NOT EXISTS Bronze.bz_shipments (
    shipment_id STRING,
    order_id STRING,
    shipment_date DATE,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 1.8 Returns Table
CREATE TABLE IF NOT EXISTS Bronze.bz_returns (
    return_id STRING,
    order_id STRING,
    return_reason STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 1.9 Stock Levels Table
CREATE TABLE IF NOT EXISTS Bronze.bz_stock_levels (
    stock_level_id STRING,
    warehouse_id STRING,
    product_id STRING,
    reorder_threshold NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 1.10 Customers Table
CREATE TABLE IF NOT EXISTS Bronze.bz_customers (
    customer_id STRING,
    customer_name STRING, -- PII: Direct PII
    email STRING, -- PII: Direct PII
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 1.11 Audit Table
CREATE TABLE IF NOT EXISTS Bronze.bz_audit_log (
    record_id NUMBER AUTOINCREMENT,
    source_table STRING,
    load_timestamp TIMESTAMP_NTZ,
    processed_by STRING,
    processing_time NUMBER,
    status STRING
);

-- =====================================================
-- 2. API Cost
-- =====================================================
-- apiCost: 0.180000

-- =====================================================
-- End of Bronze Layer Physical Data Model
-- =====================================================