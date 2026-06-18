/* 
You are given an employee table containing employee salary information.

Answer the following:

Using WHERE clause
→ Fetch all employees whose salary is greater than 5000

Using HAVING clause
→ Fetch those manager_id for which the average salary of employees reporting to that manager is greater than 10,000

Explain why WHERE works in case 1 and HAVING is required in case 2.

🧱 Table Structure (Given)

CREATE TABLE emp
(
    emp_id INT,
    emp_name TEXT,
    salary INT,
    manager_id INT
);

*/

--SOLUTION

-- 1) Using WHERE: fetch all employees whose salary is greater than 5000
SELECT *
FROM emp
WHERE salary > 5000;

-- 2) Using HAVING: fetch manager_id for which the average salary of their reports is greater than 10000
SELECT manager_id,
       AVG(salary) AS avg_salary
FROM emp
GROUP BY manager_id
HAVING AVG(salary) > 10000;

/*
DOCUMENTATION / SUMMARY

Summary:
- This file demonstrates the difference between the WHERE and HAVING clauses in SQL and shows correct usage for each.

Key points:
- WHERE filters rows before any GROUP BY or aggregate functions are applied. It cannot use aggregate functions (e.g., AVG(), SUM(), COUNT()) directly.
  Example: SELECT * FROM emp WHERE salary > 5000; -- returns individual employee rows with salary > 5000

- HAVING filters groups after aggregation (after GROUP BY). It is used to apply conditions on aggregated values.
  Example: SELECT manager_id, AVG(salary) FROM emp GROUP BY manager_id HAVING AVG(salary) > 10000; -- returns manager_ids whose group's average salary > 10000

Why WHERE works in case 1 and HAVING is required in case 2:
- Case 1 asks to return individual employees with salary > 5000. This is a row-level condition, so the WHERE clause (which operates on rows) is the appropriate place to filter.
- Case 2 asks to evaluate the average salary per manager and return managers whose average exceeds 10000. The average is an aggregate computed after rows are grouped, so a row-level WHERE cannot reference it; HAVING is needed to filter on the aggregated result.

Notes / Best practices:
- Prefer WHERE to reduce the number of rows before aggregation whenever possible (it can make aggregation faster because fewer rows are processed).
- Use HAVING only for conditions that involve aggregates or that must be applied to groups.
- You can combine both: use WHERE to pre-filter rows, GROUP BY to aggregate, then HAVING to filter groups based on aggregates.

Examples combined:
-- Pre-filter and then aggregate, then apply group filter
SELECT manager_id, AVG(salary) AS avg_salary
FROM emp
WHERE salary > 3000   -- row-level filter applied before grouping
GROUP BY manager_id
HAVING AVG(salary) > 10000; -- group-level filter applied after aggregation

*/
