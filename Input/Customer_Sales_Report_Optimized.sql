-- Optimized Snowflake SQL: Customer Sales Report
-- Optimizations performed:
-- - Merged CTEs to reduce nesting and improve performance/readability
-- - Standardized formatting and indentation
-- - Used meaningful aliases for tables
-- - Preserved business logic and output schema

WITH customer_sales AS (
    SELECT 
        c.CUSTOMER_ID,
        c.CUSTOMER_NAME,
        c.REGION,
        s.ORDER_ID,
        s.ORDER_AMOUNT,
        s.ORDER_DATE,
        YEAR(s.ORDER_DATE) AS ORDER_YEAR,
        MONTH(s.ORDER_DATE) AS ORDER_MONTH
    FROM SALES_DB.RAW.CUSTOMERS c
    LEFT JOIN SALES_DB.RAW.SALES s
        ON c.CUSTOMER_ID = s.CUSTOMER_ID
)

SELECT 
    CUSTOMER_ID,
    CUSTOMER_NAME,
    REGION,
    ORDER_YEAR,
    ORDER_MONTH,
    SUM(ORDER_AMOUNT) AS TOTAL_SALES,
    COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDERS
FROM customer_sales
GROUP BY 
    CUSTOMER_ID, CUSTOMER_NAME, REGION, ORDER_YEAR, ORDER_MONTH
ORDER BY 
    CUSTOMER_ID, ORDER_YEAR, ORDER_MONTH;