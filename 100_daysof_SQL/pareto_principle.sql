/* ============================================================
   Pareto Principle (80/20 Rule) - Top Products by Cumulative Sales
   ------------------------------------------------------------
   Goal: Identify the smallest set of top-selling products whose
   cumulative sales contribute to at least 80% of total sales.
 
   Source table:
     orders (order_id, order_date, product_id, sales)
   ============================================================ */
 
WITH product_sales_grp AS (
    -- Step 1: Aggregate total sales per product across all orders/years
    SELECT
        product_id,
        SUM(sales) AS sales
    FROM orders
    GROUP BY product_id
),
 
final AS (
    -- Step 2: Rank products by sales (highest first) and compute a
    -- running (cumulative) total. Also compute the 80% threshold of
    -- the grand total sales across all products.
    SELECT
        product_id,
        sales AS product_sales,
        SUM(sales) OVER (ORDER BY sales DESC) AS running_sales,
        0.8 * SUM(sales) OVER () AS total_sales
    FROM product_sales_grp
)
 
-- Step 3: Keep only products whose cumulative sales fall within
-- (up to) the 80% threshold of total sales.
SELECT *
FROM final


WHERE running_sales <= total_sales
ORDER BY product_sales DESC;
 
