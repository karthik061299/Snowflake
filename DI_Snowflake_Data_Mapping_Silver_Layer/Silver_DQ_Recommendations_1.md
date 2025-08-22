_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Silver Layer Data Quality Recommendations for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# SILVER LAYER DATA QUALITY RECOMMENDATIONS
## INVENTORY MANAGEMENT SYSTEM

## Recommended Data Quality Checks:

### 1. **NULL Value Validation Checks**

#### 1.1 Products Table NULL Checks
**Check Name**: Products Mandatory Fields Validation
**Description**: Validate that all mandatory fields in Products table are not NULL
**Rationale**: Based on business rules, Product_ID, Product_Name, and Category are mandatory fields. NULL values would violate referential integrity and business logic.
**SQL Example**:
```sql
SELECT COUNT(*) as null_violations
FROM Bronze.bz_products 
WHERE product_id IS NULL 
   OR product_name IS NULL 
   OR category IS NULL;
```

#### 1.2 Suppliers Table NULL Checks
**Check Name**: Suppliers Mandatory Fields Validation
**Description**: Validate that all mandatory fields in Suppliers table are not NULL
**Rationale**: Supplier_ID, Supplier_Name, Contact_Number, and Product_ID are critical for supplier management and referential integrity.
**SQL Example**:
```sql
SELECT COUNT(*) as null_violations
FROM Bronze.bz_suppliers 
WHERE supplier_id IS NULL 
   OR supplier_name IS NULL 
   OR contact_number IS NULL 
   OR product_id IS NULL;
```

#### 1.3 Warehouses Table NULL Checks
**Check Name**: Warehouses Mandatory Fields Validation
**Description**: Validate that all mandatory fields in Warehouses table are not NULL
**Rationale**: Warehouse_ID, Location, and Capacity are essential for inventory management and warehouse operations.
**SQL Example**:
```sql
SELECT COUNT(*) as null_violations
FROM Bronze.bz_warehouses 
WHERE warehouse_id IS NULL 
   OR location IS NULL 
   OR capacity IS NULL;
```

#### 1.4 Inventory Table NULL Checks
**Check Name**: Inventory Mandatory Fields Validation
**Description**: Validate that all mandatory fields in Inventory table are not NULL
**Rationale**: All fields are critical for inventory tracking and business operations.
**SQL Example**:
```sql
SELECT COUNT(*) as null_violations
FROM Bronze.bz_inventory 
WHERE inventory_id IS NULL 
   OR product_id IS NULL 
   OR quantity_available IS NULL 
   OR warehouse_id IS NULL;
```

#### 1.5 Orders Table NULL Checks
**Check Name**: Orders Mandatory Fields Validation
**Description**: Validate that all mandatory fields in Orders table are not NULL
**Rationale**: Order_ID, Customer_ID, and Order_Date are essential for order processing and customer management.
**SQL Example**:
```sql
SELECT COUNT(*) as null_violations
FROM Bronze.bz_orders 
WHERE order_id IS NULL 
   OR customer_id IS NULL 
   OR order_date IS NULL;
```

### 2. **Data Type and Format Validation Checks**

#### 2.1 Numeric Field Validation
**Check Name**: Positive Integer Validation for IDs and Quantities
**Description**: Validate that all ID fields and quantity fields contain positive integers
**Rationale**: Based on business rules, all ID fields and quantities must be positive integers. Negative values would indicate data corruption.
**SQL Example**:
```sql
SELECT 'Products' as table_name, COUNT(*) as violations
FROM Bronze.bz_products 
WHERE product_id <= 0
UNION ALL
SELECT 'Inventory' as table_name, COUNT(*) as violations
FROM Bronze.bz_inventory 
WHERE quantity_available < 0;
```

#### 2.2 Contact Number Format Validation
**Check Name**: Contact Number Format Check
**Description**: Validate that contact numbers are in correct format (10-15 digits)
**Rationale**: Business rules specify contact numbers must be numeric with 10-15 digits for valid communication.
**SQL Example**:
```sql
SELECT COUNT(*) as format_violations
FROM Bronze.bz_suppliers 
WHERE LENGTH(contact_number) < 10 
   OR LENGTH(contact_number) > 15 
   OR contact_number NOT REGEXP '^[0-9]+$';
```

