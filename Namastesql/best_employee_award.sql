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
