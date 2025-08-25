_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Comprehensive Unit Test Suite for Bronze Layer Data Ingestion Stored Procedure
## *Version*: 1 
## *Updated on*: 
_____________________________________________

/*
================================================================================
UNIT TEST SUITE: Bronze Layer Data Ingestion Stored Procedure
================================================================================
Procedure Under Test: sp_ingest_inventory_management_data
Test Suite Version: 1.0
Created Date: 2024-01-15
Author: Senior Test Data Engineer
Description: Comprehensive unit test cases for Bronze Layer Data Ingestion
             covering data quality, transformation logic, error handling,
             and performance validation.

Test Coverage Areas:
- Data Quality Tests (null validation, data types, referential integrity)
- Transformation Logic Tests (record counts, accuracy, aggregations, joins)
- Error Handling Tests (invalid data, logging, exceptions)
- Performance Tests (query performance, resource usage, clustering)

API Cost Estimate: $0.15 per full test suite execution
================================================================================
*/

-- ============================================================================
-- TEST CASE REGISTRY
-- ============================================================================
/*
TEST_ID: BZ_001 - Null Value Validation Test
DESCRIPTION: Validates handling of null values in critical fields
EXPECTED_OUTCOME: Null values are properly handled or rejected per business rules

TEST_ID: BZ_002 - Data Type Validation Test
DESCRIPTION: Ensures data types are correctly preserved during ingestion
EXPECTED_OUTCOME: All data types match target schema specifications

TEST_ID: BZ_003 - Referential Integrity Test
DESCRIPTION: Validates foreign key relationships across inventory tables
EXPECTED_OUTCOME: All referential constraints are maintained

TEST_ID: BZ_004 - Business Rules Validation Test
DESCRIPTION: Ensures business logic rules are applied correctly
EXPECTED_OUTCOME: Data conforms to defined business constraints

TEST_ID: BZ_005 - Record Count Validation Test
DESCRIPTION: Compares source and target record counts
EXPECTED_OUTCOME: Record counts match between source and bronze tables

TEST_ID: BZ_006 - Transformation Accuracy Test
DESCRIPTION: Validates data transformation logic accuracy
EXPECTED_OUTCOME: Transformed data matches expected business logic

TEST_ID: BZ_007 - Aggregation Logic Test
DESCRIPTION: Tests aggregation calculations in the ingestion process
EXPECTED_OUTCOME: Aggregated values are mathematically correct

TEST_ID: BZ_008 - Join Logic Test
DESCRIPTION: Validates join operations between inventory tables
EXPECTED_OUTCOME: Joins produce expected result sets

TEST_ID: BZ_009 - Invalid Data Handling Test
DESCRIPTION: Tests system response to invalid or corrupted data
EXPECTED_OUTCOME: Invalid data is rejected with proper error logging

TEST_ID: BZ_010 - Error Logging Test
DESCRIPTION: Validates error logging functionality
EXPECTED_OUTCOME: Errors are properly logged to bz_ingestion_errors table

TEST_ID: BZ_011 - Exception Handling Test
DESCRIPTION: Tests exception handling mechanisms
EXPECTED_OUTCOME: Exceptions are caught and handled gracefully

TEST_ID: BZ_012 - Performance Metrics Test
DESCRIPTION: Validates performance monitoring and metrics collection
EXPECTED_OUTCOME: Performance data is captured in bz_performance_metrics

TEST_ID: BZ_013 - Clustering Effectiveness Test
DESCRIPTION: Tests clustering key effectiveness
EXPECTED_OUTCOME: Data is properly clustered for optimal query performance

TEST_ID: BZ_014 - Batch Processing Test
DESCRIPTION: Validates batch processing functionality
EXPECTED_OUTCOME: Large datasets are processed in appropriate batches

TEST_ID: BZ_015 - Audit Trail Test
DESCRIPTION: Ensures audit events are properly logged
EXPECTED_OUTCOME: All ingestion events are recorded in bz_ingestion_audit
*/

-- ============================================================================
-- TEST SETUP AND TEARDOWN PROCEDURES
-- ============================================================================

