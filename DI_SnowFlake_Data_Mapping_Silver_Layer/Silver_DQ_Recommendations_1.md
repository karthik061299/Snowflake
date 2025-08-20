_____________________________________________
## *Author*: Ascendion AVA+
## *Created on*:   
## *Description*: Silver Layer Data Quality Recommendations for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# SILVER LAYER DATA QUALITY RECOMMENDATIONS - INVENTORY MANAGEMENT SYSTEM

## Recommended Data Quality Checks:

### 1. Products Table (Bronze.bz_products)

1. **Product_ID Null Check**: Validate that Product_ID is not null
   - Rationale: Product_ID is the primary key and mandatory field as per constraints
   - SQL Example: 
   ```sql
   SELECT COUNT(*) as null_product_ids 
   FROM Bronze.bz_products 
   WHERE Product_ID IS NULL;
   ```

2. **Product_ID Uniqueness Check**: Ensure Product_ID values are unique
   - Rationale: Primary key constraint requires uniqueness
   - SQL Example:
   ```sql
   SELECT Product_ID, COUNT(*) as duplicate_count 
   FROM Bronze.bz_products 
   GROUP BY Product_ID 
   HAVING COUNT(*) > 1;
   ```

3. **Product_Name Completeness Check**: Validate that Product_Name is not null or empty
   - Rationale: Product_Name is mandatory as per data constraints and business requirements
   - SQL Example:
   ```sql
   SELECT COUNT(*) as missing_product_names 
   FROM Bronze.bz_products 
   WHERE Product_Name IS NULL OR TRIM(Product_Name) = '';
   ```

4. **Product_Name Length Check**: Validate Product_Name length does not exceed 255 characters
   - Rationale: Data format expectations specify maximum 255 characters
   - SQL Example:
   ```sql
   SELECT COUNT(*) as long_product_names 
   FROM Bronze.bz_products 
   WHERE LENGTH(Product_Name) > 255;
   ```

5. **Category Completeness Check**: Validate that Category is not null
   - Rationale: Category is mandatory field as per constraints
   - SQL Example:
   ```sql
   SELECT COUNT(*) as missing_categories 
   FROM Bronze.bz_products 
   WHERE Category IS NULL OR TRIM(Category) = '';
   ```

6. **Category Standardization Check**: Validate Category values against predefined list
   - Rationale: Business rules require standardized category names from predefined list
   - SQL Example:
   ```sql
   SELECT DISTINCT Category 
   FROM Bronze.bz_products 
   WHERE Category NOT IN ('Electronics', 'Apparel', 'Furniture');
   ```

### 2. Suppliers Table (Bronze.bz_suppliers)

7. **Supplier_ID Null Check**: Validate that Supplier_ID is not null
   - Rationale: Supplier_ID is the primary key and mandatory field
   - SQL Example:
   ```sql
   SELECT COUNT(*) as null_supplier_ids 
   FROM Bronze.bz_suppliers 
   WHERE Supplier_ID IS NULL;
   ```

8. **Supplier_ID Uniqueness Check**: Ensure Supplier_ID values are unique
   - Rationale: Primary key constraint requires uniqueness
   - SQL Example:
   ```sql
   SELECT Supplier_ID, COUNT(*) as duplicate_count 
   FROM Bronze.bz_suppliers 
   GROUP BY Supplier_ID 
   HAVING COUNT(*) > 1;
   ```

9. **Supplier_Name Completeness Check**: Validate that Supplier_Name is not null
   - Rationale: Supplier_Name is mandatory as per constraints
   - SQL Example:
   ```sql
   SELECT COUNT(*) as missing_supplier_names 
   FROM Bronze.bz_suppliers 
   WHERE Supplier_Name IS NULL OR TRIM(Supplier_Name) = '';
   ```

10. **Contact_Number Format Check**: Validate Contact_Number format (10-15 digits)
    - Rationale: Data format expectations require numeric format with 10-15 digits
    - SQL Example:
    ```sql
    SELECT COUNT(*) as invalid_contact_numbers 
    FROM Bronze.bz_suppliers 
    WHERE Contact_Number IS NULL 
       OR LENGTH(Contact_Number) < 10 
       OR LENGTH(Contact_Number) > 15 
       OR Contact_Number NOT REGEXP '^[0-9]+$';
    ```

