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
