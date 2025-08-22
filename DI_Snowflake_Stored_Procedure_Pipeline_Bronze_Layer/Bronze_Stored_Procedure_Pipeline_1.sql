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
-- Target: Snowflake Bronze layer with metadata tracking
-- Architecture: Medallion Architecture - Bronze Layer
-- =====================================================

-- =====================================================
-- 1. AUDIT AND ERROR TABLES CREATION
-- =====================================================

-- Create audit table for tracking all ingestion activities
CREATE TABLE IF NOT EXISTS Bronze.bz_ingestion_audit (
    ingestion_id STRING DEFAULT CONCAT('ING_'