11. **Contact_Number Uniqueness Check**: Validate Contact_Number uniqueness per supplier
    - Rationale: Uniqueness constraints specify Contact_Number should be unique per supplier
    - SQL Example:
    ```sql
    SELECT Contact_Number, COUNT(*) as duplicate_count 
    FROM Bronze.bz_suppliers 
    WHERE Contact_Number IS NOT NULL
    GROUP BY Contact_Number 
    HAVING COUNT(*) > 1;
    ```

12. **Product_ID Referential Integrity Check**: Validate Product_ID exists in Products table
    - Rationale: Referential integrity constraint requires Suppliers.Product_ID to exist in Products.Product_ID
    - SQL Example:
    ```sql
    SELECT COUNT(*) as orphaned_suppliers 
    FROM Bronze.bz_suppliers s 
    LEFT JOIN Bronze.bz_products p ON s.Product_ID = p.Product_ID 
    WHERE s.Product_ID IS NOT NULL AND p.Product_ID IS NULL;
    ```

### 3. Warehouses Table (Bronze.bz_warehouses)

13. **Warehouse_ID Null Check**: Validate that Warehouse_ID is not null
    - Rationale: Warehouse_ID is the primary key and mandatory field
    - SQL Example:
    ```sql
    SELECT COUNT(*) as null_warehouse_ids 
    FROM Bronze.bz_warehouses 
    WHERE Warehouse_ID IS NULL;
    ```

14. **Warehouse_ID Uniqueness Check**: Ensure Warehouse_ID values are unique
    - Rationale: Primary key constraint requires uniqueness
    - SQL Example:
    ```sql
    SELECT Warehouse_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_warehouses 
    GROUP BY Warehouse_ID 
    HAVING COUNT(*) > 1;
    ```

15. **Location Completeness Check**: Validate that Location is not null
    - Rationale: Location is mandatory as per constraints
    - SQL Example:
    ```sql
    SELECT COUNT(*) as missing_locations 
    FROM Bronze.bz_warehouses 
    WHERE Location IS NULL OR TRIM(Location) = '';
    ```

16. **Location Uniqueness Check**: Validate Location uniqueness per warehouse
    - Rationale: Uniqueness constraints specify Location should be unique per warehouse
    - SQL Example:
    ```sql
    SELECT Location, COUNT(*) as duplicate_count 
    FROM Bronze.bz_warehouses 
    WHERE Location IS NOT NULL
    GROUP BY Location 
    HAVING COUNT(*) > 1;
    ```

17. **Capacity Completeness Check**: Validate that Capacity is not null
    - Rationale: Capacity is mandatory as per constraints
    - SQL Example:
    ```sql
    SELECT COUNT(*) as missing_capacity 
    FROM Bronze.bz_warehouses 
    WHERE Capacity IS NULL;
    ```

18. **Capacity Range Check**: Validate Capacity is positive
    - Rationale: Business logic requires positive capacity values
    - SQL Example:
    ```sql
    SELECT COUNT(*) as invalid_capacity 
    FROM Bronze.bz_warehouses 
    WHERE Capacity <= 0;
    ```

### 4. Inventory Table (Bronze.bz_inventory)

19. **Inventory_ID Null Check**: Validate that Inventory_ID is not null
    - Rationale: Inventory_ID is the primary key and mandatory field
    - SQL Example:
    ```sql
    SELECT COUNT(*) as null_inventory_ids 
    FROM Bronze.bz_inventory 
    WHERE Inventory_ID IS NULL;
    ```

20. **Inventory_ID Uniqueness Check**: Ensure Inventory_ID values are unique
    - Rationale: Primary key constraint requires uniqueness
    - SQL Example:
    ```sql
    SELECT Inventory_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_inventory 
    GROUP BY Inventory_ID 
    HAVING COUNT(*) > 1;
    ```

21. **Quantity_Available Non-Negative Check**: Validate Quantity_Available is non-negative
    - Rationale: Business logic constraints require non-negative quantities
    - SQL Example:
    ```sql
    SELECT COUNT(*) as negative_quantities 
    FROM Bronze.bz_inventory 
    WHERE Quantity_Available < 0;
    ```

22. **Product-Warehouse Combination Uniqueness Check**: Validate unique Product_ID and Warehouse_ID combination
    - Rationale: Uniqueness constraints require each Product_ID and Warehouse_ID combination to be unique
    - SQL Example:
    ```sql
    SELECT Product_ID, Warehouse_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_inventory 
    GROUP BY Product_ID, Warehouse_ID 
    HAVING COUNT(*) > 1;
    ```

