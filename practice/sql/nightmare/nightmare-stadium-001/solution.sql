-- Xom Data · Stadium high-attendance streaks (3+ consecutive days ≥ 100)
-- Problem: https://xomdata.com/practice/nightmare-stadium-001
-- Solved: 2026-08-10

with temp as
(select 
        id, 
        visit_date,
        people, 
        ROW_NUMBER() over (order by visit_date) as rn,
        case
            when people >= 100 then 1 else 0 end as cnt
from stadium
where people >= 100)
,
island as
(select 
        *,
        date(visit_date, '-' || rn || ' days') as collect_data
from temp)
,
count_as AS
(select *,
        count(collect_data) OVER (PARTITION BY COLLECT_DATA) AS groupcount
from island)

SELECT ID, VISIT_DATE, PEOPLE FROM COUNT_AS 
WHERE GROUPCOUNT >= 3
ORDER BY VISIT_DATE ASC;
