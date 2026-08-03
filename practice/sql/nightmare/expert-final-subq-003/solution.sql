-- Xom Data · Second-highest-paid employee per department
-- Problem: https://xomdata.com/practice/expert-final-subq-003
-- Solved: 2026-08-02

with temp
as
(select 
        department,
        full_name,
        salary,
        DENSE_RANK() over (PARTITION BY department order by salary desc) as rank
from employees)

select department,
        full_name,
        salary
from temp
where rank = 2
order by department, full_name;
