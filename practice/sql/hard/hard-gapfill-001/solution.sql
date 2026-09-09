-- Xom Data · Daily revenue including zero-sale days
-- Problem: https://xomdata.com/practice/hard-gapfill-001
-- Solved: 2026-09-09

WITH RECURSIVE CALENDAR AS
(
    SELECT MIN(DATE) AS START_DATE
    FROM daily_revenue

    UNION ALL
    SELECT DATE(START_DATE, '+1 day')
    FROM CALENDAR
    WHERE DATE(START_DATE, '+1 day') <= (
        SELECT MAX(DATE)
        FROM daily_revenue
    )
)

SELECT calendar.start_date as date, COALESCE(sum(daily_revenue.amount),0) as revenue
FROM CALENDAR
LEFT JOIN daily_revenue
ON date = start_date
GROUP BY calendar.start_date ;
