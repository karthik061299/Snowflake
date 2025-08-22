____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Model Data Constraints for Inventory Management System reporting requirements
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# MODEL DATA CONSTRAINTS - INVENTORY MANAGEMENT SYSTEM

## 1. Data Expectations

### 1.1 Data Completeness Expectations
1. **Products Table**: All products must have complete Product_Name and Category information
2. **Suppliers Table**: All suppliers must have Supplier_Name and valid Contact_Number
3. **Warehouses Table**: All warehouses must have Location and Capacity specified
4. **Inventory Table**: All inventory records must have valid Quantity_Available values
5. **Orders Table**: All orders must have valid Order_Date and Customer_ID
6. **Order_Details Table**: All order details must have valid Quantity_Ordered values
7. **Shipments Table**: All shipments must have valid Shipment_Date
8. **Returns Table**: All returns must have valid Return_Reason
9. **Stock_Levels Table**: All stock levels must have valid Reorder_Threshold values
10. **Customers Table**: All customers must have Customer_Name and Email

### 1.2 Data Accuracy Expectations
1. **Quantity Values**: All quantity fields (Quantity_Available, Quantity_Ordered) must reflect actual physical counts
2. **Date Values**: Order_Date and Shipment_Date must be chronologically consistent
3. **Contact Information**: Contact_Number and Email must be in valid formats
4. **Capacity Values**: Warehouse capacity must reflect actual physical storage limits
5. **Threshold Values**: Reorder_Threshold must be based on business requirements and historical data
6. **Return Reasons**: Must accurately reflect actual return circumstances
7. **Product Categories**: Must follow standardized categorization scheme
8. **Location Data**: Warehouse locations must be accurate and current
9. **Supplier Information**: Supplier details must be current and verified
10. **Customer Data**: Customer information must be up-to-date and accurate

### 1.3 Data Format Expectations
1. **Product_Name**: Text format, maximum 255 characters, no special characters except hyphens and spaces
2. **Category**: Standardized category names from predefined list
3. **Contact_Number**: Numeric format with country code, 10-15 digits
4. **Email**: Valid email format with @ symbol and domain
5. **Location**: Standardized address format with city, state, country
6. **Dates**: YYYY-MM-DD format for all date fields
7. **Quantities**: Integer format, non-negative values
8. **Capacity**: Numeric format representing storage units
9. **Return_Reason**: Predefined values (Damaged, Defective, Wrong Item)
10. **Supplier_Name**: Text format, maximum 255 characters

### 1.4 Data Consistency Expectations
1. **Cross-Table Consistency**: Product information must be consistent across all related tables
2. **Temporal Consistency**: Order dates must precede shipment dates
3. **Quantity Consistency**: Inventory quantities must align with order and return data
4. **Supplier Consistency**: Supplier information must be consistent across all references
5. **Warehouse Consistency**: Warehouse data must be consistent across inventory and stock level tables
6. **Customer Consistency**: Customer information must be consistent across orders and returns
7. **Category Consistency**: Product categories must follow standardized naming conventions
8. **Threshold Consistency**: Reorder thresholds must be consistent with business rules
9. **Return Consistency**: Return data must align with original order information
10. **Capacity Consistency**: Warehouse capacity utilization must not exceed physical limits

## 2. Constraints

### 2.1 Mandatory Field Constraints
1. **Products Table**: Product_ID (Primary Key), Product_Name, Category are mandatory
2. **Suppliers Table**: Supplier_ID (Primary Key), Supplier_Name, Contact_Number, Product_ID (Foreign Key) are mandatory
3. **Warehouses Table**: Warehouse_ID (Primary Key), Location, Capacity are mandatory
4. **Inventory Table**: Inventory_ID (Primary Key), Quantity_Available, Product_ID (Foreign Key), Warehouse_ID (Foreign Key) are mandatory
5. **Orders Table**: Order_ID (Primary Key), Order_Date, Customer_ID (Foreign Key) are mandatory
6. **Order_Details Table**: Order_Detail_ID (Primary Key), Quantity_Ordered, Order_ID (Foreign Key), Product_ID (Foreign Key) are mandatory
7. **Shipments Table**: Shipment_ID (Primary Key), Shipment_Date, Order_ID (Foreign Key) are mandatory
8. **Returns Table**: Return_ID (Primary Key), Return_Reason, Order_ID (Foreign Key) are mandatory
9. **Stock_Levels Table**: Stock_Level_ID (Primary Key), Reorder_Threshold, Warehouse_ID (Foreign Key), Product_ID (Foreign Key) are mandatory
10. **Customers Table**: Customer_ID (Primary Key), Customer_Name, Email are mandatory