23. **Product_ID Referential Integrity Check**: Validate Product_ID exists in Products table
    - Rationale: Referential integrity constraint
    - SQL Example:
    ```sql
    SELECT COUNT(*) as orphaned_inventory_products 
    FROM Bronze.bz_inventory i 
    LEFT JOIN Bronze.bz_products p ON i.Product_ID = p.Product_ID 
    WHERE i.Product_ID IS NOT NULL AND p.Product_ID IS NULL;
    ```

24. **Warehouse_ID Referential Integrity Check**: Validate Warehouse_ID exists in Warehouses table
    - Rationale: Referential integrity constraint
    - SQL Example:
    ```sql
    SELECT COUNT(*) as orphaned_inventory_warehouses 
    FROM Bronze.bz_inventory i 
    LEFT JOIN Bronze.bz_warehouses w ON i.Warehouse_ID = w.Warehouse_ID 
    WHERE i.Warehouse_ID IS NOT NULL AND w.Warehouse_ID IS NULL;
    ```

### 5. Orders Table (Bronze.bz_orders)

25. **Order_ID Null Check**: Validate that Order_ID is not null
    - Rationale: Order_ID is the primary key and mandatory field
    - SQL Example:
    ```sql
    SELECT COUNT(*) as null_order_ids 
    FROM Bronze.bz_orders 
    WHERE Order_ID IS NULL;
    ```

26. **Order_ID Uniqueness Check**: Ensure Order_ID values are unique
    - Rationale: Primary key constraint requires uniqueness
    - SQL Example:
    ```sql
    SELECT Order_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_orders 
    GROUP BY Order_ID 
    HAVING COUNT(*) > 1;
    ```

27. **Order_Date Completeness Check**: Validate that Order_Date is not null
    - Rationale: Order_Date is mandatory as per constraints
    - SQL Example:
    ```sql
    SELECT COUNT(*) as missing_order_dates 
    FROM Bronze.bz_orders 
    WHERE Order_Date IS NULL;
    ```

28. **Order_Date Format Check**: Validate Order_Date is in valid date format
    - Rationale: Data format expectations require YYYY-MM-DD format
    - SQL Example:
    ```sql
    SELECT COUNT(*) as invalid_order_dates 
    FROM Bronze.bz_orders 
    WHERE Order_Date IS NOT NULL AND TRY_CAST(Order_Date AS DATE) IS NULL;
    ```

29. **Customer_ID Referential Integrity Check**: Validate Customer_ID exists in Customers table
    - Rationale: Referential integrity constraint
    - SQL Example:
    ```sql
    SELECT COUNT(*) as orphaned_orders 
    FROM Bronze.bz_orders o 
    LEFT JOIN Bronze.bz_customers c ON o.Customer_ID = c.Customer_ID 
    WHERE o.Customer_ID IS NOT NULL AND c.Customer_ID IS NULL;
    ```

### 6. Order Details Table (Bronze.bz_order_details)

30. **Order_Detail_ID Null Check**: Validate that Order_Detail_ID is not null
    - Rationale: Order_Detail_ID is the primary key and mandatory field
    - SQL Example:
    ```sql
    SELECT COUNT(*) as null_order_detail_ids 
    FROM Bronze.bz_order_details 
    WHERE Order_Detail_ID IS NULL;
    ```

31. **Order_Detail_ID Uniqueness Check**: Ensure Order_Detail_ID values are unique
    - Rationale: Primary key constraint requires uniqueness
    - SQL Example:
    ```sql
    SELECT Order_Detail_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_order_details 
    GROUP BY Order_Detail_ID 
    HAVING COUNT(*) > 1;
    ```

32. **Quantity_Ordered Positive Check**: Validate Quantity_Ordered is positive
    - Rationale: Business logic constraints require positive quantities (cannot order zero or negative)
    - SQL Example:
    ```sql
    SELECT COUNT(*) as invalid_quantities 
    FROM Bronze.bz_order_details 
    WHERE Quantity_Ordered <= 0;
    ```

33. **Order-Product Combination Uniqueness Check**: Validate unique Order_ID and Product_ID combination
    - Rationale: Uniqueness constraints require each Order_ID and Product_ID combination to be unique
    - SQL Example:
    ```sql
    SELECT Order_ID, Product_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_order_details 
    GROUP BY Order_ID, Product_ID 
    HAVING COUNT(*) > 1;
    ```

