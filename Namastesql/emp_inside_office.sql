--QUESTION
/*
A company record its employee's movement In and Out of office in a table. Please note below points about the data:

 

1- First entry for each employee is “in”
2- Every “in” is succeeded by an “out”
3- Employee can work across days
Write a SQL to find the number of employees inside the Office at “2019-04-01 19:05:00".

 

Table: employee_record
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| emp_id      | int        |
| action      | varchar(3) |
| created_at  | datetime   |
+-------------+------------+

*/

--SOLUTION
with chk as (select emp_id, action , created_at, 
		lead(created_at,1,cast('2019-04-30 23:59:00' as timestamp)) over(partition by emp_id) as out_time
from employee_record )
select count(distinct(emp_id)) as no_of_emp_inside from chk 
where action = 'in' and '2019-04-01 19:05:00' between created_at and out_time

--EXPLANATION
