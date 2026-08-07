-- Xom Data · Median salary per department
-- Problem: https://xomdata.com/practice/sql-nightmare-002
-- Solved: 2026-08-07

with temp
as(select 
        dept,
        salary,
        row_number() over (PARTITION BY dept order by salary asc) as rn,
        count(salary) over (PARTITION BY dept) as cnt
from employees)
-- select * from temp;
select dept, 
-- salary
        avg(salary) as median_salary
from temp
where rn in ((cnt+1)/2, (cnt+2)/2)
group by dept;
