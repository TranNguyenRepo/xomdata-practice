-- Xom Data · Merge consecutive same-status days into ranges
-- Problem: https://xomdata.com/practice/nightmare-contiguous-dates-001
-- Solved: 2026-09-06

WITH lag_status AS (
    SELECT
        *,
        LAG(status) OVER (ORDER BY day) AS prev_status,
        LAG(day) OVER (ORDER BY day) AS prev_day
    FROM Status
),

new_group AS (
    SELECT
        *,
        CASE
            WHEN prev_status IS NULL
                 OR status <> prev_status
                 OR julianday(day) - julianday(prev_day) <> 1
            THEN 1
            ELSE 0
        END AS new_group
    FROM lag_status
),

grouped AS (
    SELECT
        *,
        SUM(new_group) OVER (ORDER BY day) AS running_total
    FROM new_group
)

SELECT
    status,
    MIN(day) AS start_date,
    MAX(day) AS end_date
FROM grouped
GROUP BY status, running_total
ORDER BY start_date;
