_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Gold layer logical data model for Inventory Management System following medallion architecture
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Gold Layer Logical Data Model - Inventory Management System

## 1. Gold Layer Logical Model

### 1.1 Go_Fact_Inventory_Movements
**Description:** Central fact table tracking all inventory movements and transactions
**Table Type:** Fact
**SCD Type:** N/A

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|-------------------|
| movement_date | DATE | Date of inventory movement | Non-PII |
| product_name | VARCHAR(200) | Product name reference | Non-PII |
| warehouse_location | VARCHAR(200) | Warehouse location reference | Non-PII |
| supplier_name | VARCHAR(200) | Supplier name reference | Non-PII |
| movement_type | VARCHAR(20) | Type of movement (IN