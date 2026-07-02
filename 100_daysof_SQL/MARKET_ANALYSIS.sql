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
/*
📖 STEP-BY-STEP LOGIC BREAKDOWN:

1️⃣ CTE: rnk_orders
   ─────────────────
   - We create a Common Table Expression (CTE) named 'rnk_orders' to prepare the orders data
   - We use the RANK() window function with:
     • PARTITION BY seller_id: Groups orders by each seller independently
     • ORDER BY order_date ASC: Sorts each seller's orders chronologically (oldest first)
     • AS rn: Assigns a rank number to each order within that seller's group
   
   Example:
   If seller_id 5 has orders from dates 2024-01-05, 2024-02-10, 2024-03-15
   Then ranks assigned would be: rn=1, rn=2, rn=3 respectively

2️⃣ Main Query - FROM users u
   ────────────────────────────
   - We START with the users table as the main source (all sellers)
   - This ensures ALL sellers are included in results, even those with fewer than 2 orders

3️⃣ First LEFT JOIN: rnk_orders ro
   ────────────────────────────────
   - ON ro.seller_id = u.user_id AND rn = 2
   
   This join is CRITICAL because:
     ✓ It filters for ONLY the second order (rn=2) of each seller
     ✓ If a seller has sold fewer than 2 items, this join returns NULL
     ✓ LEFT JOIN preserves sellers with NULL (those with <2 orders)
   
   After this join, we have:
   - For sellers with ≥2 orders: The second order's details are attached
   - For sellers with <2 orders: All columns from rnk_orders will be NULL

4️⃣ Second LEFT JOIN: items i
   ──────────────────────────
   - ON i.item_id = ro.item_id
   - This retrieves the BRAND of the second item sold
   - If ro.item_id is NULL (seller has <2 orders), this will also return NULL

5️⃣ CASE Statement Logic
   ─────────────────────
   CASE WHEN i.item_brand = u.favorite_brand THEN 'Yes' ELSE 'No' END
   
   This evaluates:
   - If item_brand equals favorite_brand → Output 'Yes'
   - If they don't match → Output 'No'
   - If i.item_brand is NULL (seller has <2 orders) → Output 'No' (NULL ≠ anything is NULL, treated as falsy)

💡 WHY THIS APPROACH WORKS:

✅ LEFT JOINs preserve ALL sellers, including those without a second order
✅ Window function RANK() handles chronological ordering elegantly
✅ Single filtering condition (rn=2) isolates exactly the second order
✅ NULL handling naturally converts sellers with <2 orders to 'No' output

📊 EXAMPLE WALKTHROUGH:

Assume:
users: seller_id=1, favorite_brand='Nike'
orders: seller_id=1, order_date='2024-01-05', item_id=101
        seller_id=1, order_date='2024-02-10', item_id=102
items: item_id=102, item_brand='Nike'

Process:
1. CTE adds rn: First order gets rn=1, second order gets rn=2
2. LEFT JOIN filters for rn=2: Gets the second order (item_id=102)
3. Join items table: Gets item_brand='Nike'
4. CASE evaluates: 'Nike' = 'Nike' → 'Yes'
Result: seller_id=1, item_fav_brand='Yes'

⚠️ POTENTIAL IMPROVEMENTS:

- Change 'Yes'/'No' to lowercase 'yes'/'no' to match problem statement exactly
- Could use COUNT(*) window function to filter out sellers with <2 orders explicitly
- Consider performance: Add indexes on (seller_id, order_date) and (item_id) for large datasets
*/
