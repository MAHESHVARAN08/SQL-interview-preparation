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

/*
----DETAILED LOGIC EXPLANATION

📊 THE PROBLEM VISUALIZED:

Input (Row Format):
emp_id | salary_component_type | val
-------|----------------------|-----
  1    | salary               | 50000
  1    | bonus                | 5000
  1    | hike_percent         | 10
  2    | salary               | 60000
  2    | bonus                | 8000
  2    | hike_percent         | 15

Desired Output (Column Format):
emp_id | salary | bonus | hike_percent
-------|--------|-------|---------------
  1    | 50000  | 5000  | 10
  2    | 60000  | 8000  | 15

---

🔍 STEP-BY-STEP LOGIC BREAKDOWN:

STEP 1: CASE STATEMENT - CONDITIONAL CHECK
=========================================

CASE
    WHEN salary_component_type = "salary" THEN val
    ELSE NULL
END

What it does:
- Checks if the salary_component_type equals "salary"
- If TRUE → returns the value from the val column
- If FALSE → returns NULL (implicit)

Example for Employee 1:
Row 1: salary_component_type = "salary" → THEN 50000 ✓
Row 2: salary_component_type = "bonus"  → THEN NULL
Row 3: salary_component_type = "hike_percent" → THEN NULL

---

STEP 2: SUM() AGGREGATION - WHY SUM?
===================================

SUM(CASE WHEN salary_component_type = "salary" THEN val END) AS salary

Why SUM and not other functions?
- SUM() ignores NULL values
- When you SUM a single non-NULL value with NULL values, you get just that value
- For Employee 1: SUM(50000, NULL, NULL) = 50000

Example calculation:
SUM(CASE...) for salary column:
  Row 1: 50000 (matches "salary")
  Row 2: NULL  (doesn't match "salary")
  Row 3: NULL  (doesn't match "salary")
  ---
  Result = 50000

---

STEP 3: GROUP BY emp_id - CONSOLIDATION
======================================

GROUP BY emp_id

What it does:
- Groups all rows belonging to the same employee together
- Applies the CASE+SUM logic to each group separately
- Results in ONE row per employee

Example:
Employee 1 has 3 rows:
  salary row    → processed for "salary" column
  bonus row     → processed for "bonus" column
  hike_percent row → processed for "hike_percent" column
  
After GROUP BY emp_id, all 3 rows collapse into 1 row with 3 columns

---

📝 COMPLETE LOGIC FLOW FOR ONE EMPLOYEE:

INPUT (Employee 1):
Row 1: emp_id=1, type="salary",       val=50000
Row 2: emp_id=1, type="bonus",        val=5000
Row 3: emp_id=1, type="hike_percent", val=10

PROCESSING:

┌─ CASE for salary column:
│   Row 1: "salary" = "salary" ✓ → 50000
│   Row 2: "bonus" = "salary" ✗ → NULL
│   Row 3: "hike_percent" = "salary" ✗ → NULL
│   SUM(50000, NULL, NULL) = 50000
│
├─ CASE for bonus column:
│   Row 1: "salary" = "bonus" ✗ → NULL
│   Row 2: "bonus" = "bonus" ✓ → 5000
│   Row 3: "hike_percent" = "bonus" ✗ → NULL
│   SUM(NULL, 5000, NULL) = 5000
│
└─ CASE for hike_percent column:
    Row 1: "salary" = "hike_percent" ✗ → NULL
    Row 2: "bonus" = "hike_percent" ✗ → NULL
    Row 3: "hike_percent" = "hike_percent" ✓ → 10
    SUM(NULL, NULL, 10) = 10

OUTPUT (Employee 1):
emp_id=1, salary=50000, bonus=5000, hike_percent=10

---

🎯 KEY CONCEPTS:

Concept          | Purpose
-----------------|------------------------------------------------------
CASE             | Acts as an IF-THEN filter to conditionally extract values
SUM()            | Aggregates one value + NULLs = returns that one value
NULL handling    | SUM automatically ignores NULLs, so only matching rows contribute
GROUP BY         | Collapses multiple rows per employee into one row

---

💡 WHY THIS APPROACH?

✅ Works across all SQL databases (MySQL, PostgreSQL, SQL Server, Oracle)
✅ No database-specific functions (PIVOT/UNPIVOT vary by DB)
✅ Scalable - Add more components by copying the pattern
✅ Easy to understand - Standard SQL logic

---

🔧 HOW TO EXTEND IT:

If you need to add another component (e.g., commission):

SELECT emp_id,
  SUM(CASE WHEN salary_component_type = "salary" THEN val END) AS salary,
  SUM(CASE WHEN salary_component_type = "bonus" THEN val END) AS bonus,
  SUM(CASE WHEN salary_component_type = "hike_percent" THEN val END) AS hike_percent,
  SUM(CASE WHEN salary_component_type = "commission" THEN val END) AS commission
FROM emp_compensation
GROUP BY emp_id;

*/
