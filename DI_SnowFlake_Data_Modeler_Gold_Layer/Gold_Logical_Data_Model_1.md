_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Comprehensive Gold layer logical data model for Inventory Management System following medallion architecture principles
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Gold Layer Logical Data Model - Inventory Management System

## 1. Gold Layer Logical Model

### 1.1 Dimension Tables

#### Go_Dim_Product (SCD Type 2)
**Description:** Product master dimension with historical tracking of product changes
**Table Type:** Dimension
**SCD Type:** Type 2 (Historical tracking)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|-------------------|
| product_key | VARCHAR(50) | Business key for product | Non-PII |
| product_name | VARCHAR(255) | Name of the product | Non-PII |
| product_description | TEXT | Detailed product description | Non-PII |
| category | VARCHAR(100) | Product category | Non-PII |
| subcategory | VARCHAR(100) | Product subcategory | Non-PII |
| brand | VARCHAR(100) | Product brand | Non-PII |
| unit_price | DECIMAL(10