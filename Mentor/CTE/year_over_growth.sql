--QUESTION - 5. Use a CTE to calculate year-over-year growth in sales.
--SOLUTION
WITH cte as (
  select * , lag(sales_amount) over(partition by employee_name order by sales_year) as previous_sales
  from yearly_sales)
  select * , ((sales_amount - previous_sales)/previous_sales)*100 as yoy from cte
