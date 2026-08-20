-- Xom Data · Revenue split by new vs returning customers
-- Problem: https://xomdata.com/practice/sql-nightmare-006
-- Solved: 2026-08-20

WITH RECURSIVE MIN_DATE AS
(SELECT 
    date(min(MONTH) ||'-01') AS MONTH
FROM SALES
)
,CALENDAR AS
(SELECT
    MONTH
FROM MIN_DATE

UNION ALL
SELECT
    date(MONTH, '+1 month') AS MONTH
FROM CALENDAR
WHERE (MONTH) < (SELECT  date(MAX(MONTH) ||'-01') FROM SALES)
)
,UNIQUE_MAP AS
(SELECT
    DISTINCT
    a.user_id,
    a.month,
    -- s.month,
    s.revenue,
    MIN(s.month) over (PARTITION BY a.user_id) AS MIN_PER_USER,
    LAG(s.revenue) over (PARTITION BY a.user_id) as lag_revenue   
FROM (SELECT DISTINCT user_id, strftime('%Y-%m', c.month) as month FROM SALES
      CROSS JOIN CALENDAR c) a
LEFT JOIN SALES s
on a.month = s.month
and a.user_id = s.user_id
)
SELECT 
    month,
    COALESCE(SUM(CASE WHEN month = MIN_PER_USER then revenue end),0) as new_revenue,
    COALESCE(SUM(CASE WHEN revenue is not null and month <> min_per_user then revenue end),0) as returning_revenue,
    COALESCE(SUM(CASE WHEN revenue is null then lag_revenue end),0) as churned_revenue
FROM UNIQUE_MAP
GROUP BY MONTH;
