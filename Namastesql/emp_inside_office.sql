--QUESTION
/*
A company record its employee's movement In and Out of office in a table. Please note below points about the data:

 

1- First entry for each employee is “in”
2- Every “in” is succeeded by an “out”
3- Employee can work across days
Write a SQL to find the number of employees inside the Office at “2019-04-01 19:05:00".

 

Table: employee_record
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| emp_id      | int        |
| action      | varchar(3) |
| created_at  | datetime   |
+-------------+------------+

*/

--SOLUTION
with chk as (select emp_id, action , created_at, 
		lead(created_at,1,cast('2019-04-30 23:59:00' as timestamp)) over(partition by emp_id) as out_time
from employee_record )
select count(distinct(emp_id)) as no_of_emp_inside from chk 
where action = 'in' and '2019-04-01 19:05:00' between created_at and out_time

--EXPLANATION
/*
Logic summary:
1) For each employee (partition by emp_id) we pair every "in" row with the next row's created_at using LEAD().
   - Because the data guarantees every "in" is followed by an "out", the next timestamp is the corresponding out time.
   - We supply a default out_time (here: '2019-04-30 23:59:00') to handle the unlikely case where an "in" has no following "out" in the table (meaning the employee is still inside).
2) The CTE named chk therefore has rows like: emp_id, action='in', created_at (in_time), out_time (the next created_at).
3) Finally we count distinct employees whose "in" interval contains the target timestamp '2019-04-01 19:05:00' using BETWEEN (inclusive).

Important note about BETWEEN: BETWEEN is inclusive of both endpoints. If you want to treat an employee who checked out exactly at the target time as "not inside", change the predicate to:
  '2019-04-01 19:05:00' >= created_at AND '2019-04-01 19:05:00' < out_time

Sample data and walk-through:

Suppose employee_record contains these rows (ordered by emp_id, created_at):

emp_id | action | created_at
-------+--------+---------------------
1      | in     | 2019-04-01 09:00:00
1      | out    | 2019-04-01 18:00:00
2      | in     | 2019-04-01 18:30:00
2      | out    | 2019-04-02 02:00:00
3      | in     | 2019-03-31 20:00:00
3      | out    | 2019-04-02 08:00:00
4      | in     | 2019-04-01 19:10:00
4      | out    | 2019-04-01 21:00:00
5      | in     | 2019-04-01 17:00:00
5      | out    | 2019-04-01 19:05:00

CTE (chk) result after applying LEAD(... ) over(partition by emp_id):

emp_id | action | created_at           | out_time
-------+--------+----------------------+---------------------
1      | in     | 2019-04-01 09:00:00  | 2019-04-01 18:00:00
1      | out    | 2019-04-01 18:00:00  | (lead for "out" points to next row if any)
2      | in     | 2019-04-01 18:30:00  | 2019-04-02 02:00:00
2      | out    | 2019-04-02 02:00:00  | ...
3      | in     | 2019-03-31 20:00:00  | 2019-04-02 08:00:00
3      | out    | 2019-04-02 08:00:00  | ...
4      | in     | 2019-04-01 19:10:00  | 2019-04-01 21:00:00
4      | out    | 2019-04-01 21:00:00  | ...
5      | in     | 2019-04-01 17:00:00  | 2019-04-01 19:05:00
5      | out    | 2019-04-01 19:05:00  | ...

We then filter only rows where action = 'in' and the target timestamp '2019-04-01 19:05:00' falls between created_at (in_time) and out_time.
Check each "in" row:
- emp 1: 2019-04-01 09:00 - 2019-04-01 18:00 -> target 19:05 is outside
- emp 2: 2019-04-01 18:30 - 2019-04-02 02:00 -> target 19:05 is inside
- emp 3: 2019-03-31 20:00 - 2019-04-02 08:00 -> target 19:05 is inside
- emp 4: 2019-04-01 19:10 - 2019-04-01 21:00 -> target 19:05 is before in_time -> outside
- emp 5: 2019-04-01 17:00 - 2019-04-01 19:05 -> target equals out_time and BETWEEN is inclusive -> counts as inside

So the query returns count(distinct emp_id) = 3 (employees 2, 3 and 5).

Possible improvements / alternatives:
- Use a very large default out_time (for example '9999-12-31') instead of a hardcoded date close to the query date, to be safe for any target timestamp.
- If your DB supports it, you can also pair events by using a row_number partition and joining odd/even rows per employee to ensure correct pairing when data quality may vary.
- If you prefer exclusive upper bound, change BETWEEN to a half-open interval as noted above.

*/
