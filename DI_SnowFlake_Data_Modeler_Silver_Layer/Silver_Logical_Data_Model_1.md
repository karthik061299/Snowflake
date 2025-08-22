_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Silver layer logical data model for Inventory Management System following medallion architecture
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Silver Layer Logical Data Model - Inventory Management System

## 1. Silver Layer Logical Model

### 1.1 Si_Products
**Description:** Cleaned and standardized product information without identifiers

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Product_Name | VARCHAR(255) | Standardized product name or title as known in the market |
| Category | VARCHAR(100) | Product category classification for organizational and reporting purposes |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |
| data_quality_score | DECIMAL(3,2) | Data quality assessment score ranging from 0.00 to 1.00 |
| is_valid | BOOLEAN | Data validation flag indicating if record passes quality checks |

### 1.2 Si_Suppliers
**Description:** Supplier information with PII handling considerations

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Supplier_Name | VARCHAR(255) | Official business name of the supplier organization |
| Contact_Number | VARCHAR(20) | Primary contact phone number for supplier communication (PII protected) |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |
| data_quality_score | DECIMAL(3,2) | Data quality assessment score ranging from 0.00 to 1.00 |
| is_valid | BOOLEAN | Data validation flag indicating if record passes quality checks |

### 1.3 Si_Warehouses
**Description:** Warehouse location and capacity information

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Location | VARCHAR(255) | Geographic address or identifier of the warehouse facility |
| Capacity | INTEGER | Maximum storage capacity or volume that the warehouse can accommodate |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |
| data_quality_score | DECIMAL(3,2) | Data quality assessment score ranging from 0.00 to 1.00 |
| is_valid | BOOLEAN | Data validation flag indicating if record passes quality checks |

### 1.4 Si_Inventory
**Description:** Current inventory levels without reference keys

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Available | INTEGER | Current stock count of products available for sale or distribution |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |
| data_quality_score | DECIMAL(3,2) | Data quality assessment score ranging from 0.00 to 1.00 |
| is_valid | BOOLEAN | Data validation flag indicating if record passes quality checks |

### 1.5 Si_Orders
**Description:** Order information without customer references

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Order_Date | DATE | Date when the customer order was placed or received |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |
| data_quality_score | DECIMAL(3,2) | Data quality assessment score ranging from 0.00 to 1.00 |
| is_valid | BOOLEAN | Data validation flag indicating if record passes quality checks |

### 1.6 Si_Order_Details
**Description:** Order line item details without order references

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Ordered | INTEGER | Number of units of a specific product requested in the order |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |
| data_quality_score | DECIMAL(3,2) | Data quality assessment score ranging from 0.00 to 1.00 |
| is_valid | BOOLEAN | Data validation flag indicating if record passes quality checks |

### 1.7 Si_Shipments
**Description:** Shipment tracking information

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Shipment_Date | DATE | Date when the order was dispatched or sent to the customer |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |
| data_quality_score | DECIMAL(3,2) | Data quality assessment score ranging from 0.00 to 1.00 |
| is_valid | BOOLEAN | Data validation flag indicating if record passes quality checks |

### 1.8 Si_Returns
**Description:** Product return information and reasons

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Return_Reason | VARCHAR(255) | Explanation or category describing why the product was returned by the customer |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |
| data_quality_score | DECIMAL(3,2) | Data quality assessment score ranging from 0.00 to 1.00 |
| is_valid | BOOLEAN | Data validation flag indicating if record passes quality checks |

### 1.9 Si_Stock_Levels
**Description:** Stock level thresholds and monitoring

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Reorder_Threshold | INTEGER | Minimum inventory level that triggers replenishment or reorder processes |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |
| data_quality_score | DECIMAL(3,2) | Data quality assessment score ranging from 0.00 to 1.00 |
| is_valid | BOOLEAN | Data validation flag indicating if record passes quality checks |

### 1.10 Si_Customers
**Description:** Customer information with PII protection

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Customer_Name | VARCHAR(255) | Full name or business name of the customer (PII protected) |
| Email | VARCHAR(255) | Primary email address for customer communication (PII protected) |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |
| data_quality_score | DECIMAL(3,2) | Data quality assessment score ranging from 0.00 to 1.00 |
| is_valid | BOOLEAN | Data validation flag indicating if record passes quality checks |

