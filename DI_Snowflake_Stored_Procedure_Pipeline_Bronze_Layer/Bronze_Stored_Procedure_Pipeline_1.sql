_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Bronze Layer Stored Procedure Pipeline for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- BRONZE LAYER INGESTION PIPELINE
-- Comprehensive Snowflake Stored Procedure for Inventory Management System
-- Medallion Architecture - Bronze Layer Implementation
-- =====================================================

-- =====================================================
-- 1. AUDIT TABLE CREATION
-- =====================================================

CREATE TABLE IF NOT EXISTS Bronze.bz_ingestion_audit (
    ingestion_id STRING DEFAULT CONCAT('ING_'