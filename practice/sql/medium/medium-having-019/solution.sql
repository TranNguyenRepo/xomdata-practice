-- Xom Data · High-rated sellers with many orders
-- Problem: https://xomdata.com/practice/medium-having-019
-- Solved: 2026-07-17

with temp 
AS
(select 
    store_name, 
    reputation_score,
    count(o.id) as order_count
from sellers s 
join orders o
    on s.id = o.seller_id
group by 1,2)
select 
    *,
    rank() over (order by order_count desc) as rank_by_orders,
    sum(order_count) over (order by order_count desc,  store_name ASC ) as cumulative_orders
from temp
where reputation_score >= 4.5
and order_count >= 3
order by rank_by_orders asc, store_name ASC;
