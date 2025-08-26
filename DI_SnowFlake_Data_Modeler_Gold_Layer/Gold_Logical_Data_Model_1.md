_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Gold Layer Logical Data Model for Inventory Management System dimensional model
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Gold Layer Logical Data Model - Inventory Management System

## 1. Gold Layer Logical Model

### 1.1 Fact Tables

#### 1.1.1 Go_Fact_Inventory

**Table Description:** Central fact table containing inventory transactions and current stock levels with dimensional relationships for comprehensive inventory analytics.

**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|-------------------|
| Inventory_Date | DATE | Date of inventory snapshot or transaction | Non-PII |
| Quantity_Available | INTEGER | Current available quantity in inventory | Non-PII |
| Quantity_Reserved | INTEGER | Quantity reserved for pending orders | Non-PII |
| Quantity_In_Transit | INTEGER | Quantity currently in transit to warehouse | Non-PII |
| Reorder_Threshold | INTEGER | Minimum stock level before reordering | Non-PII |
| Stock_Value | DECIMAL(15