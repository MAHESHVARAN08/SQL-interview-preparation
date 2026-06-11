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

/*
═══════════════════════════════════════════════════════════════════════════════
                           LOGIC EXPLANATION
═══════════════════════════════════════════════════════════════════════════════

ALGORITHM BREAKDOWN:
─────────────────────────────────────────────────────────────────────────────

The solution uses a two-part calculation:

PART 1: Calculate days to the NEXT Sunday from today_date
────────────────────────────────────────────────────────

EXTRACT(DOW FROM today_date) returns the day of week:
  • 0 = Sunday
  • 1 = Monday
  • 2 = Tuesday
  • 3 = Wednesday
  • 4 = Thursday
  • 5 = Friday
  • 6 = Saturday

CASE Statement Logic:

  IF today_date is a Sunday (DOW = 0):
     → Add 7 days to get to the NEXT Sunday
     → This ensures we skip the current day (strictly AFTER requirement)

  ELSE (today_date is Monday through Saturday):
     → Calculate: 7 - DOW
     → This gives the number of days until the next Sunday
     
     Examples:
       • Saturday (DOW=6): 7 - 6 = 1 day until Sunday ✓
       • Friday (DOW=5):   7 - 5 = 2 days until Sunday ✓
       • Monday (DOW=1):   7 - 1 = 6 days until Sunday ✓
       • Tuesday (DOW=2):  7 - 2 = 5 days until Sunday ✓


PART 2: Add weeks for remaining Sundays
───────────────────────────────────────

Formula: (n - 1) * 7

This calculates additional days needed after finding the 1st Sunday:
  • n = 1: (1-1) * 7 = 0 days   → We want just the 1st Sunday
  • n = 2: (2-1) * 7 = 7 days   → Add 1 week to get the 2nd Sunday
  • n = 3: (3-1) * 7 = 14 days  → Add 2 weeks to get the 3rd Sunday
  • n = 4: (4-1) * 7 = 21 days  → Add 3 weeks to get the 4th Sunday


═══════════════════════════════════════════════════════════════════════════════
                           WORKED EXAMPLES
═══════════════════════════════════════════════════════════════════════════════

EXAMPLE 1: today_date = '2022-01-01' (Saturday), n = 1
──────────────────────────────────────────────────────

Step 1: Get day of week
   DOW of 2022-01-01 = 6 (Saturday)

Step 2: Days to next Sunday
   CASE: DOW ≠ 0, so → 7 - 6 = 1 day
   
Step 3: Additional weeks
   (1 - 1) * 7 = 0 days

Step 4: Calculate result
   2022-01-01 + (1 + 0) = 2022-01-01 + 1 = 2022-01-02 ✓


EXAMPLE 2: today_date = '2022-01-01' (Saturday), n = 2
──────────────────────────────────────────────────────

Step 1: Get day of week
   DOW of 2022-01-01 = 6 (Saturday)

Step 2: Days to next Sunday
   CASE: DOW ≠ 0, so → 7 - 6 = 1 day

Step 3: Additional weeks
   (2 - 1) * 7 = 7 days

Step 4: Calculate result
   2022-01-01 + (1 + 7) = 2022-01-01 + 8 = 2022-01-09 ✓


EXAMPLE 3: today_date = '2022-01-02' (Sunday), n = 1
─────────────────────────────────────────────────────

Step 1: Get day of week
   DOW of 2022-01-02 = 0 (Sunday)

Step 2: Days to next Sunday
   CASE: DOW = 0, so → 7 days (skip to next Sunday since we need strictly AFTER)

Step 3: Additional weeks
   (1 - 1) * 7 = 0 days

Step 4: Calculate result
   2022-01-02 + (7 + 0) = 2022-01-02 + 7 = 2022-01-09 ✓


EXAMPLE 4: today_date = '2022-01-05' (Wednesday), n = 3
─────────────────────────────────────────────────────────

Step 1: Get day of week
   DOW of 2022-01-05 = 3 (Wednesday)

Step 2: Days to next Sunday
   CASE: DOW ≠ 0, so → 7 - 3 = 4 days
   (2022-01-05 is Wed, +4 days = 2022-01-09 which is Sunday)

Step 3: Additional weeks
   (3 - 1) * 7 = 14 days

Step 4: Calculate result
   2022-01-05 + (4 + 14) = 2022-01-05 + 18 = 2022-01-23 ✓


═══════════════════════════════════════════════════════════════════════════════
                              KEY INSIGHTS
═══════════════════════════════════════════════════════════════════════════════

✓ The formula elegantly handles all day-of-week scenarios
✓ It automatically skips the given date if it's a Sunday
✓ Works for any value of n (1st, 2nd, 3rd, etc.)
✓ Works for any starting date
✓ The calculation is pure mathematical with no loops or iterations
*/
