_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Bronze Layer Data Mapping for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Bronze Layer Data Mapping for Inventory Management System

## Overview

This document provides comprehensive data mapping for the Bronze layer in a Medallion architecture implementation using Snowflake. The Bronze layer serves as the raw data ingestion layer, preserving the original structure of source data while adding essential metadata for data lineage and governance.

## Architecture Principles

- **Raw Data Preservation**: Bronze layer maintains the original data structure with minimal transformation
- **Metadata Enhancement**: Additional fields for tracking data lineage, load timestamps, and source system information
- **Snowflake Compatibility**: All data types and structures optimized for Snowflake SQL
- **1-1 Mapping**: Direct field mapping from source to Bronze layer with type conversion only

---

## Data Mapping Tables

### 1. Products Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_products | Product_ID | Source | Products | Product_ID | 1-1 Mapping |
| Bronze | bz_products | Product_Name | Source | Products | Product_Name | 1-1 Mapping |
| Bronze | bz_products | Category | Source | Products | Category | 1-1 Mapping |
| Bronze | bz_products | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_products | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_products | source_system | System | System | 'INVENTORY_SYSTEM' | System Generated |

### 2. Suppliers Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_suppliers | Supplier_ID | Source | Suppliers | Supplier_ID | 1-1 Mapping |
| Bronze | bz_suppliers | Supplier_Name | Source | Suppliers | Supplier_Name | 1-1 Mapping |
| Bronze | bz_suppliers | Contact_Number | Source | Suppliers | Contact_Number | 1-1 Mapping |
| Bronze | bz_suppliers | Product_ID | Source | Suppliers | Product_ID | 1-1 Mapping |
| Bronze | bz_suppliers | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_suppliers | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_suppliers | source_system | System | System | 'INVENTORY_SYSTEM' | System Generated |

### 3. Warehouses Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_warehouses | Warehouse_ID | Source | Warehouses | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_warehouses | Location | Source | Warehouses | Location | 1-1 Mapping |
| Bronze | bz_warehouses | Capacity | Source | Warehouses | Capacity | 1-1 Mapping |
| Bronze | bz_warehouses | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_warehouses | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_warehouses | source_system | System | System | 'INVENTORY_SYSTEM' | System Generated |

### 4. Inventory Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_inventory | Inventory_ID | Source | Inventory | Inventory_ID | 1-1 Mapping |
| Bronze | bz_inventory | Product_ID | Source | Inventory | Product_ID | 1-1 Mapping |
| Bronze | bz_inventory | Quantity_Available | Source | Inventory | Quantity_Available | 1-1 Mapping |
| Bronze | bz_inventory | Warehouse_ID | Source | Inventory | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_inventory | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_inventory | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_inventory | source_system | System | System | 'INVENTORY_SYSTEM' | System Generated |

### 5. Orders Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_orders | Order_ID | Source | Orders | Order_ID | 1-1 Mapping |
| Bronze | bz_orders | Customer_ID | Source | Orders | Customer_ID | 1-1 Mapping |
| Bronze | bz_orders | Order_Date | Source | Orders | Order_Date | 1-1 Mapping |
| Bronze | bz_orders | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_orders | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_orders | source_system | System | System | 'INVENTORY_SYSTEM' | System Generated |

### 6. Order Details Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_order_details | Order_Detail_ID | Source | Order_Details | Order_Detail_ID | 1-1 Mapping |
| Bronze | bz_order_details | Order_ID | Source | Order_Details | Order_ID | 1-1 Mapping |
| Bronze | bz_order_details | Product_ID | Source | Order_Details | Product_ID | 1-1 Mapping |
| Bronze | bz_order_details | Quantity_Ordered | Source | Order_Details | Quantity_Ordered | 1-1 Mapping |
| Bronze | bz_order_details | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_order_details | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_order_details | source_system | System | System | 'INVENTORY_SYSTEM' | System Generated |

### 7. Shipments Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_shipments | Shipment_ID | Source | Shipments | Shipment_ID | 1-1 Mapping |
| Bronze | bz_shipments | Order_ID | Source | Shipments | Order_ID | 1-1 Mapping |
| Bronze | bz_shipments | Shipment_Date | Source | Shipments | Shipment_Date | 1-1 Mapping |
| Bronze | bz_shipments | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_shipments | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_shipments | source_system | System | System | 'INVENTORY_SYSTEM' | System Generated |

