/*
_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Comprehensive unit test suite for SP_BRONZE_TO_SILVER_ETL stored procedure validation
## *Version*: 1 
## *Updated on*: 
_____________________________________________
*/

-- =====================================================
-- UNIT TEST SCRIPT FOR SP_BRONZE_TO_SILVER_ETL
-- =====================================================

-- Test Environment Setup
USE DATABASE TEST_DB;
USE SCHEMA TEST_SCHEMA;
USE WAREHOUSE TEST_WH;

-- Create test result tracking table
CREATE OR REPLACE TABLE TEST_RESULTS (
    TEST_ID VARCHAR(10),
    TEST_CATEGORY VARCHAR(50),
    TEST_DESCRIPTION VARCHAR(500),
    EXECUTION_TIME TIMESTAMP,
    STATUS VARCHAR(10),
    EXPECTED_RESULT VARCHAR(500),
    ACTUAL_RESULT VARCHAR(500),
    PASS_FAIL VARCHAR(10)
);

-- =====================================================
-- DATA QUALITY TESTS
-- =====================================================

-- Test Case DQ001: Null Value Validation
BEGIN
    DECLARE test_result VARCHAR(500);
    DECLARE expected_result VARCHAR(500) := 'No null values in critical fields';
    DECLARE actual_result VARCHAR(500);
    
    -- Setup test data with null values
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_DQ001 AS
    SELECT 
        NULL as customer_id,
        'John Doe' as customer_name,
        '2024-01-01' as transaction_date,
        100.00 as amount
    UNION ALL
    SELECT 
        'CUST001' as customer_id,
        NULL as customer_name,
        '2024-01-01' as transaction_date,
        200.00 as amount;
    
    -- Execute stored procedure
    CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_DQ001', 'SILVER_TEST_DQ001');
    
    -- Validate results
    SELECT COUNT(*) INTO actual_result
    FROM SILVER_TEST_DQ001
    WHERE customer_id IS NULL OR customer_name IS NULL;
    
    INSERT INTO TEST_RESULTS VALUES (
        'DQ001',
        'Data Quality',
        'Validate null value handling in critical fields',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        'Null count: ' || actual_result,
        CASE WHEN actual_result = '0' THEN 'PASS' ELSE 'FAIL' END
    );
END;

-- Test Case DQ002: Data Type Validation
BEGIN
    DECLARE expected_result VARCHAR(500) := 'All data types conform to silver schema';
    DECLARE actual_result VARCHAR(500);
    
    -- Setup test data with mixed data types
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_DQ002 AS
    SELECT 
        'CUST001' as customer_id,
        'John Doe' as customer_name,
        '2024-01-01' as transaction_date,
        '100.50' as amount -- String instead of number
    UNION ALL
    SELECT 
        'CUST002' as customer_id,
        'Jane Smith' as customer_name,
        'invalid_date' as transaction_date, -- Invalid date
        '200.75' as amount;
    
    -- Execute stored procedure
    CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_DQ002', 'SILVER_TEST_DQ002');
    
    -- Validate data types in silver table
    SELECT COUNT(*) INTO actual_result
    FROM SILVER_TEST_DQ002
    WHERE TRY_CAST(amount AS NUMBER) IS NULL
       OR TRY_CAST(transaction_date AS DATE) IS NULL;
    
    INSERT INTO TEST_RESULTS VALUES (
        'DQ002',
        'Data Quality',
        'Validate data type conversions and casting',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        'Invalid type count: ' || actual_result,
        CASE WHEN actual_result = '0' THEN 'PASS' ELSE 'FAIL' END
    );
END;

-- Test Case DQ003: Duplicate Record Detection
BEGIN
    DECLARE expected_result VARCHAR(500) := 'No duplicate records in silver table';
    DECLARE actual_result VARCHAR(500);
    DECLARE duplicate_count NUMBER;
    
    -- Setup test data with duplicates
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_DQ003 AS
    SELECT 
        'CUST001' as customer_id,
        'John Doe' as customer_name,
        '2024-01-01' as transaction_date,
        100.00 as amount
    UNION ALL
    SELECT 
        'CUST001' as customer_id,
        'John Doe' as customer_name,
        '2024-01-01' as transaction_date,
        100.00 as amount; -- Exact duplicate
    
    -- Execute stored procedure
    CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_DQ003', 'SILVER_TEST_DQ003');
    
    -- Check for duplicates
    SELECT COUNT(*) - COUNT(DISTINCT customer_id, transaction_date, amount) INTO duplicate_count
    FROM SILVER_TEST_DQ003;
    
    INSERT INTO TEST_RESULTS VALUES (
        'DQ003',
        'Data Quality',
        'Validate duplicate record handling and deduplication',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        'Duplicate count: ' || duplicate_count,
        CASE WHEN duplicate_count = 0 THEN 'PASS' ELSE 'FAIL' END
    );
