--Generate numbers from 1 to 100 and calculate the cumulative sum alongside each number using a recursive CTE.

--SOLUTION
WITH recursive counter as (
  select 1 as n , 1 as cumulative_sum
  union all
  select n+1 , cumulative_sum+(n+1)
  from counter
  where n<100
  )
  select * from counter
