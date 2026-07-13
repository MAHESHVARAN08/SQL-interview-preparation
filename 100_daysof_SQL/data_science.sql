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
