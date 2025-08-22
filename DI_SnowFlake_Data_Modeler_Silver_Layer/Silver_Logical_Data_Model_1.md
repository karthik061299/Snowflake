_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Silver Layer Logical Data Model for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Silver Layer Logical Data Model - Inventory Management System

## 1. Silver Layer Logical Model

### 1.1 Si_Products

**Table Description:** Contains cleansed and standardized product information with data type standardization and quality validations applied.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Product_Name | VARCHAR(255) | Standardized name of the product with consistent formatting |
| Category | VARCHAR(100) | Standardized product category classification following business taxonomy |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated in Silver layer |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking |
| data_quality_score | DECIMAL(3,2) | Quality score between 0.00 and 1.00 indicating data completeness and accuracy |
| is_active | BOOLEAN | Flag indicating if the product record is currently active |

### 1.2 Si_Suppliers

**Table Description:** Contains cleansed and standardized supplier information with contact validation and data quality checks applied.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Supplier_Name | VARCHAR(255) | Standardized name of the supplier company with consistent formatting |
| Contact_Number | VARCHAR(20) | Validated and standardized supplier contact phone number |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated in Silver layer |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking |
| data_quality_score | DECIMAL(3,2) | Quality score between 0.00 and 1.00 indicating data completeness and accuracy |
| is_active | BOOLEAN | Flag indicating if the supplier record is currently active |

### 1.3 Si_Warehouses

**Table Description:** Contains cleansed and standardized warehouse information with location validation and capacity standardization.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Location | VARCHAR(255) | Standardized physical location of the warehouse with consistent address format |
| Capacity | INTEGER | Validated storage capacity of the warehouse in standardized units |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated in Silver layer |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking |
| data_quality_score | DECIMAL(3,2) | Quality score between 0.00 and 1.00 indicating data completeness and accuracy |
| is_active | BOOLEAN | Flag indicating if the warehouse record is currently active |

### 1.4 Si_Inventory

**Table Description:** Contains cleansed and validated inventory data with quantity standardization and business rule validations.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Available | INTEGER | Validated current available quantity in inventory (non-negative values only) |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated in Silver layer |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking |
| data_quality_score | DECIMAL(3,2) | Quality score between 0.00 and 1.00 indicating data completeness and accuracy |
| is_active | BOOLEAN | Flag indicating if the inventory record is currently active |

### 1.5 Si_Orders

**Table Description:** Contains cleansed and validated order information with date standardization and temporal consistency checks.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Order_Date | DATE | Validated date when the order was placed in standardized YYYY-MM-DD format |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated in Silver layer |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking |
| data_quality_score | DECIMAL(3,2) | Quality score between 0.00 and 1.00 indicating data completeness and accuracy |
| is_active | BOOLEAN | Flag indicating if the order record is currently active |

### 1.6 Si_Order_Details

**Table Description:** Contains cleansed and validated order detail information with quantity validation and business rule checks.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Ordered | INTEGER | Validated quantity of items ordered (positive values only) |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated in Silver layer |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking |
| data_quality_score | DECIMAL(3,2) | Quality score between 0.00 and 1.00 indicating data completeness and accuracy |
| is_active | BOOLEAN | Flag indicating if the order detail record is currently active |

### 1.7 Si_Shipments

**Table Description:** Contains cleansed and validated shipment information with date validation and temporal consistency checks.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Shipment_Date | DATE | Validated date when the shipment was sent in standardized YYYY-MM-DD format |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated in Silver layer |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking |
| data_quality_score | DECIMAL(3,2) | Quality score between 0.00 and 1.00 indicating data completeness and accuracy |
| is_active | BOOLEAN | Flag indicating if the shipment record is currently active |

### 1.8 Si_Returns

**Table Description:** Contains cleansed and validated return information with reason standardization and business rule validations.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Return_Reason | VARCHAR(500) | Standardized reason for product return from predefined list (Damaged, Defective, Wrong Item) |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated in Silver layer |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking |
| data_quality_score | DECIMAL(3,2) | Quality score between 0.00 and 1.00 indicating data completeness and accuracy |
| is_active | BOOLEAN | Flag indicating if the return record is currently active |

