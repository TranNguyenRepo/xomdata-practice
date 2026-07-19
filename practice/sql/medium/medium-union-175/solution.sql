-- Xom Data · Summary of issues to handle
-- Problem: https://xomdata.com/practice/medium-union-175
-- Solved: 2026-07-19

WITH subset_data AS (

    SELECT 'Complaint' AS type,
           COUNT(*) AS quantity
    FROM complaints
    WHERE status = 'Pending'

    UNION ALL

    SELECT 'Cancelled Order',
           COUNT(*)
    FROM orders
    WHERE status = 'Cancelled'

    UNION ALL

    SELECT 'Out of Stock Product',
           COUNT(*)
    FROM products
    WHERE status = 'Out of Stock'
),

agg AS (

    SELECT
        type,
        quantity,
        SUM(quantity) OVER () AS total_quantity,
        DENSE_RANK() OVER (ORDER BY quantity DESC) AS rank_pos
    FROM subset_data
)

SELECT
    type,
    quantity,
    ROUND(quantity * 100.0 / NULLIF(total_quantity,0),2) AS pct_of_total,
    rank_pos,
       ROUND(
            SUM(quantity) OVER (
                ORDER BY quantity DESC, type
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) * 100.0 / NULLIF(total_quantity,0),
            2) AS cumulative_pct
FROM agg
ORDER BY rank_pos, type;
