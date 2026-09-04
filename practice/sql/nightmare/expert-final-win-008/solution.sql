-- Xom Data · Cumulative revenue and cumulative % of the period total
-- Problem: https://xomdata.com/practice/expert-final-win-008
-- Solved: 2026-09-04

SELECT
    period,
    period_revenue,
    sum(period_revenue) over (ORDER BY period) as running_total,
    sum(period_revenue) over () as grand_total,
    round(sum(period_revenue) over (ORDER BY period) * 100.0 /sum(period_revenue) over (),1) as cumulative_pct
FROM (SELECT 
    period,
    sum(revenue) as period_revenue
FROM sales
GROUP BY period);
