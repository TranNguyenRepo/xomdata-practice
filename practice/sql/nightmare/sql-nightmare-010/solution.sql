-- Xom Data · TWAP per stock symbol
-- Problem: https://xomdata.com/practice/sql-nightmare-010
-- Solved: 2026-07-31

with temp
as( select  symbol,
        tick_time,
        price,
                LEAD(tick_time) OVER (
            PARTITION BY symbol
            ORDER BY tick_time
        ) as next_tick
from price_ticks),
temp1
as
(select
    *, 
    round((julianday(next_tick) - julianday(tick_time)) *24 *60,2) as minutes
from temp)

select     
    symbol,
    round(sum(minutes * price) /sum(minutes),4)  as twap

from temp1
where next_tick is not null
group by symbol
order by symbol asc;