### 2.2 Uniqueness Constraints
1. **Primary Keys**: All primary keys must be unique across their respective tables
2. **Product-Warehouse Combination**: Each Product_ID and Warehouse_ID combination in Inventory table must be unique
3. **Product-Warehouse Stock Levels**: Each Product_ID and Warehouse_ID combination in Stock_Levels table must be unique
4. **Order-Product Combination**: Each Order_ID and Product_ID combination in Order_Details table must be unique
5. **Order-Shipment Relationship**: Each Order_ID in Shipments table must be unique (one-to-one relationship)
6. **Order-Return Relationship**: Each Order_ID in Returns table must be unique (one-to-one relationship)
7. **Supplier Contact**: Contact_Number should be unique per supplier
8. **Customer Email**: Email addresses should be unique per customer
9. **Warehouse Location**: Location should be unique per warehouse
10. **Product Names**: Product_Name should be unique within the same category

### 2.3 Data Type Limitations
1. **Integer Fields**: All ID fields, quantities, and capacity must be positive integers
2. **Date Fields**: Order_Date and Shipment_Date must be valid date format
3. **Text Fields**: Product_Name, Category, Supplier_Name, Location must be text with length limits
4. **Numeric Fields**: Contact_Number must be numeric with specified digit range
5. **Email Format**: Email must follow standard email format validation
6. **Decimal Fields**: Capacity can be decimal for precise measurements
7. **Enumerated Values**: Return_Reason must be from predefined list
8. **Boolean Indicators**: Calculated fields like stock status must be boolean
9. **Percentage Values**: Utilization percentages must be between 0 and 100
10. **Currency Fields**: If applicable, must follow currency format standards

### 2.4 Referential Integrity Constraints
1. **Products-Suppliers**: Suppliers.Product_ID must exist in Products.Product_ID
2. **Products-Inventory**: Inventory.Product_ID must exist in Products.Product_ID
3. **Products-Order_Details**: Order_Details.Product_ID must exist in Products.Product_ID
4. **Products-Stock_Levels**: Stock_Levels.Product_ID must exist in Products.Product_ID
5. **Warehouses-Inventory**: Inventory.Warehouse_ID must exist in Warehouses.Warehouse_ID
6. **Warehouses-Stock_Levels**: Stock_Levels.Warehouse_ID must exist in Warehouses.Warehouse_ID
7. **Orders-Order_Details**: Order_Details.Order_ID must exist in Orders.Order_ID
8. **Orders-Shipments**: Shipments.Order_ID must exist in Orders.Order_ID
9. **Orders-Returns**: Returns.Order_ID must exist in Orders.Order_ID
10. **Customers-Orders**: Orders.Customer_ID must exist in Customers.Customer_ID

### 2.5 Business Logic Constraints
1. **Quantity Validation**: Quantity_Available must be non-negative integer
2. **Quantity_Ordered**: Must be positive integer (cannot order zero or negative quantities)
3. **Reorder_Threshold**: Must be positive integer and less than warehouse capacity
4. **Capacity Utilization**: Total inventory in warehouse cannot exceed warehouse capacity
5. **Date Logic**: Shipment_Date must be equal to or after Order_Date
6. **Return Logic**: Returns can only exist for orders that have been shipped
7. **Stock Status**: Products below reorder threshold must trigger alerts
8. **Supplier Validation**: Each product must have at least one supplier
9. **Category Validation**: Product categories must be from approved business taxonomy
10. **Contact Validation**: Contact numbers must be valid and reachable

## 3. Business Rules

### 3.1 Inventory Management Rules
1. **Reorder Point Rule**: When Quantity_Available <= Reorder_Threshold, automatic reorder process must be triggered
2. **Stock Status Classification**: Products are classified as "Below Threshold" when Quantity_Available <= Reorder_Threshold
3. **Critical Stock Alert**: Products with Quantity_Available < (Reorder_Threshold * 0.5) are marked as "Critical"
4. **Zero Stock Rule**: Products with Quantity_Available = 0 must be flagged for immediate attention
5. **Overstock Rule**: Products with Quantity_Available > (Reorder_Threshold * 3) may be considered overstocked
6. **Warehouse Capacity Rule**: Total inventory in any warehouse cannot exceed 90% of warehouse capacity
7. **Product Distribution Rule**: High-demand products should be distributed across multiple warehouses
8. **Seasonal Adjustment Rule**: Reorder thresholds may be adjusted based on seasonal demand patterns
9. **Supplier Lead Time Rule**: Reorder thresholds must account for supplier lead times
10. **Quality Control Rule**: Returned products must be inspected before returning to inventory

