-- Xom Data · Advertiser status by month (4 states)
-- Problem: https://xomdata.com/practice/nightmare-statemachine-001
-- Solved: 2026-08-12

WITH RECURSIVE 

advertisers AS (
    SELECT DISTINCT advertiser_id
    FROM advertiser_activity
),

calendar_month AS (
    SELECT MIN(month) AS full_month
    FROM advertiser_activity

    UNION ALL

    SELECT STRFTIME(
        '%Y-%m',
        DATE(full_month || '-01', '+1 month')
    )
    FROM calendar_month
    WHERE full_month < (
        SELECT MAX(month)
        FROM advertiser_activity
    )
),

mapping AS (
    SELECT
        a.advertiser_id,
        c.full_month,
        aa.month AS active_month,

        MIN(aa.month) OVER (
            PARTITION BY a.advertiser_id
        ) AS first_month,

        MAX(aa.month) OVER (
            PARTITION BY a.advertiser_id
            ORDER BY c.full_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS prev_active_month

    FROM advertisers a

    CROSS JOIN calendar_month c

    LEFT JOIN advertiser_activity aa
        ON c.full_month = aa.month
        AND aa.advertiser_id = a.advertiser_id
),

states AS (
    SELECT
        advertiser_id,
        full_month AS month,

        CASE

            -- Active lần đầu
            WHEN full_month = first_month
                THEN 'NEW'

            -- Tháng trước active, tháng này không active
            WHEN active_month IS NULL
                 AND prev_active_month = STRFTIME(
                     '%Y-%m',
                     DATE(full_month || '-01', '-1 month')
                 )
                THEN 'CHURN'

            -- Active tháng này và tháng trước cũng active
            WHEN active_month IS NOT NULL
                 AND prev_active_month = STRFTIME(
                     '%Y-%m',
                     DATE(full_month || '-01', '-1 month')
                 )
                THEN 'EXISTING'

            -- Đã từng active nhưng tháng trước không active,
            -- nay active lại
            WHEN active_month IS NOT NULL
                 AND prev_active_month IS NOT NULL
                 AND prev_active_month <> STRFTIME(
                     '%Y-%m',
                     DATE(full_month || '-01', '-1 month')
                 )
                THEN 'RESURRECT'

        END AS state

    FROM mapping
)

SELECT
    advertiser_id,
    month,
    state
FROM states
WHERE state IS NOT NULL
ORDER BY advertiser_id, month;
