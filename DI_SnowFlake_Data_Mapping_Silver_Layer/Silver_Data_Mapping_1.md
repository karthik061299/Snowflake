_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Silver Layer Data Mapping for Inventory Management System following Medallion Architecture
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# SILVER LAYER DATA MAPPING - INVENTORY MANAGEMENT SYSTEM

## 1. Overview

This document provides a comprehensive data mapping from the Bronze Layer to the Silver Layer in Snowflake's Medallion architecture for the Inventory Management System. The mapping incorporates data cleansing, validation rules, and business transformations to ensure high-quality, consistent data in the Silver layer. The Silver layer serves as the foundation for analytics and reporting by applying necessary data quality checks, standardizations, and enrichments to the raw Bronze layer data.

**Key Considerations:**
- All Bronze layer tables are mapped to corresponding Silver layer tables with "si_" prefix
- Data quality scoring and validation flags are added to each record
- Comprehensive validation rules are applied based on business requirements
- Error handling and audit mechanisms are implemented
- Transformation rules ensure data consistency and standardization

## 2. Data Mapping for the Silver Layer

### 2.1 Products Table Mapping (Bronze.bz_products → Silver.si_products)

| Target Layer | Target Table | Target Field | Source Layer | Source Table | Source Field | Validation Rule | Transformation Rule |
|--------------|--------------|--------------|--------------|--------------|--------------|-----------------|--------------------|
| Silver | si_products | product_id | Bronze | bz_products | Product_ID | Not null