### 1.9 Si_Stock_Levels

**Table Description:** Contains cleansed and validated stock level information with threshold validation and business rule checks.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Reorder_Threshold | INTEGER | Validated minimum stock level before reordering (positive values only) |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated in Silver layer |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking |
| data_quality_score | DECIMAL(3,2) | Quality score between 0.00 and 1.00 indicating data completeness and accuracy |
| is_active | BOOLEAN | Flag indicating if the stock level record is currently active |

### 1.10 Si_Customers

**Table Description:** Contains cleansed and validated customer information with PII handling and contact validation.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Customer_Name | VARCHAR(255) | Standardized full name of the customer with consistent formatting |
| Email | VARCHAR(255) | Validated customer email address following standard email format |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Silver layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated in Silver layer |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking |
| data_quality_score | DECIMAL(3,2) | Quality score between 0.00 and 1.00 indicating data completeness and accuracy |
| is_active | BOOLEAN | Flag indicating if the customer record is currently active |

## 2. Data Quality and Error Management Tables

### 2.1 Si_Data_Quality_Errors

**Table Description:** Stores detailed information about data quality issues and validation errors encountered during Silver layer processing.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| error_id | VARCHAR(50) | Unique identifier for the data quality error record |
| source_table | VARCHAR(100) | Name of the source table where the error was detected |
| source_record_id | VARCHAR(100) | Identifier of the source record that failed validation |
| error_type | VARCHAR(50) | Type of data quality error (MISSING_VALUE, INVALID_FORMAT, CONSTRAINT_VIOLATION, etc.) |
| error_description | VARCHAR(1000) | Detailed description of the data quality error |
| error_field | VARCHAR(100) | Name of the field that failed validation |
| error_value | VARCHAR(500) | Value that caused the validation error |
| error_severity | VARCHAR(20) | Severity level of the error (CRITICAL, HIGH, MEDIUM, LOW) |
| error_timestamp | TIMESTAMP | Timestamp when the error was detected |
| resolution_status | VARCHAR(50) | Status of error resolution (OPEN, IN_PROGRESS, RESOLVED, IGNORED) |
| resolution_notes | VARCHAR(1000) | Notes about error resolution or remediation actions |
| created_by | VARCHAR(100) | System or process that detected the error |

### 2.2 Si_Data_Validation_Rules

**Table Description:** Stores the data validation rules applied during Silver layer processing for audit and compliance purposes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| rule_id | VARCHAR(50) | Unique identifier for the validation rule |
| rule_name | VARCHAR(200) | Name of the validation rule |
| rule_description | VARCHAR(1000) | Detailed description of what the rule validates |
| target_table | VARCHAR(100) | Table to which the validation rule applies |
| target_field | VARCHAR(100) | Field to which the validation rule applies |
| rule_type | VARCHAR(50) | Type of validation rule (NOT_NULL, FORMAT_CHECK, RANGE_CHECK, etc.) |
| rule_expression | VARCHAR(2000) | SQL expression or logic for the validation rule |
| is_active | BOOLEAN | Flag indicating if the validation rule is currently active |
| created_timestamp | TIMESTAMP | Timestamp when the validation rule was created |
| updated_timestamp | TIMESTAMP | Timestamp when the validation rule was last updated |

## 3. Pipeline Audit and Process Management Tables

### 3.1 Si_Pipeline_Audit_Log

**Table Description:** Comprehensive audit trail for all Silver layer pipeline executions and data processing activities.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| audit_id | VARCHAR(50) | Unique identifier for the audit log record |
| pipeline_name | VARCHAR(200) | Name of the data pipeline that was executed |
| pipeline_run_id | VARCHAR(100) | Unique identifier for the specific pipeline execution |
| execution_start_time | TIMESTAMP | Timestamp when the pipeline execution started |
| execution_end_time | TIMESTAMP | Timestamp when the pipeline execution completed |
| execution_duration | DECIMAL(10,3) | Total execution time in seconds |
| execution_status | VARCHAR(50) | Status of pipeline execution (SUCCESS, FAILED, PARTIAL_SUCCESS, CANCELLED) |
| source_table | VARCHAR(100) | Name of the source table being processed |
| target_table | VARCHAR(100) | Name of the target Silver layer table |
| records_processed | INTEGER | Total number of records processed |
| records_successful | INTEGER | Number of records successfully processed |
| records_failed | INTEGER | Number of records that failed processing |
| records_skipped | INTEGER | Number of records skipped during processing |
| data_volume_mb | DECIMAL(10,2) | Volume of data processed in megabytes |
| error_message | VARCHAR(2000) | Error message if pipeline execution failed |
| executed_by | VARCHAR(100) | User or system that executed the pipeline |
| environment | VARCHAR(50) | Environment where the pipeline was executed (DEV, TEST, PROD) |