#### 2.3 Email Format Validation
**Check Name**: Email Format Validation
**Description**: Validate that email addresses follow standard email format
**Rationale**: Business rules require valid email format with @ symbol and domain for customer communication.
**SQL Example**:
```sql
SELECT COUNT(*) as email_violations
FROM Bronze.bz_customers 
WHERE email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
```

#### 2.4 Date Format and Logic Validation
**Check Name**: Date Chronological Consistency Check
**Description**: Validate that shipment dates are equal to or after order dates
**Rationale**: Business rule states shipment_date must be equal to or after order_date for logical consistency.
**SQL Example**:
```sql
SELECT COUNT(*) as date_violations
FROM Bronze.bz_orders o
JOIN Bronze.bz_shipments s ON o.order_id = s.order_id
WHERE s.shipment_date < o.order_date;
```

### 3. **Business Rule Validation Checks**

#### 3.1 Inventory Threshold Validation
**Check Name**: Reorder Threshold Business Rule Check
**Description**: Identify products below reorder threshold for automatic reorder triggering
**Rationale**: Business rule states when Quantity_Available <= Reorder_Threshold, automatic reorder process must be triggered.
**SQL Example**:
```sql
SELECT i.product_id, i.quantity_available, sl.reorder_threshold,
       CASE WHEN i.quantity_available <= sl.reorder_threshold THEN 'REORDER_REQUIRED' 
            ELSE 'OK' END as status
FROM Bronze.bz_inventory i
JOIN Bronze.bz_stock_levels sl ON i.product_id = sl.product_id AND i.warehouse_id = sl.warehouse_id
WHERE i.quantity_available <= sl.reorder_threshold;
```

#### 3.2 Critical Stock Alert Check
**Check Name**: Critical Stock Level Alert
**Description**: Identify products with critically low stock levels
**Rationale**: Business rule defines products with Quantity_Available < (Reorder_Threshold * 0.5) as "Critical" requiring immediate attention.
**SQL Example**:
```sql
SELECT i.product_id, i.quantity_available, sl.reorder_threshold,
       (sl.reorder_threshold * 0.5) as critical_threshold
FROM Bronze.bz_inventory i
JOIN Bronze.bz_stock_levels sl ON i.product_id = sl.product_id AND i.warehouse_id = sl.warehouse_id
WHERE i.quantity_available < (sl.reorder_threshold * 0.5);
```

#### 3.3 Warehouse Capacity Utilization Check
**Check Name**: Warehouse Capacity Limit Validation
**Description**: Validate that warehouse utilization does not exceed 90% of capacity
**Rationale**: Business rule states warehouse utilization should not exceed 85-90% of total capacity for operational efficiency.
**SQL Example**:
```sql
SELECT w.warehouse_id, w.location, w.capacity,
       SUM(i.quantity_available) as current_inventory,
       (SUM(i.quantity_available) / w.capacity * 100) as utilization_percentage
FROM Bronze.bz_warehouses w
LEFT JOIN Bronze.bz_inventory i ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id, w.location, w.capacity
HAVING utilization_percentage > 90;
```

#### 3.4 Return Reason Validation
**Check Name**: Valid Return Reason Check
**Description**: Validate that return reasons are from predefined list
**Rationale**: Business rules specify return reasons must be from approved list (Damaged, Defective, Wrong Item).
**SQL Example**:
```sql
SELECT COUNT(*) as invalid_return_reasons
FROM Bronze.bz_returns 
WHERE return_reason NOT IN ('Damaged', 'Defective', 'Wrong Item');
```

### 4. **Referential Integrity Checks**

