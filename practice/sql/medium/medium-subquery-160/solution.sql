-- Xom Data · Low-activity users
-- Problem: https://xomdata.com/practice/medium-subquery-160
-- Solved: 2026-07-24

WITH temp AS (
    SELECT
        u.user_name,
        COUNT(o.id) AS order_count,
        SUM(o.value) AS total_value,
        AVG(o.value) AS avg_order_value
    FROM users u
    LEFT JOIN orders o
        ON u.id = o.user_id
    GROUP BY u.id, u.user_name
),
result AS (
    SELECT
        *,
        AVG(total_value) OVER () AS avg_total_value
    FROM temp
)
SELECT
    user_name,
    order_count,
    total_value,
    avg_order_value,
    CASE
        WHEN order_count = 0 THEN 'Inactive'
        WHEN total_value < avg_total_value THEN 'Low'
        ELSE 'Normal'
    END AS tier,
    RANK() OVER (ORDER BY total_value ASC) AS activity_rank,
    ROUND(PERCENT_RANK() OVER (ORDER BY total_value ASC) * 100, 2) AS pct_above_peers
FROM result
WHERE order_count = 0
   OR total_value < avg_total_value
ORDER BY activity_rank, user_name;