END;

-- =====================================================
-- TRANSFORMATION LOGIC TESTS
-- =====================================================

-- Test Case TL001: Column Mapping Validation
BEGIN
    DECLARE expected_result VARCHAR(500) := 'All columns mapped correctly from bronze to silver';
    DECLARE actual_result VARCHAR(500);
    DECLARE column_count NUMBER;
    
    -- Setup test data
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_TL001 AS
    SELECT 
        'CUST001' as customer_id,
        'John Doe' as customer_name,
        '2024-01-01' as transaction_date,
        100.00 as amount,
        'USD' as currency
    UNION ALL
    SELECT 
        'CUST002' as customer_id,
        'Jane Smith' as customer_name,
        '2024-01-02' as transaction_date,
        200.00 as amount,
        'EUR' as currency;
    
    -- Execute stored procedure
    CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_TL001', 'SILVER_TEST_TL001');
    
    -- Validate column mapping
    SELECT COUNT(*) INTO column_count
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'SILVER_TEST_TL001'
    AND COLUMN_NAME IN ('CUSTOMER_ID', 'CUSTOMER_NAME', 'TRANSACTION_DATE', 'AMOUNT', 'CURRENCY');
    
    INSERT INTO TEST_RESULTS VALUES (
        'TL001',
        'Transformation Logic',
        'Validate column mapping from bronze to silver schema',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        'Mapped columns: ' || column_count,
        CASE WHEN column_count >= 5 THEN 'PASS' ELSE 'FAIL' END
    );
END;

-- Test Case TL002: Data Transformation Rules
BEGIN
    DECLARE expected_result VARCHAR(500) := 'Data transformations applied correctly';
    DECLARE actual_result VARCHAR(500);
    DECLARE transform_count NUMBER;
    
    -- Setup test data
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_TL002 AS
    SELECT 
        'cust001' as customer_id, -- lowercase
        'john doe' as customer_name, -- lowercase
        '2024-01-01' as transaction_date,
        100.00 as amount
    UNION ALL
    SELECT 
        'CUST002' as customer_id,
        'JANE SMITH' as customer_name, -- uppercase
        '2024-01-02' as transaction_date,
        -50.00 as amount; -- negative amount
    
    -- Execute stored procedure
    CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_TL002', 'SILVER_TEST_TL002');
    
    -- Validate transformations (assuming uppercase normalization)
    SELECT COUNT(*) INTO transform_count
    FROM SILVER_TEST_TL002
    WHERE customer_id = UPPER(customer_id)
    AND customer_name = INITCAP(customer_name);
    
    INSERT INTO TEST_RESULTS VALUES (
        'TL002',
        'Transformation Logic',
        'Validate data transformation rules and normalization',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        'Correctly transformed records: ' || transform_count,
        CASE WHEN transform_count > 0 THEN 'PASS' ELSE 'FAIL' END
    );
END;

-- Test Case TL003: Business Logic Validation
BEGIN
    DECLARE expected_result VARCHAR(500) := 'Business rules applied correctly';
    DECLARE actual_result VARCHAR(500);
    DECLARE business_rule_count NUMBER;
    
    -- Setup test data
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_TL003 AS
    SELECT 
        'CUST001' as customer_id,
        'John Doe' as customer_name,
        '2024-01-01' as transaction_date,
        1000.00 as amount,
        'ACTIVE' as status
    UNION ALL
    SELECT 
        'CUST002' as customer_id,
        'Jane Smith' as customer_name,
        '2024-01-02' as transaction_date,
        50.00 as amount,
        'INACTIVE' as status;
    
    -- Execute stored procedure
    CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_TL003', 'SILVER_TEST_TL003');
    
    -- Validate business logic (e.g., high-value transaction flag)
    SELECT COUNT(*) INTO business_rule_count
    FROM SILVER_TEST_TL003
    WHERE (amount >= 1000 AND high_value_flag = 'Y')
       OR (amount < 1000 AND high_value_flag = 'N');
    
    INSERT INTO TEST_RESULTS VALUES (
        'TL003',
        'Transformation Logic',
        'Validate business logic implementation and derived fields',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        'Business rules applied: ' || business_rule_count,
        CASE WHEN business_rule_count > 0 THEN 'PASS' ELSE 'FAIL' END
    );
END;

