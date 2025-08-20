_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Bronze Layer Data Mapping for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Bronze Layer Data Mapping - Inventory Management System

## Overview
This document provides detailed data mapping between the source system and the Bronze layer in the Medallion architecture implementation in Snowflake. The Bronze layer preserves the original data structure with minimal transformation, maintaining raw data integrity while adding necessary metadata for data lineage and auditing.

## Data Mapping for Bronze Layer

### 1. Products Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|--------------------|
| Bronze | bz_products | Product_ID | Source | Products | Product_ID | 1-1 Mapping |
| Bronze | bz_products | Product_Name | Source | Products | Product_Name | 1-1 Mapping |
| Bronze | bz_products | Category | Source | Products | Category | 1-1 Mapping |
| Bronze | bz_products | load_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_products | update_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_products | source_system | Source | System Generated | 'Inventory_Management_System' | System Generated |

### 2. Suppliers Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|--------------------|
| Bronze | bz_suppliers | Supplier_ID | Source | Suppliers | Supplier_ID | 1-1 Mapping |
| Bronze | bz_suppliers | Supplier_Name | Source | Suppliers | Supplier_Name | 1-1 Mapping |
| Bronze | bz_suppliers | Contact_Number | Source | Suppliers | Contact_Number | 1-1 Mapping |
| Bronze | bz_suppliers | Product_ID | Source | Suppliers | Product_ID | 1-1 Mapping |
| Bronze | bz_suppliers | load_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_suppliers | update_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_suppliers | source_system | Source | System Generated | 'Inventory_Management_System' | System Generated |

### 3. Warehouses Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|--------------------|
| Bronze | bz_warehouses | Warehouse_ID | Source | Warehouses | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_warehouses | Location | Source | Warehouses | Location | 1-1 Mapping |
| Bronze | bz_warehouses | Capacity | Source | Warehouses | Capacity | 1-1 Mapping |
| Bronze | bz_warehouses | load_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_warehouses | update_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_warehouses | source_system | Source | System Generated | 'Inventory_Management_System' | System Generated |

### 4. Inventory Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|--------------------|
| Bronze | bz_inventory | Inventory_ID | Source | Inventory | Inventory_ID | 1-1 Mapping |
| Bronze | bz_inventory | Product_ID | Source | Inventory | Product_ID | 1-1 Mapping |
| Bronze | bz_inventory | Quantity_Available | Source | Inventory | Quantity_Available | 1-1 Mapping |
| Bronze | bz_inventory | Warehouse_ID | Source | Inventory | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_inventory | load_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_inventory | update_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_inventory | source_system | Source | System Generated | 'Inventory_Management_System' | System Generated |

### 5. Orders Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|--------------------|
| Bronze | bz_orders | Order_ID | Source | Orders | Order_ID | 1-1 Mapping |
| Bronze | bz_orders | Customer_ID | Source | Orders | Customer_ID | 1-1 Mapping |
| Bronze | bz_orders | Order_Date | Source | Orders | Order_Date | 1-1 Mapping |
| Bronze | bz_orders | load_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_orders | update_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_orders | source_system | Source | System Generated | 'Inventory_Management_System' | System Generated |

### 6. Order Details Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|--------------------|
| Bronze | bz_order_details | Order_Detail_ID | Source | Order_Details | Order_Detail_ID | 1-1 Mapping |
| Bronze | bz_order_details | Order_ID | Source | Order_Details | Order_ID | 1-1 Mapping |
| Bronze | bz_order_details | Product_ID | Source | Order_Details | Product_ID | 1-1 Mapping |
| Bronze | bz_order_details | Quantity_Ordered | Source | Order_Details | Quantity_Ordered | 1-1 Mapping |
| Bronze | bz_order_details | load_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_order_details | update_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_order_details | source_system | Source | System Generated | 'Inventory_Management_System' | System Generated |

### 7. Shipments Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|--------------------|
| Bronze | bz_shipments | Shipment_ID | Source | Shipments | Shipment_ID | 1-1 Mapping |
| Bronze | bz_shipments | Order_ID | Source | Shipments | Order_ID | 1-1 Mapping |
| Bronze | bz_shipments | Shipment_Date | Source | Shipments | Shipment_Date | 1-1 Mapping |
| Bronze | bz_shipments | load_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_shipments | update_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_shipments | source_system | Source | System Generated | 'Inventory_Management_System' | System Generated |

### 8. Returns Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|--------------------|
| Bronze | bz_returns | Return_ID | Source | Returns | Return_ID | 1-1 Mapping |
| Bronze | bz_returns | Order_ID | Source | Returns | Order_ID | 1-1 Mapping |
| Bronze | bz_returns | Return_Reason | Source | Returns | Return_Reason | 1-1 Mapping |
| Bronze | bz_returns | load_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_returns | update_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_returns | source_system | Source | System Generated | 'Inventory_Management_System' | System Generated |

