--QUESTION
'''
Retrieve customers who have placed more than 5 orders.
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2)
);

INSERT INTO customers (customer_id, customer_name)
VALUES
(101, 'Arun'),
(102, 'Bala'),
(103, 'Charan'),
(104, 'Deepak'),
(105, 'Ezhil'),
(106, 'Gokul'),
(107, 'Arun'),
(108, 'Hari'),
(109, 'Karthik'),
(110, 'Manoj');

INSERT INTO orders (order_id, customer_id, order_date, order_amount)
VALUES
(1, 101, '2026-01-01', 1500),
(2, 101, '2026-01-02', 2000),
(3, 101, '2026-01-03', 2500),
(4, 101, '2026-01-04', 1800),
(5, 101, '2026-01-05', 3000),
(6, 101, '2026-01-06', 1200),
(7, 102, '2026-01-01', 1000),
(8, 102, '2026-01-02', 1500),
(9, 102, '2026-01-03', 2000),
(10, 102, '2026-01-04', 2500),
(11, 102, '2026-01-05', 3000),
(12, 103, '2026-01-01', 1200),
(13, 103, '2026-01-02', 1800),
(14, 103, '2026-01-03', 2200),
(15, 103, '2026-01-04', 1600),
(16, 103, '2026-01-05', 1900),
(17, 103, '2026-01-06', 2100),
(18, 104, '2026-01-01', 3000),
(19, 104, '2026-01-02', 3500),
(20, 105, '2026-01-01', 1000),
(21, 105, '2026-01-02', 1200),
(22, 105, '2026-01-03', 1400),
(23, 105, '2026-01-04', 1600),
(24, 105, '2026-01-05', 1800),
(25, 105, '2026-01-06', 2000),
(26, 107, '2026-01-01', 2500),
(27, 107, '2026-01-02', 3000),
(28, 108, '2026-01-01', 1700),
(29, NULL, '2026-01-01', 2200);
'''

--SOLUTION
select distinct c.customer_id, c.customer_name , o.order_count from (select *, count(order_id) over(partition by customer_id) as order_count from orders) as o inner join customers as c
on o.customer_id = c.customer_id 
where o.order_count > 5
