/*
An e-commerce company want to start special reward program for their premium customers.
The customers who have placed a greater number of orders than the average number of orders placed by customers are considered as premium customers.
 
Write an SQL to find the list of premium customers along with the number of orders placed by each of them, display the results in highest to lowest no of orders.

Table: orders (primary key : order_id)
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| order_id      | int         |
| order_date    | date        |
| customer_name | varchar(20) |
| sales         | int         |
+---------------+-------------+

*/

--solution


select customer_name,count(*) as no_of_orders
from orders
group by customer_name  -- group by customer_name so that we can able to know that how many orders that each customer placed
having count(*) > (select (count(*)/count(distinct customer_name)) as avg from orders) -- filter by avg of orders per customer 
order by count(*) desc
