-- QUESTION 
/*
You are given two tables:

players 	6 contains player information and their group

matches 	6 contains match results between two players

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
/*
Explanation of the solution (step-by-step):

1) Unpack each match into per-player score rows (player_scores):
   - Each match row contains two players and two scores. We "unpivot" the matches table
     into two rows per match using UNION ALL: one row for the first_player with its
     first_score, and another row for the second_player with its second_score. This
     produces a list of (player_id, score) entries for every appearance a player has
     in matches.

2) Sum total scores per player and attach group information (group_scores):
   - We join player_scores to the players table on player_id to find each player's
     group_id. Then we GROUP BY group_id and player_id and SUM(score) to compute
     the total score for each player within their group.

3) Rank players within each group to pick the winner (ranking):
   - Use a window function RANK() OVER (PARTITION BY group_id ORDER BY score DESC, player_id ASC)
     to assign ranks per group. We order primarily by total score DESC so higher scores
     come first. As the tie-breaker we order by player_id ASC so the smallest player_id
     wins when players have equal scores.
   - Because player_id is included in the ORDER BY as a deterministic tie-breaker,
     the top rank (ranks = 1) will identify a unique winner per group.
     (ROW_NUMBER() could also be used instead of RANK() to guarantee a single row;
     here RANK() works equivalently because the ORDER BY guarantees unique ordering.)

4) Select winners:
   - Finally we select rows where ranks = 1, returning group_id, player_id and the
     computed total score for each group's winner.

Notes and edge cases:
- Players who never played a match will not appear in player_scores and therefore will
  be absent from the results. If you want to include players with zero total score,
  change the aggregation to LEFT JOIN players to player_scores and COALESCE(SUM(score),0).
- If two players have the same total score, the tie-breaker enforces the smaller player_id
  as the winner as required.

Complexity:
- The query scans the matches table once (to produce player_scores), aggregates by
  player, and applies a window function partitioned by group. Performance is typical
  for aggregation + window operations on these tables and should be fine for usual
  tournament sizes.
*/
