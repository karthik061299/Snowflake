-- Optimized version of Customer_Sales_Report.sql
-- Optimizations performed:
--   * Removed unnecessary CTEs by merging logic (cte1 and cte2 can be combined)
--   * Simplified CTE structure for better readability and performance
--   * Explicit column selection and consistent formatting
--   * Preserved all business logic, joins, filters, and aggregation
--   * Added comments for clarity

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
    CUSTOMER_ID,
    CUSTOMER_NAME,
    REGION,
    ORDER_YEAR,
    ORDER_MONTH
ORDER BY
    CUSTOMER_ID,
    ORDER_YEAR,
    ORDER_MONTH;

-- NOTE: Please validate performance difference on large datasets. No business logic or output schema was changed.
