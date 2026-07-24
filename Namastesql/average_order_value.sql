--QUESTION
/*
Write an SQL query to determine the transaction date with the lowest average order value (AOV) among all dates recorded in the transaction table. 
Display the transaction date, its corresponding AOV, and the difference between the AOV for that date and the highest AOV for any day in the dataset. 
Round the result to 2 decimal places.

 

Table: transactions 
+--------------------+--------------+
| COLUMN_NAME        | DATA_TYPE    |
+--------------------+--------------+
| order_id           | int          |
| transaction_amount | decimal(5,2) |
| transaction_date   | date         |
| user_id            | int          |
+--------------------+--------------+
*/

--SOLUTION
with average as (select
	transaction_date,
	avg(transaction_amount) as aov
from transactions
group by transaction_date ),
rnk as (
select * , row_number() over(order by aov asc) as rn, max(aov) over() as highest_aov
from average )

select transaction_date, round(aov,2) as aov , round(highest_aov-aov,2) as diff_from_highest_aov
from rnk
where rn =1

--EXPLANATION
