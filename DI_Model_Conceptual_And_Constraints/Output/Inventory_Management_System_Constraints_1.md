____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Model Data Constraints for Inventory Management System reporting requirements
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# MODEL DATA CONSTRAINTS FOR INVENTORY MANAGEMENT SYSTEM

## 1. Data Expectations

### 1.1 Data Completeness Expectations
1. **Products Table**: All products must have complete Product_Name and Category information
2. **Suppliers Table**: All suppliers must have Supplier_Name and valid Contact_Number
3. **Warehouses Table**: All warehouses must have Location and Capacity specified
4. **Inventory Table**: All inventory records must have valid Quantity_Available values
5. **Orders Table**: All orders must have valid Order_Date
6. **Order_Details Table**: All order details must have Quantity_Ordered greater than zero
7. **Shipments Table**: All shipments must have valid Shipment_Date
8. **Returns Table**: All returns must have valid Return_Reason
9. **Stock_Levels Table**: All stock levels must have Reorder_Threshold defined
10. **Customers Table**: All customers must have Customer_Name and Email

### 1.2 Data Accuracy Expectations
1. **Quantity Fields**: All quantity values must be non-negative integers
2. **Date Fields**: All dates must be valid and within reasonable business periods
3. **Contact Information**: Contact_Number must follow consistent format patterns
4. **Email Addresses**: Customer emails must be in valid email format
5. **Capacity Values**: Warehouse capacity must be positive numbers
6. **Threshold Values**: Reorder thresholds must be positive integers
7. **Category Values**: Product categories must be from predefined list
8. **Return Reasons**: Must be from predefined values (Damaged, Defective, Wrong Item)
9. **Location Data**: Warehouse locations must be accurate and current
10. **Product Names**: Must be unique and descriptive

### 1.3 Data Format Expectations
1. **Primary Keys**: All primary keys must be unique, non-null integers
2. **Foreign Keys**: All foreign key references must exist in parent tables
3. **Text Fields**: Product names, supplier names, and locations must be properly formatted
4. **Numeric Fields**: All numeric values must be within reasonable business ranges
5. **Date Format**: All dates must follow consistent format (YYYY-MM-DD)
6. **Boolean Indicators**: Stock status indicators must be clearly defined
7. **Percentage Values**: Calculated percentages must be between 0 and 100
8. **Contact Numbers**: Must follow standard phone number format
9. **Email Format**: Must contain @ symbol and valid domain
10. **Category Codes**: Must be standardized across the system

### 1.4 Data Consistency Expectations
1. **Cross-Table Consistency**: Product information must be consistent across all related tables
2. **Temporal Consistency**: Order dates must be before or equal to shipment dates
3. **Quantity Consistency**: Inventory quantities must align with order and return data
4. **Supplier Consistency**: Each product must have at least one associated supplier
5. **Warehouse Consistency**: Inventory totals must not exceed warehouse capacity
6. **Customer Consistency**: Customer information must be consistent across orders
7. **Category Consistency**: Product categories must be consistent across all references
8. **Threshold Consistency**: Reorder thresholds must be appropriate for each product type
9. **Return Consistency**: Returns must be associated with valid completed orders
10. **Location Consistency**: Warehouse locations must be unique and properly identified

## 2. Constraints

### 2.1 Mandatory Field Constraints
1. **Products.Product_ID**: Primary key, cannot be null, must be unique
2. **Products.Product_Name**: Cannot be null, must be unique
3. **Products.Category**: Cannot be null, must be from predefined list
4. **Suppliers.Supplier_ID**: Primary key, cannot be null, must be unique
5. **Suppliers.Supplier_Name**: Cannot be null
6. **Suppliers.Contact_Number**: Cannot be null, must be valid format
7. **Suppliers.Product_ID**: Foreign key, cannot be null, must exist in Products table
8. **Warehouses.Warehouse_ID**: Primary key, cannot be null, must be unique
9. **Warehouses.Location**: Cannot be null, must be unique
10. **Warehouses.Capacity**: Cannot be null, must be positive number
11. **Inventory.Inventory_ID**: Primary key, cannot be null, must be unique
12. **Inventory.Quantity_Available**: Cannot be null, must be non-negative integer
13. **Inventory.Product_ID**: Foreign key, cannot be null, must exist in Products table
14. **Inventory.Warehouse_ID**: Foreign key, cannot be null, must exist in Warehouses table
15. **Orders.Order_ID**: Primary key, cannot be null, must be unique
16. **Orders.Order_Date**: Cannot be null, must be valid date
17. **Orders.Customer_ID**: Foreign key, cannot be null, must exist in Customers table
18. **Order_Details.Order_Detail_ID**: Primary key, cannot be null, must be unique
19. **Order_Details.Quantity_Ordered**: Cannot be null, must be positive integer
20. **Order_Details.Order_ID**: Foreign key, cannot be null, must exist in Orders table
21. **Order_Details.Product_ID**: Foreign key, cannot be null, must exist in Products table
22. **Stock_Levels.Reorder_Threshold**: Cannot be null, must be positive integer

