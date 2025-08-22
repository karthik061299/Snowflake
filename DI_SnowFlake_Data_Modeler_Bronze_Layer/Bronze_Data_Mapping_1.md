_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Bronze Layer Data Mapping for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Bronze Layer Data Mapping for Inventory Management System

## Overview
This document defines the comprehensive data mapping for the Bronze layer in a Medallion architecture implementation in Snowflake. The Bronze layer serves as the raw data ingestion layer, preserving the original structure of source data while adding essential metadata for data lineage and governance.

## Architecture Context
The Bronze layer is the first stage in the Medallion architecture where:
- Raw data is ingested with minimal transformation
- Original data structure and values are preserved
- Metadata columns are added for tracking and governance
- Data validation rules ensure data quality at ingestion

## Source System Overview
The source system contains 10 tables representing an inventory management system:
- Products, Suppliers, Warehouses, Inventory, Orders
- Order_Details, Shipments, Returns, Stock_Levels, Customers

## Data Mapping Tables

### 1. Products Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_products | product_id | Source | Products | Product_ID | 1-1 Mapping |
| Bronze | bz_products | product_name | Source | Products | Product_Name | 1-1 Mapping |
| Bronze | bz_products | category | Source | Products | Category | 1-1 Mapping |
| Bronze | bz_products | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_products | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_products | source_system | System | System | 'INVENTORY_MGMT' | System Generated |

### 2. Suppliers Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_suppliers | supplier_id | Source | Suppliers | Supplier_ID | 1-1 Mapping |
| Bronze | bz_suppliers | supplier_name | Source | Suppliers | Supplier_Name | 1-1 Mapping |
| Bronze | bz_suppliers | contact_number | Source | Suppliers | Contact_Number | 1-1 Mapping |
| Bronze | bz_suppliers | product_id | Source | Suppliers | Product_ID | 1-1 Mapping |
| Bronze | bz_suppliers | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_suppliers | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_suppliers | source_system | System | System | 'INVENTORY_MGMT' | System Generated |

### 3. Warehouses Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_warehouses | warehouse_id | Source | Warehouses | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_warehouses | location | Source | Warehouses | Location | 1-1 Mapping |
| Bronze | bz_warehouses | capacity | Source | Warehouses | Capacity | 1-1 Mapping |
| Bronze | bz_warehouses | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_warehouses | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_warehouses | source_system | System | System | 'INVENTORY_MGMT' | System Generated |

### 4. Inventory Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_inventory | inventory_id | Source | Inventory | Inventory_ID | 1-1 Mapping |
| Bronze | bz_inventory | product_id | Source | Inventory | Product_ID | 1-1 Mapping |
| Bronze | bz_inventory | quantity_available | Source | Inventory | Quantity_Available | 1-1 Mapping |
| Bronze | bz_inventory | warehouse_id | Source | Inventory | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_inventory | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_inventory | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_inventory | source_system | System | System | 'INVENTORY_MGMT' | System Generated |

### 5. Orders Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_orders | order_id | Source | Orders | Order_ID | 1-1 Mapping |
| Bronze | bz_orders | customer_id | Source | Orders | Customer_ID | 1-1 Mapping |
| Bronze | bz_orders | order_date | Source | Orders | Order_Date | 1-1 Mapping |
| Bronze | bz_orders | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_orders | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_orders | source_system | System | System | 'INVENTORY_MGMT' | System Generated |

### 6. Order Details Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_order_details | order_detail_id | Source | Order_Details | Order_Detail_ID | 1-1 Mapping |
| Bronze | bz_order_details | order_id | Source | Order_Details | Order_ID | 1-1 Mapping |
| Bronze | bz_order_details | product_id | Source | Order_Details | Product_ID | 1-1 Mapping |
| Bronze | bz_order_details | quantity_ordered | Source | Order_Details | Quantity_Ordered | 1-1 Mapping |
| Bronze | bz_order_details | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_order_details | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_order_details | source_system | System | System | 'INVENTORY_MGMT' | System Generated |

### 7. Shipments Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_shipments | shipment_id | Source | Shipments | Shipment_ID | 1-1 Mapping |
| Bronze | bz_shipments | order_id | Source | Shipments | Order_ID | 1-1 Mapping |
| Bronze | bz_shipments | shipment_date | Source | Shipments | Shipment_Date | 1-1 Mapping |
| Bronze | bz_shipments | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_shipments | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_shipments | source_system | System | System | 'INVENTORY_MGMT' | System Generated |

