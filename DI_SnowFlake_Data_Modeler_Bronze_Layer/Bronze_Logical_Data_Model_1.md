_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Bronze Layer Logical Data Model for Inventory Management System following Medallion Architecture principles
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# BRONZE LAYER LOGICAL DATA MODEL - INVENTORY MANAGEMENT SYSTEM

## 1. PII Classification

### 1.1 Identified PII Fields

| Column Name | Table | PII Classification | Reason |
|-------------|-------|-------------------|--------|
| Customer_Name | Bz_Customers | Direct PII | Personal identifier that can directly identify an individual customer |
| Email | Bz_Customers | Direct PII | Personal contact information that uniquely identifies an individual and is considered sensitive personal data |
| Contact_Number | Bz_Suppliers | Indirect PII | Business contact information that may indirectly identify individuals within supplier organizations |

### 1.2 PII Handling Recommendations
- Implement data masking for non-production environments
- Apply encryption at rest and in transit for all PII fields
- Establish data retention policies compliant with GDPR and other regulations
- Implement role-based access controls and comprehensive audit logging

## 2. Bronze Layer Logical Model

### 2.1 Design Principles
- Mirror source data structure exactly (excluding primary key and foreign key fields)
- Add 'Bz_' prefix to all table names for consistent naming convention
- Include standard metadata columns for data lineage and audit purposes
- Maintain data in raw format for maximum flexibility and future processing

### 2.2 Bronze Layer Tables

#### 2.2.1 Bz_Products
**Table Description**: Raw product catalog data from source systems containing product identification and categorization information

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| Product_Name | VARCHAR(255) | Commercial name or title of the product as known in the market | No |
| Category | VARCHAR(100) | Product classification grouping for organizational and reporting purposes | No |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer | No |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated | No |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking | No |

#### 2.2.2 Bz_Suppliers
**Table Description**: Raw supplier master data containing vendor information and contact details

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| Supplier_Name | VARCHAR(255) | Official business name of the supplier organization | No |
| Contact_Number | VARCHAR(20) | Primary telephone number for supplier communication and coordination | No |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer | No |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated | No |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking | No |

#### 2.2.3 Bz_Warehouses
**Table Description**: Raw warehouse facility data containing location and capacity information

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| Location | VARCHAR(255) | Geographic address or identifier of the warehouse facility | No |
| Capacity | INTEGER | Maximum storage capacity or volume that the warehouse can accommodate | No |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer | No |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated | No |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking | No |

#### 2.2.4 Bz_Inventory
**Table Description**: Raw inventory stock level data showing current product availability

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| Quantity_Available | INTEGER | Current stock count of products available for sale or distribution | No |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer | No |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated | No |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking | No |

#### 2.2.5 Bz_Orders
**Table Description**: Raw customer order data capturing order timing and transaction information

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| Order_Date | DATE | Date when the customer order was placed or received | No |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer | No |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated | No |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking | No |

#### 2.2.6 Bz_Order_Details
**Table Description**: Raw order line item data detailing specific products and quantities in customer orders

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| Quantity_Ordered | INTEGER | Number of units of a specific product requested in the order | No |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer | No |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated | No |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking | No |

#### 2.2.7 Bz_Shipments
**Table Description**: Raw shipment data tracking when orders are dispatched to customers

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| Shipment_Date | DATE | Date when the order was dispatched or sent to the customer | No |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer | No |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated | No |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking | No |

#### 2.2.8 Bz_Returns
**Table Description**: Raw customer return transaction data with return reasons and quality feedback

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| Return_Reason | VARCHAR(255) | Explanation or category describing why the product was returned by the customer | No |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer | No |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated | No |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking | No |

#### 2.2.9 Bz_Stock_Levels
**Table Description**: Raw inventory management threshold data for maintaining optimal stock levels

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| Reorder_Threshold | INTEGER | Minimum inventory level that triggers replenishment or reorder processes | No |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer | No |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated | No |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking | No |