34. **Order_ID Referential Integrity Check**: Validate Order_ID exists in Orders table
    - Rationale: Referential integrity constraint
    - SQL Example:
    ```sql
    SELECT COUNT(*) as orphaned_order_details 
    FROM Bronze.bz_order_details od 
    LEFT JOIN Bronze.bz_orders o ON od.Order_ID = o.Order_ID 
    WHERE od.Order_ID IS NOT NULL AND o.Order_ID IS NULL;
    ```

35. **Product_ID Referential Integrity Check**: Validate Product_ID exists in Products table
    - Rationale: Referential integrity constraint
    - SQL Example:
    ```sql
    SELECT COUNT(*) as orphaned_order_detail_products 
    FROM Bronze.bz_order_details od 
    LEFT JOIN Bronze.bz_products p ON od.Product_ID = p.Product_ID 
    WHERE od.Product_ID IS NOT NULL AND p.Product_ID IS NULL;
    ```

### 7. Shipments Table (Bronze.bz_shipments)

36. **Shipment_ID Null Check**: Validate that Shipment_ID is not null
    - Rationale: Shipment_ID is the primary key and mandatory field
    - SQL Example:
    ```sql
    SELECT COUNT(*) as null_shipment_ids 
    FROM Bronze.bz_shipments 
    WHERE Shipment_ID IS NULL;
    ```

37. **Shipment_ID Uniqueness Check**: Ensure Shipment_ID values are unique
    - Rationale: Primary key constraint requires uniqueness
    - SQL Example:
    ```sql
    SELECT Shipment_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_shipments 
    GROUP BY Shipment_ID 
    HAVING COUNT(*) > 1;
    ```

38. **Shipment_Date Completeness Check**: Validate that Shipment_Date is not null
    - Rationale: Shipment_Date is mandatory as per constraints
    - SQL Example:
    ```sql
    SELECT COUNT(*) as missing_shipment_dates 
    FROM Bronze.bz_shipments 
    WHERE Shipment_Date IS NULL;
    ```

39. **Order-Shipment Relationship Uniqueness Check**: Validate unique Order_ID in Shipments
    - Rationale: Uniqueness constraints require one-to-one relationship between orders and shipments
    - SQL Example:
    ```sql
    SELECT Order_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_shipments 
    WHERE Order_ID IS NOT NULL
    GROUP BY Order_ID 
    HAVING COUNT(*) > 1;
    ```

40. **Shipment Date Logic Check**: Validate Shipment_Date is equal to or after Order_Date
    - Rationale: Business logic constraints require chronological consistency
    - SQL Example:
    ```sql
    SELECT COUNT(*) as invalid_shipment_dates 
    FROM Bronze.bz_shipments s 
    JOIN Bronze.bz_orders o ON s.Order_ID = o.Order_ID 
    WHERE s.Shipment_Date < o.Order_Date;
    ```

41. **Order_ID Referential Integrity Check**: Validate Order_ID exists in Orders table
    - Rationale: Referential integrity constraint
    - SQL Example:
    ```sql
    SELECT COUNT(*) as orphaned_shipments 
    FROM Bronze.bz_shipments s 
    LEFT JOIN Bronze.bz_orders o ON s.Order_ID = o.Order_ID 
    WHERE s.Order_ID IS NOT NULL AND o.Order_ID IS NULL;
    ```

### 8. Returns Table (Bronze.bz_returns)

42. **Return_ID Null Check**: Validate that Return_ID is not null
    - Rationale: Return_ID is the primary key and mandatory field
    - SQL Example:
    ```sql
    SELECT COUNT(*) as null_return_ids 
    FROM Bronze.bz_returns 
    WHERE Return_ID IS NULL;
    ```

43. **Return_ID Uniqueness Check**: Ensure Return_ID values are unique
    - Rationale: Primary key constraint requires uniqueness
    - SQL Example:
    ```sql
    SELECT Return_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_returns 
    GROUP BY Return_ID 
    HAVING COUNT(*) > 1;
    ```

44. **Return_Reason Completeness Check**: Validate that Return_Reason is not null
    - Rationale: Return_Reason is mandatory as per constraints
    - SQL Example:
    ```sql
    SELECT COUNT(*) as missing_return_reasons 
    FROM Bronze.bz_returns 
    WHERE Return_Reason IS NULL OR TRIM(Return_Reason) = '';
    ```