### 1.11 Si_Data_Quality_Errors
**Description:** Captures data quality issues identified during Bronze to Silver transformation

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| table_name | VARCHAR(100) | Name of the source table where quality issue was detected |
| column_name | VARCHAR(100) | Specific column name with data quality issue |
| error_type | VARCHAR(100) | Type of data quality error (completeness, accuracy, format, etc.) |
| error_description | VARCHAR(500) | Detailed description of the data quality error encountered |
| record_count | INTEGER | Number of records affected by this data quality issue |
| severity_level | VARCHAR(20) | Error severity classification (LOW, MEDIUM, HIGH, CRITICAL) |
| detection_timestamp | TIMESTAMP | Timestamp when the data quality error was detected |
| source_system | VARCHAR(50) | Source system identifier where error originated |
| pipeline_run_id | VARCHAR(100) | Unique identifier for the pipeline execution run |

### 1.12 Si_Pipeline_Audit
**Description:** Audit trail for Silver layer pipeline execution

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| pipeline_name | VARCHAR(100) | Name of the data pipeline that was executed |
| execution_start_time | TIMESTAMP | Timestamp when pipeline execution started |
| execution_end_time | TIMESTAMP | Timestamp when pipeline execution completed |
| execution_status | VARCHAR(20) | Final status of pipeline execution (SUCCESS, FAILED, PARTIAL) |
| records_processed | INTEGER | Total number of records processed during pipeline run |
| records_passed | INTEGER | Number of records that passed all quality checks |
| records_failed | INTEGER | Number of records that failed quality validation |
| transformation_rules_applied | TEXT | Description of transformation rules applied during processing |
| error_summary | TEXT | Summary of errors encountered during pipeline execution |
| source_system | VARCHAR(50) | Source system identifier for the processed data |
| target_table | VARCHAR(100) | Name of the target Silver layer table |

## 2. Conceptual Data Model Diagram

