_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Gold Layer Logical Data Model for Inventory Management System with dimensional modeling
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Gold Layer Logical Data Model - Inventory Management System

## 1. Gold Layer Logical Model

### 1.1 Go_Dim_Products (Dimension Table)

**Table Description:** Product dimension table containing comprehensive product information for analytical reporting and business intelligence.
**Table Type:** Dimension
**SCD Type:** Type 2 (Slowly Changing Dimension)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|-------------------|
| Product_Key | VARCHAR(50) | Surrogate key for product dimension | Non-PII |
| Product_Name | VARCHAR(255) | Business name of the product for reporting and analytics | Non-PII |
| Category | VARCHAR(100) | Product category classification for grouping and analysis | Non-PII |
| Product_Status | VARCHAR(50) | Current status of the product (Active