### 9. Stock Levels Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|--------------------|
| Bronze | bz_stock_levels | Stock_Level_ID | Source | Stock_Levels | Stock_Level_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | Warehouse_ID | Source | Stock_Levels | Warehouse_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | Product_ID | Source | Stock_Levels | Product_ID | 1-1 Mapping |
| Bronze | bz_stock_levels | Reorder_Threshold | Source | Stock_Levels | Reorder_Threshold | 1-1 Mapping |
| Bronze | bz_stock_levels | load_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_stock_levels | update_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_stock_levels | source_system | Source | System Generated | 'Inventory_Management_System' | System Generated |

### 10. Customers Table Mapping

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|--------------------|
| Bronze | bz_customers | Customer_ID | Source | Customers | Customer_ID | 1-1 Mapping |
| Bronze | bz_customers | Customer_Name | Source | Customers | Customer_Name | 1-1 Mapping |
| Bronze | bz_customers | Email | Source | Customers | Email | 1-1 Mapping |
| Bronze | bz_customers | load_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_customers | update_timestamp | Source | System Generated | CURRENT_TIMESTAMP | System Generated |
| Bronze | bz_customers | source_system | Source | System Generated | 'Inventory_Management_System' | System Generated |

## Data Type Mapping

### Source to Snowflake Data Type Conversion

| Source Data Type | Snowflake Data Type | Rationale |
|------------------|--------------------|-----------|
| INT | NUMBER | Snowflake's NUMBER type handles all integer values efficiently |
| VARCHAR(255) | STRING | Snowflake's STRING type is flexible and handles variable length text |
| VARCHAR(100) | STRING | Snowflake's STRING type is flexible and handles variable length text |
| VARCHAR(20) | STRING | Snowflake's STRING type is flexible and handles variable length text |
| DATE | DATE | Direct mapping for date values |
| TIMESTAMP | TIMESTAMP_NTZ | Non-timezone aware timestamp for consistent data handling |

## Data Ingestion Specifications

### Ingestion Approach
- **Method**: Batch ingestion using Snowflake COPY command
- **Frequency**: Daily incremental loads
- **File Format**: CSV or JSON depending on source system export capability
- **Error Handling**: Failed records logged to error table for investigation
- **Data Validation**: Basic format validation only, no business rule validation

### Metadata Enhancement
All Bronze layer tables include the following metadata fields:
- `load_timestamp`: Timestamp when record was loaded into Bronze layer
- `update_timestamp`: Timestamp when record was last updated
- `source_system`: Identifier of the source system ('Inventory_Management_System')

## Data Quality Considerations

### Bronze Layer Principles
- **Raw Data Preservation**: All source data is preserved exactly as received
- **No Data Cleansing**: Data quality issues are not corrected in Bronze layer
- **No Business Rules**: Business logic and validations are deferred to Silver layer
- **Complete Audit Trail**: All data movements are logged for compliance and debugging

### Known Data Quality Issues (To be addressed in Silver layer)
- Potential null values in non-nullable fields
- Data format inconsistencies
- Referential integrity violations
- Duplicate records

## Sample Data Mapping Examples

### Products Table Example
**Source Record:**
```
Product_ID: 1
Product_Name: "Laptop"
Category: "Electronics"
```

**Bronze Layer Record:**
```
Product_ID: 1
Product_Name: "Laptop"
Category: "Electronics"
load_timestamp: 2024-01-15 10:30:00
update_timestamp: 2024-01-15 10:30:00
source_system: "Inventory_Management_System"
```

### Customers Table Example
**Source Record:**
```
Customer_Name: "John Doe"
Email: "john.doe@example.com"
```

**Bronze Layer Record:**
```
Customer_ID: 1
Customer_Name: "John Doe"
Email: "john.doe@example.com"
load_timestamp: 2024-01-15 10:30:00
update_timestamp: 2024-01-15 10:30:00
source_system: "Inventory_Management_System"
```

## PII Data Handling

### Identified PII Fields
| Table | Field | PII Classification | Handling Approach |
|-------|-------|-------------------|-------------------|
| bz_customers | Customer_Name | Direct PII | Preserved as-is in Bronze, encryption in Silver |
| bz_customers | Email | Direct PII | Preserved as-is in Bronze, encryption in Silver |
| bz_suppliers | Contact_Number | Indirect PII | Preserved as-is in Bronze, masking in Silver |
| bz_returns | Return_Reason | Potential PII | Preserved as-is in Bronze, review in Silver |

## Performance Considerations

### Indexing Strategy
- Primary key fields will be used as natural clustering keys
- No additional indexes in Bronze layer to maintain fast ingestion
- Partitioning by load_timestamp for efficient data management

### Storage Optimization
- Use Snowflake's automatic compression
- Implement time-based data retention policies
- Archive old data to lower-cost storage tiers

## Assumptions and Dependencies

### Assumptions
1. Source system provides consistent data formats
2. Customer_ID is system-generated and not present in source Customers table
3. All source tables have corresponding primary key fields
4. Data extraction from source system maintains referential relationships

### Dependencies
1. Source system availability for data extraction
2. Network connectivity between source and Snowflake
3. Appropriate Snowflake warehouse sizing for ingestion workloads
4. Data pipeline orchestration tool (e.g., Airflow, dbt) for scheduling

## API Cost Reporting

**API Cost Consumed:** $0.000750 USD

---

*This document serves as the foundation for Bronze layer implementation and will be referenced during Silver layer design and development.*