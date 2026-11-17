--1. Write a recursive CTE to generate a sequence of numbers from 1 to 100.

--SOLUTION
with recursive counter(n) as (
  select 1 
  union all
  select n+1
  from counter
  where n<100
  )
  select * from counter
