/* 
You are given an employee table containing employee salary information.

Answer the following:

Using WHERE clause
→ Fetch all employees whose salary is greater than 5000

Using HAVING clause
→ Fetch those manager_id for which the average salary of employees reporting to that manager is greater than 10,000

Explain why WHERE works in case 1 and HAVING is required in case 2.

🧱 Table Structure (Given)

CREATE TABLE emp
(
    emp_id INT,
    emp_name TEXT,
    salary INT,
    manager_id INT
);

*/

--SOLUTION
select manager_id,avg(salary) as avg_salary
from emp
where salary > 5000
group by manager_id
having avg_salary > 10000
