-- Xom Data · Stock-in history by supplier
-- Problem: https://xomdata.com/practice/medium-join-014
-- Solved: 2026-07-26

with temp
as
(select 
        w.warehouse_name,
        count(si.id) as import_count,
        count(distinct si.product_id) as distinct_product_count,
        count(distinct si.suppliers) as distinct_supplier_count,
        max(import_date) as last_import_date
from stock_imports si
full join warehouses w
on w.id = si.warehouse_id
group by 1)

select *,
        rank() over (order by import_count desc) as activity_rank,
        lag(warehouse_name) over (order by warehouse_name asc) as prev_warehouse

from temp
order by activity_rank asc, warehouse_name;
