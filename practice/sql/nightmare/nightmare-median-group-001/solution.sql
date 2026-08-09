-- Xom Data · Median department salary
-- Problem: https://xomdata.com/practice/nightmare-median-group-001
-- Solved: 2026-08-09

with 
temp
as
(select
        id, 
        department,
        salary,
        ROW_NUMBER() over (PARTITION BY department order by salary) as rn,
        count(salary) over (PARTITION BY department) as cnt
from employees)

select department,
        avg(salary) as median_salary

from temp
where rn in ((cnt+1)/2, (cnt+2)/2)
group by department;
