--QUESTION - Calculate the factorial of a number using a recursive CTE.

--SOLUTION
with recursive fact as (
  select 1 as n, 1 as factorial
  union all
  select n+1 , factorial*(n+1)
  from fact
  where n<5)
  select * from fact
  
