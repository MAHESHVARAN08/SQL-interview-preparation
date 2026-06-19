/*
QUESTION 
You are given two tables:

Trips – contains trip information

Users – contains user details (clients and drivers)

Definitions:

A trip can have one of the following statuses:

completed

cancelled_by_driver

cancelled_by_client

A trip is valid only if both the client and the driver are NOT banned

The cancellation rate for a given day is:

cancellation rate = 
(cancelled trips with unbanned client & driver) 
/ 
(total trips with unbanned client & driver)
🎯 Task

Write a SQL query to find the cancellation rate for each day
📅 From 2013-10-01 to 2013-10-03

🧱 Table Structures (Given)

CREATE TABLE Trips (
    id INT,
    client_id INT,
    driver_id INT,
    city_id INT,
    status VARCHAR(50),
    request_at VARCHAR(50)
);
 
CREATE TABLE Users (
    users_id INT,
    banned VARCHAR(50),
    role VARCHAR(50)
);
*/

--SOLUTION

WITH client_unbanned AS (
    SELECT DISTINCT t.client_id
    FROM Trips t
    JOIN Users u
        ON t.client_id = u.users_id
    WHERE u.banned = 'No'
),
driver_unbanned AS (
    SELECT DISTINCT t.driver_id
    FROM Trips t
    JOIN Users u
        ON t.driver_id = u.users_id
    WHERE u.banned = 'No'
)

SELECT
    request_at,
    SUM(CASE WHEN status LIKE 'cancelled%' THEN 1 ELSE 0 END) AS cancelled_trip_count,
    COUNT(*) AS total_trips,
    ((1.0 * SUM(CASE WHEN status LIKE 'cancelled%' THEN 1 ELSE 0 END)) / COUNT(*)) * 100 AS cancelled_percent
FROM Trips
WHERE client_id IN (SELECT client_id FROM client_unbanned)
  AND driver_id IN (SELECT driver_id FROM driver_unbanned)
GROUP BY request_at;

/*
# Summary

This SQL file solves a **cancellation rate problem** from a ride-sharing platform (similar to Leetcode 1093).

## Key Components:

**Problem:**
- Calculate the daily cancellation rate for trips from October 1-3, 2013
- Cancellation rate = (cancelled trips) / (total trips), where both client and driver are NOT banned

**Solution Approach:**
1. **Two CTEs** identify unbanned clients and drivers by filtering the Users table for `banned = 'No'`
2. **Main query** filters Trips to only include rows where:
   - Client is in the unbanned clients list
   - Driver is in the unbanned drivers list
3. **Aggregation** groups by `request_at` (date) and calculates:
   - Count of cancelled trips (using `CASE` with `LIKE 'cancelled%'` to match any cancellation status)
   - Total trip count
   - Cancellation percentage

**Output Columns:**
- `request_at` – trip date
- `cancelled_trip_count` – number of cancelled trips
- `total_trips` – all trips with unbanned participants
- `cancelled_percent` – cancellation rate as a percentage

This is a well-structured solution that properly handles the business logic of filtering banned users before calculating metrics.
*/
