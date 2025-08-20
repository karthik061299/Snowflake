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

#### Go_Fact_Inventory_Transactions
**Description:** Central fact table capturing all inventory-related transactions and movements
**Table Type:** Fact
**SCD Type:** N/A (Fact table)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| product_name | VARCHAR(200) | Name of the product involved in transaction | Non-PII |
| supplier_name | VARCHAR(200) | Name of supplier for the transaction | Non-PII |
| warehouse_location | VARCHAR(255) | Location of warehouse where transaction occurred | Non-PII |
| transaction_date | DATE | Date when inventory transaction occurred | Non-PII |
| transaction_time | TIME | Time when inventory transaction occurred | Non-PII |
| quantity_change | NUMBER(10