### 2.2 Uniqueness Constraints
1. **Products.Product_Name**: Must be unique across all products
2. **Suppliers.Supplier_Name**: Must be unique across all suppliers
3. **Warehouses.Location**: Must be unique across all warehouses
4. **Customers.Email**: Must be unique across all customers
5. **Inventory Combination**: Product_ID and Warehouse_ID combination must be unique
6. **Stock_Levels Combination**: Product_ID and Warehouse_ID combination must be unique
7. **Shipments.Order_ID**: Each order can have only one shipment record
8. **Returns.Order_ID**: Each order can have at most one return record
9. **Order_Details Combination**: Order_ID and Product_ID combination should be unique
10. **Primary Key Uniqueness**: All primary keys must be unique within their respective tables

### 2.3 Data Type Limitations
1. **Integer Fields**: Product_ID, Supplier_ID, Warehouse_ID, Order_ID must be integers
2. **Quantity Fields**: All quantity fields must be non-negative integers
3. **Date Fields**: Order_Date and Shipment_Date must be valid date format
4. **Text Fields**: Names and descriptions must be varchar with appropriate length limits
5. **Numeric Fields**: Capacity and threshold values must be numeric
6. **Boolean Fields**: Status indicators must be boolean or defined enumeration
7. **Email Fields**: Must conform to email format validation
8. **Phone Fields**: Contact numbers must conform to phone format validation
9. **Percentage Fields**: Calculated percentages must be decimal between 0 and 1
10. **Currency Fields**: If applicable, must be decimal with appropriate precision

### 2.4 Dependencies and Referential Integrity
1. **Suppliers → Products**: Suppliers.Product_ID must exist in Products.Product_ID
2. **Inventory → Products**: Inventory.Product_ID must exist in Products.Product_ID
3. **Inventory → Warehouses**: Inventory.Warehouse_ID must exist in Warehouses.Warehouse_ID
4. **Orders → Customers**: Orders.Customer_ID must exist in Customers.Customer_ID
5. **Order_Details → Orders**: Order_Details.Order_ID must exist in Orders.Order_ID
6. **Order_Details → Products**: Order_Details.Product_ID must exist in Products.Product_ID
7. **Shipments → Orders**: Shipments.Order_ID must exist in Orders.Order_ID
8. **Returns → Orders**: Returns.Order_ID must exist in Orders.Order_ID
9. **Stock_Levels → Products**: Stock_Levels.Product_ID must exist in Products.Product_ID
10. **Stock_Levels → Warehouses**: Stock_Levels.Warehouse_ID must exist in Warehouses.Warehouse_ID
11. **Cascade Rules**: Deletion of parent records must consider impact on child records
12. **Update Rules**: Updates to primary keys must cascade to foreign key references

## 3. Business Rules

### 3.1 Operational Rules
1. **Inventory Management**: Products with quantity below reorder threshold must trigger replenishment alerts
2. **Order Processing**: Orders can only be placed for products with available inventory
3. **Supplier Management**: Each product must have at least one active supplier
4. **Warehouse Capacity**: Total inventory in a warehouse cannot exceed warehouse capacity
5. **Stock Levels**: Reorder thresholds must be set for all products in all warehouses
6. **Return Processing**: Returns can only be processed for completed orders
7. **Shipment Rules**: Orders must be shipped within defined business timeframes
8. **Customer Management**: Customer information must be validated before order processing
9. **Product Categorization**: All products must be assigned to valid categories
10. **Quality Control**: Products with high return rates must be flagged for review

