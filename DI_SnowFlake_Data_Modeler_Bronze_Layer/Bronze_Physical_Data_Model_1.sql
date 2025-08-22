_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Bronze Layer Physical Data Model for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- 1. **Bronze Layer DDL Script**
-- =====================================================

-- Bronze Layer Tables for Inventory Management System
-- Following Medallion Architecture - Raw Data Storage
-- Compatible with Snowflake SQL Standards

-- =====================================================
-- Products Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_products (
    product_id NUMBER,
    product_name STRING,
    category STRING,
    -- Metadata columns
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- =====================================================
-- Suppliers Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_suppliers (
    supplier_id NUMBER,
    supplier_name STRING,
    contact_number STRING,
    product_id NUMBER,
    -- Metadata columns
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- =====================================================
-- Warehouses Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_warehouses (
    warehouse_id NUMBER,
    location STRING,
    capacity NUMBER,
    -- Metadata columns
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- =====================================================
-- Inventory Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_inventory (
    inventory_id NUMBER,
    product_id NUMBER,
    quantity_available NUMBER,
    warehouse_id NUMBER,
    -- Metadata columns
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- =====================================================
-- Orders Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_orders (
    order_id NUMBER,
    customer_id NUMBER,
    order_date DATE,
    -- Metadata columns
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- =====================================================
-- Order Details Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_order_details (
    order_detail_id NUMBER,
    order_id NUMBER,
    product_id NUMBER,
    quantity_ordered NUMBER,
    -- Metadata columns
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- =====================================================
-- Shipments Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_shipments (
    shipment_id NUMBER,
    order_id NUMBER,
    shipment_date DATE,
    -- Metadata columns
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- =====================================================
-- Returns Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_returns (
    return_id NUMBER,
    order_id NUMBER,
    return_reason STRING,
    -- Metadata columns
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- =====================================================
-- Stock Levels Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_stock_levels (
    stock_level_id NUMBER,
    warehouse_id NUMBER,
    product_id NUMBER,
    reorder_threshold NUMBER,
    -- Metadata columns
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- =====================================================
-- Customers Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_customers (
    customer_id NUMBER,
    customer_name STRING,
    email STRING,
    -- Metadata columns
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- =====================================================
-- Audit Table
-- =====================================================
CREATE TABLE IF NOT EXISTS Bronze.bz_audit_table (
    record_id NUMBER AUTOINCREMENT,
    source_table STRING,
    load_timestamp TIMESTAMP_NTZ,
    processed_by STRING,
    processing_time NUMBER,
    status STRING
);

-- =====================================================
-- 2. **API Cost**
-- =====================================================
apiCost: 0.000000

-- =====================================================
-- End of Bronze Layer Physical Data Model
-- =====================================================