#### 2.2.10 Bz_Customers
**Table Description**: Raw customer master data containing contact information and relationship details

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| Customer_Name | VARCHAR(255) | Full name or business name of the customer | No |
| Email | VARCHAR(255) | Primary email address for customer communication and correspondence | No |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer | No |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated | No |
| source_system | VARCHAR(50) | Source system identifier for data lineage tracking | No |

## 3. Audit Table Design

### 3.1 Bronze_Audit_Log
**Table Description**: Comprehensive audit trail for all Bronze layer data processing operations

| Column Name | Data Type | Description | Nullable |
|-------------|-----------|-------------|----------|
| record_id | BIGINT | Unique identifier for audit record (Auto-increment) | No |
| source_table | VARCHAR(100) | Name of the source table being audited | No |
| load_timestamp | TIMESTAMP | Timestamp when the data load operation occurred | No |
| processed_by | VARCHAR(100) | System or user that processed the data | No |
| processing_time | DECIMAL(10,3) | Time taken to process the data (in seconds) | Yes |
| status | VARCHAR(20) | Status of the data load (SUCCESS, FAILED, PARTIAL) | No |

### 3.2 Audit Table Constraints and Indexes
1. **Primary Key**: record_id
2. **Check Constraint**: status IN ('SUCCESS', 'FAILED', 'PARTIAL')
3. **Indexes**: 
   - source_table for filtering by table
   - load_timestamp for temporal queries
   - status for monitoring failed loads

## 4. Conceptual Data Model Diagram

### 4.1 Entity Relationships in Tabular Form

| Source Entity | Target Entity | Relationship Key Field | Relationship Type | Bronze Table Connection |
|---------------|---------------|----------------------|-------------------|------------------------|
| Products | Suppliers | Product Reference | One-to-Many | Bz_Products ↔ Bz_Suppliers |
| Products | Inventory | Product Reference | One-to-Many | Bz_Products ↔ Bz_Inventory |
| Products | Order_Details | Product Reference | One-to-Many | Bz_Products ↔ Bz_Order_Details |
| Products | Stock_Levels | Product Reference | One-to-Many | Bz_Products ↔ Bz_Stock_Levels |
| Warehouses | Inventory | Warehouse Reference | One-to-Many | Bz_Warehouses ↔ Bz_Inventory |
| Warehouses | Stock_Levels | Warehouse Reference | One-to-Many | Bz_Warehouses ↔ Bz_Stock_Levels |
| Orders | Order_Details | Order Reference | One-to-Many | Bz_Orders ↔ Bz_Order_Details |
| Orders | Shipments | Order Reference | One-to-One | Bz_Orders ↔ Bz_Shipments |
| Orders | Returns | Order Reference | One-to-One | Bz_Orders ↔ Bz_Returns |
| Customers | Orders | Customer Reference | One-to-Many | Bz_Customers ↔ Bz_Orders |

### 4.2 Data Flow Architecture
```
Source Systems → Bronze Layer (Raw Data) → Silver Layer (Cleaned) → Gold Layer (Aggregated)
     ↓               ↓                        ↓                      ↓
  OLTP/Files    Bz_* Tables              Curated Data         Business Metrics
```

## 5. Implementation Guidelines

### 5.1 Data Loading Strategy
1. **Incremental Loading**: Implement Change Data Capture (CDC) where possible
2. **Full Refresh**: For small dimension tables like warehouses and suppliers
3. **Batch Processing**: Schedule regular data loads based on business requirements
4. **Error Handling**: Implement robust error handling and comprehensive logging

### 5.2 Data Quality Checks
1. **Schema Validation**: Ensure incoming data matches expected schema structure
2. **Null Checks**: Validate that required fields are not null
3. **Data Type Validation**: Ensure data types match expectations
4. **Duplicate Detection**: Identify and handle duplicate records appropriately

### 5.3 Monitoring and Alerting
1. **Load Monitoring**: Track data load success/failure rates
2. **Data Volume Monitoring**: Monitor unexpected changes in data volume
3. **Latency Monitoring**: Track data freshness and processing times
4. **Quality Metrics**: Monitor data quality scores over time

## 6. apiCost

0.180000