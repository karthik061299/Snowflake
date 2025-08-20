_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Gold layer logical data model for Inventory Management System following medallion architecture
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Gold Layer Logical Data Model - Inventory Management System

## 1. Gold Layer Logical Model

### 1.1 Dimension Tables

#### 1.1.1 Go_Dim_Product (SCD Type 2)
**Table Type:** Dimension  
**SCD Type:** Type 2  
**Description:** Product master data with historical tracking for category and supplier changes

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| product_name | VARCHAR(255) | Commercial name or title of the product as known in the market | Non-PII |
| category | VARCHAR(100) | Product classification grouping for organizational and reporting purposes | Non-PII |
| supplier_name | VARCHAR(255) | Current supplier name providing this product | Non-PII |
| product_status | VARCHAR(50) | Current status of the product (Active/Inactive/Discontinued) | Non-PII |
| effective_date | TIMESTAMP | Date when this product record version became effective | Non-PII |
| expiry_date | TIMESTAMP | Date when this product record version expires (NULL for current) | Non-PII |
| is_current | BOOLEAN | Flag indicating if this is the current active record | Non-PII |
| load_date | TIMESTAMP | System-generated timestamp when record was loaded into Gold layer | Non-PII |
| update_date | TIMESTAMP | System-generated timestamp when record was last updated | Non-PII |
| source_system | VARCHAR(100) | Identifier of the source system from which data originated | Non-PII |

#### 1.1.2 Go_Dim_Supplier (SCD Type 1)
**Table Type:** Dimension  
**SCD Type:** Type 1  
**Description:** Supplier master data with current information only

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| supplier_name | VARCHAR(255) | Official business name of the supplier organization | Non-PII |
| contact_number | VARCHAR(50) | Primary telephone number for supplier communication | PII |
| supplier_status | VARCHAR(50) | Current status of the supplier (Active/Inactive/Suspended) | Non-PII |
| product_count | INTEGER | Total number of products currently supplied by this supplier | Non-PII |
| is_single_source | BOOLEAN | Flag indicating if supplier is the only source for any products | Non-PII |
| load_date | TIMESTAMP | System-generated timestamp when record was loaded into Gold layer | Non-PII |
| update_date | TIMESTAMP | System-generated timestamp when record was last updated | Non-PII |
| source_system | VARCHAR(100) | Identifier of the source system from which data originated | Non-PII |

#### 1.1.3 Go_Dim_Warehouse (SCD Type 1)
**Table Type:** Dimension  
**SCD Type:** Type 1  
**Description:** Warehouse location and capacity information

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| warehouse_location | VARCHAR(255) | Geographic address or identifier of the warehouse facility | Non-PII |
| capacity | INTEGER | Maximum storage capacity or volume that the warehouse can accommodate | Non-PII |
| current_utilization | DECIMAL(5