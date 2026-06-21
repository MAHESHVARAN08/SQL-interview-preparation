-- QUESTION
/*
You are given an emp table that stores employee details including salary.

Task:
Write SQL queries to calculate the median salary of employees.

You must:

Handle both odd and even number of records

Solve it using:

Method 1: Generic SQL (works in all databases)

Method 2: PERCENTILE_CONT() (database-specific)

👉 Assume no built-in MEDIAN function exists.

🧱 Table Structure (Given)

CREATE TABLE emp
(
    emp_id INT,
    emp_name VARCHAR(20),
    department_id INT,
    salary INT,
    manager_id INT,
    emp_age INT
);

*/

--SOLUTION
with row_num as (select *,
row_number() over(partition by department_id order by salary asc) as asc_row_num,
row_number() over(partition by department_id order by salary desc) as desc_row_num
from emp)

select department_id, avg(salary) as median_salary from row_num
where abs(asc_row_num - desc_row_num)<=1
group by department_id

--EXPLANATION
