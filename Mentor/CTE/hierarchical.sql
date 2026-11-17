--QUESTION - Use a CTE to find employees who directly and indirectly report to a specific manager.

'''
  CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(50),
    manager_id INT
);
INSERT INTO employees (employee_id, employee_name, manager_id)
VALUES
(1, 'Arun', NULL),

(2, 'Bala', 1),
(3, 'Charan', 1),
(4, 'Deepak', 2),
(5, 'Ezhil', 2),
(6, 'Gokul', 3),
(7, 'Hari', 3),

(8, 'Karthik', 4),
(9, 'Manoj', 4),
(10, 'Naveen', 5),
(11, 'Praveen', 6),
(12, 'Raj', 8);
  '''
--solution

WITH RECURSIVE manager as (
  select employee_id, employee_name, manager_id, 1 as level
  from employees
  where manager_id =1
  union all
  select e.employee_id, e.employee_name, e.manager_id, m.level + 1
  from manager as m 
  join employees as e
  on e.manager_id = m.employee_id )
  select * from manager
