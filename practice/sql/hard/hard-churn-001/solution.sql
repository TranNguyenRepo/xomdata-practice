-- Xom Data · Churned and returning customers
-- Problem: https://xomdata.com/practice/hard-churn-001
-- Solved: 2026-07-27

with temp
as
(select 
        user_id,
        order_date as prev_order,
        lead(order_date) over (partition by user_id order by order_date asc) as next_order,
        abs(julianday(order_date) - julianday(lead(order_date) over (partition by user_id order by order_date asc))) as gap_days
from orders
order by order_date asc)

select * from temp
where gap_days >= 90
order by gap_days desc, user_id asc;
