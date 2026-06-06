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