#### 4.1 Product-Supplier Referential Integrity
**Check Name**: Supplier Product Reference Validation
**Description**: Validate that all Product_IDs in Suppliers table exist in Products table
**Rationale**: Referential integrity constraint ensures data consistency across related tables.
**SQL Example**:
```sql
SELECT COUNT(*) as orphaned_supplier_products
FROM Bronze.bz_suppliers s
LEFT JOIN Bronze.bz_products p ON s.product_id = p.product_id
WHERE p.product_id IS NULL;
```

#### 4.2 Inventory-Product Referential Integrity
**Check Name**: Inventory Product Reference Validation
**Description**: Validate that all Product_IDs in Inventory table exist in Products table
**Rationale**: Ensures inventory records reference valid products for accurate inventory management.
**SQL Example**:
```sql
SELECT COUNT(*) as orphaned_inventory_products
FROM Bronze.bz_inventory i
LEFT JOIN Bronze.bz_products p ON i.product_id = p.product_id
WHERE p.product_id IS NULL;
```

#### 4.3 Inventory-Warehouse Referential Integrity
**Check Name**: Inventory Warehouse Reference Validation
**Description**: Validate that all Warehouse_IDs in Inventory table exist in Warehouses table
**Rationale**: Ensures inventory records reference valid warehouses for accurate location tracking.
**SQL Example**:
```sql
SELECT COUNT(*) as orphaned_inventory_warehouses
FROM Bronze.bz_inventory i
LEFT JOIN Bronze.bz_warehouses w ON i.warehouse_id = w.warehouse_id
WHERE w.warehouse_id IS NULL;
```

#### 4.4 Order-Customer Referential Integrity
**Check Name**: Order Customer Reference Validation
**Description**: Validate that all Customer_IDs in Orders table exist in Customers table
**Rationale**: Ensures all orders are associated with valid customers for proper order management.
**SQL Example**:
```sql
SELECT COUNT(*) as orphaned_order_customers
FROM Bronze.bz_orders o
LEFT JOIN Bronze.bz_customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
```

### 5. **Uniqueness Constraint Checks**

#### 5.1 Primary Key Uniqueness Validation
**Check Name**: Primary Key Uniqueness Check
**Description**: Validate that all primary keys are unique across their respective tables
**Rationale**: Primary key uniqueness is fundamental for data integrity and proper table relationships.
**SQL Example**:
```sql
SELECT 'Products' as table_name, product_id, COUNT(*) as duplicate_count
FROM Bronze.bz_products 
GROUP BY product_id
HAVING COUNT(*) > 1
UNION ALL
SELECT 'Suppliers' as table_name, supplier_id, COUNT(*) as duplicate_count
FROM Bronze.bz_suppliers 
GROUP BY supplier_id
HAVING COUNT(*) > 1;
```

#### 5.2 Product-Warehouse Combination Uniqueness
**Check Name**: Inventory Product-Warehouse Uniqueness Check
**Description**: Validate that each Product_ID and Warehouse_ID combination is unique in Inventory table
**Rationale**: Business rule requires unique product-warehouse combinations to prevent duplicate inventory records.
**SQL Example**:
```sql
SELECT product_id, warehouse_id, COUNT(*) as duplicate_count
FROM Bronze.bz_inventory
GROUP BY product_id, warehouse_id
HAVING COUNT(*) > 1;
```

#### 5.3 Customer Email Uniqueness
**Check Name**: Customer Email Uniqueness Check
**Description**: Validate that email addresses are unique per customer
**Rationale**: Business rule requires unique email addresses to prevent customer identification issues.
**SQL Example**:
```sql
SELECT email, COUNT(*) as duplicate_count
FROM Bronze.bz_customers
GROUP BY email
HAVING COUNT(*) > 1;
```

### 6. **Data Completeness and Quality Checks**

#### 6.1 Product Name Length and Character Validation
**Check Name**: Product Name Format Validation
**Description**: Validate product names are within length limits and contain only allowed characters
**Rationale**: Business rules specify product names should be maximum 255 characters with no special characters except hyphens and spaces.
**SQL Example**:
```sql
SELECT COUNT(*) as format_violations
FROM Bronze.bz_products 
WHERE LENGTH(product_name) > 255 
   OR product_name REGEXP '[^A-Za-z0-9\s\-]';
```

