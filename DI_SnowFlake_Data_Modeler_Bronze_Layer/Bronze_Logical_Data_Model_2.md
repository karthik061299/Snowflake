_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Bronze Layer Logical Data Model for Inventory Management System
## *Version*: 2 
## *Changes*: Added visual connections between tables in Conceptual Data Model Diagram
## *Reason*: Enhanced diagram readability by showing relationships with visual connections and arrows instead of text-only format
## *Updated on*: 
_____________________________________________

# Bronze Layer Logical Data Model - Inventory Management System

## 1. PII Classification

### 1.1 PII Fields Identified

1. **Bz_Suppliers.Contact_Number**
   - **Reason:** Contains personal contact information that could be used to identify or contact individuals

2. **Bz_Customers.Customer_Name**
   - **Reason:** Contains personally identifiable information (full name) that can be used to identify specific individuals

3. **Bz_Customers.Email**
   - **Reason:** Contains personally identifiable information (email address) that can be used to identify and contact specific individuals

### 1.2 Non-PII Fields

All other fields are classified as Non-PII as they contain business operational data, metadata, or system-generated information that cannot be used to identify specific individuals.

## 2. Bronze Layer Logical Model

### 2.1 Bz_Products

**Table Description:** Contains raw product information including product names and categories from the source system.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Product_Name | VARCHAR(255) | Name of the product |
| Category | VARCHAR(100) | Product category classification |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### 2.2 Bz_Suppliers

**Table Description:** Contains raw supplier information including supplier names and contact details from the source system.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Supplier_Name | VARCHAR(255) | Name of the supplier company |
| Contact_Number | VARCHAR(20) | Supplier contact phone number |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### 2.3 Bz_Warehouses

**Table Description:** Contains raw warehouse information including location and capacity details from the source system.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Location | VARCHAR(255) | Physical location of the warehouse |
| Capacity | INTEGER | Storage capacity of the warehouse |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### 2.4 Bz_Inventory

**Table Description:** Contains raw inventory data showing available quantities from the source system.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Available | INTEGER | Current available quantity in inventory |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### 2.5 Bz_Orders

**Table Description:** Contains raw order information including order dates from the source system.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Order_Date | DATE | Date when the order was placed |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### 2.6 Bz_Order_Details

**Table Description:** Contains raw order detail information including quantities ordered from the source system.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Ordered | INTEGER | Quantity of items ordered |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### 2.7 Bz_Shipments

**Table Description:** Contains raw shipment information including shipment dates from the source system.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Shipment_Date | DATE | Date when the shipment was sent |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### 2.8 Bz_Returns

**Table Description:** Contains raw return information including return reasons from the source system.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Return_Reason | VARCHAR(500) | Reason for product return |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### 2.9 Bz_Stock_Levels

**Table Description:** Contains raw stock level information including reorder thresholds from the source system.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Reorder_Threshold | INTEGER | Minimum stock level before reordering |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

### 2.10 Bz_Customers

**Table Description:** Contains raw customer information including customer names and email addresses from the source system.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Customer_Name | VARCHAR(255) | Full name of the customer |
| Email | VARCHAR(255) | Customer email address |
| load_timestamp | TIMESTAMP | Timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | Timestamp when record was last updated |
| source_system | VARCHAR(50) | Source system identifier |

## 3. Audit Table Design

### 3.1 Bz_Audit_Log

**Table Description:** Tracks all data processing activities and provides audit trail for Bronze layer operations.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| record_id | VARCHAR(50) | Unique identifier for the audit record |
| source_table | VARCHAR(100) | Name of the source table being processed |
| load_timestamp | TIMESTAMP | Timestamp when the data load operation occurred |
| processed_by | VARCHAR(100) | System or user that processed the data |
| processing_time | DECIMAL(10,3) | Time taken to process the data (in seconds) |
| status | VARCHAR(20) | Status of the processing (SUCCESS, FAILED, PARTIAL) |

## 4. Conceptual Data Model Diagram

```
                    Bz_Customers
                   ┌─────────────────┐
                   │ Customer_Name   │
                   │ Email           │
                   │ load_timestamp  │
                   │ update_timestamp│
                   │ source_system   │
                   └─────────────────┘
                            │
                            │ Customer_Name
                            ▼
    Bz_Suppliers           Bz_Orders
   ┌─────────────────┐    ┌─────────────────┐
   │ Supplier_Name   │    │ Order_Date      │
   │ Contact_Number  │    │ load_timestamp  │
   │ load_timestamp  │    │ update_timestamp│
   │ update_timestamp│    │ source_system   │
   │ source_system   │    └─────────────────┘
   └─────────────────┘             │
            ▲                       │ Order_Date
            │ Product_Name          ├─────────────────┐
            │                       ▼                 ▼
    Bz_Products              Bz_Order_Details    Bz_Shipments
   ┌─────────────────┐      ┌─────────────────┐ ┌─────────────────┐
   │ Product_Name    │◄─────│ Quantity_Ordered│ │ Shipment_Date   │
   │ Category        │      │ load_timestamp  │ │ load_timestamp  │
   │ load_timestamp  │      │ update_timestamp│ │ update_timestamp│
   │ update_timestamp│      │ source_system   │ │ source_system   │
   │ source_system   │      └─────────────────┘ └─────────────────┘
   └─────────────────┘               │
            │                        │ Order_Date
            │ Product_Name           ▼
            ├─────────────────► Bz_Returns
            │                  ┌─────────────────┐
            │                  │ Return_Reason   │
            ▼                  │ load_timestamp  │
    Bz_Inventory               │ update_timestamp│
   ┌─────────────────┐         │ source_system   │
   │Quantity_Available│         └─────────────────┘
   │ load_timestamp  │
   │ update_timestamp│
   │ source_system   │
   └─────────────────┘
            ▲
            │ Location
            │
    Bz_Warehouses              Bz_Stock_Levels
   ┌─────────────────┐         ┌─────────────────┐
   │ Location        │────────►│Reorder_Threshold│
   │ Capacity        │         │ load_timestamp  │
   │ load_timestamp  │         │ update_timestamp│
   │ update_timestamp│         │ source_system   │
   │ source_system   │         └─────────────────┘
   └─────────────────┘                  ▲
                                        │ Product_Name
                                        │
                               ─────────┘
```

**Visual Connection Legend:**
- ▼ : Connects to (one-to-many relationship)
- ◄─ : Connected by (foreign key relationship)
- ──► : Direct connection

**Relationship Connections with Key Fields:**
1. **Bz_Customers** ──► **Bz_Orders** (via Customer_Name field)
2. **Bz_Orders** ──► **Bz_Order_Details** (via Order_Date field)
3. **Bz_Orders** ──► **Bz_Shipments** (via Order_Date field)
4. **Bz_Orders** ──► **Bz_Returns** (via Order_Date field)
5. **Bz_Products** ──► **Bz_Suppliers** (via Product_Name field)
6. **Bz_Products** ──► **Bz_Order_Details** (via Product_Name field)
7. **Bz_Products** ──► **Bz_Inventory** (via Product_Name field)
8. **Bz_Products** ──► **Bz_Stock_Levels** (via Product_Name field)
9. **Bz_Warehouses** ──► **Bz_Inventory** (via Location field)
10. **Bz_Warehouses** ──► **Bz_Stock_Levels** (via Location field)

## 5. API Cost

- **apiCost:** 0.175000