'''question
CREATE TABLE customers (
    customer_id INT,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);
CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2)
);
INSERT INTO customers (customer_id, customer_name, city)
VALUES
(101, 'Arun', 'Chennai'),
(102, 'Bala', 'Bangalore'),
(103, 'Charan', 'Hyderabad'),
(104, 'Deepak', 'Mumbai'),
(105, 'Ezhil', 'Chennai'),
(106, 'Gokul', 'Pune'),
(107, 'Hari', 'Delhi'),
(108, 'Karthik', 'Coimbatore');
INSERT INTO orders (order_id, customer_id, order_date, order_amount)
VALUES
(1, 101, '2026-01-01', 1500),
(2, 102, '2026-01-02', 2500),
(3, 101, '2026-01-05', 3000),
(4, 103, '2026-01-06', 1800),
(5, 105, '2026-01-08', 4500),
(6, 103, '2026-01-10', 2200),
(7, 106, '2026-01-12', 3500),
(8, 108, '2026-01-15', 5000);
'''
--SOLUTION
select distinct c.customer_id,c.customer_name,c.city
from customers as c
inner join orders as o 
on c.customer_id = o.customer_id
