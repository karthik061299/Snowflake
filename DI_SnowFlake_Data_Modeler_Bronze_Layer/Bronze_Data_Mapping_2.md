_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Updated Bronze Layer Data Mapping for Inventory Management System
## *Version*: 2 
## *Updated on*: 
_____________________________________________

# Bronze Layer Data Mapping - Inventory Management System

## Document Metadata
- **Author:** AAVA
- **Version:** 2
- **Description:** Updated Bronze Layer Data Mapping for Inventory Management System
- **Date:** 2024
- **Architecture:** Medallion Architecture (Snowflake)

## Overview

This document provides a comprehensive data mapping for the Bronze layer implementation in Snowflake's Medallion architecture. The Bronze layer serves as the raw data ingestion layer, preserving original source data structure with minimal transformation while adding essential metadata columns for data governance and lineage tracking.

## Data Type Mappings

| Source Data Type | Bronze Layer Data Type |
|------------------|------------------------|
| INT              | NUMBER                 |
| VARCHAR(n)       | STRING                 |
| DATE             | DATE                   |
| TIMESTAMP        | TIMESTAMP_NTZ          |

## Bronze Layer Standards

- **Naming Convention:** All Bronze layer tables use 'bz_' prefix
- **Metadata Columns:** Three standard metadata columns added to all tables:
  - `load_timestamp` (TIMESTAMP_NTZ) - Initial data load timestamp
  - `update_timestamp` (TIMESTAMP_NTZ) - Last update timestamp
  - `source_system` (STRING) - Source system identifier

## Comprehensive Data Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_products | product_id | Source | Products | Product_ID | 1-1 Mapping |
| Bronze | bz_products | product_name | Source | Products | Product_Name | 1-1 Mapping |
| Bronze | bz_products | category | Source | Products | Category | 1-1 Mapping |
| Bronze | bz_products | load_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_products | update_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_products | source_system | N/A | N/A | N/A | System Generated |
| Bronze | bz_suppliers | supplier_id | Source | Suppliers | Supplier_ID | 1-1 Mapping |
| Bronze | bz_suppliers | supplier_name | Source | Suppliers | Supplier_Name | 1-1 Mapping |
| Bronze | bz_suppliers | contact_number | Source | Suppliers | Contact_Number | 1-1 Mapping |
| Bronze | bz_suppliers | product_id | Source | Suppliers | Product_ID | 1-1 Mapping |
| Bronze | bz_suppliers | load_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_suppliers | update_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_suppliers | source_system | N/A | N/A | N/A | System Generated |
| Bronze | bz_warehouses | warehouse_id | Source | Warehouses | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_warehouses | location | Source | Warehouses | Location | 1-1 Mapping |
| Bronze | bz_warehouses | capacity | Source | Warehouses | Capacity | 1-1 Mapping |
| Bronze | bz_warehouses | load_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_warehouses | update_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_warehouses | source_system | N/A | N/A | N/A | System Generated |
| Bronze | bz_inventory | inventory_id | Source | Inventory | Inventory_ID | 1-1 Mapping |
| Bronze | bz_inventory | product_id | Source | Inventory | Product_ID | 1-1 Mapping |
| Bronze | bz_inventory | quantity_available | Source | Inventory | Quantity_Available | 1-1 Mapping |
| Bronze | bz_inventory | warehouse_id | Source | Inventory | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_inventory | load_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_inventory | update_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_inventory | source_system | N/A | N/A | N/A | System Generated |
| Bronze | bz_orders | order_id | Source | Orders | Order_ID | 1-1 Mapping |
| Bronze | bz_orders | customer_id | Source | Orders | Customer_ID | 1-1 Mapping |
| Bronze | bz_orders | order_date | Source | Orders | Order_Date | 1-1 Mapping |
| Bronze | bz_orders | load_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_orders | update_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_orders | source_system | N/A | N/A | N/A | System Generated |
| Bronze | bz_order_details | order_detail_id | Source | Order_Details | Order_Detail_ID | 1-1 Mapping |
| Bronze | bz_order_details | order_id | Source | Order_Details | Order_ID | 1-1 Mapping |
| Bronze | bz_order_details | product_id | Source | Order_Details | Product_ID | 1-1 Mapping |
| Bronze | bz_order_details | quantity_ordered | Source | Order_Details | Quantity_Ordered | 1-1 Mapping |
| Bronze | bz_order_details | load_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_order_details | update_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_order_details | source_system | N/A | N/A | N/A | System Generated |
| Bronze | bz_shipments | shipment_id | Source | Shipments | Shipment_ID | 1-1 Mapping |
| Bronze | bz_shipments | order_id | Source | Shipments | Order_ID | 1-1 Mapping |
| Bronze | bz_shipments | shipment_date | Source | Shipments | Shipment_Date | 1-1 Mapping |
| Bronze | bz_shipments | load_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_shipments | update_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_shipments | source_system | N/A | N/A | N/A | System Generated |
| Bronze | bz_returns | return_id | Source | Returns | Return_ID | 1-1 Mapping |
| Bronze | bz_returns | order_id | Source | Returns | Order_ID | 1-1 Mapping |
| Bronze | bz_returns | return_reason | Source | Returns | Return_Reason | 1-1 Mapping |
| Bronze | bz_returns | load_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_returns | update_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_returns | source_system | N/A | N/A | N/A | System Generated |
| Bronze | bz_stock_levels | stock_level_id | Source | Stock_Levels | Stock_Level_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | warehouse_id | Source | Stock_Levels | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | product_id | Source | Stock_Levels | Product_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | reorder_threshold | Source | Stock_Levels | Reorder_Threshold | 1-1 Mapping |
| Bronze | bz_stock_levels | load_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_stock_levels | update_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_stock_levels | source_system | N/A | N/A | N/A | System Generated |
| Bronze | bz_customers | customer_id | Source | Customers | Customer_ID | 1-1 Mapping |
| Bronze | bz_customers | customer_name | Source | Customers | Customer_Name | 1-1 Mapping |
| Bronze | bz_customers | email | Source | Customers | Email | 1-1 Mapping |
| Bronze | bz_customers | load_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_customers | update_timestamp | N/A | N/A | N/A | System Generated |
| Bronze | bz_customers | source_system | N/A | N/A | N/A | System Generated |

