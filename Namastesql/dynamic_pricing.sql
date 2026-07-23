--QUESTION
/*
You are given a products table where a new row is inserted every time the price of a product changes. Additionally, there is a transaction table containing details such as order_date and product_id for each order.

Write an SQL query to calculate the total sales value for each product, considering the cost of the product at the time of the order date, display the output in ascending order of the product_id.

 

Table: products
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| product_id  | int       |
| price       | int       |
| price_date  | date      |
+-------------+-----------+
Table: orders 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| order_date  | date      |
| product_id  | int       |
+-------------+-----------+

*/
--SOLUTION
WITH valid_to as (select *,( lead(price_date,1,'9999-12-31') over(partition by product_id order by price_date )- interval '1 day')::DATE as valid_till from products ) 

select p.product_id,sum(p.price) as total_sales
from orders as o
inner join valid_to as p
on o.product_id=p.product_id
and o.order_date between p.price_date and p.valid_till
group by 1
order by 1

--EXPLANATION
