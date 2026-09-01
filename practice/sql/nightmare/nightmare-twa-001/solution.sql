-- Xom Data · Time-weighted average price
-- Problem: https://xomdata.com/practice/nightmare-twa-001
-- Solved: 2026-09-01

WITH PW AS
(SELECT 
    *,
    LEAD(valid_from) over (partition by ticker order by valid_from) as valid_to,
    julianday(LEAD(valid_from) over (partition by ticker order by valid_from))-julianday(valid_from) as days
FROM price_states)

,ARR AS
(
    SELECT 
        *, 
        price * days as price_weighted
    FROM PW
    WHERE days is not null
)
SELECT 
    ticker, 
    COALESCE(ROUND(SUM(price_weighted)/sum(days),4),0) as twa FROM ARR
GROUP BY ticker
ORDER BY ticker asc;