#### 6.2 Category Standardization Check
**Check Name**: Product Category Standardization Validation
**Description**: Validate that product categories follow standardized naming conventions
**Rationale**: Business rules require standardized category names from predefined list for consistency.
**SQL Example**:
```sql
SELECT DISTINCT category, COUNT(*) as product_count
FROM Bronze.bz_products 
WHERE category NOT IN ('Electronics', 'Apparel', 'Furniture')
GROUP BY category;
```

#### 6.3 Quantity Ordered Business Logic Check
**Check Name**: Positive Quantity Ordered Validation
**Description**: Validate that all ordered quantities are positive integers
**Rationale**: Business rule states quantity_ordered must be positive integer as you cannot order zero or negative quantities.
**SQL Example**:
```sql
SELECT COUNT(*) as invalid_quantities
FROM Bronze.bz_order_details 
WHERE quantity_ordered <= 0;
```

### 7. **Temporal Data Quality Checks**

#### 7.1 Order Processing Timeline Validation
**Check Name**: Order to Shipment Timeline Check
**Description**: Validate that orders are shipped within business timeline requirements
**Rationale**: Business rule states orders must be shipped within 2 business days of order placement.
**SQL Example**:
```sql
SELECT o.order_id, o.order_date, s.shipment_date,
       DATEDIFF(day, o.order_date, s.shipment_date) as processing_days
FROM Bronze.bz_orders o
JOIN Bronze.bz_shipments s ON o.order_id = s.order_id
WHERE DATEDIFF(day, o.order_date, s.shipment_date) > 2;
```

#### 7.2 Return Processing Timeline Check
**Check Name**: Return Timeline Validation
**Description**: Validate that returns are processed within 30 days of original order
**Rationale**: Business rule states returns must be processed within 30 days of original order.
**SQL Example**:
```sql
SELECT r.return_id, o.order_date, 
       DATEDIFF(day, o.order_date, CURRENT_DATE()) as days_since_order
FROM Bronze.bz_returns r
JOIN Bronze.bz_orders o ON r.order_id = o.order_id
WHERE DATEDIFF(day, o.order_date, CURRENT_DATE()) > 30;
```

### 8. **Advanced Business Logic Checks**

#### 8.1 Supplier Risk Assessment Check
**Check Name**: Single Source Supplier Risk Check
**Description**: Identify products with only one supplier for risk management
**Rationale**: Business rule flags products with only one supplier for risk management and supplier diversification.
**SQL Example**:
```sql
SELECT p.product_id, p.product_name, COUNT(s.supplier_id) as supplier_count
FROM Bronze.bz_products p
LEFT JOIN Bronze.bz_suppliers s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(s.supplier_id) = 1;
```

#### 8.2 Return Rate Analysis Check
**Check Name**: High Return Rate Product Identification
**Description**: Identify products with return rates exceeding 5% threshold
**Rationale**: Business rule states products with return rates > 5% must be investigated for quality issues.
**SQL Example**:
```sql
WITH order_counts AS (
    SELECT od.product_id, COUNT(*) as total_orders
    FROM Bronze.bz_order_details od
    GROUP BY od.product_id
),
return_counts AS (
    SELECT od.product_id, COUNT(r.return_id) as total_returns
    FROM Bronze.bz_order_details od
    LEFT JOIN Bronze.bz_returns r ON od.order_id = r.order_id
    GROUP BY od.product_id
)
SELECT oc.product_id, 
       oc.total_orders, 
       COALESCE(rc.total_returns, 0) as total_returns,
       (COALESCE(rc.total_returns, 0) * 100.0 / oc.total_orders) as return_rate_percentage
FROM order_counts oc
LEFT JOIN return_counts rc ON oc.product_id = rc.product_id
WHERE (COALESCE(rc.total_returns, 0) * 100.0 / oc.total_orders) > 5;
```

### 9. **Data Freshness and Audit Checks**

