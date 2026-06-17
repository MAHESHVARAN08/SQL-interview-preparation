/*
You are given two tables:

person – stores each person’s basic information and score.

friend – stores friendship relationships between people.

A person can have one or more friends.

🎯 Objective

Write a SQL query to find details of persons whose friends’ total score is greater than 100.

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
