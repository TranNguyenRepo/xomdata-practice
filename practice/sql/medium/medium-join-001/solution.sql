-- Xom Data · Customer spending per order
-- Problem: https://xomdata.com/practice/medium-join-001
-- Solved: 2026-07-26

select
        c.full_name,
        count(o.id) as order_count,
        COALESCE(sum(total_amount),0) as total_spending,
        COALESCE(avg(total_amount),0) as avg_order_value,
        row_number() over (order by sum(total_amount) desc, c.full_name) as spending_rank
from orders o
join customers c
on c.id = o.customer_id
group by 1
order by spending_rank asc;