#### 9.1 Data Load Timestamp Validation
**Check Name**: Data Freshness Check
**Description**: Validate that data is loaded within acceptable timeframes
**Rationale**: Business rule requires reports to use data that is no more than 24 hours old.
**SQL Example**:
```sql
SELECT 'Products' as table_name, 
       MAX(load_timestamp) as latest_load,
       DATEDIFF(hour, MAX(load_timestamp), CURRENT_TIMESTAMP()) as hours_since_load
FROM Bronze.bz_products
WHERE DATEDIFF(hour, MAX(load_timestamp), CURRENT_TIMESTAMP()) > 24
UNION ALL
SELECT 'Inventory' as table_name, 
       MAX(load_timestamp) as latest_load,
       DATEDIFF(hour, MAX(load_timestamp), CURRENT_TIMESTAMP()) as hours_since_load
FROM Bronze.bz_inventory
WHERE DATEDIFF(hour, MAX(load_timestamp), CURRENT_TIMESTAMP()) > 24;
```

#### 9.2 Source System Validation
**Check Name**: Source System Consistency Check
**Description**: Validate that source_system field is populated and consistent
**Rationale**: Ensures data lineage and traceability for audit and data governance purposes.
**SQL Example**:
```sql
SELECT 'Products' as table_name, 
       source_system, 
       COUNT(*) as record_count
FROM Bronze.bz_products
WHERE source_system IS NULL OR source_system = ''
GROUP BY source_system
UNION ALL
SELECT 'Inventory' as table_name, 
       source_system, 
       COUNT(*) as record_count
FROM Bronze.bz_inventory
WHERE source_system IS NULL OR source_system = ''
GROUP BY source_system;
```

### 10. **Comprehensive Data Quality Summary Check**

#### 10.1 Overall Data Quality Score
**Check Name**: Comprehensive Data Quality Assessment
**Description**: Generate overall data quality score across all validation checks
**Rationale**: Provides holistic view of data quality status for management reporting and continuous improvement.
**SQL Example**:
```sql
WITH quality_metrics AS (
    SELECT 
        'NULL_VIOLATIONS' as metric_type,
        (SELECT COUNT(*) FROM Bronze.bz_products WHERE product_id IS NULL OR product_name IS NULL OR category IS NULL) as violation_count,
        (SELECT COUNT(*) FROM Bronze.bz_products) as total_records
    UNION ALL
    SELECT 
        'REFERENTIAL_INTEGRITY' as metric_type,
        (SELECT COUNT(*) FROM Bronze.bz_suppliers s LEFT JOIN Bronze.bz_products p ON s.product_id = p.product_id WHERE p.product_id IS NULL) as violation_count,
        (SELECT COUNT(*) FROM Bronze.bz_suppliers) as total_records
    UNION ALL
    SELECT 
        'BUSINESS_RULES' as metric_type,
        (SELECT COUNT(*) FROM Bronze.bz_inventory i JOIN Bronze.bz_stock_levels sl ON i.product_id = sl.product_id WHERE i.quantity_available <= sl.reorder_threshold) as violation_count,
        (SELECT COUNT(*) FROM Bronze.bz_inventory) as total_records
)
SELECT 
    metric_type,
    violation_count,
    total_records,
    CASE 
        WHEN total_records = 0 THEN 100.0
        ELSE ((total_records - violation_count) * 100.0 / total_records)
    END as quality_score_percentage
FROM quality_metrics;
```

---

## **Implementation Recommendations**

### **Priority Levels**
1. **Critical (P1)**: NULL validations, Primary key uniqueness, Referential integrity
2. **High (P2)**: Business rule validations, Data format checks
3. **Medium (P3)**: Advanced analytics, Return rate analysis
4. **Low (P4)**: Data freshness, Audit trail validations

### **Automation Strategy**
- Implement automated daily data quality checks
- Set up alerts for critical violations
- Create dashboards for data quality monitoring
- Establish data quality SLAs and KPIs

### **Remediation Process**
- Define clear escalation procedures for data quality issues
- Establish data steward responsibilities
- Create data quality incident management process
- Implement continuous improvement feedback loop

---

## **API Cost**
apiCost: 0.45 USD