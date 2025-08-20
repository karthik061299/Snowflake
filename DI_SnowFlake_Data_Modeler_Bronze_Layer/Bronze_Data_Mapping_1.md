_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Bronze Layer Data Mapping for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Bronze Layer Data Mapping for Inventory Management System

## Metadata Header
- **Author:** Ascendion AVA+
- **Version:** 1
- **Description:** Bronze Layer Data Mapping for Inventory Management System
- **API Cost:** 0.180000
- **Date Created:** 2024
- **Architecture:** Medallion Architecture - Bronze Layer
- **Target Platform:** Snowflake

## Overview

This document provides comprehensive data mapping for the Bronze layer implementation in a Medallion architecture for the Inventory Management System. The Bronze layer serves as the raw data ingestion layer, preserving source data structure with minimal transformation while adding essential metadata for data lineage and governance.

## Bronze Layer Principles

- **Raw Data Preservation:** Maintain original data structure and values
- **Minimal Transformation:** Apply only essential data type conversions
- **Metadata Enhancement:** Add load timestamps, update timestamps, and source system tracking
- **Data Lineage:** Ensure traceability from source to Bronze layer
- **Schema Evolution:** Support for future schema changes

## Data Mapping Tables

### 1. Products Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_products | product_id | Source | Products | Product_ID | 1-1 Mapping |
| Bronze | bz_products | product_name | Source | Products | Product_Name | 1-1 Mapping |
| Bronze | bz_products | category | Source | Products | Category | 1-1 Mapping |
| Bronze | bz_products | load_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_products | update_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_products | source_system | Bronze | N/A | N/A | 'INVENTORY_MGMT_SYS' |

### 2. Suppliers Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_suppliers | supplier_id | Source | Suppliers | Supplier_ID | 1-1 Mapping |
| Bronze | bz_suppliers | supplier_name | Source | Suppliers | Supplier_Name | 1-1 Mapping |
| Bronze | bz_suppliers | contact_number | Source | Suppliers | Contact_Number | 1-1 Mapping |
| Bronze | bz_suppliers | product_id | Source | Suppliers | Product_ID | 1-1 Mapping |
| Bronze | bz_suppliers | load_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_suppliers | update_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_suppliers | source_system | Bronze | N/A | N/A | 'INVENTORY_MGMT_SYS' |

### 3. Warehouses Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_warehouses | warehouse_id | Source | Warehouses | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_warehouses | location | Source | Warehouses | Location | 1-1 Mapping |
| Bronze | bz_warehouses | capacity | Source | Warehouses | Capacity | 1-1 Mapping |
| Bronze | bz_warehouses | load_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_warehouses | update_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_warehouses | source_system | Bronze | N/A | N/A | 'INVENTORY_MGMT_SYS' |

### 4. Inventory Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_inventory | inventory_id | Source | Inventory | Inventory_ID | 1-1 Mapping |
| Bronze | bz_inventory | product_id | Source | Inventory | Product_ID | 1-1 Mapping |
| Bronze | bz_inventory | quantity_available | Source | Inventory | Quantity_Available | 1-1 Mapping |
| Bronze | bz_inventory | warehouse_id | Source | Inventory | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_inventory | load_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_inventory | update_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_inventory | source_system | Bronze | N/A | N/A | 'INVENTORY_MGMT_SYS' |

### 5. Orders Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_orders | order_id | Source | Orders | Order_ID | 1-1 Mapping |
| Bronze | bz_orders | customer_id | Source | Orders | Customer_ID | 1-1 Mapping |
| Bronze | bz_orders | order_date | Source | Orders | Order_Date | 1-1 Mapping |
| Bronze | bz_orders | load_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_orders | update_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_orders | source_system | Bronze | N/A | N/A | 'INVENTORY_MGMT_SYS' |

### 6. Order Details Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_order_details | order_detail_id | Source | Order_Details | Order_Detail_ID | 1-1 Mapping |
| Bronze | bz_order_details | order_id | Source | Order_Details | Order_ID | 1-1 Mapping |
| Bronze | bz_order_details | product_id | Source | Order_Details | Product_ID | 1-1 Mapping |
| Bronze | bz_order_details | quantity_ordered | Source | Order_Details | Quantity_Ordered | 1-1 Mapping |
| Bronze | bz_order_details | load_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_order_details | update_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_order_details | source_system | Bronze | N/A | N/A | 'INVENTORY_MGMT_SYS' |

### 7. Shipments Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_shipments | shipment_id | Source | Shipments | Shipment_ID | 1-1 Mapping |
| Bronze | bz_shipments | order_id | Source | Shipments | Order_ID | 1-1 Mapping |
| Bronze | bz_shipments | shipment_date | Source | Shipments | Shipment_Date | 1-1 Mapping |
| Bronze | bz_shipments | load_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_shipments | update_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_shipments | source_system | Bronze | N/A | N/A | 'INVENTORY_MGMT_SYS' |

