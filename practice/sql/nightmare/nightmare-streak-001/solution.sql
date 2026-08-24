-- Xom Data · Customers active and purchasing 3 weeks in a row
-- Problem: https://xomdata.com/practice/nightmare-streak-001
-- Solved: 2026-08-24

WITH WEEKS AS (
    SELECT DISTINCT
        user_id,
        strftime('%Y-%W', event_date) AS week
    FROM EVENTS
    WHERE subtype = 'purchase'
),

TEMP AS (
    SELECT
        user_id,
        week,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY week
        ) AS rn
    FROM WEEKS
)
, ISLAND AS
(SELECT
    *, 
    -- date(week_start, '-' || (rn - 1) || ' days') as island
    (substr(week,-2)-rn) as island
FROM TEMP)
, MIN_MAX AS
(SELECT 
    DISTINCT
    user_id,
    MIN(WEEK) OVER (PARTITION BY ISLAND, user_id) AS streak_start_week, 
    MAX(WEEK) OVER (PARTITION BY ISLAND, user_id) AS streak_end_week,
    COUNT() OVER (PARTITION BY user_id,ISLAND) AS n_weeks
FROM ISLAND)
SELECT * FROM MIN_MAX
WHERE n_weeks>=3
ORDER BY user_id, streak_start_week ASC;
