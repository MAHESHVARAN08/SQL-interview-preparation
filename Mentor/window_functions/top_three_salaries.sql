'''
1. Create table
CREATE TABLE employee (
    employee_id INT,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);


2. Insert sample records
INSERT INTO employee
(employee_id, employee_name, department, salary)
VALUES
-- IT Department
(101, 'Arun', 'IT', 90000),
(102, 'Bala', 'IT', 85000),
(103, 'Charan', 'IT', 95000),
(104, 'Deepak', 'IT', 85000),
(105, 'Ezhil', 'IT', 75000),
(106, 'Gokul', 'IT', 70000),

-- HR Department
(107, 'Hari', 'HR', 60000),
(108, 'Karthik', 'HR', 55000),
(109, 'Manoj', 'HR', 65000),
(110, 'Naveen', 'HR', 55000),
(111, 'Praveen', 'HR', 50000),
(112, 'Raj', 'HR', 45000),

-- Finance Department
(113, 'Sanjay', 'Finance', 80000),
(114, 'Vijay', 'Finance', 75000),
(115, 'Ajay', 'Finance', 90000),
(116, 'Kiran', 'Finance', 85000),
(117, 'Ramesh', 'Finance', 75000),
(118, 'Suresh', 'Finance', 70000);


3. Your SQL challenge
Identify the top three salaries in each department.

Expected output structure:
employee_name	department	salary	salary_rank
Charan	IT	95000	?
Arun	IT	90000	?
Bala	IT	85000	?
Deepak	IT	85000	?
Manoj	HR	65000	?
Hari	HR	60000	?
Karthik	HR	55000	?
Naveen	HR	55000	?
'''
--SOLUTION
with cte as (select * , dense_rank() over(partition by department order by salary desc) as salary_rank
from employee)
select * from cte
where salary_rank in (1,2,3)
