_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Comprehensive unit test cases for Bronze to Silver layer data transformation stored procedure
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- Unit Test Cases for sp_bronze_to_silver_transformation
-- Bronze to Silver Layer Data Transformation Tests
-- =====================================================

-- Test Setup and Cleanup Procedures
CREATE OR REPLACE PROCEDURE setup_test_environment()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Create test schemas if they don't exist
    CREATE SCHEMA IF NOT EXISTS test_bronze;
    CREATE SCHEMA IF NOT EXISTS test_silver;
    
    -- Create test tables with sample data
    CREATE OR REPLACE TABLE test_bronze.bz_products AS
    SELECT * FROM bronze.bz_products LIMIT 0;
    
    CREATE OR REPLACE TABLE test_bronze.bz_suppliers AS
    SELECT * FROM bronze.bz_suppliers LIMIT 0;
    
    CREATE OR REPLACE TABLE test_bronze.bz_warehouses AS
    SELECT * FROM bronze.bz_warehouses LIMIT 0;
    
    CREATE OR REPLACE TABLE test_bronze.bz_inventory AS
    SELECT * FROM bronze.bz_inventory LIMIT 0;
    
    CREATE OR REPLACE TABLE test_bronze.bz_customers AS
    SELECT * FROM bronze.bz_customers LIMIT 0;
    
    CREATE OR REPLACE TABLE test_bronze.bz_orders AS
    SELECT * FROM bronze.bz_orders LIMIT 0;
    
    CREATE OR REPLACE TABLE test_bronze.bz_order_details AS
    SELECT * FROM bronze.bz_order_details LIMIT 0;
    
    CREATE OR REPLACE TABLE test_bronze.bz_shipments AS
    SELECT * FROM bronze.bz_shipments LIMIT 0;
    
    -- Create corresponding silver test tables
    CREATE OR REPLACE TABLE test_silver.si_products LIKE silver.si_products;
    CREATE OR REPLACE TABLE test_silver.si_suppliers LIKE silver.si_suppliers;
    CREATE OR REPLACE TABLE test_silver.si_warehouses LIKE silver.si_warehouses;
    CREATE OR REPLACE TABLE test_silver.si_inventory LIKE silver.si_inventory;
    CREATE OR REPLACE TABLE test_silver.si_customers LIKE silver.si_customers;
    CREATE OR REPLACE TABLE test_silver.si_orders LIKE silver.si_orders;
    CREATE OR REPLACE TABLE test_silver.si_order_details LIKE silver.si_order_details;
    CREATE OR REPLACE TABLE test_silver.si_shipments LIKE silver.si_shipments;
    CREATE OR REPLACE TABLE test_silver.si_data_quality_errors LIKE silver.si_data_quality_errors;
    CREATE OR REPLACE TABLE test_silver.si_pipeline_audit_log LIKE silver.si_pipeline_audit_log;
    
    RETURN 'Test environment setup completed';
END;
$$;

CREATE OR REPLACE PROCEDURE cleanup_test_environment()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    DROP SCHEMA IF EXISTS test_bronze CASCADE;
    DROP SCHEMA IF EXISTS test_silver CASCADE;
    RETURN 'Test environment cleaned up';
END;
$$;

-- =====================================================
-- DATA QUALITY TESTS
-- =====================================================

-- Test Case ID: DQ_001
-- Description: Validate null value handling in products table
-- Expected Outcome: Records with null product_id should be logged as errors
CREATE OR REPLACE PROCEDURE test_dq_001_null_validation()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    error_count INTEGER;
    test_result STRING;
BEGIN
    -- Setup test data with null product_id
    INSERT INTO test_bronze.bz_products (product_id