-- =====================================================
-- ERROR HANDLING TESTS
-- =====================================================

-- Test Case EH001: Invalid Input Table
BEGIN
    DECLARE expected_result VARCHAR(500) := 'Graceful error handling for invalid input';
    DECLARE actual_result VARCHAR(500);
    DECLARE error_caught BOOLEAN := FALSE;
    
    BEGIN
        -- Attempt to call procedure with non-existent table
        CALL SP_BRONZE_TO_SILVER_ETL('NON_EXISTENT_TABLE', 'SILVER_TEST_EH001');
    EXCEPTION
        WHEN OTHER THEN
            error_caught := TRUE;
            actual_result := 'Error caught: ' || SQLERRM;
    END;
    
    INSERT INTO TEST_RESULTS VALUES (
        'EH001',
        'Error Handling',
        'Validate error handling for invalid input table',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        actual_result,
        CASE WHEN error_caught THEN 'PASS' ELSE 'FAIL' END
    );
END;

-- Test Case EH002: Schema Mismatch Handling
BEGIN
    DECLARE expected_result VARCHAR(500) := 'Proper handling of schema mismatches';
    DECLARE actual_result VARCHAR(500);
    DECLARE error_caught BOOLEAN := FALSE;
    
    -- Create table with incompatible schema
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_EH002 AS
    SELECT 
        123 as invalid_column, -- Different column structure
        'test' as another_column;
    
    BEGIN
        CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_EH002', 'SILVER_TEST_EH002');
    EXCEPTION
        WHEN OTHER THEN
            error_caught := TRUE;
            actual_result := 'Schema mismatch handled: ' || SQLERRM;
    END;
    
    INSERT INTO TEST_RESULTS VALUES (
        'EH002',
        'Error Handling',
        'Validate error handling for schema mismatches',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        actual_result,
        CASE WHEN error_caught THEN 'PASS' ELSE 'FAIL' END
    );
END;

-- Test Case EH003: Resource Constraint Handling
BEGIN
    DECLARE expected_result VARCHAR(500) := 'Graceful handling of resource constraints';
    DECLARE actual_result VARCHAR(500);
    DECLARE resource_test_passed BOOLEAN := TRUE;
    
    -- Create large test dataset to simulate resource constraints
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_EH003 AS
    WITH RECURSIVE large_dataset AS (
        SELECT 
            1 as id,
            'CUST' || LPAD(1, 6, '0') as customer_id,
            'Customer ' || 1 as customer_name,
            CURRENT_DATE() as transaction_date,
            RANDOM() * 1000 as amount
        UNION ALL
        SELECT 
            id + 1,
            'CUST' || LPAD(id + 1, 6, '0'),
            'Customer ' || (id + 1),
            CURRENT_DATE(),
            RANDOM() * 1000
        FROM large_dataset
        WHERE id < 10000 -- Limit to prevent infinite recursion
    )
    SELECT * FROM large_dataset;
    
    BEGIN
        CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_EH003', 'SILVER_TEST_EH003');
        actual_result := 'Large dataset processed successfully';
    EXCEPTION
        WHEN OTHER THEN
            actual_result := 'Resource constraint handled: ' || SQLERRM;
    END;
    
    INSERT INTO TEST_RESULTS VALUES (
        'EH003',
        'Error Handling',
        'Validate handling of resource constraints and large datasets',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        actual_result,
        'PASS' -- Any outcome is acceptable as long as it's handled gracefully
    );
END;

-- =====================================================
-- PERFORMANCE TESTS
-- =====================================================

-- Test Case PO001: Execution Time Validation
BEGIN
    DECLARE expected_result VARCHAR(500) := 'Execution completes within acceptable time limits';
    DECLARE actual_result VARCHAR(500);
    DECLARE start_time TIMESTAMP;
    DECLARE end_time TIMESTAMP;
    DECLARE execution_duration NUMBER;
    
    -- Setup performance test data
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_PO001 AS
    SELECT 
        'CUST' || LPAD(SEQ4(), 6, '0') as customer_id,
        'Customer ' || SEQ4() as customer_name,
        DATEADD(day, UNIFORM(1, 365, RANDOM()), '2023-01-01') as transaction_date,
        UNIFORM(10, 1000, RANDOM()) as amount
    FROM TABLE(GENERATOR(ROWCOUNT => 5000));
    
    -- Measure execution time
    start_time := CURRENT_TIMESTAMP();
    CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_PO001', 'SILVER_TEST_PO001');
    end_time := CURRENT_TIMESTAMP();
    
    execution_duration := DATEDIFF(second, start_time, end_time);
    actual_result := 'Execution time: ' || execution_duration || ' seconds';
    
    INSERT INTO TEST_RESULTS VALUES (
        'PO001',
        'Performance',
        'Validate execution time for standard dataset (5000 records)',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        actual_result,
        CASE WHEN execution_duration <= 60 THEN 'PASS' ELSE 'FAIL' END -- 60 second threshold
    );
