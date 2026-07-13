--QUESTION 
/*
You are given:

An orders table with order-wise product purchases

A products table with product names

Your task:

👉 Find all unique pairs of products that were purchased together in the same order and count how many times each pair was bought together.

Important Rules

Only consider products within the same order

Each pair should be unique and unordered

(A, B) is the same as (B, A)

Orders with only one product should be ignored

Output should contain:

Product 1

Product 2

Number of times bought together

🗄️ Table Schemas

CREATE TABLE orders (
    order_id INTEGER,
    customer_id INTEGER,
    product_id INTEGER
);
 
CREATE TABLE products (
    id INTEGER,
    name TEXT
);

*/

--SOLUTION 
with unique_pairs as (select o1.product_id as p1,o2.product_id as p2 , count(1) as freq from orders as o1
inner join orders as o2
on o1.order_id = o2.order_id
where o1.product_id < o2.product_id 
group by o1.product_id , o2.product_id) 

select p1.name || ' ' || p2.name as pair , u.freq as purchase_freq 
from unique_pairs as u 
inner join products as p1 
on u.p1 = p1.id
inner join products as p2 
on u.p2 = p2.id
order by p1.name , p2.name

--EXPLANATION 

/*
STEP-BY-STEP BREAKDOWN:

1. CTE (Common Table Expression) - "unique_pairs":
   
   - We perform a SELF-JOIN on the orders table (o1 INNER JOIN o2)
   - Both copies are joined ON o1.order_id = o2.order_id
     This ensures we only pair products that were in the same order
   
   - The WHERE clause: where o1.product_id < o2.product_id
     This is CRITICAL for ensuring unique, unordered pairs:
     • It prevents duplicate pairs like (A, B) and (B, A)
     • It excludes self-joins like (A, A)
     • By using <, we maintain consistent ordering (smaller ID first)
   
   - COUNT(1) counts how many orders contain both product p1 and p2 together
   - GROUP BY o1.product_id, o2.product_id aggregates the counts

2. MAIN SELECT Statement:
   
   - We select from the unique_pairs CTE and join it with the products table TWICE:
     • First join: to get the name of product p1 (u.p1 = p1.id)
     • Second join: to get the name of product p2 (u.p2 = p2.id)
   
   - Concatenate product names: p1.name || ' ' || p2.name creates a readable pair label
   
   - ORDER BY p1.name, p2.name sorts results alphabetically by product names
     This makes the output organized and easy to read

KEY INSIGHTS:

✓ The self-join technique is efficient for finding co-purchased items
✓ The WHERE clause with < operator eliminates redundant pairs and avoids duplicates
✓ Multiple table joins enrich the data with human-readable product names
✓ The GROUP BY aggregates transaction counts for each unique pair
✓ This approach scales well and is used in market basket analysis and recommendation systems

EXAMPLE OUTPUT (if we had sample data):
pair                          purchase_freq
Apple Banana                  5
Apple Orange                  3
Banana Orange                 2

*/
