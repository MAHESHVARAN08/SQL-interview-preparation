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