### 3.2 Order Processing Rules
1. **Order Fulfillment Rule**: Orders can only be fulfilled if sufficient inventory is available
2. **Order Priority Rule**: Orders are processed on first-come, first-served basis unless priority is specified
3. **Partial Fulfillment Rule**: Orders may be partially fulfilled if complete inventory is not available
4. **Order Validation Rule**: All orders must have valid customer information and product availability
5. **Shipment Timing Rule**: Orders must be shipped within 2 business days of order placement
6. **Order Modification Rule**: Orders can only be modified before shipment processing begins
7. **Backorder Rule**: Products not in stock may be backordered with customer approval
8. **Order Cancellation Rule**: Orders can be cancelled before shipment with full refund
9. **Bulk Order Rule**: Large orders may require special handling and approval
10. **Customer Credit Rule**: Orders must be validated against customer credit limits

### 3.3 Supplier Management Rules
1. **Single Source Risk Rule**: Products with only one supplier must be flagged for risk management
2. **Supplier Performance Rule**: Suppliers must maintain minimum performance standards for delivery and quality
3. **Supplier Diversification Rule**: Critical products should have at least two qualified suppliers
4. **Supplier Contact Rule**: Supplier contact information must be verified and updated quarterly
5. **Product-Supplier Mapping Rule**: Each product must be mapped to at least one active supplier
6. **Supplier Category Rule**: Suppliers may specialize in specific product categories
7. **Supplier Capacity Rule**: Supplier capacity must be considered in procurement planning
8. **Supplier Quality Rule**: Suppliers must meet quality standards for their product categories
9. **Supplier Contract Rule**: All supplier relationships must be governed by formal contracts
10. **Supplier Evaluation Rule**: Suppliers must be evaluated annually for performance and compliance

### 3.4 Returns Processing Rules
1. **Return Reason Validation**: All returns must have valid reason codes (Damaged, Defective, Wrong Item)
2. **Return Time Limit**: Returns must be processed within 30 days of original order
3. **Return Condition Rule**: Returned products must be inspected for condition before restocking
4. **Return Rate Monitoring**: Products with return rates > 5% must be investigated for quality issues
5. **Customer Return Limit**: Customers with excessive returns may be flagged for review
6. **Return Refund Rule**: Refunds are processed based on return reason and product condition
7. **Return Restocking Rule**: Only products in sellable condition can be returned to inventory
8. **Return Reporting Rule**: Return patterns must be analyzed monthly for quality improvement
9. **Return Authorization Rule**: All returns must be authorized before processing
10. **Return Documentation Rule**: All returns must be properly documented with reason and resolution

### 3.5 Reporting and Analytics Rules
1. **Data Freshness Rule**: Reports must use data that is no more than 24 hours old
2. **KPI Calculation Rule**: All KPIs must be calculated using standardized formulas
3. **Threshold Alert Rule**: Automated alerts must be generated when thresholds are breached
4. **Access Control Rule**: Report access must be restricted based on user roles and responsibilities
5. **Data Accuracy Rule**: Report data must be validated for accuracy before publication
6. **Historical Data Rule**: Historical trends must be maintained for at least 2 years
7. **Exception Reporting Rule**: Unusual patterns or anomalies must be highlighted in reports
8. **Performance Monitoring Rule**: Report generation performance must be monitored and optimized
9. **Data Security Rule**: Sensitive data must be protected and access logged
10. **Report Scheduling Rule**: Critical reports must be generated and distributed on schedule

### 3.6 Warehouse Operations Rules
1. **Capacity Management Rule**: Warehouse utilization should not exceed 85% of total capacity
2. **Product Placement Rule**: Products should be placed based on demand frequency and accessibility
3. **Inventory Counting Rule**: Physical inventory counts must be conducted quarterly
4. **Warehouse Safety Rule**: All warehouse operations must comply with safety regulations
5. **Product Segregation Rule**: Different product categories may require separate storage areas
6. **Temperature Control Rule**: Products requiring special storage conditions must be properly maintained
7. **Inventory Movement Rule**: All inventory movements must be properly documented and tracked
8. **Warehouse Security Rule**: Access to warehouse areas must be controlled and monitored
9. **Equipment Maintenance Rule**: Warehouse equipment must be maintained according to schedule
10. **Emergency Procedures Rule**: Emergency procedures must be in place for various scenarios

## 4. API Cost Calculation

– Cost for this particular Api Call to LLM model: $0.25
