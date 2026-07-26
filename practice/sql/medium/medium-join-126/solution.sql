-- Xom Data · Salary by department and title
-- Problem: https://xomdata.com/practice/medium-join-126
-- Solved: 2026-07-26

select 
        d.department_name,
        -- p.employee_id,
        po.position_name,
        count(e.id) as employee_count,
        avg(net_salary) as avg_salary,
        min(net_salary) as min_salary,
        max(net_salary) as max_salary,
        max(net_salary) - min(net_salary) as salary_spread,
        rank() over (PARTITION BY department_name order by avg(net_salary) desc) as rank_in_dept
from payroll p
FULL JOIN employees e
on e.id = p.employee_id
join positions po
on po.id = e.position_id
join departments d
on d.id = e.department_id
group by 1,2
order by department_name, rank_in_dept asc, position_name;
