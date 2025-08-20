_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Silver Layer Logical Data Model for Inventory Management System following Medallion Architecture
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Silver Layer Logical Data Model - Inventory Management System

## 1. Silver Layer Logical Model

### 1.1 Si_Products
**Description:** Cleaned and standardized product information with validated data types and business rules applied

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Product_Name | VARCHAR(255) | Standardized product name with consistent formatting and validation |
| Category | VARCHAR(100) | Validated product category following business taxonomy standards |
| load_timestamp | TIMESTAMP | System timestamp indicating when record was processed into Silver layer |
| update_timestamp | TIMESTAMP | System timestamp of last modification in Silver layer |
| source_system | VARCHAR(50) | Validated source system identifier for data lineage tracking |

### 1.2 Si_Suppliers
**Description:** Validated supplier information with standardized contact details and data quality checks applied

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Supplier_Name | VARCHAR(255) | Standardized supplier organization name with consistent formatting |
| Contact_Number | VARCHAR(20) | Validated phone number in standardized format for reliable communication |
| load_timestamp | TIMESTAMP | System timestamp indicating when record was processed into Silver layer |
| update_timestamp | TIMESTAMP | System timestamp of last modification in Silver layer |
| source_system | VARCHAR(50) | Validated source system identifier for data lineage tracking |

### 1.3 Si_Warehouses
**Description:** Standardized warehouse facility data with validated location and capacity information

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Location | VARCHAR(255) | Standardized warehouse location with consistent address formatting |
| Capacity | INTEGER | Validated maximum storage capacity ensuring positive values |
| load_timestamp | TIMESTAMP | System timestamp indicating when record was processed into Silver layer |
| update_timestamp | TIMESTAMP | System timestamp of last modification in Silver layer |
| source_system | VARCHAR(50) | Validated source system identifier for data lineage tracking |

### 1.4 Si_Inventory
**Description:** Validated inventory data with business rule enforcement and data quality checks

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Available | INTEGER | Validated available stock quantity ensuring non-negative values |
| load_timestamp | TIMESTAMP | System timestamp indicating when record was processed into Silver layer |
| update_timestamp | TIMESTAMP | System timestamp of last modification in Silver layer |
| source_system | VARCHAR(50) | Validated source system identifier for data lineage tracking |

### 1.5 Si_Orders
**Description:** Standardized order header information with validated dates and business rule compliance

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Order_Date | DATE | Validated order placement date ensuring chronological consistency |
| load_timestamp | TIMESTAMP | System timestamp indicating when record was processed into Silver layer |
| update_timestamp | TIMESTAMP | System timestamp of last modification in Silver layer |
| source_system | VARCHAR(50) | Validated source system identifier for data lineage tracking |

### 1.6 Si_Order_Details
**Description:** Validated order line items with quantity validation and business rule enforcement

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Ordered | INTEGER | Validated ordered quantity ensuring positive values and business rules |
| load_timestamp | TIMESTAMP | System timestamp indicating when record was processed into Silver layer |
| update_timestamp | TIMESTAMP | System timestamp of last modification in Silver layer |
| source_system | VARCHAR(50) | Validated source system identifier for data lineage tracking |

### 1.7 Si_Shipments
**Description:** Standardized shipment data with validated dates and logical consistency checks

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Shipment_Date | DATE | Validated shipment date ensuring chronological order with order dates |
| load_timestamp | TIMESTAMP | System timestamp indicating when record was processed into Silver layer |
| update_timestamp | TIMESTAMP | System timestamp of last modification in Silver layer |
| source_system | VARCHAR(50) | Validated source system identifier for data lineage tracking |

### 1.8 Si_Returns
**Description:** Standardized return information with validated reason codes and business rule compliance

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Return_Reason | VARCHAR(255) | Standardized return reason from predefined business taxonomy |
| load_timestamp | TIMESTAMP | System timestamp indicating when record was processed into Silver layer |
| update_timestamp | TIMESTAMP | System timestamp of last modification in Silver layer |
| source_system | VARCHAR(50) | Validated source system identifier for data lineage tracking |

