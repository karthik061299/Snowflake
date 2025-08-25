_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Comprehensive Bronze Layer Data Ingestion Stored Procedure for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- BRONZE LAYER DATA INGESTION STORED PROCEDURE
-- =====================================================
-- Purpose: Ingest raw data from Inventory Management System into Bronze layer
-- Architecture: Medallion Architecture - Bronze Layer (Raw Data)
-- Source System: Inventory Management System (10 tables)
-- Target: Snowflake Bronze Layer with comprehensive audit logging
-- =====================================================

-- =====================================================
-- 1. AUDIT AND ERROR TABLES SETUP
-- =====================================================

-- Comprehensive Audit Table
CREATE TABLE IF NOT EXISTS Bronze.bz_ingestion_audit (
    ingestion_id STRING DEFAULT UUID_STRING()