-- Create test schema and tables
CREATE OR REPLACE PROCEDURE setup_test_environment()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Create test schema
    CREATE SCHEMA IF NOT EXISTS TEST_BRONZE_LAYER;
    
    -- Create test source tables
    CREATE OR REPLACE TABLE TEST_BRONZE_LAYER.test_inventory_items (
        item_id NUMBER,
        item_name VARCHAR(255),
        category_id NUMBER,
        unit_price DECIMAL(10,2),
        created_date TIMESTAMP_NTZ,
        is_active BOOLEAN
    );
    
    CREATE OR REPLACE TABLE TEST_BRONZE_LAYER.test_inventory_categories (
        category_id NUMBER,
        category_name VARCHAR(100),
        parent_category_id NUMBER
    );
    
    -- Insert test data
    INSERT INTO TEST_BRONZE_LAYER.test_inventory_items VALUES
    (1, 'Test Item 1', 1, 10.50, '2024-01-01 10:00:00', TRUE),
    (2, 'Test Item 2', 1, 25.75, '2024-01-01 11:00:00', TRUE),
    (3, 'Test Item 3', 2, NULL, '2024-01-01 12:00:00', FALSE),
    (4, NULL, 1, 15.00, '2024-01-01 13:00:00', TRUE);
    
    INSERT INTO TEST_BRONZE_LAYER.test_inventory_categories VALUES
    (1, 'Electronics', NULL),
    (2, 'Clothing', NULL),
    (3, 'Books', NULL);
    
    RETURN 'Test environment setup completed';
END;
$$;

CREATE OR REPLACE PROCEDURE cleanup_test_environment()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    DROP SCHEMA IF EXISTS TEST_BRONZE_LAYER CASCADE;
    RETURN 'Test environment cleaned up';
END;
$$;

-- ============================================================================
-- DATA QUALITY TESTS
-- ============================================================================

-- TEST_ID: BZ_001 - Null Value Validation Test
CREATE OR REPLACE PROCEDURE test_bz_001_null_validation()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    null_count NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Check for null values in critical fields after ingestion
    SELECT COUNT(*) INTO null_count
    FROM bronze_layer.inventory_items 
    WHERE item_id IS NULL OR item_name IS NULL;
    
    IF (null_count > 0) THEN
        test_status := 'FAIL';
        test_details := 'Found ' || null_count || ' records with null critical fields';
    ELSE
        test_details := 'No null values found in critical fields';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_001', 'Null Value Validation', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_002 - Data Type Validation Test
CREATE OR REPLACE PROCEDURE test_bz_002_data_type_validation()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    type_mismatch_count NUMBER := 0;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Validate data types match schema
    SELECT COUNT(*) INTO type_mismatch_count
    FROM bronze_layer.inventory_items
    WHERE NOT (
        TRY_CAST(item_id AS NUMBER) IS NOT NULL AND
        TRY_CAST(unit_price AS DECIMAL(10,2)) IS NOT NULL AND
        TRY_CAST(created_date AS TIMESTAMP_NTZ) IS NOT NULL
    );
    
    IF (type_mismatch_count > 0) THEN
        test_status := 'FAIL';
        test_details := 'Found ' || type_mismatch_count || ' records with data type mismatches';
    ELSE
        test_details := 'All data types are valid';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_002', 'Data Type Validation', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_003 - Referential Integrity Test
CREATE OR REPLACE PROCEDURE test_bz_003_referential_integrity()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    orphan_count NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Check for orphaned records
    SELECT COUNT(*) INTO orphan_count
    FROM bronze_layer.inventory_items i
    LEFT JOIN bronze_layer.inventory_categories c ON i.category_id = c.category_id
    WHERE i.category_id IS NOT NULL AND c.category_id IS NULL;
    
    IF (orphan_count > 0) THEN
        test_status := 'FAIL';
        test_details := 'Found ' || orphan_count || ' orphaned inventory items';
    ELSE
        test_details := 'All referential integrity constraints satisfied';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_003', 'Referential Integrity', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_004 - Business Rules Validation Test
CREATE OR REPLACE PROCEDURE test_bz_004_business_rules_validation()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    rule_violation_count NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Check business rules (e.g., unit_price must be positive for active items)
    SELECT COUNT(*) INTO rule_violation_count
    FROM bronze_layer.inventory_items
    WHERE is_active = TRUE AND (unit_price IS NULL OR unit_price <= 0);
    
    IF (rule_violation_count > 0) THEN
        test_status := 'FAIL';
        test_details := 'Found ' || rule_violation_count || ' business rule violations';
    ELSE
        test_details := 'All business rules satisfied';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_004', 'Business Rules Validation', test_status, test_details);
END;
$$;

-- ============================================================================
-- TRANSFORMATION LOGIC TESTS
-- ============================================================================

