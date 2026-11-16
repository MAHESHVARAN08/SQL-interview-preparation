'''
1. Create table
CREATE TABLE employee_sales (
    employee_id INT,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    sales_amount DECIMAL(10,2)
);


2. Insert sample records
INSERT INTO employee_sales
(employee_id, employee_name, department, sales_amount)
VALUES
-- Sales department
(101, 'Arun', 'Sales', 50000),
(102, 'Bala', 'Sales', 75000),
(103, 'Charan', 'Sales', 60000),
(104, 'Deepak', 'Sales', 75000),

-- IT department
(105, 'Ezhil', 'IT', 90000),
(106, 'Gokul', 'IT', 85000),
(107, 'Hari', 'IT', 95000),
(108, 'Karthik', 'IT', 70000),

-- HR department
(109, 'Manoj', 'HR', 40000),
(110, 'Naveen', 'HR', 55000),
(111, 'Praveen', 'HR', 45000),
(112, 'Raj', 'HR', 60000);


3. Your SQL challenge
Rank employees based on their sales within their department.

Expected output structure:
employee_name	department	sales_amount	sales_rank
Bala	Sales	75000	?
Deepak	Sales	75000	?
Charan	Sales	60000	?
Arun	Sales	50000	?
Hari	IT	95000	?
Ezhil	IT	90000	?
Gokul	IT	85000	?
Karthik	IT	70000	?
'''

--solution
select * , dense_rank() over(partition by department order by sales_amount desc) as sales_rank
from employee_sales
