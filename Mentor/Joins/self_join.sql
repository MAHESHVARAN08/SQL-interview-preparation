--QUESTION

'''
CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(50),
    department VARCHAR(50)
);
INSERT INTO employees
(employee_id, employee_name, department)
VALUES
(101, 'Arun', 'IT'),
(102, 'Bala', 'IT'),
(103, 'Charan', 'IT'),
(104, 'Deepak', 'HR'),
(105, 'Ezhil', 'HR'),
(106, 'Gokul', 'Finance'),
(107, 'Hari', 'Finance'),
(108, 'Karthik', 'IT'),
(109, 'Manoj', 'HR'),
(110, 'Naveen', 'Finance');
'''

--SOLUTION
select e1.employee_name as employee_1 , e2.employee_name as employee_2 , e1.department as department
from employees as e1
inner join employees as e2
on e1.department = e2.department and e1.employee_id < e2.employee_id
