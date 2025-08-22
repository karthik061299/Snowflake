_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Bronze Layer Stored Procedure Pipeline for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- BRONZE LAYER INGESTION STORED PROCEDURE PIPELINE
-- =====================================================
-- Purpose: Comprehensive data ingestion pipeline for Bronze layer
-- Source: Inventory Management System (10 tables)
-- Target: Snowflake Bronze layer with bz_ prefix
-- Features: Audit logging, error handling, metadata tracking
-- =====================================================

-- =====================================================
-- 1. AUDIT AND ERROR TABLES CREATION
-- =====================================================

-- Create comprehensive audit table for ingestion tracking
CREATE TABLE IF NOT EXISTS Bronze.bz_ingestion_audit (
    ingestion_id STRING DEFAULT CONCAT('ING_', TO_VARCHAR(CURRENT_TIMESTAMP(), 'YYYYMMDDHH24MISS'), '_', UNIFORM(1000, 9999, RANDOM())),
    source_system STRING,
    table_name STRING,
    start_timestamp TIMESTAMP_NTZ,
    end_timestamp TIMESTAMP_NTZ,
    records_ingested NUMBER,
    records_failed NUMBER,
    execution_status STRING, -- SUCCESS, FAILED, PARTIAL
    user_identity STRING,
    error_message STRING,
    processing_time_seconds NUMBER,
    warehouse_used STRING,
    load_type STRING, -- FULL, INCREMENTAL
    created_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Create error table for rejected records
CREATE TABLE IF NOT EXISTS Bronze.bz_error_records (
    error_id STRING DEFAULT CONCAT('ERR_', TO_VARCHAR(CURRENT_TIMESTAMP(), 'YYYYMMDDHH24MISS'), '_', UNIFORM(1000, 9999, RANDOM())),
    ingestion_id STRING,
    source_table STRING,
    error_type STRING, -- DATA_TYPE_MISMATCH, NULL_CONSTRAINT, VALIDATION_FAILED
    error_description STRING,
    rejected_record VARIANT,
    error_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- 2. UTILITY PROCEDURES
-- =====================================================

-- Utility procedure for logging messages
CREATE OR REPLACE PROCEDURE Bronze.log_audit_message(
    p_ingestion_id STRING,
    p_source_system STRING,
    p_table_name STRING,
    p_status STRING,
    p_message STRING DEFAULT NULL,
    p_records_ingested NUMBER DEFAULT 0,
    p_records_failed NUMBER DEFAULT 0,
    p_start_time TIMESTAMP_NTZ DEFAULT NULL,
    p_end_time TIMESTAMP_NTZ DEFAULT NULL
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_processing_time NUMBER DEFAULT 0;
    v_warehouse STRING;
    v_user STRING;
BEGIN
    -- Get current user and warehouse
    SELECT CURRENT_USER(), CURRENT_WAREHOUSE() INTO v_user, v_warehouse;
    
    -- Calculate processing time if both timestamps provided
    IF p_start_time