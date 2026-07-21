--QUESTION
/*
Flipkart an ecommerce company wants to find out its top most selling product by quantity in each category. 
In case of a tie when quantities sold are same for more than 1 product, then we need to give preference to the product with higher sales value.

Display category and product in output with category in ascending order.

 

Table: orders
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| category    | varchar(50) |
| order_id    | int         |
| product_id  | varchar(20) |
| quantity    | int         |
| unit_price  | int         |
+-------------+-------------+
*/

--SOLUTION
with sales as (
select
	category,
	product_id,
	sum(quantity) as total_qty,
	sum(quantity*unit_price) as total_sales
from
	orders
group by
	1,2
)

select category,product_id from (select
	*,
	rank() over(partition by category order by total_qty desc,total_sales desc) as rn
from
	sales) as a
where rn = 1

--EXPLANATION
