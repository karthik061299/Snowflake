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

#### 1.1.1 Go_Dim_Products (SCD Type 2)
**Description:** Product dimension with historical tracking for product attribute changes over time
**Table Type:** Dimension
**SCD Type:** Type 2

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| product_key | VARCHAR(50) | Business key for product identification | None |
| product_name | VARCHAR(255) | Standardized product name or title as known in the market | None |
| category | VARCHAR(100) | Product category classification for organizational and reporting purposes | None |
| subcategory | VARCHAR(100) | Product subcategory for detailed classification | None |
| unit_price | DECIMAL(10