### 1.9 Si_Stock_Levels
**Description:** Validated stock level configuration with business rule enforcement and threshold validation

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Reorder_Threshold | INTEGER | Validated reorder threshold ensuring positive values and business logic |
| load_timestamp | TIMESTAMP | System timestamp indicating when record was processed into Silver layer |
| update_timestamp | TIMESTAMP | System timestamp of last modification in Silver layer |
| source_system | VARCHAR(50) | Validated source system identifier for data lineage tracking |

### 1.10 Si_Customers
**Description:** Standardized customer information with PII handling and data quality validation

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Customer_Name | VARCHAR(255) | Standardized customer name with consistent formatting (PII protected) |
| Email | VARCHAR(255) | Validated email address in standard format for reliable communication (PII protected) |
| load_timestamp | TIMESTAMP | System timestamp indicating when record was processed into Silver layer |
| update_timestamp | TIMESTAMP | System timestamp of last modification in Silver layer |
| source_system | VARCHAR(50) | Validated source system identifier for data lineage tracking |

## 2. Data Quality and Error Management Structure

### 2.1 Si_Data_Quality_Errors
**Description:** Comprehensive error tracking for data validation failures and quality issues in Silver layer processing

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| error_timestamp | TIMESTAMP | Timestamp when data quality error was detected during processing |
| source_table | VARCHAR(100) | Name of the Silver layer table where error occurred |
| error_type | VARCHAR(50) | Classification of error (VALIDATION, CONSTRAINT, FORMAT, BUSINESS_RULE) |
| error_severity | VARCHAR(20) | Severity level of error (CRITICAL, HIGH, MEDIUM, LOW) |
| error_description | VARCHAR(500) | Detailed description of the data quality issue encountered |
| failed_record_count | INTEGER | Number of records that failed validation for this specific error |
| error_column | VARCHAR(100) | Specific column name where error was detected |
| error_value | VARCHAR(255) | Actual value that caused the validation failure |
| expected_format | VARCHAR(255) | Expected format or value range for the failed validation |
| resolution_status | VARCHAR(50) | Current status of error resolution (OPEN, IN_PROGRESS, RESOLVED, IGNORED) |
| resolution_timestamp | TIMESTAMP | Timestamp when error was resolved or addressed |
| processed_by | VARCHAR(100) | Identifier of process or user that detected the error |

### 2.2 Si_Validation_Rules_Log
**Description:** Tracking of validation rule execution and results for Silver layer data processing

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| validation_timestamp | TIMESTAMP | Timestamp when validation rule was executed |
| rule_name | VARCHAR(100) | Name or identifier of the validation rule applied |
| target_table | VARCHAR(100) | Silver layer table targeted by the validation rule |
| target_column | VARCHAR(100) | Specific column targeted by the validation rule |
| rule_description | VARCHAR(500) | Description of the validation logic and criteria |
| records_processed | INTEGER | Total number of records processed by the validation rule |
| records_passed | INTEGER | Number of records that successfully passed validation |
| records_failed | INTEGER | Number of records that failed validation |
| pass_rate_percentage | DECIMAL(5,2) | Percentage of records that passed validation |
| rule_execution_time | DECIMAL(10,3) | Time taken to execute validation rule in seconds |
| rule_status | VARCHAR(20) | Execution status of validation rule (SUCCESS, FAILED, PARTIAL) |

## 3. Pipeline Audit and Process Tracking Structure