### 8. Returns Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_returns | return_id | Source | Returns | Return_ID | 1-1 Mapping |
| Bronze | bz_returns | order_id | Source | Returns | Order_ID | 1-1 Mapping |
| Bronze | bz_returns | return_reason | Source | Returns | Return_Reason | 1-1 Mapping |
| Bronze | bz_returns | load_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_returns | update_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_returns | source_system | Bronze | N/A | N/A | 'INVENTORY_MGMT_SYS' |

### 9. Stock Levels Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_stock_levels | stock_level_id | Source | Stock_Levels | Stock_Level_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | warehouse_id | Source | Stock_Levels | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | product_id | Source | Stock_Levels | Product_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | reorder_threshold | Source | Stock_Levels | Reorder_Threshold | 1-1 Mapping |
| Bronze | bz_stock_levels | load_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_stock_levels | update_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_stock_levels | source_system | Bronze | N/A | N/A | 'INVENTORY_MGMT_SYS' |

### 10. Customers Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|---------------------|
| Bronze | bz_customers | customer_id | Source | Customers | Customer_ID | 1-1 Mapping |
| Bronze | bz_customers | customer_name | Source | Customers | Customer_Name | 1-1 Mapping |
| Bronze | bz_customers | email | Source | Customers | Email | 1-1 Mapping |
| Bronze | bz_customers | load_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_customers | update_timestamp | Bronze | N/A | N/A | CURRENT_TIMESTAMP() |
| Bronze | bz_customers | source_system | Bronze | N/A | N/A | 'INVENTORY_MGMT_SYS' |

## Data Type Transformations

### Source to Bronze Data Type Mapping

| Source Data Type | Bronze Data Type | Rationale |
|------------------|------------------|-----------||
| INT | STRING | Preserve original values, avoid data loss |
| VARCHAR(n) | STRING | Maintain flexibility for varying lengths |
| DATE | DATE | Direct mapping for date fields |
| N/A | TIMESTAMP_NTZ | Metadata fields for tracking |
| N/A | STRING | Source system identifier |

## Metadata Management

### Standard Metadata Fields

All Bronze layer tables include the following metadata fields:

1. **load_timestamp (TIMESTAMP_NTZ)**: Records when the record was first loaded into the Bronze layer
2. **update_timestamp (TIMESTAMP_NTZ)**: Records the last update time for the record
3. **source_system (STRING)**: Identifies the source system ('INVENTORY_MGMT_SYS')

### Data Lineage Tracking

- Source system identification through source_system field
- Load tracking through load_timestamp
- Change tracking through update_timestamp
- Full audit trail for data governance

## Initial Data Validation Rules

### Primary Key Validation
- Ensure all primary key fields from source are not null
- Validate uniqueness constraints where applicable
- Log validation failures for data quality monitoring

### Data Quality Checks
1. **Null Value Validation**: Check for unexpected null values in critical fields
2. **Data Type Validation**: Ensure source data conforms to expected types
3. **Referential Integrity**: Validate foreign key relationships exist
4. **Business Rule Validation**: Apply basic business logic checks

### Error Handling
- Invalid records are logged but not rejected (Bronze layer principle)
- Data quality issues are flagged for downstream processing
- Maintain complete audit trail of all data quality issues

## Raw Data Ingestion Process

### Ingestion Strategy
1. **Full Load**: Initial load of all historical data
2. **Incremental Load**: Ongoing updates based on change data capture
3. **Real-time Streaming**: For high-frequency data updates

### Data Preservation
- All source data is preserved in its original format
- No data cleansing or business rule application
- Maintain complete history of all changes
- Support for schema evolution and backward compatibility

### Load Patterns
- **Batch Processing**: Scheduled loads for bulk data
- **Micro-batch**: Small, frequent loads for near real-time processing
- **Event-driven**: Triggered loads based on source system events

## Snowflake Implementation Considerations

### Storage Optimization
- Use appropriate clustering keys for large tables
- Implement time-based partitioning where applicable
- Consider compression options for cost optimization

### Performance Optimization
- Design for parallel processing capabilities
- Optimize for downstream Silver layer consumption
- Implement efficient indexing strategies

### Security and Governance
- Implement role-based access control
- Ensure data encryption at rest and in transit
- Maintain compliance with data privacy regulations

## API Cost Reporting

**API Cost Consumed**: 0.180000

## Summary

This Bronze Layer Data Mapping document provides a comprehensive foundation for implementing the raw data ingestion layer of the Medallion architecture for the Inventory Management System. The mapping ensures:

- **Complete Data Preservation**: All source data is maintained in its original form
- **Enhanced Metadata**: Additional tracking fields for governance and lineage
- **Scalable Architecture**: Designed for growth and evolution
- **Data Quality Foundation**: Basic validation while preserving all data
- **Audit Trail**: Complete tracking of data movement and changes

The Bronze layer serves as the reliable foundation for all downstream data processing, ensuring data integrity and providing the flexibility needed for future analytics and business intelligence requirements.