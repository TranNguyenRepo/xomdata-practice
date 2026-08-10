-- Xom Data · Merge overlapping bookings into continuous ranges
-- Problem: https://xomdata.com/practice/nightmare-interval-merge-001
-- Solved: 2026-08-09

with temp 
as
(select 
        *,
        max(end_at) over (PARTITION BY room_id order by start_at  ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
) as max_date
from bookings)
, within_chain
as
(select *, 
        case 
            when  max_date >= start_at then 0
            else 1
        end as within_chain
from temp)
, 
island
as
(select *,
        sum(within_chain) over (PARTITION BY room_id order by start_at) as total
from within_chain)
select distinct room_id,
-- end_at,
        min(start_at) over (PARTITION BY room_id, total) as merged_start,
        max(end_at) over (PARTITION BY room_id, total) as merged_end, 
        count(total) over (partition by room_id, total) as n_bookings, 
        round((julianday(max(end_at) over (PARTITION BY room_id, total)) - julianday(min(start_at) over (PARTITION BY room_id, total)))*24*60,2) as duration_min
from island;
