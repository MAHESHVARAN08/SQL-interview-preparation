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

/* ============================================================
   Part 5: Explanation & Real-World Application
   ============================================================
   
   WHY USE THE PARETO PRINCIPLE?
   
   The Pareto Principle (80/20 rule) states that approximately 80% of 
   effects come from 20% of causes. In business analytics, this means:
   - 80% of sales often come from 20% of products
   - 80% of problems come from 20% of root causes
   - 80% of revenue comes from 20% of customers
   
   BUSINESS BENEFITS:
   
   1. INVENTORY OPTIMIZATION
      - Focus warehouse space and resources on high-impact products
      - Reduce carrying costs by prioritizing best sellers
      - Better demand forecasting for top 20%
   
   2. MARKETING FOCUS
      - Allocate marketing budget to top-performing products
      - Maximize ROI by concentrating efforts on what sells
      - Identify which products drive customer loyalty
   
   3. RESOURCE ALLOCATION
      - Prioritize product development for proven winners
      - Make data-driven decisions on R&D investment
      - Discontinue low-impact products to reduce complexity
   
   4. PERFORMANCE ANALYSIS
      - Quickly identify business drivers
      - Benchmark product performance
      - Track changes in product mix over time
   
   EXAMPLE OUTPUT:
   
   product_id | product_sales | running_sales | total_sales
   ----------|---------------|---------------|----------
   P001      | 50,000        | 50,000        | 100,000
   P002      | 35,000        | 85,000        | 100,000
   P003      | 15,000        | 100,000       | 100,000
   
   Result: Products P001 and P002 (20% of products) generate 85% of 
   total sales, confirming the Pareto principle in action.
   
   ============================================================ */
