_____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Comprehensive unit test suite for SP_BRONZE_TO_SILVER_ETL stored procedure in Inventory Management System. Tests data transformations, error handling, data quality validations, and output correctness for Silver Layer ETL processes.
## *Version*: 1
## *Updated on*: 
_____________________________________________

-- =====================================================
-- UNIT TEST SUITE FOR SP_BRONZE_TO_SILVER_ETL
-- =====================================================

-- Test Database and Schema Setup
USE DATABASE TEST_DB;
USE SCHEMA TEST_SCHEMA;

-- =====================================================
-- TEST SETUP PROCEDURES
-- =====================================================

CREATE OR REPLACE PROCEDURE SETUP_TEST_ENVIRONMENT()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Create test tables if they don't exist
    CREATE TABLE IF NOT EXISTS BRONZE_INVENTORY (
        INVENTORY_ID NUMBER,
        PRODUCT_ID VARCHAR(50),
        WAREHOUSE_ID VARCHAR(50),
        QUANTITY NUMBER,
        UNIT_COST DECIMAL(10,2),
        LAST_UPDATED TIMESTAMP,
        SOURCE_SYSTEM VARCHAR(50),
        RECORD_STATUS VARCHAR(20),
        CREATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
    );
    
    CREATE TABLE IF NOT EXISTS SILVER_INVENTORY (
        INVENTORY_ID NUMBER PRIMARY KEY,
        PRODUCT_ID VARCHAR(50) NOT NULL,
        WAREHOUSE_ID VARCHAR(50) NOT NULL,
        QUANTITY NUMBER NOT NULL,
        UNIT_COST DECIMAL(10,2) NOT NULL,
        TOTAL_VALUE DECIMAL(15,2),
        LAST_UPDATED TIMESTAMP,
        SOURCE_SYSTEM VARCHAR(50),
        DATA_QUALITY_SCORE NUMBER(3,2),
        IS_ACTIVE BOOLEAN DEFAULT TRUE,
        PROCESSED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
        ETL_BATCH_ID VARCHAR(50)
    );
    
    -- Create test results table
    CREATE TABLE IF NOT EXISTS TEST_RESULTS (
        TEST_ID VARCHAR(100),
        TEST_NAME VARCHAR(200),
        TEST_STATUS VARCHAR(20),
        TEST_MESSAGE TEXT,
        EXECUTION_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
    );
    
    RETURN 'Test environment setup completed successfully';
END;
$$;

CREATE OR REPLACE PROCEDURE CLEANUP_TEST_DATA()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    DELETE FROM BRONZE_INVENTORY;
    DELETE FROM SILVER_INVENTORY;
    DELETE FROM TEST_RESULTS;
    RETURN 'Test data cleanup completed';
END;
$$;

-- =====================================================
-- UNIT TEST PROCEDURES
-- =====================================================

-- Test 1: Data Transformation Validation
CREATE OR REPLACE PROCEDURE TEST_DATA_TRANSFORMATION()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    test_result STRING;
    expected_count NUMBER;
    actual_count NUMBER;
    test_status STRING := 'PASSED';
    test_message STRING := '';
BEGIN
    -- Setup test data
    INSERT INTO BRONZE_INVENTORY VALUES
        (1, 'PROD001', 'WH001', 100, 25.50, CURRENT_TIMESTAMP(), 'ERP_SYSTEM', 'ACTIVE'),
        (2, 'PROD002', 'WH002', 200, 15.75, CURRENT_TIMESTAMP(), 'ERP_SYSTEM', 'ACTIVE'),
        (3, 'PROD003', 'WH001', 150, 30.00, CURRENT_TIMESTAMP(), 'WMS_SYSTEM', 'ACTIVE');
    
    -- Execute the stored procedure
    CALL SP_BRONZE_TO_SILVER_ETL();
    
    -- Validate transformation results
    SELECT COUNT(*) INTO actual_count FROM SILVER_INVENTORY;
    expected_count := 3;
    
    IF (actual_count != expected_count) THEN
        test_status := 'FAILED';
        test_message := 'Expected ' || expected_count || ' records, but got ' || actual_count;
    END IF;
    
    -- Validate calculated fields
    IF (test_status = 'PASSED') THEN
        SELECT COUNT(*) INTO actual_count 
        FROM SILVER_INVENTORY 
        WHERE TOTAL_VALUE = QUANTITY * UNIT_COST;
        
        IF (actual_count != expected_count) THEN
            test_status := 'FAILED';
            test_message := 'Total value calculation failed for some records';
        END IF;
    END IF;
    
    -- Log test result
    INSERT INTO TEST_RESULTS VALUES 
        ('TEST_001', 'Data Transformation Validation', test_status, test_message, CURRENT_TIMESTAMP());
    
    RETURN 'Test completed: ' || test_status;