### 3.2 Reporting Logic Rules
1. **Stock Status Calculation**: Stock Status = IF(Quantity_Available ≤ Reorder_Threshold, "Below Threshold", "Above Threshold")
2. **Critical Stock Alert**: Critical Alert = IF(Quantity_Available < (Reorder_Threshold × 0.5), "Critical", "Normal")
3. **Threshold Alert Percentage**: (Below Threshold Count / Total Product Count) × 100
4. **Order to Inventory Ratio**: Total Quantity Ordered / Quantity_Available
5. **Warehouse Utilization**: SUM(Quantity_Available) / Warehouse.Capacity × 100
6. **Return Rate Calculation**: COUNT(Returns) / COUNT(Orders) × 100
7. **Supplier Product Count**: COUNT(Products) per Supplier
8. **Category Distribution**: SUM(Quantity_Available) GROUP BY Category
9. **Stockout Risk**: IF(Order to Inventory Ratio > 0.8, "High", IF(> 0.5, "Medium", "Low"))
10. **Product Demand Ranking**: RANK() OVER (ORDER BY Total Quantity Ordered DESC)

### 3.3 Data Transformation Guidelines
1. **Date Standardization**: All dates must be converted to standard format (YYYY-MM-DD)
2. **Text Normalization**: Product names and categories must be standardized and trimmed
3. **Numeric Formatting**: All numeric values must be properly formatted with appropriate precision
4. **Status Indicators**: Boolean values must be converted to standardized text indicators
5. **Category Mapping**: Product categories must be mapped to standard category codes
6. **Contact Formatting**: Phone numbers must be formatted to standard format
7. **Email Validation**: Email addresses must be validated and normalized
8. **Percentage Conversion**: Ratio calculations must be converted to percentage format
9. **Currency Formatting**: If applicable, monetary values must be properly formatted
10. **Null Handling**: Null values must be handled according to business rules

### 3.4 Data Quality Rules
1. **Completeness Validation**: All mandatory fields must be populated before processing
2. **Accuracy Checks**: Quantity values must be validated against business logic
3. **Consistency Verification**: Cross-table data must be consistent and synchronized
4. **Timeliness Rules**: Data must be updated within defined refresh intervals
5. **Validity Checks**: All foreign key references must be validated
6. **Range Validation**: Numeric values must be within acceptable business ranges
7. **Format Validation**: Text fields must conform to defined format standards
8. **Duplicate Detection**: Duplicate records must be identified and resolved
9. **Anomaly Detection**: Unusual patterns must be flagged for investigation
10. **Historical Integrity**: Historical data must be preserved and protected

### 3.5 Access Control Rules
1. **Role-Based Access**: Users can only access data appropriate to their role
2. **Warehouse Filtering**: Warehouse managers see only their warehouse data
3. **Category Restrictions**: Category managers see only their category data
4. **Customer Privacy**: Customer personal information access is restricted
5. **Supplier Confidentiality**: Supplier contact information access is controlled
6. **Executive Access**: Senior management has aggregated view with drill-down capability
7. **Audit Requirements**: All data access and modifications must be logged
8. **Data Masking**: Sensitive information must be masked for unauthorized users
9. **Time-Based Access**: Some reports may have time-based access restrictions
10. **Geographic Restrictions**: Access may be restricted based on geographic location

### 3.6 Alert and Notification Rules
1. **Critical Stock Alerts**: Immediate notification when inventory falls below critical levels
2. **Threshold Violations**: Daily alerts for products below reorder threshold
3. **Capacity Warnings**: Alerts when warehouse utilization exceeds 90%
4. **Return Rate Alerts**: Notification when product return rates exceed acceptable levels
5. **Data Quality Alerts**: Immediate notification of data quality issues
6. **System Performance**: Alerts for report generation performance issues
7. **Access Violations**: Security alerts for unauthorized access attempts
8. **Supplier Issues**: Alerts for supplier-related data inconsistencies
9. **Order Anomalies**: Alerts for unusual order patterns or volumes
10. **Integration Failures**: Alerts for data integration or synchronization failures

## 4. API Cost Calculation

– Cost for this particular Api Call to LLM model: $0.25