-- Xom Data · Running inventory balance over time
-- Problem: https://xomdata.com/practice/hard-fifo-001
-- Solved: 2026-07-31

select sku, 
    occurred_at,
    type,
    quantity,
    -- case when type = 'IN' then quantity*1 else quantity*(-1) end as total,
    sum(case when type = 'IN' then quantity*1 else quantity*(-1) end) over (PARTITION BY sku order by sku, occurred_at asc, id asc) as running_balance
from inventory_movements
order by sku, occurred_at asc, id asc;
