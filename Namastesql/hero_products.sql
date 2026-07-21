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

/*
The query is solved using a two-step approach:

STEP 1: CTE (Common Table Expression) - "sales"
--------
- Aggregates data from the orders table at product level
- sum(quantity) as total_qty: Calculates total quantity sold for each product in each category
- sum(quantity*unit_price) as total_sales: Calculates total sales value (revenue) for each product
- group by 1,2: Groups results by category and product_id to get aggregate metrics per product per category

Result: A virtual table with columns [category, product_id, total_qty, total_sales]

STEP 2: Window Function with Ranking
--------
- rank() over(partition by category order by total_qty desc, total_sales desc) as rn
  
  * PARTITION BY category: Creates separate ranking windows for each category
  * ORDER BY total_qty DESC: Ranks products within each category by quantity sold (highest first)
  * ORDER BY total_sales DESC: Acts as tie-breaker; if two products have same total_qty, 
    the product with higher total_sales gets rank 1
  
- where rn = 1: Filters to keep only the top-ranked product from each category

FINAL OUTPUT:
--------
Returns the top-selling product for each category, where:
- Primary sorting: Highest quantity sold
- Secondary sorting (tie-breaker): Highest sales value
- Result: category and product_id columns displaying the winning products
- Categories appear in ascending order (default sort order when not explicitly specified in outer query)

EXAMPLE:
--------
If Category "Electronics" has:
  - Product A: qty=100, sales=10000
  - Product B: qty=100, sales=12000
  - Product C: qty=80, sales=8000

Result: Product B is selected (qty matches Product A, but Product B has higher sales value)
*/
