-- Xom Data · Top 2 salespeople by sales each month
-- Problem: https://xomdata.com/practice/expert-final-multi-007
-- Solved: 2026-07-24

with sale 
as
(select 
        s.month, 
        s.employee_id,
        e.full_name,
        sum(s.revenue)  as total_sales 
from sales s
join employees e
on s.employee_id = e.id
group by 1,2,3
order by month, total_sales desc),
ranking
as
(select month,
        dense_rank() over (PARTITION BY month order by total_sales  desc) as hang,
        employee_id,
        full_name,
        total_sales
from sale)

select * from ranking
where hang <= 2
order by month asc, hang asc, employee_id asc;
