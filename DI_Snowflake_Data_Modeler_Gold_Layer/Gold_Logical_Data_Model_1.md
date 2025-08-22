_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Gold Layer Logical Data Model for Inventory Management System dimensional modeling
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Gold Layer Logical Data Model - Inventory Management System

## 1. Gold Layer Logical Model

### 1.1 Fact Tables

#### 1.1.1 Go_Fact_Inventory_Snapshot

**Table Description:** Daily snapshot fact table capturing inventory levels across products and warehouses for trend analysis and historical reporting.

**Table Type:** Fact Table

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|-------------------|
| Snapshot_Date | DATE | Date of the inventory snapshot | Non-PII |
| Product_Name | VARCHAR(255) | Name of the product for inventory tracking | Non-PII |
| Warehouse_Location | VARCHAR(255) | Location of the warehouse storing the inventory | Non-PII |
| Quantity_Available | INTEGER | Available quantity of product in warehouse on snapshot date | Non-PII |
| Reorder_Threshold | INTEGER | Reorder threshold for the product at the warehouse | Non-PII |
| Quantity_Below_Threshold | INTEGER | Quantity below reorder threshold (calculated field) | Non-PII |
| Inventory_Value_Estimate | DECIMAL(15