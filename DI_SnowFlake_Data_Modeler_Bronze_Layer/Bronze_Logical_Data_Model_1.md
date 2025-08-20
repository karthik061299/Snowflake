_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Bronze Layer Logical Data Model for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Bronze Layer Logical Data Model - Inventory Management System

## 1. PII Classification

### Identified PII Fields
| Column Name | Table | Reason for PII Classification |
|-------------|-------|-------------------------------|
| Customer_Name | Bz_Customers | Personal identifier that can directly identify an individual customer |
| Email | Bz_Customers | Personal contact information that uniquely identifies an individual and is considered direct PII |
| Contact_Number | Bz_Suppliers | Personal contact information that can identify an individual supplier representative |
| Return_Reason | Bz_Returns | May contain personal information about customer behavior, preferences, or personal circumstances |

## 2. Bronze Layer Logical Model

### Bz_Products
**Description:** Raw product master data preserving original product information from source systems

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Product_Name | VARCHAR(255) | Commercial name or title of the product as known in the market |
| Category | VARCHAR(100) | Product classification grouping for organizational and reporting purposes |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### Bz_Suppliers
**Description:** Raw supplier information with contact details and business relationships

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Supplier_Name | VARCHAR(255) | Official business name of the supplier organization |
| Contact_Number | VARCHAR(20) | Primary telephone number for supplier communication and coordination |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### Bz_Warehouses
**Description:** Raw warehouse master data including location and capacity specifications

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Location | VARCHAR(255) | Geographic address or identifier of the warehouse facility |
| Capacity | INTEGER | Maximum storage capacity or volume that the warehouse can accommodate |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### Bz_Inventory
**Description:** Raw inventory levels data showing current stock positions by warehouse location

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Available | INTEGER | Current stock count of products available for sale or distribution |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### Bz_Orders
**Description:** Raw order header information capturing customer purchase requests and timing

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Order_Date | DATE | Date when the customer order was placed or received |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### Bz_Order_Details
**Description:** Raw order line item details with product quantities and specifications

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Ordered | INTEGER | Number of units of a specific product requested in the order |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### Bz_Shipments
**Description:** Raw shipment tracking data with delivery information and dispatch records

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Shipment_Date | DATE | Date when the order was dispatched or sent to the customer |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### Bz_Returns
**Description:** Raw return transaction data with customer feedback and quality information

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Return_Reason | VARCHAR(255) | Explanation or category describing why the product was returned by the customer |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### Bz_Stock_Levels
**Description:** Raw stock level thresholds and reorder point configurations for inventory management

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Reorder_Threshold | INTEGER | Minimum inventory level that triggers replenishment or reorder processes |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### Bz_Customers
**Description:** Raw customer master data containing contact information and relationship details

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Customer_Name | VARCHAR(255) | Full name or business name of the customer |
| Email | VARCHAR(255) | Primary email address for customer communication and correspondence |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

## 3. Audit Table Design

### Bz_Audit_Log
**Description:** Comprehensive audit trail for all Bronze layer data processing activities

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| record_id | BIGINT | Unique identifier for audit record |
| source_table | VARCHAR(100) | Name of the source table being processed |
| load_timestamp | TIMESTAMP | Timestamp when the data load operation occurred |
| processed_by | VARCHAR(100) | Identifier of the process or user that performed the operation |
| processing_time | DECIMAL(10,3) | Time taken to process the operation in seconds |
| status | VARCHAR(20) | Status of the processing operation (SUCCESS, FAILED, WARNING) |

## 4. Conceptual Data Model Diagram in Tabular Form

| Source Entity | Target Entity | Relationship Key Field | Relationship Type |
|---------------|---------------|----------------------|-------------------|
| Bz_Products | Bz_Suppliers | Product Reference | One-to-Many |
| Bz_Products | Bz_Inventory | Product Reference | One-to-Many |
| Bz_Products | Bz_Order_Details | Product Reference | One-to-Many |
| Bz_Products | Bz_Stock_Levels | Product Reference | One-to-Many |
| Bz_Warehouses | Bz_Inventory | Warehouse Reference | One-to-Many |
| Bz_Warehouses | Bz_Stock_Levels | Warehouse Reference | One-to-Many |
| Bz_Orders | Bz_Order_Details | Order Reference | One-to-Many |
| Bz_Orders | Bz_Shipments | Order Reference | One-to-One |
| Bz_Orders | Bz_Returns | Order Reference | One-to-One |
| Bz_Customers | Bz_Orders | Customer Reference | One-to-Many |

## 5. API Cost

- **apiCost:** 0.150000 (cost consumed in USD, up to six decimal places)