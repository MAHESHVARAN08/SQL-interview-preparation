--QUESTION - Flatten a hierarchical organization chart using a CTE.

--SOLUTION
WITH RECURSIVE MANAGER AS (
  select employee_id, employee_name, cast(employee_name as text) as reporting_path,1 as level
  from employees
  where employee_id = 1
  union all
  select e.employee_id, e.employee_name, m.reporting_path||'->'|| e.employee_name, m.level+1
  from manager as m
  join employees as e 
  on e.manager_id = m.employee_id)
  select * from manager
