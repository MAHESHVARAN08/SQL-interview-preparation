--QUESTION
'''
Identify the second highest salary in the company using a subquery.
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

INSERT INTO employees (employee_id, employee_name, department, salary)
VALUES
(101, 'Arun', 'IT', 90000),
(102, 'Bala', 'HR', 75000),
(103, 'Charan', 'IT', 85000),
(104, 'Deepak', 'Finance', 60000),
(105, 'Ezhil', 'HR', 75000),
(106, 'Gokul', 'Finance', 95000),
(107, 'Hari', 'IT', 65000),
(108, 'Karthik', 'Finance', 80000),
(109, 'Manoj', 'HR', 55000),
(110, 'Naveen', 'IT', 95000),
(111, 'Praveen', 'Finance', 70000),
(112, 'Raj', 'HR', 85000);
'''

--SOLUTION
select max(salary) as second_highest_salary
from employees
where salary < (select max(salary) from employees)
