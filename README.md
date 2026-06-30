# SQL Interview Preparation

A collection of SQL interview and practice problems I've solved, with explanations of the logic and approach behind each solution — not just the queries themselves.

## 📊 Current Status

| Folder | Problems Solved |
|---|---|
| `100_daysof_SQL/` | 10 |
| `Leetcode/` | 1 |
| `Namastesql/` | 6 |
| `Udemy course/` | 1 |
| **Total** | **18** |

*Last updated: June 2026 — actively maintained, with new problems added regularly.*

## 📁 Repository Structure

### `100_daysof_SQL/`
Daily SQL practice problems with detailed write-ups, including:
- **Most Visited Floor** – Find each employee's most-visited floor and resource usage using CTEs and `ROW_NUMBER()`
- **New and Repeat Customers** – Classify daily orders as new vs. repeat customer orders using a self-join on first purchase date
- **Nth Occurrence of Sunday** – Date arithmetic to find the nth Sunday after a given date, using `EXTRACT(DOW ...)`
- **Pivot and Unpivot** – Convert row-based salary component data into columnar format using `CASE` + `SUM`, without database-specific PIVOT functions
- **Friends Score** – Find persons whose friends' combined score exceeds 100, using a CTE with `INNER JOIN`, `GROUP BY`, and `HAVING`
- **Median Salary** – Compute the median salary per department using window functions to rank and select middle row(s)
- **Pareto Principle (80/20 Rule)** – Identify the smallest set of top-selling products contributing to 80% of total sales using `SUM() OVER` for running totals
- **WHERE vs HAVING** – Demonstrates row-level filtering with `WHERE` versus group-level filtering with `HAVING` on employee salary data

### `Leetcode/`
Solutions to classic LeetCode SQL problems:
- **Rank** – Rank scores using `DENSE_RANK()` to handle ties without gaps

### `Namastesql/`
Business-analytics style SQL problems based on real-world scenarios:
- **Airbnb Top Hosts** – Find top-rated hosts with 2+ listings using joins, subqueries, and `HAVING`
- **Electricity Consumption** – Aggregate household consumption and cost by year
- **LinkedIn Top Voice** – Identify top creators by follower count, post volume, and impressions
- **Premium Customers** – Find customers ordering above the average order count
- **Return Orders Customer Feedback** – Identify customers with high return rates using `LEFT JOIN` and ratio calculations
- **Product Category** – Bucket products into price tiers using `CASE` in a subquery

### `Udemy course/`
Window function exercises on a Sakila/Pagila-style dataset:
- Average film length by category (`AVG() OVER PARTITION BY`)
- Counting repeated payments (`COUNT() OVER`)
- Top customers by country (`ROW_NUMBER()` + ranking)
- Daily revenue trends with `LAG()` for period-over-period comparison
- Running totals with `SUM() OVER (ORDER BY ...)`

## 🎯 Topics Covered

- Joins (INNER, LEFT, SELF)
- Aggregate functions, `GROUP BY`, `HAVING`
- Subqueries and correlated subqueries
- Window functions (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, running totals)
- Common Table Expressions (CTEs)
- Conditional aggregation (`CASE` + `SUM`/`COUNT`)
- Date and string functions
- Manual pivot/unpivot without DB-specific syntax
- `WHERE` vs `HAVING` filtering semantics

## 🚀 How to Use

Each `.sql` file follows the same format: the problem statement and table schema are included as a comment block, followed by the solution query, followed by a detailed explanation of the approach and logic. This makes each file useful both as a reference and as a way to review reasoning before interviews.

## 📌 About

An ongoing learning repository — updated regularly as part of continued SQL interview preparation.

## 📫 Connect

Check out my other repositories:
- [Python-interview-preparation](https://github.com/MAHESHVARAN08/Python-interview-preparation)
- [Pyspark_learning](https://github.com/MAHESHVARAN08/Pyspark_learning)