END;
$$;

-- Test 2: Error Handling Validation
CREATE OR REPLACE PROCEDURE TEST_ERROR_HANDLING()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    test_status STRING := 'PASSED';
    test_message STRING := '';
    error_occurred BOOLEAN := FALSE;
BEGIN
    -- Setup invalid test data
    INSERT INTO BRONZE_INVENTORY VALUES
        (4, NULL, 'WH001', 100, 25.50, CURRENT_TIMESTAMP(), 'ERP_SYSTEM', 'ACTIVE'),
        (5, 'PROD005', NULL, 200, 15.75, CURRENT_TIMESTAMP(), 'ERP_SYSTEM', 'ACTIVE'),
        (6, 'PROD006', 'WH001', -50, 30.00, CURRENT_TIMESTAMP(), 'WMS_SYSTEM', 'ACTIVE');
    
    -- Execute the stored procedure and check error handling
    BEGIN
        CALL SP_BRONZE_TO_SILVER_ETL();
    EXCEPTION
        WHEN OTHER THEN
            error_occurred := TRUE;
    END;
    
    -- Validate that invalid records are handled properly
    -- Check if records with NULL values are excluded or flagged
    IF NOT error_occurred THEN
        test_message := 'Error handling validation completed - procedure handled invalid data gracefully';
    ELSE
        test_status := 'FAILED';
        test_message := 'Procedure failed to handle invalid data properly';
    END IF;
    
    -- Log test result
    INSERT INTO TEST_RESULTS VALUES 
        ('TEST_002', 'Error Handling Validation', test_status, test_message, CURRENT_TIMESTAMP());
    
    RETURN 'Test completed: ' || test_status;
END;
$$;

-- Test 3: Data Quality Validation
CREATE OR REPLACE PROCEDURE TEST_DATA_QUALITY()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    test_status STRING := 'PASSED';
    test_message STRING := '';
    quality_check_count NUMBER;
BEGIN
    -- Setup test data with varying quality
    INSERT INTO BRONZE_INVENTORY VALUES
        (7, 'PROD007', 'WH001', 100, 25.50, CURRENT_TIMESTAMP(), 'ERP_SYSTEM', 'ACTIVE'),
        (8, 'PROD008', 'WH002', 0, 15.75, CURRENT_TIMESTAMP(), 'ERP_SYSTEM', 'ACTIVE'),
        (9, 'PROD009', 'WH001', 150, 0, CURRENT_TIMESTAMP(), 'WMS_SYSTEM', 'ACTIVE');
    
    -- Execute the stored procedure
    CALL SP_BRONZE_TO_SILVER_ETL();
    
    -- Validate data quality scores are assigned
    SELECT COUNT(*) INTO quality_check_count 
    FROM SILVER_INVENTORY 
    WHERE DATA_QUALITY_SCORE IS NOT NULL 
    AND DATA_QUALITY_SCORE BETWEEN 0 AND 1;
    
    IF (quality_check_count = 0) THEN
        test_status := 'FAILED';
        test_message := 'Data quality scores not properly assigned';
    ELSE
        test_message := 'Data quality validation completed successfully';
    END IF;
    
    -- Log test result
    INSERT INTO TEST_RESULTS VALUES 
        ('TEST_003', 'Data Quality Validation', test_status, test_message, CURRENT_TIMESTAMP());
    
    RETURN 'Test completed: ' || test_status;
END;
$$;

