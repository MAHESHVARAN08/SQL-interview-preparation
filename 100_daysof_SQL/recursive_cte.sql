--QUESTION
/*
You are given a table that contains sales periods for products, along with average daily sales.

Each row represents:

A product

A start date

An end date

Average daily sales during that period

📋 Input Table

CREATE TABLE sales 
( 
    product_id INT, 
    period_start DATE, 
    period_end DATE, 
    average_daily_sales INT 
);
🧠 Problem Requirement

For each product, calculate total sales per year.

⚠️ Important catch:

A single period may span multiple years

Sales must be split year-wise

You cannot simply do:

DATEDIFF(period_end, period_start) * average_daily_sales
That only works when the entire period is within one year ❌
*/
--SOLUTION
with recursive r_cte as (
  select min(period_start) as dates, max(period_end) as max_date 
  from sales
  union all 
  select dates + 1 , max_date 
  from r_cte 
  where dates < max_date 
)

select s.product_id, extract(year from r.dates) as report_year, sum(s.average_daily_sales) as total_amount
from r_cte as r 
inner join sales as s
on r.dates between s.period_start and s.period_end
group by s.product_id, extract(year from r.dates)
order by 1,2

--EXPLANATION

/*
═══════════════════════════════════════════════════════════════════════════════
                            DETAILED EXPLANATION
═══════════════════════════════════════════════════════════════════════════════

🎯 PROBLEM: Calculate yearly sales for products when sales periods span multiple years

KEY INSIGHT:
─────────────
Since a single period can span multiple years (e.g., 2022-01-15 to 2023-06-30),
we cannot simply multiply days × average_daily_sales. We need to split the sales
by year and count each day individually.

═══════════════════════════════════════════════════════════════════════════════

STEP 1: BUILD A RECURSIVE CTE (r_cte)
─────────────────────────────────────

Purpose: Generate a date sequence from the minimum to maximum date across all records

  ANCHOR (Base Case):
  ───────────────────
  SELECT MIN(period_start) AS dates, MAX(period_end) AS max_date FROM sales
  
  This creates the starting point:
    • dates = earliest start date in the entire sales table
    • max_date = latest end date in the entire sales table
  
  Example: If sales span 2022-01-01 to 2023-12-31
    dates      │ max_date
    ───────────┼──────────
    2022-01-01 │ 2023-12-31

  RECURSIVE (Iteration):
  ──────────────────────
  SELECT dates + 1, max_date FROM r_cte WHERE dates < max_date
  
  This adds 1 day to the previous date and continues until we've covered
  all dates from min to max.
  
  • Each iteration: dates becomes dates + 1
  • Stops when: dates reaches max_date
  • Result: A complete sequence of all dates

  Example output (simplified):
    dates      │ max_date
    ───────────┼──────────
    2022-01-01 │ 2023-12-31
    2022-01-02 │ 2023-12-31
    2022-01-03 │ 2023-12-31
    ...
    2023-12-31 │ 2023-12-31

═══════════════════════════════════════════════════════════════════════════════

STEP 2: JOIN r_cte WITH sales TABLE
────────────────────────────────────

INNER JOIN sales ON r.dates BETWEEN s.period_start AND s.period_end

This matches each date in r_cte with ALL sales periods that cover that date.

Example:
  
  Sales table:
    product_id │ period_start │ period_end │ average_daily_sales
    ────────────┼──────────────┼────────────┼────────────────────
    1           │ 2022-01-01   │ 2022-01-03 │ 100
    2           │ 2022-01-02   │ 2022-01-04 │ 50

  After INNER JOIN:
    dates      │ product_id │ average_daily_sales
    ───────────┼────────────┼────────────────────
    2022-01-01 │ 1          │ 100           (only product 1 active)
    2022-01-02 │ 1          │ 100           (product 1 active)
    2022-01-02 │ 2          │ 50            (product 2 also active)
    2022-01-03 │ 1          │ 100           (product 1 active)
    2022-01-03 │ 2          │ 50            (product 2 also active)
    2022-01-04 │ 2          │ 50            (only product 2 active)

  Note: Each date can match multiple product periods!

═══════════════════════════════════════════════════════════════════════════════

STEP 3: GROUP BY product_id AND YEAR
──────────────────────────────────────

GROUP BY s.product_id, EXTRACT(YEAR FROM r.dates)
SUM(s.average_daily_sales) AS total_amount

For each (product_id, year) combination:
  • EXTRACT(YEAR FROM r.dates): Convert each date to its year
  • SUM(average_daily_sales): Add up all the daily sales for that year
  
Continuing the example:

  Before GROUP BY (with years):
    report_year │ product_id │ average_daily_sales
    ────────────┼────────────┼────────────────────
    2022        │ 1          │ 100
    2022        │ 1          │ 100
    2022        │ 2          │ 50
    2022        │ 1          │ 100
    2022        │ 2          │ 50
    2022        │ 2          │ 50

  After GROUP BY (Final Result):
    product_id │ report_year │ total_amount
    ────────────┼─────────────┼──────────────
    1           │ 2022        │ 300           (100+100+100)
    2           │ 2022        │ 150           (50+50+50)

═══════════════════════════════════════════════════════════════════════════════

WHY RECURSION?
──────────────

The recursive CTE expands each sales period into individual days:
  • Period: 2022-01-01 to 2022-01-05 (5 days × $100 = $500)
  
Without recursion (NAIVE):
  DATEDIFF(2022-01-05, 2022-01-01) * 100 = 5 × 100 = $500 ✓
  BUT if period spans years:
  DATEDIFF(2023-01-05, 2022-01-01) * 100 includes both 2022 and 2023 sales
  This gives a WRONG total for each year! ✗

With recursion (CORRECT):
  Expand into daily rows, then group by year to separate accurately.
  2022: (2022-01-01 to 2022-12-31) = some days × $100 = correct 2022 total
  2023: (2023-01-01 to 2023-01-05) = remaining days × $100 = correct 2023 total

═══════════════════════════════════════════════════════════════════════════════

TIME COMPLEXITY WARNING
───────────────────────

⚠️  This solution generates ONE ROW PER DAY across the entire date range!

If your date range is:
  • 365 days → 365 rows (acceptable)
  • 5 years → ~1,825 rows (manageable)
  • 10 years → ~3,650 rows (still okay)
  • 100 years → ~36,500 rows (getting large)

For very large ranges, consider alternative approaches using DATEDIFF and
date arithmetic instead of generating every date.

═══════════════════════════════════════════════════════════════════════════════

SUMMARY
───────

1. Recursive CTE: Generate all dates from min to max
2. Inner Join: Match each date with applicable sales periods
3. Group & Sum: Sum sales by (product, year)
4. Result: Yearly sales totals per product, correctly split across year boundaries

This ensures multi-year periods are accurately split into per-year totals!

═══════════════════════════════════════════════════════════════════════════════
*/