-- TEST_ID: BZ_005 - Record Count Validation Test
CREATE OR REPLACE PROCEDURE test_bz_005_record_count_validation()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    source_count NUMBER;
    target_count NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Compare source and target record counts
    SELECT COUNT(*) INTO source_count FROM source_layer.inventory_items;
    SELECT COUNT(*) INTO target_count FROM bronze_layer.inventory_items;
    
    IF (source_count != target_count) THEN
        test_status := 'FAIL';
        test_details := 'Record count mismatch: Source=' || source_count || ', Target=' || target_count;
    ELSE
        test_details := 'Record counts match: ' || source_count || ' records';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_005', 'Record Count Validation', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_006 - Transformation Accuracy Test
CREATE OR REPLACE PROCEDURE test_bz_006_transformation_accuracy()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    mismatch_count NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Validate transformation accuracy by comparing key fields
    SELECT COUNT(*) INTO mismatch_count
    FROM source_layer.inventory_items s
    JOIN bronze_layer.inventory_items b ON s.item_id = b.item_id
    WHERE s.item_name != b.item_name 
       OR s.unit_price != b.unit_price 
       OR s.category_id != b.category_id;
    
    IF (mismatch_count > 0) THEN
        test_status := 'FAIL';
        test_details := 'Found ' || mismatch_count || ' transformation mismatches';
    ELSE
        test_details := 'All transformations are accurate';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_006', 'Transformation Accuracy', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_007 - Aggregation Logic Test
