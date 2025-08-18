_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Conceptual data model for Inventory Management System reporting requirements
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# CONCEPTUAL DATA MODEL FOR INVENTORY MANAGEMENT SYSTEM

## 1. Domain Overview

The Inventory Management System encompasses the complete lifecycle of inventory operations including product management, supplier relationships, warehouse operations, order processing, shipment tracking, returns management, and stock level monitoring. This system supports critical business functions such as inventory optimization, supplier management, order fulfillment, and warehouse capacity planning across multiple locations.

## 2. List of Entity Name with Description

1. **Products** - Core product catalog containing all items managed within the inventory system
2. **Suppliers** - External vendors and suppliers who provide products to the organization
3. **Warehouses** - Physical storage locations where inventory is maintained
4. **Inventory** - Current stock levels and availability of products across warehouses
5. **Orders** - Customer purchase requests and order transactions
6. **Order_Details** - Detailed line items for each order specifying products and quantities
7. **Shipments** - Outbound delivery records for fulfilled orders
8. **Returns** - Product returns from customers with associated reasons
9. **Stock_Levels** - Reorder thresholds and stock management parameters
10. **Customers** - Customer information and contact details

## 3. List of Attributes for each Entity with Description

### Products Entity
- **Product Name** - Commercial name or title of the product
- **Category** - Product classification or grouping for organizational purposes

### Suppliers Entity
- **Supplier Name** - Official business name of the supplier organization
- **Contact Number** - Primary telephone number for supplier communication

### Warehouses Entity
- **Location** - Physical address or geographic location of the warehouse
- **Capacity** - Maximum storage capacity of the warehouse facility

### Inventory Entity
- **Quantity Available** - Current stock quantity available for sale or distribution

### Orders Entity
- **Order Date** - Date when the customer order was placed

### Order_Details Entity
- **Quantity Ordered** - Number of units requested for a specific product in an order

### Shipments Entity
- **Shipment Date** - Date when the order was shipped to the customer

### Returns Entity
- **Return Reason** - Explanation or cause for the product return

### Stock_Levels Entity
- **Reorder Threshold** - Minimum inventory level that triggers replenishment action

### Customers Entity
- **Customer Name** - Full name of the customer
- **Email** - Customer's email address for communication

## 4. KPI List

1. **Current Inventory Quantity** - Total available stock by product and warehouse
2. **Products Below Reorder Threshold** - Count and percentage of products requiring replenishment
3. **Inventory Distribution by Category** - Stock allocation across product categories
4. **Warehouse Capacity Utilization** - Percentage of warehouse space currently occupied
5. **Stock Status Distribution** - Classification of products as above or below threshold
6. **Critical Stock Alerts** - Items at or near zero inventory levels
7. **Supplier Product Count** - Number of products supplied by each vendor
8. **Single-Source Product Identification** - Products available from only one supplier
9. **Order-to-Inventory Ratio** - Relationship between demand and available stock
10. **Product Demand Ranking** - Products ranked by total order quantities
11. **Order Frequency by Product** - How often each product is ordered
12. **Stockout Risk Indicators** - Products at risk of running out of stock
13. **Warehouse Product Diversity** - Variety of products stored in each warehouse
14. **Return Rate by Product** - Percentage of orders returned for each product
15. **Return Reason Distribution** - Categorization of why products are returned
16. **Customer Return Patterns** - Frequency of returns by customer

## 5. Conceptual Data Model Diagram in Tabular Form

| Source Entity | Target Entity | Relationship Key Field | Relationship Type |
|---------------|---------------|----------------------|-------------------|
| Products | Suppliers | Product Reference | One-to-Many |
| Products | Inventory | Product Reference | One-to-Many |
| Products | Order_Details | Product Reference | One-to-Many |
| Products | Stock_Levels | Product Reference | One-to-Many |
| Warehouses | Inventory | Warehouse Reference | One-to-Many |
| Warehouses | Stock_Levels | Warehouse Reference | One-to-Many |
| Orders | Order_Details | Order Reference | One-to-Many |
| Orders | Shipments | Order Reference | One-to-One |
| Orders | Returns | Order Reference | One-to-One |
| Customers | Orders | Customer Reference | One-to-Many |

## 6. Common Data Elements in Report Requirements

1. **Product Reference Fields** - Used across Suppliers, Inventory, Order_Details, and Stock_Levels entities
2. **Warehouse Reference Fields** - Shared between Inventory and Stock_Levels entities
3. **Order Reference Fields** - Common across Order_Details, Shipments, and Returns entities
4. **Customer Reference Fields** - Links Orders to Customers entity
5. **Product Name** - Referenced in multiple reports for product identification
6. **Product Category** - Used for grouping and analysis across various reports
7. **Warehouse Location** - Referenced for geographic and operational analysis
8. **Quantity Fields** - Various quantity measurements used across inventory and order entities
9. **Date Fields** - Order dates and shipment dates used for temporal analysis
10. **Threshold Values** - Reorder thresholds used for inventory management calculations

## 7. API Cost Calculation

– Cost for this Call: $0.15