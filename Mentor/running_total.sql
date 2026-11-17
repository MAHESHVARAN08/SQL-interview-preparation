'''
1. Create table
CREATE TABLE orders (
    order_id INT,
    customer_name VARCHAR(50),
    order_date DATE,
    order_amount DECIMAL(10,2)
);


2. Insert sample records
INSERT INTO orders
(order_id, customer_name, order_date, order_amount)
VALUES
(1, 'Arun', '2026-01-01', 1500),
(2, 'Bala', '2026-01-01', 2000),
(3, 'Charan', '2026-01-02', 1000),
(4, 'Arun', '2026-01-02', 2500),
(5, 'Deepak', '2026-01-03', 3000),
(6, 'Bala', '2026-01-03', 1200),
(7, 'Ezhil', '2026-01-04', 1800),
(8, 'Charan', '2026-01-04', 2200),
(9, 'Arun', '2026-01-05', 3500),
(10, 'Deepak', '2026-01-05', 1700),
(11, 'Bala', '2026-01-06', 2800),
(12, 'Ezhil', '2026-01-06', 1300);


3. Your challenge
Calculate a running total of orders by order date.

Expected output structure:
order_id	order_date	order_amount	running_total
1	2026-01-01	1500	?
2	2026-01-01	2000	?
3	2026-01-02	1000	?
4	2026-01-02	2500	?
5	2026-01-03	3000	?
...	...	...	...
'''
--SOLUTION
select * , sum(order_amount) over(order by order_date,order_id) as running_total
from orders