45. **Return_Reason Validation Check**: Validate Return_Reason against predefined values
    - Rationale: Business rules require predefined values (Damaged, Defective, Wrong Item)
    - SQL Example:
    ```sql
    SELECT COUNT(*) as invalid_return_reasons 
    FROM Bronze.bz_returns 
    WHERE Return_Reason NOT IN ('Damaged', 'Defective', 'Wrong Item');
    ```

46. **Order-Return Relationship Uniqueness Check**: Validate unique Order_ID in Returns
    - Rationale: Uniqueness constraints require one-to-one relationship between orders and returns
    - SQL Example:
    ```sql
    SELECT Order_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_returns 
    WHERE Order_ID IS NOT NULL
    GROUP BY Order_ID 
    HAVING COUNT(*) > 1;
    ```

47. **Order_ID Referential Integrity Check**: Validate Order_ID exists in Orders table
    - Rationale: Referential integrity constraint
    - SQL Example:
    ```sql
    SELECT COUNT(*) as orphaned_returns 
    FROM Bronze.bz_returns r 
    LEFT JOIN Bronze.bz_orders o ON r.Order_ID = o.Order_ID 
    WHERE r.Order_ID IS NOT NULL AND o.Order_ID IS NULL;
    ```

### 9. Stock Levels Table (Bronze.bz_stock_levels)

48. **Stock_Level_ID Null Check**: Validate that Stock_Level_ID is not null
    - Rationale: Stock_Level_ID is the primary key and mandatory field
    - SQL Example:
    ```sql
    SELECT COUNT(*) as null_stock_level_ids 
    FROM Bronze.bz_stock_levels 
    WHERE Stock_Level_ID IS NULL;
    ```

49. **Stock_Level_ID Uniqueness Check**: Ensure Stock_Level_ID values are unique
    - Rationale: Primary key constraint requires uniqueness
    - SQL Example:
    ```sql
    SELECT Stock_Level_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_stock_levels 
    GROUP BY Stock_Level_ID 
    HAVING COUNT(*) > 1;
    ```

50. **Reorder_Threshold Positive Check**: Validate Reorder_Threshold is positive
    - Rationale: Business logic constraints require positive threshold values
    - SQL Example:
    ```sql
    SELECT COUNT(*) as invalid_thresholds 
    FROM Bronze.bz_stock_levels 
    WHERE Reorder_Threshold <= 0;
    ```

51. **Product-Warehouse Stock Level Uniqueness Check**: Validate unique Product_ID and Warehouse_ID combination
    - Rationale: Uniqueness constraints require each Product_ID and Warehouse_ID combination to be unique
    - SQL Example:
    ```sql
    SELECT Product_ID, Warehouse_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_stock_levels 
    GROUP BY Product_ID, Warehouse_ID 
    HAVING COUNT(*) > 1;
    ```

52. **Reorder_Threshold vs Capacity Check**: Validate Reorder_Threshold is less than warehouse capacity
    - Rationale: Business logic constraints require threshold to be less than warehouse capacity
    - SQL Example:
    ```sql
    SELECT COUNT(*) as invalid_threshold_capacity 
    FROM Bronze.bz_stock_levels sl 
    JOIN Bronze.bz_warehouses w ON sl.Warehouse_ID = w.Warehouse_ID 
    WHERE sl.Reorder_Threshold >= w.Capacity;
    ```

53. **Warehouse_ID Referential Integrity Check**: Validate Warehouse_ID exists in Warehouses table
    - Rationale: Referential integrity constraint
    - SQL Example:
    ```sql
    SELECT COUNT(*) as orphaned_stock_level_warehouses 
    FROM Bronze.bz_stock_levels sl 
    LEFT JOIN Bronze.bz_warehouses w ON sl.Warehouse_ID = w.Warehouse_ID 
    WHERE sl.Warehouse_ID IS NOT NULL AND w.Warehouse_ID IS NULL;
    ```

54. **Product_ID Referential Integrity Check**: Validate Product_ID exists in Products table
    - Rationale: Referential integrity constraint
    - SQL Example:
    ```sql
    SELECT COUNT(*) as orphaned_stock_level_products 
    FROM Bronze.bz_stock_levels sl 
    LEFT JOIN Bronze.bz_products p ON sl.Product_ID = p.Product_ID 
    WHERE sl.Product_ID IS NOT NULL AND p.Product_ID IS NULL;
    ```

