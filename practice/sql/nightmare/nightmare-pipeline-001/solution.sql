-- Xom Data · Top 3 campaigns by month-over-month growth
-- Problem: https://xomdata.com/practice/nightmare-pipeline-001
-- Solved: 2026-08-25

WITH TEMP AS
(SELECT 
    strftime ('%Y-%m', spend_date) as month,
    campaign_id,
    MAX(amount) OVER (PARTITION BY campaign_id, spend_date) as dedup_amount,
    -- strftime('%Y-%m',MAX(spend_date) OVER ()) as max_month,
    spend_date 
FROM campaign_spend
order by spend_date)
, DEDUP AS
(SELECT 
    DISTINCT
    *
FROM TEMP)
, PREV_SPEND AS
(SELECT *,
        SUM(dedup_amount) as total_amount,
        LAG(SUM(dedup_amount)) OVER (PARTITION BY campaign_id ORDER BY month) AS prev_month
FROM DEDUP
GROUP BY campaign_id, month)
,RANKING AS
(SELECT 
    *,
    round((total_amount - prev_month)*100.0/prev_month,2) as growth_pct,
    DENSE_RANK() over (partition by month order by (total_amount - prev_month)*100.0/prev_month desc, campaign_id) as rank_in_month
FROM PREV_SPEND)
SELECT month, campaign_id, total_amount AS total_spend, growth_pct, rank_in_month
FROM RANKING
WHERE rank_in_month <= 3 and growth_pct is not null
ORDER BY month, rank_in_month asc;