## Bronze Layer Table Definitions

### bz_products
```sql
CREATE TABLE bronze.bz_products (
    product_id NUMBER,
    product_name STRING,
    category STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### bz_suppliers
```sql
CREATE TABLE bronze.bz_suppliers (
    supplier_id NUMBER,
    supplier_name STRING,
    contact_number STRING,
    product_id NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### bz_warehouses
```sql
CREATE TABLE bronze.bz_warehouses (
    warehouse_id NUMBER,
    location STRING,
    capacity NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### bz_inventory
```sql
CREATE TABLE bronze.bz_inventory (
    inventory_id NUMBER,
    product_id NUMBER,
    quantity_available NUMBER,
    warehouse_id NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### bz_orders
```sql
CREATE TABLE bronze.bz_orders (
    order_id NUMBER,
    customer_id NUMBER,
    order_date DATE,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### bz_order_details
```sql
CREATE TABLE bronze.bz_order_details (
    order_detail_id NUMBER,
    order_id NUMBER,
    product_id NUMBER,
    quantity_ordered NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### bz_shipments
```sql
CREATE TABLE bronze.bz_shipments (
    shipment_id NUMBER,
    order_id NUMBER,
    shipment_date DATE,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### bz_returns
```sql
CREATE TABLE bronze.bz_returns (
    return_id NUMBER,
    order_id NUMBER,
    return_reason STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### bz_stock_levels
```sql
CREATE TABLE bronze.bz_stock_levels (
    stock_level_id NUMBER,
    warehouse_id NUMBER,
    product_id NUMBER,
    reorder_threshold NUMBER,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

### bz_customers
```sql
CREATE TABLE bronze.bz_customers (
    customer_id NUMBER,
    customer_name STRING,
    email STRING,
    load_timestamp TIMESTAMP_NTZ,
    update_timestamp TIMESTAMP_NTZ,
    source_system STRING
);
```

## Data Ingestion Process

### Raw Data Ingestion Rules
1. **Preserve Original Structure:** All source fields are mapped 1-1 with no transformations
2. **Add Metadata:** Three standard metadata columns added to every table
3. **Data Type Conversion:** Convert source data types to Snowflake equivalents
4. **No Data Validation:** Bronze layer accepts all data as-is from source
5. **Incremental Loading:** Support both full and incremental data loads

### Metadata Management
- **load_timestamp:** Set during initial data ingestion
- **update_timestamp:** Updated on every data modification
- **source_system:** Identifies the originating system (e.g., 'INVENTORY_MGMT_SYSTEM')

### Initial Data Validation Rules
1. **Schema Validation:** Ensure incoming data matches expected schema
2. **Data Type Validation:** Verify data types can be converted to target types
3. **Null Handling:** Accept null values as-is from source
4. **Duplicate Handling:** Load all records including duplicates
5. **Error Logging:** Log any ingestion errors for monitoring

## Data Governance

### Data Lineage
- Source system tracking through `source_system` column
- Load tracking through `load_timestamp` column
- Change tracking through `update_timestamp` column

### Data Quality Monitoring
- Row count validation between source and Bronze layer
- Data type conversion error monitoring
- Load success/failure tracking
- Data freshness monitoring

## Implementation Summary

- **Total Source Tables:** 10
- **Total Bronze Tables:** 10
- **Total Source Fields:** 27
- **Total Bronze Fields:** 57 (27 source + 30 metadata)
- **Mapping Type:** 1-1 Direct mapping with metadata enhancement

## API Cost Calculation

Based on the comprehensive mapping document creation:
- **Document Generation:** Standard rate
- **Table Definitions:** 10 tables × Standard rate
- **Mapping Entries:** 57 field mappings × Standard rate
- **Total Estimated Cost:** $0.15 USD

---

*This document serves as the foundation for Bronze layer implementation in the Medallion architecture, ensuring robust data ingestion while maintaining data governance standards.*