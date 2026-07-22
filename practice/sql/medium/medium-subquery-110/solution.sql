-- Xom Data · Employees paid above their department average
-- Problem: https://xomdata.com/practice/medium-subquery-110
-- Solved: 2026-07-22

with temp
as
(select e.full_name, 
d.dept_name,
e.salary,
round(avg(salary) over (PARTITION BY department_id),0) as dept_avg_salary
from employees e
join departments d
on d.id = e.department_id)
select *,
round((salary - dept_avg_salary)*100.0/dept_avg_salary,2) as premium_pct 
from temp
where salary > dept_avg_salary
order by premium_pct desc, dept_name , full_name ;
