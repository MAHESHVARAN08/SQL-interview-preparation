--QUESTION 
/*
TCS wants to award employees based on number of projects completed by each individual each month.  
Write an SQL to find best employee for each month along with number of projects completed by him/her in that month, display the output in descending order of number of completed projects & employee name.

Table: projects
+-------------------------+-------------+
| COLUMN_NAME             | DATA_TYPE   |
+-------------------------+-------------+
| project_id              | int         |
| employee_name           | varchar(10) |
| project_completion_date | date        |
+-------------------------+-------------+
*/

--SOLUTION
with nproject as (
select
	employee_name,
	TO_CHAR(project_completion_date,'YYYYMM') as year_month,
	count(1) as no_of_completed_projects,
	RANK() OVER(PARTITION BY TO_CHAR(project_completion_date,'YYYYMM') ORDER BY count(1) desc) as rn
from
	projects
group by 1,2
)

select employee_name,no_of_completed_projects, year_month from nproject
where rn =1
order by no_of_completed_projects desc , employee_name desc

--EXPLANATION

/*
STEP 1: CTE (Common Table Expression) - "nproject"
--------
This CTE aggregates and ranks employee project completions by month.

1. TO_CHAR(project_completion_date,'YYYYMM') as year_month
   - Converts the project completion date to YYYYMM format (e.g., 202301 for January 2023)
   - Groups projects by month regardless of the day

2. count(1) as no_of_completed_projects
   - Counts the number of projects completed by each employee in that month
   - count(1) counts the number of rows/records

3. GROUP BY 1,2
   - Groups records by employee_name and year_month
   - This aggregation gives us the total count of projects per employee per month

4. RANK() OVER(PARTITION BY TO_CHAR(project_completion_date,'YYYYMM') ORDER BY count(1) desc) as rn
   - Window function that ranks employees within each month partition
   - PARTITION BY TO_CHAR(...) - creates separate groups for each month
   - ORDER BY count(1) desc - ranks employees in descending order of project count
   - Assigns rank 1 to the employee with the most projects in that month
   - If two employees have the same count, both get rank 1 (RANK() function handles ties)

STEP 2: Main SELECT Query
--------
Filters and displays the final results from the CTE.

1. WHERE rn = 1
   - Filters to only include employees with rank 1 in each month
   - This gives us the BEST EMPLOYEE (or employees if there's a tie) for each month

2. ORDER BY no_of_completed_projects desc, employee_name desc
   - Sorts results first by number of projects in descending order (highest projects first)
   - Then sorts by employee_name in descending order as a secondary sort
   - Ensures consistent ordering and alphabetical arrangement when project counts are equal

EXAMPLE:
--------
If we have data:
Employee  | Date       | Projects
----------|------------|--------
John      | 2023-01-05 | 1 project
John      | 2023-01-10 | 1 project (Total: 2 projects in Jan 2023)
Alice     | 2023-01-15 | 1 project (Total: 1 project in Jan 2023)
John      | 2023-02-05 | 1 project (Total: 1 project in Feb 2023)
Bob       | 2023-02-10 | 1 project
Bob       | 2023-02-15 | 1 project (Total: 2 projects in Feb 2023)

Result:
employee_name | no_of_completed_projects | year_month
--------------|--------------------------|----------
John          | 2                        | 202301
Bob           | 2                        | 202302

John is the best employee in January with 2 completed projects.
Bob is the best employee in February with 2 completed projects.
*/