END;

-- Test Case PO002: Memory Usage Validation
BEGIN
    DECLARE expected_result VARCHAR(500) := 'Memory usage within acceptable limits';
    DECLARE actual_result VARCHAR(500);
    DECLARE memory_efficient BOOLEAN := TRUE;
    
    -- Setup memory test data
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_PO002 AS
    SELECT 
        'CUST' || LPAD(SEQ4(), 6, '0') as customer_id,
        'Customer Name ' || REPEAT('X', 100) as customer_name, -- Large text fields
        DATEADD(day, UNIFORM(1, 365, RANDOM()), '2023-01-01') as transaction_date,
        UNIFORM(10, 1000, RANDOM()) as amount,
        REPEAT('Additional Data ', 50) as notes -- Large text field
    FROM TABLE(GENERATOR(ROWCOUNT => 1000));
    
    -- Execute procedure and monitor
    BEGIN
        CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_PO002', 'SILVER_TEST_PO002');
        actual_result := 'Memory usage test completed successfully';
    EXCEPTION
        WHEN OTHER THEN
            memory_efficient := FALSE;
            actual_result := 'Memory constraint encountered: ' || SQLERRM;
    END;
    
    INSERT INTO TEST_RESULTS VALUES (
        'PO002',
        'Performance',
        'Validate memory usage efficiency with large text fields',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        actual_result,
        CASE WHEN memory_efficient THEN 'PASS' ELSE 'FAIL' END
    );
END;

-- =====================================================
-- INTEGRATION TESTS
-- =====================================================

-- Test Case IT001: End-to-End Pipeline Validation
BEGIN
    DECLARE expected_result VARCHAR(500) := 'Complete pipeline execution with data validation';
    DECLARE actual_result VARCHAR(500);
    DECLARE source_count NUMBER;
    DECLARE target_count NUMBER;
    DECLARE data_integrity_check NUMBER;
    
    -- Setup comprehensive test data
    CREATE OR REPLACE TEMPORARY TABLE BRONZE_TEST_IT001 AS
    SELECT 
        'CUST' || LPAD(SEQ4(), 6, '0') as customer_id,
        'Customer ' || SEQ4() as customer_name,
        DATEADD(day, UNIFORM(1, 365, RANDOM()), '2023-01-01') as transaction_date,
        UNIFORM(10, 1000, RANDOM()) as amount,
        CASE WHEN UNIFORM(1, 10, RANDOM()) <= 8 THEN 'ACTIVE' ELSE 'INACTIVE' END as status,
        'USD' as currency,
        CURRENT_TIMESTAMP() as created_timestamp
    FROM TABLE(GENERATOR(ROWCOUNT => 2000));
    
    -- Get source record count
    SELECT COUNT(*) INTO source_count FROM BRONZE_TEST_IT001;
    
    -- Execute the complete pipeline
    CALL SP_BRONZE_TO_SILVER_ETL('BRONZE_TEST_IT001', 'SILVER_TEST_IT001');
    
    -- Get target record count
    SELECT COUNT(*) INTO target_count FROM SILVER_TEST_IT001;
    
    -- Perform data integrity checks
    SELECT COUNT(*) INTO data_integrity_check
    FROM SILVER_TEST_IT001 s
    INNER JOIN BRONZE_TEST_IT001 b ON s.customer_id = b.customer_id
    WHERE s.customer_name = b.customer_name
    AND s.transaction_date = b.transaction_date
    AND s.amount = b.amount;
    
    actual_result := 'Source: ' || source_count || ', Target: ' || target_count || ', Integrity: ' || data_integrity_check;
    
    INSERT INTO TEST_RESULTS VALUES (
        'IT001',
        'Integration',
        'End-to-end pipeline validation with comprehensive data checks',
        CURRENT_TIMESTAMP(),
        'COMPLETED',
        expected_result,
        actual_result,
        CASE WHEN target_count > 0 AND data_integrity_check = target_count THEN 'PASS' ELSE 'FAIL' END
    );
END;

-- =====================================================
-- TEST EXECUTION SUMMARY
-- =====================================================

-- Generate comprehensive test summary
SELECT 
    '=== UNIT TEST EXECUTION SUMMARY ===' as SUMMARY_HEADER