### 3.2 Si_Process_Monitoring

**Table Description:** Real-time monitoring information for Silver layer processes and system performance metrics.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| monitor_id | VARCHAR(50) | Unique identifier for the monitoring record |
| process_name | VARCHAR(200) | Name of the process being monitored |
| process_type | VARCHAR(100) | Type of process (DATA_LOAD, DATA_VALIDATION, DATA_TRANSFORMATION) |
| start_timestamp | TIMESTAMP | Timestamp when the process started |
| end_timestamp | TIMESTAMP | Timestamp when the process completed |
| process_status | VARCHAR(50) | Current status of the process (RUNNING, COMPLETED, FAILED, QUEUED) |
| cpu_usage_percent | DECIMAL(5,2) | CPU usage percentage during process execution |
| memory_usage_mb | DECIMAL(10,2) | Memory usage in megabytes during process execution |
| disk_io_mb | DECIMAL(10,2) | Disk I/O in megabytes during process execution |
| network_io_mb | DECIMAL(10,2) | Network I/O in megabytes during process execution |
| performance_score | DECIMAL(3,2) | Performance score between 0.00 and 1.00 |
| alert_threshold_breached | BOOLEAN | Flag indicating if any performance threshold was breached |
| monitoring_timestamp | TIMESTAMP | Timestamp when the monitoring data was captured |

## 4. Conceptual Data Model Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Si_Products   │    │  Si_Suppliers   │    │  Si_Warehouses  │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ Product_Name    │    │ Supplier_Name   │    │ Location        │
│ Category        │    │ Contact_Number  │    │ Capacity        │
│ load_timestamp  │    │ load_timestamp  │    │ load_timestamp  │
│ update_timestamp│    │ update_timestamp│    │ update_timestamp│
│ source_system   │    │ source_system   │    │ source_system   │
│data_quality_score│   │data_quality_score│   │data_quality_score│
│ is_active       │    │ is_active       │    │ is_active       │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Si_Inventory   │    │   Si_Orders     │    │ Si_Order_Details│
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│Quantity_Available│    │ Order_Date      │    │ Quantity_Ordered│
│ load_timestamp  │    │ load_timestamp  │    │ load_timestamp  │
│ update_timestamp│    │ update_timestamp│    │ update_timestamp│
│ source_system   │    │ source_system   │    │ source_system   │
│data_quality_score│   │data_quality_score│   │data_quality_score│
│ is_active       │    │ is_active       │    │ is_active       │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Si_Shipments   │    │   Si_Returns    │    │ Si_Stock_Levels │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ Shipment_Date   │    │ Return_Reason   │    │Reorder_Threshold│
│ load_timestamp  │    │ load_timestamp  │    │ load_timestamp  │
│ update_timestamp│    │ update_timestamp│    │ update_timestamp│
│ source_system   │    │ source_system   │    │ source_system   │
│data_quality_score│   │data_quality_score│   │data_quality_score│
│ is_active       │    │ is_active       │    │ is_active       │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐
│  Si_Customers   │    │Si_Data_Quality_ │
├─────────────────┤    │     Errors      │
│ Customer_Name   │    ├─────────────────┤
│ Email           │    │ error_id        │
│ load_timestamp  │    │ source_table    │
│ update_timestamp│    │ source_record_id│
│ source_system   │    │ error_type      │
│data_quality_score│   │ error_description│
│ is_active       │    │ error_field     │
└─────────────────┘    │ error_value     │
                       │ error_severity  │
                       │ error_timestamp │
                       │resolution_status│
                       │resolution_notes │
                       │ created_by      │
                       └─────────────────┘