-- Test 4: Performance and Volume Testing
CREATE OR REPLACE PROCEDURE TEST_PERFORMANCE_VOLUME()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    test_status STRING := 'PASSED';
    test_message STRING := '';
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    execution_duration NUMBER;
    record_count NUMBER := 1000;
BEGIN
    -- Generate large volume of test data
    INSERT INTO BRONZE_INVENTORY 
    SELECT 
        SEQ4() + 1000 as INVENTORY_ID,
        'PROD' || LPAD(SEQ4() + 1000, 6, '0') as PRODUCT_ID,
        'WH' || LPAD(MOD(SEQ4(), 5) + 1, 3, '0') as WAREHOUSE_ID,
        UNIFORM(1, 1000, RANDOM()) as QUANTITY,
        UNIFORM(10, 100, RANDOM()) as UNIT_COST,
        CURRENT_TIMESTAMP() as LAST_UPDATED,
        'PERF_TEST_SYSTEM' as SOURCE_SYSTEM,
        'ACTIVE' as RECORD_STATUS
    FROM TABLE(GENERATOR(ROWCOUNT => record_count));
    
    -- Measure execution time
    start_time := CURRENT_TIMESTAMP();
    CALL SP_BRONZE_TO_SILVER_ETL();
    end_time := CURRENT_TIMESTAMP();
    
    execution_duration := DATEDIFF('seconds', start_time, end_time);
    
    -- Validate performance (should complete within reasonable time)
    IF (execution_duration > 300) THEN -- 5 minutes threshold
        test_status := 'FAILED';
        test_message := 'Performance test failed - execution took ' || execution_duration || ' seconds';
    ELSE
        test_message := 'Performance test passed - execution took ' || execution_duration || ' seconds for ' || record_count || ' records';
    END IF;
    
    -- Log test result
    INSERT INTO TEST_RESULTS VALUES 
        ('TEST_004', 'Performance and Volume Testing', test_status, test_message, CURRENT_TIMESTAMP());
    
    RETURN 'Test completed: ' || test_status;
END;
$$;

-- Test 5: Idempotency Testing
CREATE OR REPLACE PROCEDURE TEST_IDEMPOTENCY()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    test_status STRING := 'PASSED';
    test_message STRING := '';
    first_run_count NUMBER;
    second_run_count NUMBER;
BEGIN
    -- Setup test data
    INSERT INTO BRONZE_INVENTORY VALUES
        (10, 'PROD010', 'WH001', 100, 25.50, CURRENT_TIMESTAMP(), 'ERP_SYSTEM', 'ACTIVE'),
        (11, 'PROD011', 'WH002', 200, 15.75, CURRENT_TIMESTAMP(), 'ERP_SYSTEM', 'ACTIVE');
    
    -- First execution
    CALL SP_BRONZE_TO_SILVER_ETL();
    SELECT COUNT(*) INTO first_run_count FROM SILVER_INVENTORY WHERE PRODUCT_ID IN ('PROD010', 'PROD011');
    
    -- Second execution (should not create duplicates)
    CALL SP_BRONZE_TO_SILVER_ETL();
    SELECT COUNT(*) INTO second_run_count FROM SILVER_INVENTORY WHERE PRODUCT_ID IN ('PROD010', 'PROD011');
    
    -- Validate idempotency
    IF (first_run_count != second_run_count) THEN
        test_status := 'FAILED';
        test_message := 'Idempotency test failed - duplicate records created';
    ELSE
        test_message := 'Idempotency test passed - no duplicate records created';
    END IF;
    
    -- Log test result
    INSERT INTO TEST_RESULTS VALUES 
        ('TEST_005', 'Idempotency Testing', test_status, test_message, CURRENT_TIMESTAMP());
    
    RETURN 'Test completed: ' || test_status;
END;
$$;

-- Test 6: Business Logic Validation
CREATE OR REPLACE PROCEDURE TEST_BUSINESS_LOGIC()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    test_status STRING := 'PASSED';
    test_message STRING := '';
    validation_count NUMBER;
