/*

Suppose you are a data analyst working for a travel company that offers vacation rentals similar to Airbnb.
Your company wants to identify the top hosts with the highest average ratings for their listings. 
This information will be used to recognize exceptional hosts and potentially offer them incentives to continue providing outstanding service.

Your task is to write an SQL query to find the top 2 hosts with the highest average ratings for their listings. 
However, you should only consider hosts who have at least 2 listings, as hosts with fewer listings may not be representative.

Display output in descending order of average ratings and round the average ratings to 2 decimal places.

Table: listings
+----------------+---------------+
| COLUMN_NAME    | DATA_TYPE     |
+----------------+---------------+
| host_id        | int           |
| listing_id     | int           |
| minimum_nights | int           |
| neighborhood   | varchar(20)   |
| price          | decimal(10,2) |
| room_type      | varchar(20)   |
+----------------+---------------+
Table: reviews
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| listing_id  | int       |
| rating      | int       |
| review_date | date      |
| review_id   | int       |
+-------------+-----------+
*/

--solution

select 
  host_id, 
  count(distinct l.listing_id) as no_of_listings, -- one listing_id has multiple customers so to find the exact listing count for that host will have to take the distinct
  round(avg(rating),2) as avg_rating  -- take avg of rating 
from 
  listings as l
inner join 
  reviews as r
on 
  l.listing_id = r.listing_id
where 
  host_id in (select host_id from listings   --subquery is to find the host who are having greater than 1 listing 
  group by host_id
  having count(listing_id) >=2)
group by 
  host_id
order by 
  round(avg(rating),2) desc
limit 2 -- select top two host who is having highest rating