┌─────────────────┐    ┌─────────────────┐
│Si_Data_Validation│   │Si_Pipeline_Audit│
│     Rules       │    │      Log        │
├─────────────────┤    ├─────────────────┤
│ rule_id         │    │ audit_id        │
│ rule_name       │    │ pipeline_name   │
│ rule_description│    │ pipeline_run_id │
│ target_table    │    │execution_start_ │
│ target_field    │    │     time        │
│ rule_type       │    │execution_end_   │
│ rule_expression │    │     time        │
│ is_active       │    │execution_duration│
│created_timestamp│    │execution_status │
│updated_timestamp│    │ source_table    │
└─────────────────┘    │ target_table    │
                       │records_processed│
                       │records_successful│
                       │ records_failed  │
                       │ records_skipped │
                       │ data_volume_mb  │
                       │ error_message   │
                       │ executed_by     │
                       │ environment     │
                       └─────────────────┘

┌─────────────────┐
│Si_Process_      │
│   Monitoring    │
├─────────────────┤
│ monitor_id      │
│ process_name    │
│ process_type    │
│ start_timestamp │
│ end_timestamp   │
│ process_status  │
│cpu_usage_percent│
│memory_usage_mb  │
│ disk_io_mb      │
│ network_io_mb   │
│performance_score│
│alert_threshold_ │
│    breached     │
│monitoring_      │
│  timestamp      │
└─────────────────┘
```

**Relationship Connections:**
- Si_Products connects to Si_Suppliers via Product_Name field
- Si_Products connects to Si_Inventory via Product_Name field
- Si_Products connects to Si_Order_Details via Product_Name field
- Si_Products connects to Si_Stock_Levels via Product_Name field
- Si_Warehouses connects to Si_Inventory via Location field
- Si_Warehouses connects to Si_Stock_Levels via Location field
- Si_Orders connects to Si_Order_Details via Order_Date field
- Si_Orders connects to Si_Shipments via Order_Date field
- Si_Orders connects to Si_Returns via Order_Date field
- Si_Customers connects to Si_Orders via Customer_Name field
- Si_Data_Quality_Errors connects to all Silver tables via source_table field
- Si_Pipeline_Audit_Log connects to all Silver tables via source_table and target_table fields
- Si_Data_Validation_Rules connects to all Silver tables via target_table field
- Si_Process_Monitoring tracks all Silver layer processes and transformations

## 5. Design Rationale and Key Decisions

### 5.1 Data Type Standardization
- **Timestamps**: All timestamp fields use TIMESTAMP data type for consistency across the Silver layer
- **Dates**: Order_Date and Shipment_Date standardized to DATE format (YYYY-MM-DD)
- **Text Fields**: VARCHAR lengths standardized based on business requirements and data analysis
- **Numeric Fields**: INTEGER used for quantities and thresholds, DECIMAL for scores and measurements
- **Boolean Fields**: Added is_active flags for soft delete functionality and data lifecycle management

### 5.2 Data Quality Framework
- **Quality Scores**: Added data_quality_score field to all tables for monitoring data completeness and accuracy
- **Error Tracking**: Comprehensive error management system to capture and track data quality issues
- **Validation Rules**: Structured approach to define and manage data validation rules
- **Audit Trail**: Complete audit logging for compliance and troubleshooting purposes

### 5.3 Naming Conventions
- **Table Prefix**: All Silver layer tables prefixed with "Si_" for clear layer identification
- **Field Names**: Consistent naming convention maintained from Bronze layer
- **System Fields**: Standardized system fields (load_timestamp, update_timestamp, source_system) across all tables

### 5.4 Key Assumptions
- **Data Lineage**: Source system tracking maintained for data governance
- **Soft Deletes**: is_active flag used instead of hard deletes for data preservation
- **Performance**: Indexes and partitioning strategies to be implemented based on query patterns
- **Scalability**: Design supports horizontal scaling and future data volume growth

## 6. API Cost

- **apiCost:** 0.200000