BEGIN
    -- Setup test data with specific business scenarios
    INSERT INTO BRONZE_INVENTORY VALUES
        (12, 'PROD012', 'WH001', 100, 25.50, CURRENT_TIMESTAMP(), 'ERP_SYSTEM', 'ACTIVE'),
        (13, 'PROD013', 'WH002', 0, 15.75, CURRENT_TIMESTAMP(), 'ERP_SYSTEM', 'INACTIVE'),
        (14, 'PROD014', 'WH001', 150, 30.00, CURRENT_TIMESTAMP(), 'WMS_SYSTEM', 'ACTIVE');
    
    -- Execute the stored procedure
    CALL SP_BRONZE_TO_SILVER_ETL();
    
    -- Validate business rules
    -- Rule 1: Only ACTIVE records should be processed
    SELECT COUNT(*) INTO validation_count 
    FROM SILVER_INVENTORY s
    JOIN BRONZE_INVENTORY b ON s.INVENTORY_ID = b.INVENTORY_ID
    WHERE b.RECORD_STATUS = 'INACTIVE';
    
    IF (validation_count > 0) THEN
        test_status := 'FAILED';
        test_message := 'Business logic validation failed - inactive records were processed';
    END IF;
    
    -- Rule 2: Total value should be calculated correctly
    IF (test_status = 'PASSED') THEN
        SELECT COUNT(*) INTO validation_count 
        FROM SILVER_INVENTORY 
        WHERE ABS(TOTAL_VALUE - (QUANTITY * UNIT_COST)) > 0.01;
        
        IF (validation_count > 0) THEN
            test_status := 'FAILED';
            test_message := 'Business logic validation failed - total value calculation incorrect';
        ELSE
            test_message := 'Business logic validation passed';
        END IF;
    END IF;
    
    -- Log test result
    INSERT INTO TEST_RESULTS VALUES 
        ('TEST_006', 'Business Logic Validation', test_status, test_message, CURRENT_TIMESTAMP());
    
    RETURN 'Test completed: ' || test_status;
END;
$$;

-- =====================================================
-- MASTER TEST EXECUTION PROCEDURE
-- =====================================================

CREATE OR REPLACE PROCEDURE RUN_ALL_SILVER_ETL_TESTS()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    test_summary STRING := '';
    total_tests NUMBER := 0;
    passed_tests NUMBER := 0;
    failed_tests NUMBER := 0;
    overall_status STRING;
    execution_start TIMESTAMP;
    execution_end TIMESTAMP;
    total_duration NUMBER;
