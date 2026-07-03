--QUESTION
/*
You are given a table spending that records user purchase history on an e-commerce platform.

Each record contains:

user_id – ID of the user

spend_date – Date of purchase

platform – Platform used (mobile or desktop)

amount – Amount spent

A user can make purchases from:

Mobile only

Desktop only

Both mobile and desktop on the same day

🔍 Task

Write an SQL query to find, for each spend_date, the following three metrics:

Mobile Only

Total number of users who purchased only on mobile

Total amount spent by those users

Desktop Only

Total number of users who purchased only on desktop

Total amount spent by those users

Both Platforms

Total number of users who purchased on both mobile and desktop

Total amount spent by those users (mobile + desktop)

⚠️ Important:

Every date must return exactly 3 rows: mobile_only, desktop_only, both

Even if a category has zero users, it must still appear

🧱 Table Definition

CREATE TABLE spending 
(
    user_id INT,
    spend_date DATE,
    platform VARCHAR(10),
    amount INT
); */

--SOLUTION

with spends as (select spend_date,user_id,max(platform) as platform,sum(amount) as amount
from spending
group by spend_date,user_id
having count(distinct(platform))=1
union all
select spend_date,user_id,'both' as platform,sum(amount) as amount
from spending
group by spend_date,user_id
having count(distinct(platform))=2
union all
select distinct spend_date, null as user_id, 'both' as platform, 0 as amount from spending

)

select spend_date,platform,sum(amount) as total_amount, count(user_id) as total_users
from spends
group by spend_date,platform
order by spend_date,platform desc

--EXPLANATION
/*
This SQL solution identifies user purchase patterns (mobile-only, desktop-only, or both) 
for each date using a three-part UNION approach:

STEP 1: SINGLE PLATFORM USERS (HAVING count(distinct(platform))=1)
--------
Purpose: Identify users who purchased from ONLY ONE platform on a given date

Logic:
  - GROUP BY spend_date, user_id to aggregate data per user per day
  - count(distinct(platform)) = 1 means user made purchases on only one platform type
  - max(platform) returns either 'mobile' or 'desktop' (since there's only 1 distinct platform)
  - sum(amount) gives total spending for that user on that date

Result Example:
  If User 1 bought on 2025-01-01 only from mobile: 
    → (2025-01-01, 1, 'mobile', 500)

---

STEP 2: MULTI-PLATFORM USERS (HAVING count(distinct(platform))=2)
--------
Purpose: Identify users who purchased from BOTH platforms on the same date

Logic:
  - GROUP BY spend_date, user_id to aggregate data per user per day
  - count(distinct(platform)) = 2 means user made purchases from both 'mobile' AND 'desktop'
  - Explicitly set platform = 'both' (since multiple platforms are involved)
  - sum(amount) aggregates total spending across both platforms for that user on that date

Result Example:
  If User 2 spent $300 on mobile and $200 on desktop on 2025-01-01:
    → (2025-01-01, 2, 'both', 500)

---

STEP 3: PLACEHOLDER FOR ZERO-COUNT CATEGORIES (UNION ALL third query)
--------
Purpose: Ensure every date appears in results with all 3 categories, even if some have 0 users

Logic:
  - SELECT DISTINCT spend_date gets all unique dates from the spending table
  - Hardcoded: user_id = null, platform = 'both', amount = 0
  - This acts as a placeholder to guarantee 'both' category exists for every date

Why needed?
  If on 2025-01-01 no user bought from both platforms, the second UNION query produces 
  no 'both' row. This step ensures the final results always show 3 rows per date.

Result:
  For each unique date: (date, null, 'both', 0)

---

FINAL SELECT: AGGREGATE & FORMAT RESULTS
--------
select spend_date, platform, sum(amount) as total_amount, count(user_id) as total_users

After the CTE combines all three result sets:
  - GROUP BY spend_date, platform: Consolidate multiple users in the same category/date
  - sum(amount): Total amount for all users in that category/date
  - count(user_id): Number of users (null values from placeholder are NOT counted)
  - ORDER BY spend_date, platform DESC: Ensures 'mobile' > 'desktop' > 'both' alphabetically

---

EXAMPLE OUTPUT
--------
Input (spending table):
  | user_id | spend_date | platform | amount |
  |---------|------------|----------|--------|
  | 1       | 2025-01-01 | mobile   | 100    |
  | 1       | 2025-01-01 | desktop  | 50     |
  | 2       | 2025-01-01 | mobile   | 75     |
  | 3       | 2025-01-02 | desktop  | 200    |

Output:
  | spend_date | platform    | total_amount | total_users |
  |------------|-------------|--------------|-------------|
  | 2025-01-01 | mobile      | 75           | 1           | ← User 2 (mobile only)
  | 2025-01-01 | desktop     | 0            | 0           | ← No desktop-only on this date
  | 2025-01-01 | both        | 150          | 1           | ← User 1 (bought from both)
  | 2025-01-02 | mobile      | 0            | 0           | ← No mobile-only on this date
  | 2025-01-02 | desktop     | 200          | 1           | ← User 3 (desktop only)
  | 2025-01-02 | both        | 0            | 0           | ← No multi-platform on this date

---

KEY INSIGHTS
--------
1. UNION ALL combines three independent queries without removing duplicates
2. count(distinct(platform)) filters users by purchase diversity
3. max(platform) deterministically chooses one value when only one platform exists
4. The third query's null values are invisible to count() aggregate function
5. Every date guaranteed to have exactly 3 rows in output
*/
