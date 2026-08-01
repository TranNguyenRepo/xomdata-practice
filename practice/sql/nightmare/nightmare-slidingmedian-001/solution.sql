-- Xom Data · Centered 5-session rolling median price per session
-- Problem: https://xomdata.com/practice/nightmare-slidingmedian-001
-- Solved: 2026-08-01

with temp
as
(select 
        p1.day,
        p2.day,
        p2.price,
        count(*) over (PARTITION BY p1.day order by p1.day) as cnt,
        row_number() over (PARTITION BY p1.day order by p2.price) as rn
from prices p1
join prices p2
on p1.day between p2.day - 2 and p2.day+2
order by p1.day, p2.price)

select 
day,
        -- (cnt+1)/2,
        -- (cnt+2)/2,
        avg(price) as median_price
from temp
where rn in ((cnt+1)/2,(cnt+2)/2)
group by day;
