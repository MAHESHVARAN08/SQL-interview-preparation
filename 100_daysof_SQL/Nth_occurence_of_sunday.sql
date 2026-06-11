/*
You are given a table that contains:

a starting date (today_date)

a number n

Your task is to find the date of the nth occurrence of Sunday after the given date.

🔍 Key Rules

The search is strictly after the given date
(if the given date itself is Sunday, it does NOT count).

You must return the nth Sunday occurring in the future.

The solution should work for any given date and any value of n.

🧩 Example Explanation

If:

today_date = '2022-01-01' (Saturday)

n = 1 → Output: 2022-01-02

n = 2 → Output: 2022-01-09

n = 3 → Output: 2022-01-16

📋 Table Structure

CREATE TABLE input_date (
    today_date DATE,
    n INTEGER
);
Assuming today's date as per input_date table, Write SQL to get 3rd Sunday
*/

----SOLUTION
SELECT
    today_date +
    (
        CASE
            WHEN CAST(EXTRACT(DOW FROM today_date) AS INTEGER) = 0 THEN 7
            ELSE 7 - CAST(EXTRACT(DOW FROM today_date) AS INTEGER)
        END
        + (n - 1) * 7
    ) AS nth_sunday
FROM input_date;
