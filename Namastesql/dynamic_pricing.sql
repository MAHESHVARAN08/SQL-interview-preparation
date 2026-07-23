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
/*

LOGIC:
------
The problem requires joining orders with products based on the PRICE APPLICABLE AT THE TIME OF ORDER.
Since products table has multiple rows for the same product (each time price changes), we need to:
1. Find the price range for each product (when was each price valid)
2. Match each order to the correct price based on its order_date
3. Sum up the sales value for each product

STEP-BY-STEP BREAKDOWN:

Step 1: Create "valid_to" CTE to establish price validity periods
-------
- LEAD() window function gets the next price_date for each product
- Default value '9999-12-31' ensures the last price remains valid indefinitely
- Subtracting 1 day creates the range: price_date to valid_till (inclusive on both ends)

Step 2: Join orders with valid_to using date range logic
-------
- Inner join on product_id to match products with orders
- Condition: o.order_date BETWEEN p.price_date AND p.valid_till
- This ensures each order uses the price that was valid on that order_date

Step 3: Aggregate and sort
-------
- GROUP BY product_id to calculate total sales per product
- SUM(p.price) multiplies price by count of matching orders
- ORDER BY product_id (ascending)


SAMPLE DATA AND WALKTHROUGH:
----------------------------

Products Table:
+------------+-------+------------+
| product_id | price | price_date |
+------------+-------+------------+
| 1          | 100   | 2024-01-01 |
| 1          | 120   | 2024-03-01 |
| 2          | 50    | 2024-01-15 |
| 2          | 60    | 2024-04-01 |
+------------+-------+------------+

Orders Table:
+----------+------------+------------+
| order_id | order_date | product_id |
+----------+------------+------------+
| 1        | 2024-01-20 | 1          |
| 2        | 2024-02-10 | 1          |
| 3        | 2024-03-15 | 1          |
| 4        | 2024-01-20 | 2          |
| 5        | 2024-05-01 | 2          |
+----------+------------+------------+


Step 1: After CTE "valid_to" calculation:
+------------+-------+------------+------------+
| product_id | price | price_date | valid_till |
+------------+-------+------------+------------+
| 1          | 100   | 2024-01-01 | 2024-02-29 |  (Next price starts 2024-03-01, so -1 day)
| 1          | 120   | 2024-03-01 | 9999-12-30 |  (No next price, so 9999-12-31 -1 day)
| 2          | 50    | 2024-01-15 | 2024-03-31 |  (Next price starts 2024-04-01, so -1 day)
| 2          | 60    | 2024-04-01 | 9999-12-30 |  (No next price, so 9999-12-31 -1 day)
+------------+-------+------------+------------+

Step 2: Matching Orders with Prices:
------
Order 1 (2024-01-20, product_id=1):
  - Check: 2024-01-20 BETWEEN 2024-01-01 AND 2024-02-29? YES ✓
  - Price used: 100

Order 2 (2024-02-10, product_id=1):
  - Check: 2024-02-10 BETWEEN 2024-01-01 AND 2024-02-29? YES ✓
  - Price used: 100

Order 3 (2024-03-15, product_id=1):
  - Check: 2024-03-15 BETWEEN 2024-03-01 AND 9999-12-30? YES ✓
  - Price used: 120

Order 4 (2024-01-20, product_id=2):
  - Check: 2024-01-20 BETWEEN 2024-01-15 AND 2024-03-31? YES ✓
  - Price used: 50

Order 5 (2024-05-01, product_id=2):
  - Check: 2024-05-01 BETWEEN 2024-04-01 AND 9999-12-30? YES ✓
  - Price used: 60

Step 3: Aggregation:
------
Product 1: 100 + 100 + 120 = 320
Product 2: 50 + 60 = 110

FINAL RESULT:
+------------+-------------+
| product_id | total_sales |
+------------+-------------+
| 1          | 320         |
| 2          | 110         |
+------------+-------------+

KEY CONCEPTS:
- Window Function LEAD(): Looks ahead to get next value within partition
- Date Range Matching: BETWEEN clause handles temporal joins efficiently
- CTE (Common Table Expression): Makes complex logic readable
- Aggregation: SUM counts orders at valid prices
*/