**Block Diagram Format - Silver Layer Table Relationships:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           SILVER LAYER - INVENTORY MANAGEMENT                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                CORE BUSINESS TABLES                            │
│                                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐            │
│  │   Si_Products   │    │  Si_Suppliers   │    │  Si_Warehouses  │            │
│  ├─────────────────┤    ├─────────────────┤    ├─────────────────┤            │
│  │ Product_Name    │    │ Supplier_Name   │    │ Location        │            │
│  │ Category        │    │ Contact_Number  │    │ Capacity        │            │
│  │ load_timestamp  │    │ load_timestamp  │    │ load_timestamp  │            │
│  │ update_timestamp│    │ update_timestamp│    │ update_timestamp│            │
│  │ source_system   │    │ source_system   │    │ source_system   │            │
│  │ data_quality_sc │    │ data_quality_sc │    │ data_quality_sc │            │
│  │ is_valid        │    │ is_valid        │    │ is_valid        │            │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘            │
│           │                       │                       │                    │
│           │ (Product Reference)   │ (Product Reference)   │ (Warehouse Ref)    │
│           └───────────────────────┼───────────────────────┘                    │
│                                   │                                            │
│                                   ▼                                            │
│                      ┌─────────────────┐                                      │
│                      │  Si_Inventory   │                                      │
│                      ├─────────────────┤                                      │
│                      │Quantity_Available│                                      │
│                      │ load_timestamp  │                                      │
│                      │ update_timestamp│                                      │
│                      │ source_system   │                                      │
│                      │ data_quality_sc │                                      │
│                      │ is_valid        │                                      │
│                      └─────────────────┘                                      │
│                                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐            │
│  │  Si_Customers   │    │   Si_Orders     │    │ Si_Order_Details│            │
│  ├─────────────────┤    ├─────────────────┤    ├─────────────────┤            │
│  │ Customer_Name   │    │ Order_Date      │    │ Quantity_Ordered│            │
│  │ Email           │    │ load_timestamp  │    │ load_timestamp  │            │
│  │ load_timestamp  │    │ update_timestamp│    │ update_timestamp│            │
│  │ update_timestamp│    │ source_system   │    │ source_system   │            │
│  │ source_system   │    │ data_quality_sc │    │ data_quality_sc │            │
│  │ data_quality_sc │    │ is_valid        │    │ is_valid        │            │
│  │ is_valid        │    └─────────────────┘    └─────────────────┘            │
│  └─────────────────┘             │                       │                    │
│           │                      │ (Order Reference)     │ (Order Reference)  │
│           │ (Customer Reference) │                       │ (Product Reference)│
│           └──────────────────────┼───────────────────────┘                    │
│                                  │                                            │
│                                  ▼                                            │
│                     ┌─────────────────┐    ┌─────────────────┐              │
│                     │  Si_Shipments   │    │   Si_Returns    │              │
│                     ├─────────────────┤    ├─────────────────┤              │
│                     │ Shipment_Date   │    │ Return_Reason   │              │
│                     │ load_timestamp  │    │ load_timestamp  │              │
│                     │ update_timestamp│    │ update_timestamp│              │
│                     │ source_system   │    │ source_system   │              │
│                     │ data_quality_sc │    │ data_quality_sc │              │
│                     │ is_valid        │    │ is_valid        │              │
│                     └─────────────────┘    └─────────────────┘              │
│                              │                       │                       │
│                              │ (Order Reference)     │ (Order Reference)     │
│                              └───────────────────────┘                       │
│                                                                                 │
│                        ┌─────────────────┐                                   │
│                        │ Si_Stock_Levels │                                   │
│                        ├─────────────────┤                                   │
│                        │Reorder_Threshold│                                   │
│                        │ load_timestamp  │                                   │
│                        │ update_timestamp│                                   │
│                        │ source_system   │                                   │
│                        │ data_quality_sc │                                   │
│                        │ is_valid        │                                   │
│                        └─────────────────┘                                   │
│                                 │                                             │
│                                 │ (Warehouse Reference)                     │
│                                 │ (Product Reference)                       │
│                                 ▼                                             │
│                        Connected to Si_Warehouses and Si_Products            │
│                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│                            DATA QUALITY & AUDIT LAYER                          │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────┐    ┌─────────────────────────────┐            │
│  │   Si_Data_Quality_Errors    │    │     Si_Pipeline_Audit       │            │
│  ├─────────────────────────────┤    ├─────────────────────────────┤            │
│  │ table_name                  │    │ pipeline_name               │            │
│  │ column_name                 │    │ execution_start_time        │            │
│  │ error_type                  │    │ execution_end_time          │            │
│  │ error_description           │    │ execution_status            │            │
│  │ record_count                │    │ records_processed           │            │
│  │ severity_level              │    │ records_passed              │            │
│  │ detection_timestamp         │    │ records_failed              │            │
│  │ source_system               │    │ transformation_rules        │            │
│  │ pipeline_run_id             │    │ error_summary               │            │
│  └─────────────────────────────┘    │ source_system               │            │
│                                     │ target_table                │            │
│                                     └─────────────────────────────┘            │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

**Table Connection Summary:**
1. **Si_Products** connects to **Si_Inventory** via Product Reference (logical relationship)
2. **Si_Products** connects to **Si_Order_Details** via Product Reference (logical relationship)
3. **Si_Products** connects to **Si_Stock_Levels** via Product Reference (logical relationship)
4. **Si_Warehouses** connects to **Si_Inventory** via Warehouse Reference (logical relationship)
5. **Si_Warehouses** connects to **Si_Stock_Levels** via Warehouse Reference (logical relationship)
6. **Si_Customers** connects to **Si_Orders** via Customer Reference (logical relationship)
7. **Si_Orders** connects to **Si_Order_Details** via Order Reference (logical relationship)
8. **Si_Orders** connects to **Si_Shipments** via Order Reference (logical relationship)
9. **Si_Orders** connects to **Si_Returns** via Order Reference (logical relationship)
10. **Si_Suppliers** connects to **Si_Products** via Product Reference (logical relationship)

**Note:** In the Silver layer, actual foreign key constraints are removed, but logical relationships are maintained through data lineage and business context.

## 3. apiCost

**Cost consumed by the API for this call (in USD):** 0.40