### 10. Customers Table (Bronze.bz_customers)

55. **Customer_ID Null Check**: Validate that Customer_ID is not null
    - Rationale: Customer_ID is the primary key and mandatory field
    - SQL Example:
    ```sql
    SELECT COUNT(*) as null_customer_ids 
    FROM Bronze.bz_customers 
    WHERE Customer_ID IS NULL;
    ```

56. **Customer_ID Uniqueness Check**: Ensure Customer_ID values are unique
    - Rationale: Primary key constraint requires uniqueness
    - SQL Example:
    ```sql
    SELECT Customer_ID, COUNT(*) as duplicate_count 
    FROM Bronze.bz_customers 
    GROUP BY Customer_ID 
    HAVING COUNT(*) > 1;
    ```

57. **Customer_Name Completeness Check**: Validate that Customer_Name is not null
    - Rationale: Customer_Name is mandatory as per constraints
    - SQL Example:
    ```sql
    SELECT COUNT(*) as missing_customer_names 
    FROM Bronze.bz_customers 
    WHERE Customer_Name IS NULL OR TRIM(Customer_Name) = '';
    ```

58. **Email Completeness Check**: Validate that Email is not null
    - Rationale: Email is mandatory as per constraints
    - SQL Example:
    ```sql
    SELECT COUNT(*) as missing_emails 
    FROM Bronze.bz_customers 
    WHERE Email IS NULL OR TRIM(Email) = '';
    ```

59. **Email Format Check**: Validate Email format with @ symbol and domain
    - Rationale: Data format expectations require valid email format
    - SQL Example:
    ```sql
    SELECT COUNT(*) as invalid_emails 
    FROM Bronze.bz_customers 
    WHERE Email IS NOT NULL 
      AND (Email NOT LIKE '%@%' 
           OR Email NOT LIKE '%.%' 
           OR LENGTH(Email) < 5);
    ```

60. **Email Uniqueness Check**: Validate Email uniqueness per customer
    - Rationale: Uniqueness constraints specify Email should be unique per customer
    - SQL Example:
    ```sql
    SELECT Email, COUNT(*) as duplicate_count 
    FROM Bronze.bz_customers 
    WHERE Email IS NOT NULL
    GROUP BY Email 
    HAVING COUNT(*) > 1;
    ```

### 11. Business Rule Based Checks

61. **Reorder Point Alert Check**: Identify products below reorder threshold
    - Rationale: Business rule requires automatic reorder process when Quantity_Available <= Reorder_Threshold
    - SQL Example:
    ```sql
    SELECT COUNT(*) as products_below_threshold 
    FROM Bronze.bz_inventory i 
    JOIN Bronze.bz_stock_levels sl ON i.Product_ID = sl.Product_ID AND i.Warehouse_ID = sl.Warehouse_ID 
    WHERE i.Quantity_Available <= sl.Reorder_Threshold;
    ```

62. **Critical Stock Alert Check**: Identify products with critical stock levels
    - Rationale: Business rule marks products as "Critical" when Quantity_Available < (Reorder_Threshold * 0.5)
    - SQL Example:
    ```sql
    SELECT COUNT(*) as critical_stock_products 
    FROM Bronze.bz_inventory i 
    JOIN Bronze.bz_stock_levels sl ON i.Product_ID = sl.Product_ID AND i.Warehouse_ID = sl.Warehouse_ID 
    WHERE i.Quantity_Available < (sl.Reorder_Threshold * 0.5);
    ```

63. **Zero Stock Check**: Identify products with zero inventory
    - Rationale: Business rule requires flagging products with Quantity_Available = 0
    - SQL Example:
    ```sql
    SELECT COUNT(*) as zero_stock_products 
    FROM Bronze.bz_inventory 
    WHERE Quantity_Available = 0;
    ```

64. **Warehouse Capacity Utilization Check**: Validate warehouse utilization does not exceed 90%
    - Rationale: Business rule requires total inventory cannot exceed 90% of warehouse capacity
    - SQL Example:
    ```sql
    SELECT COUNT(*) as over_capacity_warehouses 
    FROM (
        SELECT w.Warehouse_ID, 
               SUM(i.Quantity_Available) as total_inventory,
               w.Capacity,
               (SUM(i.Quantity_Available) / w.Capacity) * 100 as utilization_pct
        FROM Bronze.bz_warehouses w 
        LEFT JOIN