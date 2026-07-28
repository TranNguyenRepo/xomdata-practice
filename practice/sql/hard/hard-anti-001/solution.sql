-- Xom Data · Customers silent for 90 days
-- Problem: https://xomdata.com/practice/hard-anti-001
-- Solved: 2026-07-28

with temp
as
(select
        user_id,
        max(order_date) over (PARTITION BY user_id order by order_date desc) as last_order_date,
        max(order_date) over () as max_date,
        julianday(max(order_date) over () ) - julianday(max(order_date) over (PARTITION BY user_id order by order_date desc) ) as days_since_last
from orders
)

select distinct user_id,
        last_order_date,
        days_since_last
from temp
where days_since_last >= 90
order by days_since_last desc, user_id asc;
