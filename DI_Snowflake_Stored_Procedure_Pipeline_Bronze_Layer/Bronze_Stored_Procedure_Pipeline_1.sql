_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Bronze Layer Stored Procedure for Inventory Management System Data Ingestion
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- Bronze Layer Data Ingestion Stored Procedure
-- Inventory Management System - Medallion Architecture
-- =====================================================

-- =====================================================
-- 1. AUDIT TABLE CREATION
-- =====================================================

CREATE TABLE IF NOT EXISTS Bronze.bz_ingestion_audit (
    ingestion_id NUMBER AUTOINCREMENT PRIMARY KEY