-- Xom Data · Multi-level profit margin analysis
-- Problem: https://xomdata.com/practice/hard-multicte-001
-- Solved: 2026-09-02

with revenue as
(SELECT 
    product_id,
    sum(quantity) as quantity,
    sum(quantity * price) as revenue
-- FROM PRODUCTS P
FROM ORDERS 
group by product_id)
, revenue1 as
(select  
    p.category, 
    p.name as product_name,
    r.revenue ,
    sum(r.quantity * unit_cost) as cost,
    r.revenue - sum(r.quantity * unit_cost) as profit,
    round(( r.revenue - sum(r.quantity * unit_cost) )*100.0/r.revenue,2) as margin_pct
from revenue r
join products p
on p.id = r.product_id
group by p.category, p.name)
, max_profit as
(select 
    distinct
    r1.*,
    dense_rank() over (partition by category order by profit desc) as rank_in_cat,
    max(profit) over (partition by category) as max_profit
    -- round(profit*100.0/max_profit,2) as pct_of_top_in_cat
from revenue1 r1)
select 
    category,
    product_name,
    revenue,
    cost,
    profit, 
    margin_pct, rank_in_cat,  
    round((profit*100.0)/max_profit,2) as pct_of_top_in_cat
from max_profit
order by category , rank_in_cat , product_name;


-- ON P.ID = O.PRODUCT_ID;
