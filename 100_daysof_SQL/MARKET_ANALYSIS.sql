-- QUESTION
/*
You are given three tables:

users – contains seller information and their favorite brand

orders – contains order details with buyer and seller IDs

items – contains item and brand information

🎯 Objective

Write an SQL query to determine for each seller whether the brand of the second item they sold matches their favorite brand.

📌 Rules

Orders should be considered in chronological order (order_date)

If a seller has sold fewer than 2 items, return 'no'

Output columns:

seller_id

second_item_fav_brand → 'yes' or 'no'

🧱 Table Definitions (As Given)

CREATE TABLE users 
(
  user_id         INT,
  join_date       TEXT,
  favorite_brand  VARCHAR(50)
);
 
CREATE TABLE orders 
(
  order_id   INT,
  order_date TEXT,
  item_id    INT,
  buyer_id   INT,
  seller_id  INT
);
 
CREATE TABLE items
(
  item_id    INT,
  item_brand VARCHAR(50)
);
*/

--SOLUTION
with rnk_orders as
(select *,
rank() over(partition by seller_id order by order_date asc) as rn 
from orders
)
select u.user_id as seller_id
, case when i.item_brand=u.favorite_brand then 'Yes' else 'No' end as item_fav_brand
from users u
LEFT join rnk_orders ro on ro.seller_id=u.user_id and rn=2
LEFT join items i on i.item_id=ro.item_id

--EXPLANATION