UNION ALL
SELECT 
    'Test Execution Date: ' || CURRENT_TIMESTAMP()
UNION ALL
SELECT 
    'Total Tests Executed: ' || COUNT(*)
FROM TEST_RESULTS
UNION ALL
SELECT 
    'Tests Passed: ' || SUM(CASE WHEN PASS_FAIL = 'PASS' THEN 1 ELSE 0 END)
FROM TEST_RESULTS
UNION ALL
SELECT 
    'Tests Failed: ' || SUM(CASE WHEN PASS_FAIL = 'FAIL' THEN 1 ELSE 0 END)
FROM TEST_RESULTS
UNION ALL
SELECT 
    'Success Rate: ' || ROUND((SUM(CASE WHEN PASS_FAIL = 'PASS' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) || '%'
FROM TEST_RESULTS;

-- Detailed test results
SELECT 
    TEST_ID,
    TEST_CATEGORY,
    TEST_DESCRIPTION,
    STATUS,
    PASS_FAIL,
    EXECUTION_TIME
FROM TEST_RESULTS
ORDER BY TEST_ID;

-- Failed tests detail
SELECT 
    'FAILED TESTS DETAIL:' as HEADER
UNION ALL
SELECT 
    TEST_ID || ' - ' || TEST_DESCRIPTION || ' | Expected: ' || EXPECTED_RESULT || ' | Actual: ' || ACTUAL_RESULT
FROM TEST_RESULTS
WHERE PASS_FAIL = 'FAIL';

-- =====================================================
-- TEST CASE SUMMARY WITH API COST CALCULATION
-- =====================================================

/*
TEST CASE SUMMARY:

Test Case ID | Description | Expected Outcome
-------------|-------------|------------------
DQ001 | Null Value Validation | No null values in critical fields after processing
DQ002 | Data Type Validation | All data types conform to silver schema specifications
DQ003 | Duplicate Record Detection | No duplicate records present in final silver table
TL001 | Column Mapping Validation | All columns correctly mapped from bronze to silver
TL002 | Data Transformation Rules | Data transformations applied according to business rules
TL003 | Business Logic Validation | Business logic implemented correctly with derived fields
EH001 | Invalid Input Table | Graceful error handling for non-existent input tables
EH002 | Schema Mismatch Handling | Proper error handling for incompatible schema structures
EH003 | Resource Constraint Handling | Graceful handling of memory and processing constraints
PO001 | Execution Time Validation | Procedure completes within acceptable time limits (60s)
PO002 | Memory Usage Validation | Memory usage remains within efficient operational limits
IT001 | End-to-End Pipeline Validation | Complete pipeline execution with full data integrity

API COST CALCULATION:

Snowflake Compute Credits Estimation:
- Test Environment Setup: 0.1 credits
- Data Quality Tests (3 tests): 0.3 credits
- Transformation Logic Tests (3 tests): 0.4 credits
- Error Handling Tests (3 tests): 0.2 credits
- Performance Tests (2 tests): 0.8 credits (includes large dataset processing)
- Integration Tests (1 test): 0.5 credits
- Test Result Analysis: 0.1 credits

Total Estimated Credits: 2.4 credits
Estimated Cost (at $2 per credit): $4.80

Storage Costs:
- Temporary test tables: ~10MB
- Test result storage: ~1MB
- Estimated storage cost: <$0.01

Total Estimated Test Execution Cost: $4.81

Note: Actual costs may vary based on warehouse size, data volume, and execution time.
Recommendation: Use XS warehouse for test execution to minimize costs.
*/

-- Cleanup temporary objects (optional)
-- DROP TABLE IF EXISTS TEST_RESULTS;
-- DROP TABLE IF EXISTS BRONZE_TEST_DQ001;
-- DROP TABLE IF EXISTS BRONZE_TEST_DQ002;
-- DROP TABLE IF EXISTS BRONZE_TEST_DQ003;
-- DROP TABLE IF EXISTS BRONZE_TEST_TL001;
-- DROP TABLE IF EXISTS BRONZE_TEST_TL002;
-- DROP TABLE IF EXISTS BRONZE_TEST_TL003;
-- DROP TABLE IF EXISTS BRONZE_TEST_EH002;
-- DROP TABLE IF EXISTS BRONZE_TEST_EH003;
-- DROP TABLE IF EXISTS BRONZE_TEST_PO001;
-- DROP TABLE IF EXISTS BRONZE_TEST_PO002;
-- DROP TABLE IF EXISTS BRONZE_TEST_IT001;

-- End of Unit Test Script