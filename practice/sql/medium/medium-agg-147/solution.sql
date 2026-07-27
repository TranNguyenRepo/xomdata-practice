-- Xom Data · Top 10 highest-profit dishes
-- Problem: https://xomdata.com/practice/medium-agg-147
-- Solved: 2026-07-26

with temp
as
(select 
        d.dish_name, 
        c.category_name,
        sum(oi.quantity) as total_sold,
        sum(oi.unit_price * oi.quantity) as revenue,
        sum(oi.unit_price * oi.quantity) - sum(d.cost_price * oi.quantity) as profit

from order_items oi
join orders o
on o.id = oi.order_id
join dishes d
on d.id = oi.dish_id
join categories c
on d.category_id = c.id
where o.status = 'Completed'
GROUP BY 1)

select *,
        round(profit*100.0/revenue,2) as margin_pct,
        rank() over (order by profit desc) as rank_by_profit,
        rank() over (order by profit*100.0/revenue desc) as rank_by_margin
from temp
order by profit desc, dish_name
limit 10;
