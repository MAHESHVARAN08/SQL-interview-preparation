-- QUESTION
'''
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    category VARCHAR(50)
);
INSERT INTO products (product_id, product_name, category)
VALUES
(101, 'Laptop', 'Electronics'),
(102, 'Mobile', 'Electronics'),
(103, 'Tablet', 'Electronics'),
(104, 'Keyboard', 'Accessories'),
(105, 'Mouse', 'Accessories');
'''
--SOLUTION

SELECT p1.product_name as p1, p2.product_name as p2
from products as p1
cross join products as p2
