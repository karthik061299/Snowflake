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

CREATE OR REPLACE PROCEDURE SP_BRONZE_TO_SILVER_ETL(
    p_batch_size INTEGER DEFAULT 10000