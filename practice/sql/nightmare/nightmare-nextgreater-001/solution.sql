-- Xom Data · Next session with a higher price
-- Problem: https://xomdata.com/practice/nightmare-nextgreater-001
-- Solved: 2026-08-03

select
        p1.day,
        p1.price,
        -- p2.price,
        p2.day as next_higher_day,
        p2.day - p1.day as days_until

from prices p1
left join prices p2
on p2.price > p1.price
and p1.day < p2.day
GROUP BY p1.day
order by p1.day asc;
