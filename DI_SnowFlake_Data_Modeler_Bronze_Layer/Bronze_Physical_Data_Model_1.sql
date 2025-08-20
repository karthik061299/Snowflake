_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*: 
## *Description*: Bronze Layer Physical Data Model for Inventory Management System following Medallion Architecture
## *Version*: 1
## *Updated on*: 
_____________________________________________

# Bronze Layer Physical Data Model - Inventory Management System

## 1. Bronze Layer DDL Script

### • Create Bronze Schema
```sql
CREATE SCHEMA IF NOT EXISTS Bronze;
```

### • Products Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_products (
    Product_ID NUMBER,
    Product_Name STRING,
    Category STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### • Suppliers Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_suppliers (
    Supplier_ID NUMBER,
    Supplier_Name STRING,
    Contact_Number STRING,
    Product_ID NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### • Warehouses Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_warehouses (
    Warehouse_ID NUMBER,
    Location STRING,
    Capacity NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### • Inventory Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_inventory (
    Inventory_ID NUMBER,
    Product_ID NUMBER,
    Quantity_Available NUMBER,
    Warehouse_ID NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### • Orders Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_orders (
    Order_ID NUMBER,
    Customer_ID NUMBER,
    Order_Date DATE,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### • Order Details Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_order_details (
    Order_Detail_ID NUMBER,
    Order_ID NUMBER,
    Product_ID NUMBER,
    Quantity_Ordered NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### • Shipments Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_shipments (
    Shipment_ID NUMBER,
    Order_ID NUMBER,
    Shipment_Date DATE,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### • Returns Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_returns (
    Return_ID NUMBER,
    Order_ID NUMBER,
    Return_Reason STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### • Stock Levels Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_stock_levels (
    Stock_Level_ID NUMBER,
    Warehouse_ID NUMBER,
    Product_ID NUMBER,
    Reorder_Threshold NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### • Customers Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_customers (
    Customer_ID NUMBER,
    Customer_Name STRING,
    Email STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### • Audit Table
```sql
CREATE TABLE IF NOT EXISTS Bronze.bz_audit_log (
    record_id NUMBER AUTOINCREMENT,
    source_table STRING,
    load_timestamp TIMESTAMP_NTZ,
    processed_by STRING,
    processing_time NUMBER,
    status STRING
);
```

## 2. API Cost

• **apiCost**: 0.150000