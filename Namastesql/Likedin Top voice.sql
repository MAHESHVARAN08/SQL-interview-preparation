/*
LinkedIn is a professional social networking app. They want to give top voice badge to their best creators to encourage them to create more quality content. 
A creator qualifies for the badge if he/she satisfies following criteria.

1- Creator should have more than 50k followers.
2- Creator should have more than 100k impressions on the posts that they published in the month of Dec-2023.
3- Creator should have published atleast 3 posts in Dec-2023.

Write a SQL to get the list of top voice creators name along with no of posts and impressions by them in the month of Dec-2023.

Table: creators(primary key : creator_id)
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| creator_id   | int         |
| creator_name | varchar(20) |
| followers    | int         |
+--------------+-------------+
Table: posts(primary key : post_id)
+--------------+------------+
| COLUMN_NAME  | DATA_TYPE  |
+--------------+------------+
| creator_id   | int        |
| post_id      | varchar(3) |
| publish_date | date       |
| impressions  | int        |
+--------------+------------+

*/

--solution 

select 
	c.creator_name, 
	count(p.post_id) as no_of_posts, 
	sum(p.impressions) as total_impressions
from creators as c
inner join posts as p -- join two tables on creator id then we get all the details of the creator 
on p.creator_id = c.creator_id
where c.followers > 50000 and p.publish_date between '2023-12-01' and '2023-12-31'   -- filter the records which is having more than 50k followers and published in the month of dec-2023
group by c.creator_name -- Group by creator name so that we can get aggregated values for each creator such as no of post per creator and total impression per creator 
having count(p.post_id)>= 3 and sum(p.impressions) > 100000  -- from the grouped value we need only the records which creator is having 3 or more post and total impression of above 100k  
ORDER BY  total_impressions DESC -- order by highest value first

