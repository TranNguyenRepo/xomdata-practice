-- Xom Data · Next-month customer retention rate by cohort
-- Problem: https://xomdata.com/practice/expert-final-cohort-002
-- Solved: 2026-09-06

with temp as
(SELECT
    *,
    strftime('%Y-%m', order_date) as month
    -- count(distinct user_id) as fasirst_month_users 
FROM ORDERS )
, lead_month as
(SELECT *,
    LEAD(month) OVER (PARTITION BY user_id ORDER BY month) as next_month
FROM temp
ORDER BY user_id)
, diff_month as
(SELECT 
    *,
    month, 
    -- count (distinct user_id)  first_month_users,
    round((julianday(date(next_month || '-01')) - julianday(date(month || '-01')))/30,1) as diff_month
FROM lead_month
-- GROUP BY month
ORDER BY month)
, JOINING as
(SELECT 
    d.month as first_month, 
    count (distinct d.user_id)  first_month_users,
    COALESCE(a.return_count,0) as return_count
FROM diff_month d
LEFT JOIN ( SELECT 
    distinct
    month, 
    count(user_id) over (partition by next_month) as return_count
FROM diff_month
where diff_month = 1) a
ON d.month = a.month
GROUP BY d.month)
SELECT *, 
    round(return_count*100.0/first_month_users,1) as retention_rate
FROM JOINING
ORDER BY first_month asc;

-- SELECT COUNT(distinct user_id) as first_month_users FROM TEMP GROUP BY month
