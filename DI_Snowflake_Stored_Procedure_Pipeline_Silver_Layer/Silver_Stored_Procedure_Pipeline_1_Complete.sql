_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Silver Layer ETL Stored Procedure for Inventory Management System
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- =====================================================
-- SILVER LAYER ETL STORED PROCEDURE
-- INVENTORY MANAGEMENT SYSTEM
-- =====================================================

-- Main ETL Stored Procedure for Bronze to Silver Layer Data Processing
CREATE OR REPLACE PROCEDURE Silver.sp_bronze_to_silver_etl(
    p_batch_size INTEGER DEFAULT 10000