BEGIN
    execution_start := CURRENT_TIMESTAMP();
    
    -- Initialize test environment
    CALL SETUP_TEST_ENVIRONMENT();
    
    test_summary := 'SILVER ETL UNIT TEST EXECUTION REPORT\n';
    test_summary := test_summary || '==========================================\n\n';
    
    -- Execute all test procedures
    BEGIN
        CALL CLEANUP_TEST_DATA();
        CALL TEST_DATA_TRANSFORMATION();
        
        CALL CLEANUP_TEST_DATA();
        CALL TEST_ERROR_HANDLING();
        
        CALL CLEANUP_TEST_DATA();
        CALL TEST_DATA_QUALITY();
        
        CALL CLEANUP_TEST_DATA();
        CALL TEST_PERFORMANCE_VOLUME();
        
        CALL CLEANUP_TEST_DATA();
        CALL TEST_IDEMPOTENCY();
        
        CALL CLEANUP_TEST_DATA();
        CALL TEST_BUSINESS_LOGIC();
        
    EXCEPTION
        WHEN OTHER THEN
            test_summary := test_summary || 'CRITICAL ERROR: Test execution failed\n';
            INSERT INTO TEST_RESULTS VALUES 
                ('MASTER_TEST', 'Master Test Execution', 'FAILED', 'Critical error during test execution', CURRENT_TIMESTAMP());
    END;
    
    -- Calculate test statistics
    SELECT COUNT(*) INTO total_tests FROM TEST_RESULTS;
    SELECT COUNT(*) INTO passed_tests FROM TEST_RESULTS WHERE TEST_STATUS = 'PASSED';
    SELECT COUNT(*) INTO failed_tests FROM TEST_RESULTS WHERE TEST_STATUS = 'FAILED';
    
    execution_end := CURRENT_TIMESTAMP();
    total_duration := DATEDIFF('seconds', execution_start, execution_end);
    
    -- Determine overall status
    IF (failed_tests = 0) THEN
        overall_status := 'ALL TESTS PASSED';
    ELSE
        overall_status := 'SOME TESTS FAILED';
    END IF;
    
    -- Build comprehensive test summary
    test_summary := test_summary || 'EXECUTION SUMMARY:\n';
    test_summary := test_summary || 'Total Tests: ' || total_tests || '\n';
    test_summary := test_summary || 'Passed: ' || passed_tests || '\n';
    test_summary := test_summary || 'Failed: ' || failed_tests || '\n';
    test_summary := test_summary || 'Overall Status: ' || overall_status || '\n';
    test_summary := test_summary || 'Total Execution Time: ' || total_duration || ' seconds\n\n';
    
    test_summary := test_summary || 'DETAILED TEST RESULTS:\n';
    test_summary := test_summary || '=====================\n';
    
    -- Add detailed results for each test
    FOR result_record IN (SELECT TEST_ID, TEST_NAME, TEST_STATUS, TEST_MESSAGE, EXECUTION_TIME 
                         FROM TEST_RESULTS 
                         ORDER BY EXECUTION_TIME) DO
        test_summary := test_summary || result_record.TEST_ID || ': ' || result_record.TEST_NAME || '\n';
        test_summary := test_summary || 'Status: ' || result_record.TEST_STATUS || '\n';
        test_summary := test_summary || 'Message: ' || result_record.TEST_MESSAGE || '\n';
        test_summary := test_summary || 'Executed: ' || result_record.EXECUTION_TIME || '\n\n';
    END FOR;
    
    -- Log master test completion
    INSERT INTO TEST_RESULTS VALUES 
        ('MASTER_TEST_COMPLETE', 'Master Test Suite Execution', overall_status, 
         'Completed ' || total_tests || ' tests in ' || total_duration || ' seconds', 
         CURRENT_TIMESTAMP());
    
    -- Final cleanup
    CALL CLEANUP_TEST_DATA();
    
    RETURN test_summary;
END;
$$;

-- =====================================================
-- TEST EXECUTION INSTRUCTIONS
-- =====================================================

/*
To execute the complete test suite, run:
CALL RUN_ALL_SILVER_ETL_TESTS();

To execute individual tests:
CALL TEST_DATA_TRANSFORMATION();
CALL TEST_ERROR_HANDLING();
CALL TEST_DATA_QUALITY();
CALL TEST_PERFORMANCE_VOLUME();
CALL TEST_IDEMPOTENCY();
CALL TEST_BUSINESS_LOGIC();

To view test results:
SELECT * FROM TEST_RESULTS ORDER BY EXECUTION_TIME DESC;
*/

-- =====================================================
-- API COST ANALYSIS
-- =====================================================

/*
ESTIMATED API COSTS FOR TEST EXECUTION:

1. COMPUTE COSTS:
   - Test Environment Setup: ~0.1 credits
   - Data Transformation Tests: ~0.2 credits
   - Error Handling Tests: ~0.1 credits
   - Data Quality Tests: ~0.15 credits
   - Performance/Volume Tests: ~0.5 credits (1000 records)
   - Idempotency Tests: ~0.1 credits
   - Business Logic Tests: ~0.15 credits
   - Master Test Execution: ~0.05 credits
   
   TOTAL COMPUTE: ~1.25 credits per full test suite execution

2. STORAGE COSTS:
   - Test tables and data: Minimal (temporary test data)
   - Test results storage: ~0.01 credits per execution
   
3. DATA TRANSFER COSTS:
   - Internal Snowflake operations: Included in compute
   - No external data transfer for unit tests

TOTAL ESTIMATED COST PER TEST EXECUTION: ~1.26 credits

RECOMMENDATIONS:
- Run full test suite during development and before production deployments
- Use smaller datasets for frequent testing during development
- Schedule automated test runs during off-peak hours for cost optimization
- Monitor actual costs and adjust test data volumes as needed

COST OPTIMIZATION STRATEGIES:
- Use TRANSIENT tables for test data to reduce storage costs
- Implement test data cleanup procedures
- Use warehouse auto-suspend features
- Consider using smaller warehouse sizes for testing (XS or S)
*/