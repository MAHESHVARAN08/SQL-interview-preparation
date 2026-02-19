-- Window functions

--1
select f.film_id,f.title,f.length,c.name as category,
round(avg(coalesce(f.length,0)) over(partition by c.name),2) as avg
from film f
left join film_category fc
on f.film_id = fc.film_id
left join category c
on fc.category_id = c.category_id
order by f.film_id


--2
select *,
count(*) over(partition by customer_id,amount) as count
from payment
order by payment_id

--3
select *
from
(select first_name ||' '|| last_name as name,
country,
count(amount) as no_of_sales,
row_number() over(partition by country order by count(amount) desc) as rank
from payment as p
left join customer as c
on p.customer_id = c.customer_id
left join address as a
on a.address_id = c.address_id
left join city as ci
on a.city_id = ci.city_id
left join country as co
on co.country_id = ci.country_id
group by first_name ||' '|| last_name,country) t
where rank <=3


--4
select sum(amount) as current_revenue,
date(payment_date) as day,
lag(sum(amount),1,0) over(order by date(payment_date)) as previous_revenue,
sum(amount) - lag(sum(amount),1,0) over(order by date(payment_date)) as difference,
coalesce(round((sum(amount) - lag(sum(amount)) over(order by date(payment_date)))
/
(lag(sum(amount)) over(order by date(payment_date)))*100,2),0) as percentage_growth
from payment
group by date(payment_date)

--1
select flight_id, departure_airport, actual_arrival-scheduled_arrival as difference,
sum(actual_arrival-scheduled_arrival) over(order by flight_id,departure_airport) as running_total
from flights


--2
select flight_id, departure_airport, actual_arrival-scheduled_arrival as difference,
sum(actual_arrival-scheduled_arrival) over(partition by departure_airport order by flight_id,departure_airport) as running_total
from flights

