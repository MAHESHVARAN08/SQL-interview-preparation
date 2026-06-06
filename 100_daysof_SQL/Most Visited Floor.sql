/*# Employee Entry Analysis SQL

## Problem Statement

A company allows only **one entry per employee per day**. However, some employees bypass this restriction by using **multiple email addresses**, resulting in multiple entries being recorded for the same person.

Given an `entries` table, identify employee visit patterns and generate a summary report.

### Table Structure

```sql
CREATE TABLE entries (
    name VARCHAR(20),
    address VARCHAR(20),
    email VARCHAR(30),
    floor INT,
    resources VARCHAR(20)
);
```

## Requirements

For each employee, return:

* Total number of visits
* Most visited floor
* List of distinct resources used

---
*/
## Solution

```sql
WITH floor_count AS (
    SELECT
        name,
        floor,
        COUNT(*) AS visit_count,
        ROW_NUMBER() OVER (
            PARTITION BY name
            ORDER BY COUNT(*) DESC
        ) AS rank
    FROM entries
    GROUP BY name, floor
),

total_visits AS (
    SELECT
        name,
        COUNT(*) AS total_visits,
        GROUP_CONCAT(DISTINCT resources) AS used_resources
    FROM entries
    GROUP BY name
)

SELECT
    f.name,
    f.floor AS most_visited_floor,
    t.total_visits,
    t.used_resources
FROM floor_count f
JOIN total_visits t
    ON f.name = t.name
WHERE f.rank = 1;
```

---
/*
## Approach

### 1. Calculate Floor Visit Frequency

The `floor_count` CTE:

* Groups records by employee and floor.
* Counts the number of visits to each floor.
* Uses `ROW_NUMBER()` to rank floors based on visit frequency.
* Rank `1` represents the most visited floor for each employee.

### 2. Aggregate Employee Activity

The `total_visits` CTE:

* Counts the total number of visits made by each employee.
* Collects all unique resources used via `GROUP_CONCAT(DISTINCT resources)`.

### 3. Generate Final Report

The final query:

* Joins both CTEs using employee name.
* Filters only the highest-ranked floor (`rank = 1`).
* Returns the required summary for each employee.

---

## Output

| Column               | Description                                     |
| -------------------- | ----------------------------------------------- |
| `name`               | Employee name                                   |
| `most_visited_floor` | Floor visited most frequently                   |
| `total_visits`       | Total number of visits                          |
| `used_resources`     | Comma-separated list of distinct resources used |

---

## SQL Concepts Used

* Common Table Expressions (CTEs)
* Aggregate Functions (`COUNT`)
* Window Functions (`ROW_NUMBER`)
* String Aggregation (`GROUP_CONCAT`)
* Joins
* Grouping (`GROUP BY`)

---

## Time Complexity

| Operation      | Complexity |
| -------------- | ---------- |
| Aggregation    | O(N)       |
| Window Ranking | O(N log N) |
| Final Join     | O(N)       |

Overall complexity: **O(N log N)**
*/
