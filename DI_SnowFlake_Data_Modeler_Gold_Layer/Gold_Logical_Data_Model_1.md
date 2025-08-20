_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Gold layer logical data model for Inventory Management System following medallion architecture
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Gold Layer Logical Data Model - Inventory Management System

## 1. Gold Layer Logical Model

### 1.1 Fact Tables

#### Go_Fact_Orders
**Table Type:** Fact
**SCD Type:** N/A
**Description:** Central fact table capturing order transactions and business metrics for analytical reporting

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|-------------------|
| order_date | DATE | Date when the customer order was placed or received | None |
| customer_name | VARCHAR(255) | Full name or business name of the customer | High |
| product_name | VARCHAR(255) | Commercial name or title of the product as known in the market | None |
| warehouse_location | VARCHAR(255) | Geographic address or identifier of the warehouse facility | Low |
| supplier_name | VARCHAR(255) | Official business name of the supplier organization | None |
| quantity_ordered | INTEGER | Number of units of a specific product requested in the order | None |
| unit_price | DECIMAL(10