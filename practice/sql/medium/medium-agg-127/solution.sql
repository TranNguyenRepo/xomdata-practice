-- Xom Data · Top 10 highest-paid employees and their leave days
-- Problem: https://xomdata.com/practice/medium-agg-127
-- Solved: 2026-07-27

with salary 
as
(select 
        e.full_name,
        e.id,
        e.employee_code,
        d.department_name,
        sum(net_salary) as total_received_salary
from employees e 
join payroll p
on e.id = p.employee_id
join departments d
on d.id =  e.department_id
group by 1,2,3,4)
select  s.full_name,
        s.employee_code,
        s.department_name,
        s.total_received_salary,
        COUNT(
    DISTINCT CASE
        WHEN status='duyet'
        THEN l.id
    END
) as leave_count,
        round((s.total_received_salary - avg(s.total_received_salary) over (PARTITION BY s.department_name))*100.0/avg(s.total_received_salary) over (PARTITION BY s.department_name),2) as pct_above_dept_avg
from salary s
left join leaves l
on l.employee_id = s.id
group by 1,2,3,4
order by s.total_received_salary desc, s.employee_code asc
limit 10;
