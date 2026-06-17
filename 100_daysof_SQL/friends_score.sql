/*
You are given two tables:

person – stores each person's basic information and score.

friend – stores friendship relationships between people.

A person can have one or more friends.

🎯 Objective

Write a SQL query to find details of persons whose friends' total score is greater than 100.

For each qualifying person, return:

PersonID

Name

Number of friends

Total score of all friends

📋 Table Structures

CREATE TABLE person (
    PersonID INT,
    Name VARCHAR(50),
    Score INT
);
 
CREATE TABLE friend (
    pid INT,   -- person id
    fid INT    -- friend id
);
*/

--SOLUTION 
with score_details as (select f.pid as pid,sum(p.Score) as total_friend_score, count(*) as no_of_friends 
from friend as f 
inner join person as p 
on f.fid=p.PersonID
group by f.pid
having sum(p.Score) > 100)

select s.pid,s.total_friend_score, s.no_of_friends, p.Name as person_name
from score_details as s 
inner join person as p 
on s.pid=p.PersonID


/*
================================================================================
                          📚 DETAILED EXPLANATION
================================================================================

🔍 QUERY BREAKDOWN:

The query uses a Common Table Expression (CTE) and executes in 2 main steps:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 1: CTE - score_details (Calculate friend statistics for each person)
────────────────────────────────────────────────────────────────────────────

  with score_details as (
    select f.pid as pid,
           sum(p.Score) as total_friend_score, 
           count(*) as no_of_friends 
    from friend as f 
    inner join person as p 
    on f.fid = p.PersonID
    group by f.pid
    having sum(p.Score) > 100
  )

  What happens:
  ─────────────
  • INNER JOIN friend (f) with person (p)
    └─ Match: f.fid (friend's ID) = p.PersonID (person's ID)
    └ Purpose: Get the score of each friend

  • GROUP BY f.pid
    └─ Groups all friends by the person ID (pid) who has them
    └ Example: All friends of Person 1 grouped together

  • SUM(p.Score) → total_friend_score
    └─ Adds up scores of all friends for each person
    └ Example: Person 1's friends scored 30+40+50 = 120

  • COUNT(*) → no_of_friends
    └─ Counts how many friends each person has
    └ Example: Person 1 has 3 friends

  • HAVING SUM(p.Score) > 100
    └─ Filters out persons whose friends' TOTAL score ≤ 100
    └ Only keeps persons with friends' total score > 100

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 2: Main SELECT (Get person's details)
───────────────────────────────────────────

  select s.pid,
         s.total_friend_score, 
         s.no_of_friends, 
         p.Name as person_name
  from score_details as s 
  inner join person as p 
  on s.pid = p.PersonID

  What happens:
  ─────────────
  • Joins CTE (score_details) with person table
    └─ s.pid = p.PersonID to get the person's name

  • Returns 4 columns:
    ├─ s.pid → PersonID of the person
    ├─ s.total_friend_score → Combined score of all their friends
    ├─ s.no_of_friends → Count of friends
    └─ p.Name → Person's name

================================================================================

📋 SAMPLE DATA & EXECUTION:

  PERSON table:
  ┌─────────┬────────┬───────┐
  │ PersonID│ Name   │ Score │
  ├─────────┼────────┼───────┤
  │ 1       │ Alice  │ 80    │
  │ 2       │ Bob    │ 30    │
  │ 3       │ Carol  │ 40    │
  │ 4       │ David  │ 50    │
  │ 5       │ Eve    │ 60    │
  └─────────┴────────┴───────┘

  FRIEND table:
  ┌─────┬─────┐
  │ pid │ fid │  (pid = person, fid = friend)
  ├─────┼─────┤
  │ 1   │ 2   │  Alice's friend: Bob (score 30)
  │ 1   │ 3   │  Alice's friend: Carol (score 40)
  │ 1   │ 4   │  Alice's friend: David (score 50)
  │ 5   │ 2   │  Eve's friend: Bob (score 30)
  │ 5   │ 3   │  Eve's friend: Carol (score 40)
  └─────┴─────┘

  EXECUTION TRACE:

  CTE Calculation:
  ┌─────┬──────────────────────┬──────────────┐
  │ pid │ total_friend_score   │ no_of_friends│
  ├─────┼──────────────────────┼──────────────┤
  │ 1   │ 30+40+50 = 120 ✅    │ 3            │
  │ 5   │ 30+40 = 70 ❌        │ 2            │
  └─────┴──────────────────────┴──────────────┘

  After HAVING filter (score > 100): Only Person 1 qualifies

  FINAL OUTPUT:
  ┌────────┬──────────────────────┬──────────────┬──────────────┐
  │ pid    │ total_friend_score   │ no_of_friends│ person_name  │
  ├────────┼──────────────────────┼──────────────┼──────────────┤
  │ 1      │ 120                  │ 3            │ Alice        │
  └────────┴──────────────────────┴──────────────┴──────────────┘

================================================================================

🎯 KEY CONCEPTS USED:

  1. INNER JOIN
     └─ Only returns rows where there's a match on both sides
     └ Used to match friends with their scores

  2. GROUP BY
     └─ Aggregates data by a specific column (here: pid)
     └ Allows use of aggregate functions like SUM() and COUNT()

  3. HAVING Clause
     └─ Filters grouped results (applies to aggregate functions)
     └ Different from WHERE: WHERE filters rows BEFORE grouping,
       HAVING filters groups AFTER aggregation

  4. Common Table Expression (CTE)
     └─ Temporary result set that can be referenced in the main query
     └ Makes complex queries more readable and maintainable

  5. Aggregate Functions
     └─ SUM() → calculates total
     └─ COUNT() → counts rows

================================================================================
*/