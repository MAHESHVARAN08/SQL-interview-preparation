'''
QUESTION
CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(50),
    department VARCHAR(50)
);
CREATE TABLE projects (
    project_id INT,
    project_name VARCHAR(100),
    employee_id INT
);
INSERT INTO employees
(employee_id, employee_name, department)
VALUES
(101, 'Arun', 'IT'),
(102, 'Bala', 'HR'),
(103, 'Charan', 'Finance'),
(104, 'Deepak', 'IT'),
(105, 'Ezhil', 'HR'),
(106, 'Gokul', 'Finance'),
(107, 'Hari', 'IT'),
(108, 'Karthik', 'Finance'),
(109, 'Manoj', 'HR'),
(110, 'Naveen', 'IT');
INSERT INTO projects
(project_id, project_name, employee_id)
VALUES
(1, 'Data Migration', 101),
(2, 'Cloud Upgrade', 102),
(3, 'ETL Development', 101),
(4, 'AWS Migration', 104),
(5, 'Reporting Dashboard', 106),
(6, 'Pipeline Optimization', 108),
(7, 'Data Warehouse', 102);
'''

--SOLUTION
SELECT DISTINCT e.employee_id, e.employee_name, e.department
FROM employees as e
left join projects as p 
on e.employee_id = p.employee_id
where p.project_id is null