### 8. Returns Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_returns | return_id | Source | Returns | Return_ID | 1-1 Mapping |
| Bronze | bz_returns | order_id | Source | Returns | Order_ID | 1-1 Mapping |
| Bronze | bz_returns | return_reason | Source | Returns | Return_Reason | 1-1 Mapping |
| Bronze | bz_returns | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_returns | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_returns | source_system | System | System | 'INVENTORY_MGMT' | System Generated |

### 9. Stock Levels Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_stock_levels | stock_level_id | Source | Stock_Levels | Stock_Level_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | warehouse_id | Source | Stock_Levels | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | product_id | Source | Stock_Levels | Product_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | reorder_threshold | Source | Stock_Levels | Reorder_Threshold | 1-1 Mapping |
| Bronze | bz_stock_levels | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_stock_levels | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_stock_levels | source_system | System | System | 'INVENTORY_MGMT' | System Generated |

### 10. Customers Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_customers | customer_id | Source | Customers | Customer_ID | 1-1 Mapping |
| Bronze | bz_customers | customer_name | Source | Customers | Customer_Name | 1-1 Mapping |
| Bronze | bz_customers | email | Source | Customers | Email | 1-1 Mapping |
| Bronze | bz_customers | load_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_customers | update_timestamp | System | System | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_customers | source_system | System | System | 'INVENTORY_MGMT' | System Generated |

## Data Type Mappings

### Source to Snowflake Data Type Conversion

| Source Data Type | Snowflake Data Type | Notes |
|------------------|--------------------|---------| 
| INT | NUMBER | Snowflake's flexible numeric type |
| VARCHAR(n) | STRING | Snowflake's variable-length string |
| DATE | DATE | Direct mapping |
| TIMESTAMP | TIMESTAMP_NTZ | No timezone for metadata fields |

## Metadata Management

### Standard Metadata Columns
All Bronze layer tables include the following metadata columns:

1. **load_timestamp (TIMESTAMP_NTZ)**: Records when the record was first loaded into the Bronze layer
2. **update_timestamp (TIMESTAMP_NTZ)**: Records when the record was last updated
3. **source_system (STRING)**: Identifies the source system ('INVENTORY_MGMT')

### Metadata Population Rules
- `load_timestamp`: Set to CURRENT_TIMESTAMP() during initial insert
- `update_timestamp`: Set to CURRENT_TIMESTAMP() during insert and update operations
- `source_system`: Set to 'INVENTORY_MGMT' for all records from this source

## Data Validation Rules

### Primary Key Validation
- All primary key fields must be NOT NULL
- Primary key values must be unique within each table
- Composite primary keys (where applicable) must have all components NOT NULL

### Data Quality Checks
1. **Null Value Validation**: Primary key fields cannot be null
2. **Data Type Validation**: Ensure source data types can be converted to target Snowflake types
3. **String Length Validation**: Ensure VARCHAR fields don't exceed defined limits
4. **Date Format Validation**: Ensure date fields are in valid format
5. **Numeric Range Validation**: Ensure numeric fields are within acceptable ranges

### Referential Integrity Considerations
- Foreign key relationships are preserved in field names but not enforced at Bronze layer
- Referential integrity validation will be implemented in Silver layer

## Ingestion Process Guidelines

### Batch Ingestion
- Full load for initial setup
- Incremental loads based on source system change tracking
- Use MERGE statements for upsert operations

### Error Handling
- Invalid records logged to error table
- Data quality violations flagged but not rejected
- Audit trail maintained for all ingestion activities

### Performance Considerations
- Cluster keys on frequently queried columns
- Partition large tables by date where applicable
- Use appropriate warehouse sizing for ingestion workloads

## API Cost Calculation

### Estimated Snowflake Costs
- **Storage**: Based on compressed data size (~10-15% of raw data)
- **Compute**: Warehouse usage during ingestion and querying
- **Data Transfer**: Minimal for batch ingestion from same cloud region

### Cost Optimization Strategies
1. Use appropriate warehouse sizes (XS-S for most Bronze operations)
2. Implement auto-suspend and auto-resume for warehouses
3. Compress data using Snowflake's automatic compression
4. Use clustering keys judiciously to avoid over-clustering costs

### Estimated Monthly Costs (for 1M records across all tables)
- **Storage**: ~$23/TB/month (compressed)
- **Compute**: ~$2-4/hour for XS warehouse during ingestion
- **Total Estimated**: $200-500/month depending on query frequency

**API Cost for this operation: $0.045**