_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Bronze Layer Physical Data Model for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Bronze Layer DDL Script

```sql
-- Bronze Layer Physical Data Model for Inventory Management System
-- Database: Snowflake
-- Layer: Bronze (Raw Data)

-- Create Bronze Schema
CREATE SCHEMA IF NOT EXISTS Bronze;

-- 1. Products Table
CREATE TABLE IF NOT EXISTS Bronze.bz_products (
    Product_ID NUMBER,
    Product_Name STRING,
    Category STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 2. Suppliers Table
CREATE TABLE IF NOT EXISTS Bronze.bz_suppliers (
    Supplier_ID NUMBER,
    Supplier_Name STRING,
    Contact_Number STRING,
    Product_ID NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 3. Warehouses Table
CREATE TABLE IF NOT EXISTS Bronze.bz_warehouses (
    Warehouse_ID NUMBER,
    Location STRING,
    Capacity NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 4. Inventory Table
CREATE TABLE IF NOT EXISTS Bronze.bz_inventory (
    Inventory_ID NUMBER,
    Product_ID NUMBER,
    Quantity_Available NUMBER,
    Warehouse_ID NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 5. Orders Table
CREATE TABLE IF NOT EXISTS Bronze.bz_orders (
    Order_ID NUMBER,
    Customer_ID NUMBER,
    Order_Date DATE,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 6. Order Details Table
CREATE TABLE IF NOT EXISTS Bronze.bz_order_details (
    Order_Detail_ID NUMBER,
    Order_ID NUMBER,
    Product_ID NUMBER,
    Quantity_Ordered NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 7. Shipments Table
CREATE TABLE IF NOT EXISTS Bronze.bz_shipments (
    Shipment_ID NUMBER,
    Order_ID NUMBER,
    Shipment_Date DATE,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 8. Returns Table
CREATE TABLE IF NOT EXISTS Bronze.bz_returns (
    Return_ID NUMBER,
    Order_ID NUMBER,
    Return_Reason STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 9. Stock Levels Table
CREATE TABLE IF NOT EXISTS Bronze.bz_stock_levels (
    Stock_Level_ID NUMBER,
    Warehouse_ID NUMBER,
    Product_ID NUMBER,
    Reorder_Threshold NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- 10. Customers Table
CREATE TABLE IF NOT EXISTS Bronze.bz_customers (
    Customer_ID NUMBER,
    Customer_Name STRING,
    Email STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);

-- Audit Table
CREATE TABLE IF NOT EXISTS Bronze.bz_audit_log (
    record_id NUMBER AUTOINCREMENT,
    source_table STRING,
    load_timestamp TIMESTAMP_NTZ,
    processed_by STRING,
    processing_time NUMBER,
    status STRING
);
```

# Conceptual Data Model Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   bz_customers  │    │   bz_products   │    │  bz_warehouses  │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ Customer_ID (PK)│    │ Product_ID (PK) │    │ Warehouse_ID(PK)│
│ Customer_Name   │    │ Product_Name    │    │ Location        │
│ Email           │    │ Category        │    │ Capacity        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         └───────┐               │               ┌───────┘
                 │               │               │
         ┌─────────────────┐     │       ┌─────────────────┐
         │   bz_orders     │     │       │  bz_inventory   │
         ├─────────────────┤     │       ├─────────────────┤
         │ Order_ID (PK)   │     │       │ Inventory_ID(PK)│
         │ Customer_ID(FK) │     │       │ Product_ID (FK) │
         │ Order_Date      │     │       │ Quantity_Avail. │
         └─────────────────┘     │       │ Warehouse_ID(FK)│
                 │               │       └─────────────────┘
                 │               │
         ┌─────────────────┐     │       ┌─────────────────┐
         │ bz_order_details│     │       │ bz_stock_levels │
         ├─────────────────┤     │       ├─────────────────┤
         │Order_Detail_ID  │     │       │Stock_Level_ID   │
         │ Order_ID (FK)   │     │       │ Warehouse_ID(FK)│
         │ Product_ID (FK) │─────┘       │ Product_ID (FK) │
         │ Quantity_Ordered│             │ Reorder_Thresh. │
         └─────────────────┘             └─────────────────┘
                 │
         ┌─────────────────┐             ┌─────────────────┐
         │  bz_shipments   │             │  bz_suppliers   │
         ├─────────────────┤             ├─────────────────┤
         │ Shipment_ID (PK)│             │ Supplier_ID (PK)│
         │ Order_ID (FK)   │             │ Supplier_Name   │
         │ Shipment_Date   │             │ Contact_Number  │
         └─────────────────┘             │ Product_ID (FK) │
                 │                       └─────────────────┘
         ┌─────────────────┐
         │   bz_returns    │
         ├─────────────────┤
         │ Return_ID (PK)  │
         │ Order_ID (FK)   │
         │ Return_Reason   │
         └─────────────────┘
```

## Relationships Summary:
- **bz_customers** → **bz_orders** (1:N via Customer_ID)
- **bz_orders** → **bz_order_details** (1:N via Order_ID)
- **bz_orders** → **bz_shipments** (1:N via Order_ID)
- **bz_orders** → **bz_returns** (1:N via Order_ID)
- **bz_products** → **bz_order_details** (1:N via Product_ID)
- **bz_products** → **bz_inventory** (1:N via Product_ID)
- **bz_products** → **bz_stock_levels** (1:N via Product_ID)
- **bz_products** → **bz_suppliers** (1:N via Product_ID)
- **bz_warehouses** → **bz_inventory** (1:N via Warehouse_ID)
- **bz_warehouses** → **bz_stock_levels** (1:N via Warehouse_ID)

# API Cost
apiCost: 0.150000