### 3.1 Si_Pipeline_Audit_Log
**Description:** Comprehensive audit trail for all Silver layer pipeline execution and data processing activities

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| pipeline_run_id | VARCHAR(100) | Unique identifier for each pipeline execution instance |
| pipeline_name | VARCHAR(100) | Name of the data pipeline or process executed |
| execution_start_time | TIMESTAMP | Timestamp when pipeline execution began |
| execution_end_time | TIMESTAMP | Timestamp when pipeline execution completed |
| execution_duration | DECIMAL(10,3) | Total time taken for pipeline execution in seconds |
| pipeline_status | VARCHAR(20) | Final status of pipeline execution (SUCCESS, FAILED, PARTIAL, CANCELLED) |
| source_table | VARCHAR(100) | Bronze layer table used as source for processing |
| target_table | VARCHAR(100) | Silver layer table created or updated by pipeline |
| records_read | INTEGER | Total number of records read from source |
| records_processed | INTEGER | Number of records successfully processed |
| records_inserted | INTEGER | Number of new records inserted into Silver layer |
| records_updated | INTEGER | Number of existing records updated in Silver layer |
| records_rejected | INTEGER | Number of records rejected due to quality issues |
| error_count | INTEGER | Total number of errors encountered during processing |
| warning_count | INTEGER | Total number of warnings generated during processing |
| processed_by | VARCHAR(100) | Identifier of user, service, or system that executed pipeline |
| pipeline_version | VARCHAR(50) | Version of pipeline code or configuration used |
| configuration_parameters | VARCHAR(1000) | Key configuration parameters used in pipeline execution |

### 3.2 Si_Process_Performance_Metrics
**Description:** Performance metrics and monitoring data for Silver layer processing optimization

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| metric_timestamp | TIMESTAMP | Timestamp when performance metric was captured |
| process_name | VARCHAR(100) | Name of the specific process or transformation |
| metric_type | VARCHAR(50) | Type of performance metric (THROUGHPUT, LATENCY, RESOURCE_USAGE) |
| metric_value | DECIMAL(15,4) | Numerical value of the performance metric |
| metric_unit | VARCHAR(20) | Unit of measurement for the metric (SECONDS, RECORDS_PER_SECOND, MB) |
| table_name | VARCHAR(100) | Silver layer table associated with the performance metric |
| record_count | INTEGER | Number of records processed when metric was captured |
| cpu_usage_percentage | DECIMAL(5,2) | CPU utilization percentage during process execution |
| memory_usage_mb | DECIMAL(10,2) | Memory consumption in megabytes during processing |
| io_operations | INTEGER | Number of input/output operations performed |
| network_usage_mb | DECIMAL(10,2) | Network bandwidth usage in megabytes |
| optimization_recommendations | VARCHAR(500) | System-generated recommendations for performance improvement |

## 4. Conceptual Data Model Diagram in Tabular Form

| Source Entity | Target Entity | Relationship Key Field | Relationship Type |
|---------------|---------------|----------------------|-------------------|
| Si_Products | Si_Inventory | Product Reference | One-to-Many |
| Si_Products | Si_Order_Details | Product Reference | One-to-Many |
| Si_Products | Si_Stock_Levels | Product Reference | One-to-Many |
| Si_Warehouses | Si_Inventory | Warehouse Reference | One-to-Many |
| Si_Warehouses | Si_Stock_Levels | Warehouse Reference | One-to-Many |
| Si_Orders | Si_Order_Details | Order Reference | One-to-Many |
| Si_Orders | Si_Shipments | Order Reference | One-to-One |
| Si_Orders | Si_Returns | Order Reference | One-to-One |
| Si_Customers | Si_Orders | Customer Reference | One-to-Many |
| Si_Suppliers | Si_Products | Product Reference | One-to-Many |
| Si_Data_Quality_Errors | All Si_Tables | Table Reference | Monitoring |
| Si_Validation_Rules_Log | All Si_Tables | Table Reference | Monitoring |
| Si_Pipeline_Audit_Log | All Si_Tables | Table Reference | Audit |
| Si_Process_Performance_Metrics | All Si_Tables | Table Reference | Performance |

## 5. apiCost

**Cost consumed by the API for this call (in USD):** 0.20