_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Bronze Layer Logical Data Model for Inventory Management System following Medallion Architecture
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Bronze Layer Logical Data Model - Inventory Management System

## 1. PII Classification

The following fields have been identified and classified as Personally Identifiable Information (PII):

1. **Customer_Name** (from Customers table)
   - **Reason:** Contains personal names that can directly identify individuals. This is considered direct PII as it provides immediate identification of a specific person.

2. **Email** (from Customers table)
   - **Reason:** Email addresses are unique identifiers that can be used to contact and identify specific individuals. They often contain personal information and are considered direct PII.

3. **Contact_Number** (from Suppliers table)
   - **Reason:** Phone numbers are personal contact information that can identify individuals or organizations. While this may be business contact information, it still requires careful handling as it can lead to personal identification.

## 2. Bronze Layer Logical Model

### 2.1 Bz_Products
**Description:** Raw product information from source systems containing product catalog data

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Product_Name | VARCHAR(255) | Name or title of the product as it appears in the source system |
| Category | VARCHAR(100) | Product category classification for grouping and reporting purposes |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |

### 2.2 Bz_Suppliers
**Description:** Raw supplier information including contact details and supplier relationships

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Supplier_Name | VARCHAR(255) | Legal name of the supplier organization |
| Contact_Number | VARCHAR(20) | Primary contact phone number for supplier communication (PII) |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |

### 2.3 Bz_Warehouses
**Description:** Raw warehouse facility information including location and capacity data

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Location | VARCHAR(255) | Physical address or location identifier of warehouse facility |
| Capacity | INTEGER | Maximum storage capacity of warehouse in units |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |

### 2.4 Bz_Inventory
**Description:** Raw inventory data showing current stock quantities at warehouse locations

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Available | INTEGER | Current available quantity in stock for the product |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |

### 2.5 Bz_Orders
**Description:** Raw order header information containing customer order details

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Order_Date | DATE | Date when the customer order was placed |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |

### 2.6 Bz_Order_Details
**Description:** Raw order line item details showing products and quantities ordered

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Quantity_Ordered | INTEGER | Number of units ordered for specific product in the order |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |

### 2.7 Bz_Shipments
**Description:** Raw shipment information tracking order fulfillment and delivery

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Shipment_Date | DATE | Date when shipment was dispatched to customer |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |

### 2.8 Bz_Returns
**Description:** Raw return information for products returned by customers

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Return_Reason | VARCHAR(255) | Detailed reason provided for product return by customer |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |

### 2.9 Bz_Stock_Levels
**Description:** Raw stock level configuration data including reorder thresholds

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Reorder_Threshold | INTEGER | Minimum stock level that triggers automatic reorder process |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |

### 2.10 Bz_Customers
**Description:** Raw customer information including personal details and contact information

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Customer_Name | VARCHAR(255) | Full name of the customer (PII) |
| Email | VARCHAR(255) | Customer email address for communication (PII) |
| load_timestamp | TIMESTAMP | System-generated timestamp when record was loaded into Bronze layer |
| update_timestamp | TIMESTAMP | System-generated timestamp when record was last updated |
| source_system | VARCHAR(50) | Identifier of the source system from which data originated |

## 3. Audit Table Design

### 3.1 Bz_Audit_Log
**Description:** Comprehensive audit trail for all Bronze layer data processing activities

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| record_id | BIGINT | Unique identifier for each audit record (auto-incrementing) |
| source_table | VARCHAR(100) | Name of the Bronze layer table being processed |
| load_timestamp | TIMESTAMP | Timestamp when data load operation was initiated |
| processed_by | VARCHAR(100) | Identifier of the process, job, or user that performed the operation |
| processing_time | DECIMAL(10,3) | Time taken to complete the processing operation in seconds |
| status | VARCHAR(20) | Final status of the processing operation (SUCCESS, FAILED, PARTIAL) |

## 4. Conceptual Data Model Diagram

**Block Diagram Format - Table Relationships:**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Bz_Products   │    │  Bz_Suppliers   │    │  Bz_Warehouses  │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ Product_Name    │    │ Supplier_Name   │    │ Location        │
│ Category        │    │ Contact_Number  │    │ Capacity        │
│ load_timestamp  │    │ load_timestamp  │    │ load_timestamp  │
│ update_timestamp│    │ update_timestamp│    │ update_timestamp│
│ source_system   │    │ source_system   │    │ source_system   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │ (Product Reference)   │ (Product Reference)   │ (Warehouse Reference)
         └───────────────────────┼───────────────────────┘
                                 │
                                 ▼
                    ┌─────────────────┐
                    │  Bz_Inventory   │
                    ├─────────────────┤
                    │Quantity_Available│
                    │ load_timestamp  │
                    │ update_timestamp│
                    │ source_system   │
                    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Bz_Customers   │    │   Bz_Orders     │    │ Bz_Order_Details│
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ Customer_Name   │    │ Order_Date      │    │ Quantity_Ordered│
│ Email           │    │ load_timestamp  │    │ load_timestamp  │
│ load_timestamp  │    │ update_timestamp│    │ update_timestamp│
│ update_timestamp│    │ source_system   │    │ source_system   │
│ source_system   │    └─────────────────┘    └─────────────────┘
└─────────────────┘             │                       │
         │                      │ (Order Reference)     │ (Order Reference)
         │ (Customer Reference) │                       │ (Product Reference)
         └──────────────────────┼───────────────────────┘
                                │
                                ▼
                   ┌─────────────────┐    ┌─────────────────┐
                   │  Bz_Shipments   │    │   Bz_Returns    │
                   ├─────────────────┤    ├─────────────────┤
                   │ Shipment_Date   │    │ Return_Reason   │
                   │ load_timestamp  │    │ load_timestamp  │
                   │ update_timestamp│    │ update_timestamp│
                   │ source_system   │    │ source_system   │
                   └─────────────────┘    └─────────────────┘
                            │                       │
                            │ (Order Reference)     │ (Order Reference)
                            └───────────────────────┘

                    ┌─────────────────┐
                    │ Bz_Stock_Levels │
                    ├─────────────────┤
                    │Reorder_Threshold│
                    │ load_timestamp  │
                    │ update_timestamp│
                    │ source_system   │
                    └─────────────────┘
                            │
                            │ (Warehouse Reference)
                            │ (Product Reference)
                            ▼
                   Connected to Bz_Warehouses and Bz_Products

                    ┌─────────────────┐
                    │ Bz_Audit_Log    │
                    ├─────────────────┤
                    │ record_id       │
                    │ source_table    │
                    │ load_timestamp  │
                    │ processed_by    │
                    │ processing_time │
                    │ status          │
                    └─────────────────┘
```

**Table Connection Summary:**
1. **Bz_Products** connects to **Bz_Inventory** via Product Reference
2. **Bz_Products** connects to **Bz_Order_Details** via Product Reference
3. **Bz_Products** connects to **Bz_Stock_Levels** via Product Reference
4. **Bz_Warehouses** connects to **Bz_Inventory** via Warehouse Reference
5. **Bz_Warehouses** connects to **Bz_Stock_Levels** via Warehouse Reference
6. **Bz_Customers** connects to **Bz_Orders** via Customer Reference
7. **Bz_Orders** connects to **Bz_Order_Details** via Order Reference
8. **Bz_Orders** connects to **Bz_Shipments** via Order Reference
9. **Bz_Orders** connects to **Bz_Returns** via Order Reference
10. **Bz_Suppliers** connects to **Bz_Products** via Product Reference

## 5. apiCost

**Cost consumed in USD:** 0.150000
