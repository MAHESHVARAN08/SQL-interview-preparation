--QUESTION
/*
Write an SQL query to determine the transaction date with the lowest average order value (AOV) among all dates recorded in the transaction table. 
Display the transaction date, its corresponding AOV, and the difference between the AOV for that date and the highest AOV for any day in the dataset. 
Round the result to 2 decimal places.

 

Table: transactions 
+--------------------+--------------+
| COLUMN_NAME        | DATA_TYPE    |
+--------------------+--------------+
| order_id           | int          |
| transaction_amount | decimal(5,2) |
| transaction_date   | date         |
| user_id            | int          |
+--------------------+--------------+
*/

--SOLUTION
with average as (select
	transaction_date,
	avg(transaction_amount) as aov
from transactions
group by transaction_date ),
rnk as (
select * , row_number() over(order by aov asc) as rn, max(aov) over() as highest_aov
from average )

select transaction_date, round(aov,2) as aov , round(highest_aov-aov,2) as diff_from_highest_aov
from rnk
where rn =1

--EXPLANATION

/*
STEP-BY-STEP LOGIC:

1. FIRST CTE (average):
   - Groups transactions by transaction_date
   - Calculates the average transaction_amount for each date
   - Outputs: transaction_date, aov (average order value)

2. SECOND CTE (rnk):
   - Assigns row_number() based on aov in ascending order
   - The date with lowest AOV gets rn = 1
   - Calculates max(aov) over entire dataset (window function without partition)
   - This highest_aov is the same value for all rows

3. FINAL SELECT:
   - Filters for rn = 1 (the date with lowest AOV)
   - Calculates difference: highest_aov - aov (always non-negative)
   - Rounds all decimal values to 2 places

---

SAMPLE DATA WALKTHROUGH:

Input table (transactions):
order_id | transaction_amount | transaction_date | user_id
---------|-------------------|------------------|--------
   1     |      100.50       |   2024-01-01     |   101
   2     |       50.25       |   2024-01-01     |   102
   3     |      150.00       |   2024-01-02     |   103
   4     |      200.00       |   2024-01-02     |   104
   5     |      175.75       |   2024-01-03     |   105
   6     |      225.50       |   2024-01-03     |   106

---

STEP 1 - CTE (average) output:
transaction_date | aov
-----------------|----------
2024-01-01       | 75.375
2024-01-02       | 175.00
2024-01-03       | 200.625

Explanation:
- 2024-01-01: (100.50 + 50.25) / 2 = 75.375
- 2024-01-02: (150.00 + 200.00) / 2 = 175.00
- 2024-01-03: (175.75 + 225.50) / 2 = 200.625

---

STEP 2 - CTE (rnk) output:
transaction_date | aov     | rn | highest_aov
-----------------|---------|----|-----------
2024-01-01       | 75.375  | 1  | 200.625
2024-01-02       | 175.00  | 2  | 200.625
2024-01-03       | 200.625 | 3  | 200.625

Explanation:
- row_number() over(order by aov asc):
  - 75.375 is smallest → rn = 1
  - 175.00 is middle → rn = 2
  - 200.625 is largest → rn = 3
- max(aov) over() = 200.625 (maximum from all rows)

---

FINAL RESULT (where rn = 1):
transaction_date | aov   | diff_from_highest_aov
-----------------|-------|---------------------
2024-01-01       | 75.38 | 125.25

Explanation:
- AOV for 2024-01-01 = 75.375 → rounded to 75.38
- Difference = 200.625 - 75.375 = 125.25 → rounded to 125.25
- This shows that the lowest AOV day is 125.25 points below the highest AOV day

---

KEY CONCEPTS USED:

1. GROUP BY: Aggregates data by transaction_date
2. AVG(): Calculates mean transaction_amount per date
3. ROW_NUMBER(): Assigns sequential numbers ordered by AOV (ascending)
4. MAX() OVER(): Window function that finds maximum without partitioning (applies to all rows)
5. WHERE rn = 1: Filters to only the row with lowest AOV
6. ROUND(): Limits decimal precision to 2 places
*/
