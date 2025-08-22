_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Silver Layer Data Quality Recommendations for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# SILVER LAYER DATA QUALITY RECOMMENDATIONS - INVENTORY MANAGEMENT SYSTEM

## Recommended Data Quality Checks:

### 1. **Products Table (bz_products) Data Quality Checks**

#### 1.1 [Product_ID_Not_Null_Check]: Validate Product ID is not null
- **Rationale**: Product_ID is the primary key and must be present for all records to ensure data integrity and proper referential relationships
- **SQL Example**: 
```sql
SELECT COUNT(*) as null_product_ids
FROM Bronze.bz_products 
WHERE product_id IS NULL;
```

#### 1.2 [Product_ID_Uniqueness_Check]: Validate Product ID uniqueness
- **Rationale**: Primary key constraint requires unique values to prevent duplicate records and maintain data consistency
- **SQL Example**: 
```sql
SELECT product_id