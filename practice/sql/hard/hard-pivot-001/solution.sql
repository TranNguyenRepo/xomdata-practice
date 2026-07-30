-- Xom Data · Revenue pivoted by product type
-- Problem: https://xomdata.com/practice/hard-pivot-001
-- Solved: 2026-07-30

select
        strftime('%Y-%m', sale_date) as month,
        COALESCE(sum(case when category = 'Electronics' then (amount) end),0) as electronics,
        COALESCE(sum(case when category = 'Clothing' then (amount) end),0) as clothing,
        COALESCE(sum(case when category = 'Food' then (amount) end),0) as food,
        sum(amount) as total

from sales
group by month
