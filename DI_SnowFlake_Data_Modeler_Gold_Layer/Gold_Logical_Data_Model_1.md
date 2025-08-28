_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Gold Layer Logical Data Model for Inventory Management System following medallion architecture principles
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Gold Layer Logical Data Model - Inventory Management System

## 1. Gold Layer Logical Model

### 1.1 Fact Tables

#### Go_Inventory_Facts
**Table Description:** Central fact table capturing inventory transactions and current stock levels
**Table Type:** Fact Table
**SCD Type:** N/A

| Column Name | Description | Data Type | PII Classification |
|-------------|-------------|-----------|-------------------|
| quantity_available | Current available quantity in stock | INTEGER | Non-PII |
| quantity_reserved | Quantity reserved for pending orders | INTEGER | Non-PII |
| quantity_on_order | Quantity ordered from suppliers but not received | INTEGER | Non-PII |
| unit_cost | Cost per unit of inventory item | DECIMAL(10