### 8. Returns Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_returns | Return_ID | Source | Returns | Return_ID | 1-1 Mapping |
| Bronze | bz_returns | Order_ID | Source | Returns | Order_ID | 1-1 Mapping |
| Bronze | bz_returns | Return_Reason | Source | Returns | Return_Reason | 1-1 Mapping |
| Bronze | bz_returns | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_returns | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_returns | source_system | System | System | 'INVENTORY_SYSTEM' | System Generated |

### 9. Stock Levels Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_stock_levels | Stock_Level_ID | Source | Stock_Levels | Stock_Level_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | Warehouse_ID | Source | Stock_Levels | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | Product_ID | Source | Stock_Levels | Product_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | Reorder_Threshold | Source | Stock_Levels | Reorder_Threshold | 1-1 Mapping |
| Bronze | bz_stock_levels | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_stock_levels | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_stock_levels | source_system | System | System | 'INVENTORY_SYSTEM' | System Generated |

### 10. Customers Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_customers | Customer_ID | Source | Customers | Customer_ID | 1-1 Mapping |
| Bronze | bz_customers | Customer_Name | Source | Customers | Customer_Name | 1-1 Mapping |
| Bronze | bz_customers | Email | Source | Customers | Email | 1-1 Mapping |
| Bronze | bz_customers | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_customers | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_customers | source_system | System | System | 'INVENTORY_SYSTEM' | System Generated |

---

## Data Type Mappings

### Source to Snowflake Data Type Conversion

| Source Data Type | Snowflake Data Type | Notes |
|------------------|--------------------|---------| 
| INT | NUMBER | Snowflake's universal numeric type |
| VARCHAR(n) | STRING | Snowflake's variable-length string type |
| DATE | DATE | Direct mapping for date values |
| System Generated | TIMESTAMP_NTZ | For load and update timestamps |
| System Generated | STRING | For source system identification |

---

## Metadata Management

### System-Generated Fields

All Bronze layer tables include the following metadata fields:

1. **load_timestamp (TIMESTAMP_NTZ)**: Records when the data was first loaded into the Bronze layer
2. **update_timestamp (TIMESTAMP_NTZ)**: Records the last update time for the record
3. **source_system (STRING)**: Identifies the source system ('INVENTORY_SYSTEM')

### Data Validation Rules

#### Primary Key Validation
- All source primary keys must be preserved and cannot be NULL
- Duplicate primary keys within the same load batch are rejected

#### Data Quality Checks
- **NOT NULL Constraints**: Applied to all primary key fields
- **Data Type Validation**: Ensure source data conforms to expected Snowflake data types
- **String Length Validation**: Verify string fields don't exceed maximum lengths
- **Date Format Validation**: Ensure date fields are in valid format

#### Referential Integrity
- Foreign key relationships are preserved but not enforced at Bronze layer
- Data lineage tracking through metadata fields

---

## Implementation Guidelines

### Ingestion Process

1. **Extract**: Pull data from source system tables
2. **Load**: Insert into Bronze layer with minimal transformation
3. **Audit**: Populate metadata fields (timestamps, source system)
4. **Validate**: Apply basic data quality checks

### Error Handling

- **Data Type Errors**: Log and quarantine records with type conversion issues
- **Constraint Violations**: Reject records violating NOT NULL constraints
- **Duplicate Keys**: Implement upsert logic based on business requirements

### Performance Considerations

- **Partitioning**: Consider partitioning large tables by load_timestamp
- **Clustering**: Implement clustering on frequently queried fields
- **Incremental Loading**: Use update_timestamp for incremental data loads

---

## API Cost Reporting

**Cost consumed in USD:** 0.150000

---

## Summary

This Bronze layer data mapping provides:

- **Complete Coverage**: All 10 source tables mapped to corresponding Bronze tables
- **Metadata Enhancement**: System-generated fields for data governance
- **Data Preservation**: Raw data structure maintained with minimal transformation
- **Snowflake Optimization**: Data types and structures optimized for Snowflake
- **Scalability**: Foundation for Silver and Gold layer transformations

The Bronze layer serves as the foundation for the Medallion architecture, ensuring data lineage, governance, and providing a reliable source for downstream transformations in the Silver and Gold layers.
