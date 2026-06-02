/* QUESTION 

You are working on an e-commerce platform (Amazon-like).

Every day:

Customers place orders

Some customers are new (first-time buyers)

Some customers are repeat buyers

🎯 Goal

For each day, find:

Number of new customers

Number of repeat customers

🧱 Table Structure

CREATE TABLE customer_orders (
    order_id INTEGER,
    customer_id INTEGER,
    order_date TEXT,      -- YYYY-MM-DD
    order_amount INTEGER
);

*/



-- SOLUTION
-- Find each customer's first purchase date
with first_visit as (
select customer_id,min(order_date) as first_visit_date 
from customer_orders
group by customer_id
)
-- Count new and repeat customers for each order date
select co.order_date,
sum(case when co.order_date=fv.first_visit_date then 1 else 0 end) as new_customers,  -- Orders placed on customer's first purchase date
sum(case when co.order_date!=fv.first_visit_date then 1 else 0 end) as repeat_customers  -- Orders placed after customer's first purchase date
from customer_orders as co
inner join first_visit as fv 
on co.customer_id = fv.customer_id
group by co.order_date
order by co.order_date asc

/* EXPLANATION
### New vs Repeat Customers by Order Date

This query identifies the first purchase date for each customer and classifies every order as either a **new customer order** or a **repeat customer order**.

**Logic:**

1. The `first_visit` CTE finds the earliest (`MIN`) order date for each customer.
2. The main query joins all customer orders with their first visit date.
3. For each order date:

   * Orders placed on a customer's first purchase date are counted as **new customers**.
   * Orders placed after the first purchase date are counted as **repeat customers**.
4. Results are aggregated by `order_date` and sorted chronologically.

**Output:**

* `order_date` – Date of the order.
* `new_customers` – Number of customers making their first purchase on that date.
* `repeat_customers` – Number of customers who had purchased previously and placed another order on that date.
  
Note: If a customer places multiple orders on their first purchase date, each order is counted in new_customers. 
  If you need unique customer counts instead of order counts, use COUNT(DISTINCT customer_id).

*/
