-- Xom Data · Employees averaging over 5 overtime hours
-- Problem: https://xomdata.com/practice/medium-having-128
-- Solved: 2026-07-21

with high_work as
(select employee_id,
        avg(work_days)  as avg_work_days,
        avg(overtime_hours)  as avg_overtime_hours
from attendance
group by employee_id
having avg_work_days >= 18 and avg_overtime_hours >5),

payroll_view as
(select employee_id, 
        avg(net_salary) as avg_salary 
from payroll
group by 1)

select e.full_name,
        e.employee_code,
        h.avg_work_days, 
        h.avg_overtime_hours,
        p.avg_salary, 
        round((h.avg_overtime_hours/h.avg_work_days),4) as overtime_intensity ,
        rank() over (order by (h.avg_overtime_hours/h.avg_work_days) desc) as intensity_rank ,
        ntile(4) over (order by (h.avg_overtime_hours/h.avg_work_days) desc ) as workload_quartile 

from high_work h
join payroll_view p
on h.employee_id = p.employee_id
join employees e
on e.id = h.employee_id;
