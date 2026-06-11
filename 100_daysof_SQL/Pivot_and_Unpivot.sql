/*
-----QUESTION:

You are given an employee compensation table where each salary component is stored as a separate row.

Each employee can have multiple salary components such as:

salary

bonus

hike_percentage

Your manager wants the data in a columnar format, where:

Each employee appears only once

Each salary component becomes a separate column

You must not use database-specific PIVOT or UNPIVOT functions.
Use standard SQL only.

📋 Input Table

CREATE TABLE emp_compensation (
    emp_id INT,
    salary_component_type VARCHAR(20),
    val INT
);
Expected Output

*/

----SOLUTION
select emp_id,
sum(case
    when salary_component_type = "salary" then val
    end)
as salary,
sum(case
    when salary_component_type = "bonus" then val
    end)
as bonus,
sum(case 
    when salary_component_type = "hike_percent" then val
    end)
as hike_percent 
from emp_compensation
group by emp_id
