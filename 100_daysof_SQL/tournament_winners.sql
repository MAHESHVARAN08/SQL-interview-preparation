-- QUESTION 
/*
You are given two tables:

players – contains player information and their group

matches – contains match results between two players

Each player belongs to one group only.

Each match has:

two players

score of both players

🎯 Objective

Write an SQL query to find the tournament winner for each group.

🏆 Winner Rules

For each group, calculate total score per player

The player with the maximum total score in a group is the winner

Tie-breaker:

If multiple players have the same score, the lowest player_id wins

🧱 Table Structures

CREATE TABLE players
(
  player_id INT,
  group_id INT
);
 
CREATE TABLE matches
(
  match_id INT,
  first_player INT,
  second_player INT,
  first_score INT,
  second_score INT
);
*/

--SOLUTION
with player_scores as (select first_player as player_id, first_score as score from matches
union all
select second_player as player_id, second_score as score from matches),
group_scores as (select p.group_id, p.player_id, sum(score) as score from player_scores as ps 
inner join players as p 
on ps.player_id = p.player_id
group by p.group_id,p.player_id),
ranking as (
select *, rank() over(partition by group_id order by score desc,player_id asc) as ranks from group_scores)

select group_id,player_id,score from ranking
where ranks =1


--EXPLANATION
