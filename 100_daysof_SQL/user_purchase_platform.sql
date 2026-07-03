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
