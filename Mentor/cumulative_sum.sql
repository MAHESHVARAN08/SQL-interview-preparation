'''
1. Create table
CREATE TABLE employee_sales (
    employee_id INT,
    employee_name VARCHAR(50),
    sale_date DATE,
    sales_amount DECIMAL(10,2)
);


2. Insert sample records
INSERT INTO employee_sales
(employee_id, employee_name, sale_date, sales_amount)
VALUES
(101, 'Arun', '2026-01-01', 1000),
(101, 'Arun', '2026-01-02', 1500),
(101, 'Arun', '2026-01-03', 2000),
(101, 'Arun', '2026-01-04', 1200),

(102, 'Bala', '2026-01-01', 800),
(102, 'Bala', '2026-01-02', 1200),
(102, 'Bala', '2026-01-03', 1800),
(102, 'Bala', '2026-01-04', 1000),

(103, 'Charan', '2026-01-01', 500),
(103, 'Charan', '2026-01-02', 700),
(103, 'Charan', '2026-01-03', 900),
(103, 'Charan', '2026-01-04', 1100);


3. Your task
Find the cumulative sum of sales for each employee.

Expected output structure:
employee_id	employee_name	sale_date	sales_amount	cumulative_sales
101	Arun	2026-01-01	1000	?
101	Arun	2026-01-02	1500	?
101	Arun	2026-01-03	2000	?
101	Arun	2026-01-04	1200	?
102	Bala	2026-01-01	800	?
...	...	...	...	...
'''
--Solution
SELECT * , sum(sales_amount) over(partition by employee_name order by sale_date rows between unbounded preceding and current row) as cumulative_sales
FROM employee_sales
