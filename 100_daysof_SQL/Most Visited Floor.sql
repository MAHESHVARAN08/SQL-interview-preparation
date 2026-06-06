-- QUESTION
/*
A company allows only one entry per employee per day.
However, employees found a loophole:
they can enter multiple times using different email IDs.

You are given an entries table that logs:

employee name

address

email used

floor visited

resource used

🎯 Your task is to write an SQL query that returns:

For each person:

Total number of visits

Most visited floor

List of distinct resources used

🧱 Table Structure

CREATE TABLE entries ( 
    name VARCHAR(20),
    address VARCHAR(20),
    email VARCHAR(30),
    floor INT,
    resources VARCHAR(20)
);
*/

--SOLUTION
with floor_count as(
select name, floor, count(floor) as max_count,  row_number() over(partition by name order by count(floor) desc) as rank
from entries
group by name, floor),
total_visites as (
select name,count(*) as total,  GROUP_CONCAT(DISTINCT resources) as resources
from entries
group by name)
select f.name,f.floor as most_visited_floor,t.total as total_visits, t.resources as used_resources
from floor_count as f 
inner join total_visites as t 
on f.name=t.name
where rank=1

--EXPLANATION
/*
This SQL file contains a solution to find employee visit patterns despite the loophole where they use different email IDs to visit multiple times per day.

Problem
Employees can bypass the one-entry-per-day rule by using different email addresses
Need to track their actual visiting behavior
Solution Output
The query returns for each person:

Total number of visits (across all email IDs)
Most visited floor
List of distinct resources used
Approach
The solution uses two CTEs (Common Table Expressions):

floor_count CTE: Groups visits by employee and floor, counts them, and ranks floors by visit frequency (descending). The ROW_NUMBER() window function assigns rank 1 to the most visited floor.

total_visites CTE: Aggregates total visits per employee and concatenates all distinct resources used.

Final SELECT: Joins both CTEs on employee name and filters for rank=1 to get only the most visited floor, combining all required information.

Note: The query uses GROUP_CONCAT() which is MySQL-specific syntax for string aggregation.
*/






