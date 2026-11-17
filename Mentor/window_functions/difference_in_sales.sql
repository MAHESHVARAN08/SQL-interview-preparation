'''
1. Create table
CREATE TABLE monthly_sales (
    sales_id INT,
    employee_name VARCHAR(50),
    sales_month DATE,
    sales_amount DECIMAL(12,2)
);


2. Insert sample records
I've included multiple employees and multiple months so you can practise partitioning as well.
INSERT INTO monthly_sales
(sales_id, employee_name, sales_month, sales_amount)
VALUES
-- Arun
(1, 'Arun', '2026-01-01', 10000),
(2, 'Arun', '2026-02-01', 12000),
(3, 'Arun', '2026-03-01', 15000),
(4, 'Arun', '2026-04-01', 13000),
(5, 'Arun', '2026-05-01', 18000),

-- Bala
(6, 'Bala', '2026-01-01', 8000),
(7, 'Bala', '2026-02-01', 9500),
(8, 'Bala', '2026-03-01', 9000),
(9, 'Bala', '2026-04-01', 11000),
(10, 'Bala', '2026-05-01', 14000),

-- Charan
(11, 'Charan', '2026-01-01', 15000),
(12, 'Charan', '2026-02-01', 14000),
(13, 'Charan', '2026-03-01', 17000),
(14, 'Charan', '2026-04-01', 19000),
(15, 'Charan', '2026-05-01', 16000);


3. Your SQL challenge
Compute the difference between the current and previous month's sales.

Expected output structure:
Employee	Month	Current sales	Previous sales	Difference
Arun	Jan	10000	NULL	NULL
Arun	Feb	12000	10000	2000
Arun	Mar	15000	12000	3000
Arun	Apr	13000	15000	-2000
Arun	May	18000	13000	5000
Bala	Jan	8000	NULL	NULL
Bala	Feb	9500	8000	1500
'''

--SOLUTION
with cte as (select * , extract(month from sales_month) as monthe from monthly_sales),
cte1 as (select * , sales_amount as current_sales, lag(sales_amount) over(partition by employee_name order by monthe asc) as previous_sales from cte )
select * , (current_sales - previous_sales) as difference  from cte1