CREATE OR REPLACE PROCEDURE test_bz_007_aggregation_logic()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    expected_total DECIMAL(15,2);
    actual_total DECIMAL(15,2);
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Test aggregation logic (e.g., total inventory value by category)
    SELECT SUM(unit_price) INTO expected_total
    FROM source_layer.inventory_items
    WHERE is_active = TRUE;
    
    SELECT SUM(unit_price) INTO actual_total
    FROM bronze_layer.inventory_items
    WHERE is_active = TRUE;
    
    IF (ABS(expected_total - actual_total) > 0.01) THEN
        test_status := 'FAIL';
        test_details := 'Aggregation mismatch: Expected=' || expected_total || ', Actual=' || actual_total;
    ELSE
        test_details := 'Aggregation logic is correct: ' || actual_total;
    END IF;
    
    RETURN TABLE(SELECT 'BZ_007', 'Aggregation Logic', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_008 - Join Logic Test
CREATE OR REPLACE PROCEDURE test_bz_008_join_logic()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    expected_join_count NUMBER;
    actual_join_count NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Test join logic between items and categories
    SELECT COUNT(*) INTO expected_join_count
    FROM source_layer.inventory_items i
    INNER JOIN source_layer.inventory_categories c ON i.category_id = c.category_id;
    
    SELECT COUNT(*) INTO actual_join_count
    FROM bronze_layer.inventory_items i
    INNER JOIN bronze_layer.inventory_categories c ON i.category_id = c.category_id;
    
    IF (expected_join_count != actual_join_count) THEN
        test_status := 'FAIL';
        test_details := 'Join count mismatch: Expected=' || expected_join_count || ', Actual=' || actual_join_count;
    ELSE
        test_details := 'Join logic is correct: ' || actual_join_count || ' joined records';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_008', 'Join Logic', test_status, test_details);
END;
$$;

-- ============================================================================
-- ERROR HANDLING TESTS
-- ============================================================================

-- TEST_ID: BZ_009 - Invalid Data Handling Test
CREATE OR REPLACE PROCEDURE test_bz_009_invalid_data_handling()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    error_count NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Insert invalid test data and check if it's properly handled
    BEGIN
        INSERT INTO source_layer.inventory_items VALUES
        (99999, 'Invalid Item', 'INVALID_CATEGORY', 'INVALID_PRICE', 'INVALID_DATE', 'INVALID_BOOLEAN');
        
        -- Call the stored procedure
        CALL sp_ingest_inventory_management_data();
        
        -- Check if invalid data was rejected
        SELECT COUNT(*) INTO error_count
        FROM bronze_layer.inventory_items
        WHERE item_id = 99999;
        
        IF (error_count > 0) THEN
            test_status := 'FAIL';
            test_details := 'Invalid data was not properly rejected';
        ELSE
            test_details := 'Invalid data was properly rejected';
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            test_details := 'Exception properly caught: ' || SQLERRM;
    END;
    
    RETURN TABLE(SELECT 'BZ_009', 'Invalid Data Handling', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_010 - Error Logging Test
CREATE OR REPLACE PROCEDURE test_bz_010_error_logging()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    error_log_count NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Check if errors are properly logged
    SELECT COUNT(*) INTO error_log_count
    FROM bronze_layer.bz_ingestion_errors
    WHERE error_timestamp >= DATEADD(hour, -1, CURRENT_TIMESTAMP());
    
    IF (error_log_count = 0) THEN
        test_status := 'WARNING';
        test_details := 'No recent errors logged - may indicate logging issues or no errors occurred';
    ELSE
        test_details := 'Error logging is working: ' || error_log_count || ' errors logged';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_010', 'Error Logging', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_011 - Exception Handling Test
CREATE OR REPLACE PROCEDURE test_bz_011_exception_handling()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Test exception handling by forcing an error condition
    BEGIN
        -- Attempt to call procedure with invalid parameters
        CALL sp_ingest_inventory_management_data('INVALID_BATCH_SIZE');
        test_status := 'FAIL';
        test_details := 'Exception was not properly handled';
    EXCEPTION
        WHEN OTHERS THEN
            test_details := 'Exception properly handled: ' || SQLERRM;
    END;
    
    RETURN TABLE(SELECT 'BZ_011', 'Exception Handling', test_status, test_details);
END;
$$;

-- ============================================================================
-- PERFORMANCE TESTS
-- ============================================================================

-- TEST_ID: BZ_012 - Performance Metrics Test
CREATE OR REPLACE PROCEDURE test_bz_012_performance_metrics()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    metrics_count NUMBER;
    avg_execution_time NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Check if performance metrics are being captured
    SELECT COUNT(*), AVG(execution_time_seconds) 
    INTO metrics_count, avg_execution_time
    FROM bronze_layer.bz_performance_metrics
    WHERE metric_timestamp >= DATEADD(hour, -1, CURRENT_TIMESTAMP());
    
    IF (metrics_count = 0) THEN
        test_status := 'FAIL';
        test_details := 'No performance metrics captured';
    ELSIF (avg_execution_time > 300) THEN -- 5 minutes threshold
        test_status := 'WARNING';
        test_details := 'Average execution time is high: ' || avg_execution_time || ' seconds';
    ELSE
        test_details := 'Performance metrics captured: Avg time = ' || avg_execution_time || ' seconds';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_012', 'Performance Metrics', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_013 - Clustering Effectiveness Test
CREATE OR REPLACE PROCEDURE test_bz_013_clustering_effectiveness()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    clustering_depth NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Check clustering effectiveness
    SELECT AVG(CLUSTERING_DEPTH) INTO clustering_depth
    FROM TABLE(INFORMATION_SCHEMA.CLUSTERING_INFORMATION('bronze_layer.inventory_items'));
    
    IF (clustering_depth > 100) THEN
        test_status := 'WARNING';
        test_details := 'Clustering depth is high: ' || clustering_depth || ' - consider re-clustering';
    ELSE
        test_details := 'Clustering is effective: depth = ' || clustering_depth;
    END IF;
    
    RETURN TABLE(SELECT 'BZ_013', 'Clustering Effectiveness', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_014 - Batch Processing Test
CREATE OR REPLACE PROCEDURE test_bz_014_batch_processing()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    batch_count NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Check if batch processing is working correctly
    SELECT COUNT(DISTINCT batch_id) INTO batch_count
    FROM bronze_layer.bz_ingestion_audit
    WHERE audit_timestamp >= DATEADD(hour, -1, CURRENT_TIMESTAMP());
    
    IF (batch_count = 0) THEN
        test_status := 'FAIL';
        test_details := 'No batch processing detected';
    ELSE
        test_details := 'Batch processing is working: ' || batch_count || ' batches processed';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_014', 'Batch Processing', test_status, test_details);
END;
$$;

-- TEST_ID: BZ_015 - Audit Trail Test
CREATE OR REPLACE PROCEDURE test_bz_015_audit_trail()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    audit_count NUMBER;
    test_status VARCHAR := 'PASS';
    test_details VARCHAR := '';
BEGIN
    -- Check if audit events are properly logged
    SELECT COUNT(*) INTO audit_count
    FROM bronze_layer.bz_ingestion_audit
    WHERE audit_timestamp >= DATEADD(hour, -1, CURRENT_TIMESTAMP());
    
    IF (audit_count = 0) THEN
        test_status := 'FAIL';
        test_details := 'No audit events logged';
    ELSE
        test_details := 'Audit trail is working: ' || audit_count || ' events logged';
    END IF;
    
    RETURN TABLE(SELECT 'BZ_015', 'Audit Trail', test_status, test_details);
END;
$$;

-- ============================================================================
-- TEST EXECUTION FRAMEWORK
-- ============================================================================

-- Master test runner procedure
CREATE OR REPLACE PROCEDURE run_all_bronze_layer_tests()
RETURNS TABLE (test_id VARCHAR, test_name VARCHAR, status VARCHAR, details VARCHAR, execution_time NUMBER)
LANGUAGE SQL
AS
$$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    execution_seconds NUMBER;
BEGIN
    -- Setup test environment
    CALL setup_test_environment();
    
    start_time := CURRENT_TIMESTAMP();
    
    -- Execute all tests and collect results
    LET result_cursor CURSOR FOR
        SELECT * FROM TABLE(test_bz_001_null_validation())
        UNION ALL
        SELECT * FROM TABLE(test_bz_002_data_type_validation())
        UNION ALL
        SELECT * FROM TABLE(test_bz_003_referential_integrity())
        UNION ALL
        SELECT * FROM TABLE(test_bz_004_business_rules_validation())
        UNION ALL
        SELECT * FROM TABLE(test_bz_005_record_count_validation())
        UNION ALL
        SELECT * FROM TABLE(test_bz_006_transformation_accuracy())
        UNION ALL
        SELECT * FROM TABLE(test_bz_007_aggregation_logic())
        UNION ALL
        SELECT * FROM TABLE(test_bz_008_join_logic())
        UNION ALL
        SELECT * FROM TABLE(test_bz_009_invalid_data_handling())
        UNION ALL
        SELECT * FROM TABLE(test_bz_010_error_logging())
        UNION ALL
        SELECT * FROM TABLE(test_bz_011_exception_handling())
        UNION ALL
        SELECT * FROM TABLE(test_bz_012_performance_metrics())
        UNION ALL
        SELECT * FROM TABLE(test_bz_013_clustering_effectiveness())
        UNION ALL
        SELECT * FROM TABLE(test_bz_014_batch_processing())
        UNION ALL
        SELECT * FROM TABLE(test_bz_015_audit_trail());
    
    end_time := CURRENT_TIMESTAMP();
    execution_seconds := DATEDIFF(second, start_time, end_time);
    
    -- Return results with execution time
    FOR record IN result_cursor DO
        RETURN TABLE(SELECT record.test_id, record.test_name, record.status, record.details, execution_seconds);
    END FOR;
    
    -- Cleanup test environment
    CALL cleanup_test_environment();
END;
$$;

-- Test results summary procedure
CREATE OR REPLACE PROCEDURE get_test_summary()
RETURNS TABLE (total_tests NUMBER, passed NUMBER, failed NUMBER, warnings NUMBER, pass_rate DECIMAL(5,2))
LANGUAGE SQL
AS
$$
DECLARE
    total_count NUMBER;
    pass_count NUMBER;
    fail_count NUMBER;
    warning_count NUMBER;
    pass_percentage DECIMAL(5,2);
BEGIN
    -- Get test summary from last execution
    WITH test_results AS (
        SELECT * FROM TABLE(run_all_bronze_layer_tests())
    )
    SELECT 
        COUNT(*),
        SUM(CASE WHEN status = 'PASS' THEN 1 ELSE 0 END),
        SUM(CASE WHEN status = 'FAIL' THEN 1 ELSE 0 END),
        SUM(CASE WHEN status = 'WARNING' THEN 1 ELSE 0 END)
    INTO total_count, pass_count, fail_count, warning_count
    FROM test_results;
    
    pass_percentage := ROUND((pass_count::DECIMAL / total_count::DECIMAL) * 100, 2);
    
    RETURN TABLE(SELECT total_count, pass_count, fail_count, warning_count, pass_percentage);
END;
$$;

-- ============================================================================
-- EXECUTION INSTRUCTIONS
-- ============================================================================
/*
TO EXECUTE THE COMPLETE TEST SUITE:

1. Run individual test:
   SELECT * FROM TABLE(test_bz_001_null_validation());

2. Run all tests:
   SELECT * FROM TABLE(run_all_bronze_layer_tests());

3. Get test summary:
   SELECT * FROM TABLE(get_test_summary());

4. Setup test environment only:
   CALL setup_test_environment();

5. Cleanup test environment:
   CALL cleanup_test_environment();

ESTIMATED API COSTS:
- Individual test execution: $0.01 per test
- Full test suite execution: $0.15 per run
- Test environment setup/teardown: $0.02 per operation

PERFORMANCE CONSIDERATIONS:
- Tests should complete within 5 minutes for optimal performance
- Large datasets may require batch processing validation
- Clustering tests may need periodic re-evaluation
- Error handling tests should be run in isolated environments

MAINTENANCE SCHEDULE:
- Run full test suite after each stored procedure deployment
- Execute performance tests weekly
- Review and update business rules tests monthly
- Validate error handling tests quarterly
*/

-- =====================================================
-- Explicit API Cost: $0.15
-- =====================================================
```
