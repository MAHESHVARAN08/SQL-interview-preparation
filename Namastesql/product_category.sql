/*
You are provided with a table named Products containing information about various products,
including their names and prices. Write a SQL query to count number of products in each category based on its price into three categories below. 
Display the output in descending order of no of products.
 
1- "Low Price" for products with a price less than 100
2- "Medium Price" for products with a price between 100 and 500 (inclusive)
3- "High Price" for products with a price greater than 500.
Tables: Products
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| product_id   | int         |
| product_name | varchar(20) |
| price        | int         |
+--------------+-------------+
Hints
Expected Output
category   | no_of_products 
--------------+----------------
 Low Price    |              9
 Medium Price |              4
 High Price   |              2

*/

--solution
select 
	category,
	count(*) as no_of_products   -- count no of products on each category
from
	(select   -- write subquery to separate the categories based on price for all the products
		*,
		case
			when price < 100 then 'Low Price'
			when price between 100 and 500 then 'Medium Price'
			when price > 500 then 'High Price'
		end as category
	from
		products) t
group by category  -- group by category sothat we get the total count for each category 
order by no_of_products desc -- order by no of products count ineach category from highest to lowest
	
