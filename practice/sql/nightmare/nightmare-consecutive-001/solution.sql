-- Xom Data · Numbers appearing 3 times in a row in the log
-- Problem: https://xomdata.com/practice/nightmare-consecutive-001
-- Solved: 2026-07-31

with 
testing
as
(select 
        id,
        num,
        lead(num,1) over (order by id) as next_log,
        lead(num,2) over (order by id) as next_next_log,
        case when num = lead(num,1) over (order by id) and   lead(num,1) over (order by id) = lead(num,2) over (order by id) then num end as consecutive_num

from logs)

select distinct
        consecutive_num

from testing
where next_log is not null
and next_next_log is not null 
and consecutive_num is not null
order by consecutive_num asc;
