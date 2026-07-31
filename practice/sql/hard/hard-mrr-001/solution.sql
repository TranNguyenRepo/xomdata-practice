-- Xom Data · Monthly recurring revenue (MRR) by subscription plan
-- Problem: https://xomdata.com/practice/hard-mrr-001
-- Solved: 2026-07-31

with recursive months as
(
    select 
        date(min(started_at),'start of month') as month,
        date(max(started_at),'start of month') as ended_month
    from subscriptions

    UNION ALL
    select  date(month,'+1 month'),
        ended_month
    from months
        where month < ended_month
)
SELECT
    strftime('%Y-%m', month) AS month,
    COUNT(s.user_id) AS active_subs,
    COALESCE(SUM(s.mrr),0) AS total_mrr
FROM months m
LEFT JOIN subscriptions s
    ON s.started_at <= date(m.month, '+1 month', '-1 day')
   AND (
        s.ended_at IS NULL
        OR s.ended_at > date(m.month, '+1 month', '-1 day')
   )
GROUP BY month
ORDER BY month;
