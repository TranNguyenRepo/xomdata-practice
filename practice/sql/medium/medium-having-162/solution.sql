-- Xom Data · Suppliers that deliver late frequently
-- Problem: https://xomdata.com/practice/medium-having-162
-- Solved: 2026-07-21

with temp as
(select supplier_id,
    count(*) as purchase_count,
    round(avg(julianday(actual_receipt) - julianday(expected_receipt)),2) AS avg_late_days,
    sum(total_value) as total_purchase_value,
    sum(case when actual_receipt <= expected_receipt then 1 else 0 end) as on_time
from purchase_orders p
    group by 1
    )
select  s.supplier_name , 
        s.material_type ,
        t.purchase_count, 
        t.total_purchase_value, 
        t.avg_late_days, 
        round(t.on_time * 100.0/t.purchase_count,2) as on_time_rate,
        rank() over (order by avg_late_days desc) as late_rank,
        ntile( 4) over (order by avg_late_days desc) as risk_tier
from temp t
    join suppliers s
        on s.id = t.supplier_id
        where purchase_count >= 3 and avg_late_days > 0
        order by late_rank asc;
 


--  with temp as
-- (select supplier_id,
--     count(*) as purchase_count,
--     round(avg(julianday(actual_receipt) - julianday(expected_receipt)),2) AS avg_late_days,
--     sum(total_value) as total_purchase_value,
--     sum(case when actual_receipt <= expected_receipt then 1 else 0 end) as on_time
-- from purchase_orders p
--     group by 1
--     having purchase_count >= 3 and avg_late_days > 0
--     )
-- select  s.supplier_name , 
--         s.material_type ,
--         t.purchase_count, 
--         t.total_purchase_value, 
--         t.avg_late_days, 
--         round(t.on_time * 100.0/t.purchase_count,2) as on_time_rate,
--         rank() over (order by avg_late_days desc) as late_rank,
--         ntile( 4) over (order by avg_late_days desc) as risk_tier
-- from temp t
--     join suppliers s
--         on s.id = t.supplier_id
--         order by late_rank asc;
