--QUESTION
'''
Find departments where all employees earn above a specific threshold.
CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2)
);
INSERT INTO employees VALUES
(1, 'Arun', 101, 60000),
(2, 'Bala', 101, 75000),
(3, 'Charan', 102, 45000),
(4, 'David', 102, 55000),
(5, 'Ezhil', 103, 80000),
(6, 'Farhan', 103, 90000),
(7, 'Gokul', 104, 40000),
(8, 'Hari', 104, 70000);
'''

--SOLUTION

SELECT department_id
FROM employees
GROUP BY department_id
HAVING MIN(salary) > 50000;
