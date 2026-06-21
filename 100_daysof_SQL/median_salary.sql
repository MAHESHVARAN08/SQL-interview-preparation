-- QUESTION
/*
You are given an emp table that stores employee details including salary.

Task:
Write SQL queries to calculate the median salary of employees.

You must:

Handle both odd and even number of records

Solve it using:

Method 1: Generic SQL (works in all databases)

Method 2: PERCENTILE_CONT() (database-specific)

👉 Assume no built-in MEDIAN function exists.

🧱 Table Structure (Given)

CREATE TABLE emp
(
    emp_id INT,
    emp_name VARCHAR(20),
    department_id INT,
    salary INT,
    manager_id INT,
    emp_age INT
);

*/

--SOLUTION
with row_num as (select *,
row_number() over(partition by department_id order by salary asc) as asc_row_num,
row_number() over(partition by department_id order by salary desc) as desc_row_num
from emp)

select department_id, avg(salary) as median_salary from row_num
where abs(asc_row_num - desc_row_num)<=1
group by department_id

--EXPLANATION

/*
## How This SQL Query Calculates Median Salary

### Core Concept
The median is the middle value(s) in a sorted dataset. 
- For ODD number of records: single middle value
- For EVEN number of records: average of two middle values

### Step-by-Step Logic

#### Step 1: Create Row Numbers (CTE)
```
with row_num as (
    select *,
    row_number() over(partition by department_id order by salary asc) as asc_row_num,
    row_number() over(partition by department_id order by salary desc) as desc_row_num
    from emp
)
```

This CTE adds two window function columns:
- `asc_row_num`: Rank each salary in ASCENDING order within each department (1, 2, 3, 4, 5...)
- `desc_row_num`: Rank each salary in DESCENDING order within each department (5, 4, 3, 2, 1...)

**Example with 5 employees in a department:**
| Salary | asc_row_num | desc_row_num |
|--------|-------------|--------------|
| 30000  | 1           | 5            |
| 40000  | 2           | 4            |
| 50000  | 3           | 3    ← MEDIAN (matches!)
| 60000  | 4           | 2            |
| 70000  | 5           | 1            |

**Example with 4 employees in a department:**
| Salary | asc_row_num | desc_row_num |
|--------|-------------|--------------|
| 30000  | 1           | 4            |
| 40000  | 2           | 3    ← 1st middle value (diff = 1)
| 60000  | 3           | 2    ← 2nd middle value (diff = 1)
| 70000  | 4           | 1            |

#### Step 2: Filter Middle Values
```
where abs(asc_row_num - desc_row_num) <= 1
```

The `WHERE` clause identifies the middle salary/salaries:
- When `asc_row_num` and `desc_row_num` are equal or differ by 1, we're at the center
- For ODD count: exactly 1 row matches (asc_row_num = desc_row_num)
  - Example: 5 records → row 3 has asc_row_num=3, desc_row_num=3, diff=0 ✓
- For EVEN count: exactly 2 rows match (diff = 1)
  - Example: 4 records → row 2 has diff=1 AND row 3 has diff=1 ✓

#### Step 3: Calculate Average
```
select department_id, avg(salary) as median_salary
group by department_id
```

- For ODD records: `avg()` returns the single middle salary
- For EVEN records: `avg()` returns the average of the two middle salaries

### Why This Works

| Scenario | Records | asc_row_num | desc_row_num | abs(diff) | Result |
|----------|---------|------------|-------------|-----------|--------|
| Odd      | 5       | 1,2,3,4,5  | 5,4,3,2,1   | 4,2,0,2,4 | Only row 3 (diff=0) |
| Even     | 4       | 1,2,3,4    | 4,3,2,1     | 3,1,1,3   | Rows 2,3 (diff=1) |

### Time Complexity
- **Window Functions**: O(N log N) - sorting required
- **Filtering**: O(N)
- **Grouping**: O(N log N)
- **Overall**: O(N log N)

### Space Complexity
- O(N) - storing the CTE result set

### Key Advantages
✓ Works across all SQL databases (MySQL, PostgreSQL, SQL Server, Oracle)
✓ Handles both odd and even record counts automatically
✓ Partitions by department to calculate median per department
✓ No complex CASE statements needed
*/