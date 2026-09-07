-- Xom Data · Maximize inventory under an area limit
-- Problem: https://xomdata.com/practice/nightmare-greedy-capacity-001
-- Solved: 2026-09-07

WITH RECURSIVE non_prime AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY sqft, item_id) AS rn,
        item_id,
        sqft
    FROM items
    WHERE item_type = 'non_prime'
),

storage AS (
    -- Initial state: toàn bộ prime đã được lấy
    SELECT
        0 AS rn,
        NULL AS item_id,
        COALESCE(SUM(sqft), 0) AS sqft_used
    FROM items
    WHERE item_type = 'prime'

    UNION ALL

    -- Lấy non-prime tiếp theo
    SELECT
        np.rn,
        np.item_id,
        s.sqft_used + np.sqft
    FROM storage s
    JOIN non_prime np
        ON np.rn = s.rn + 1
    WHERE s.sqft_used + np.sqft <= 500000
)

SELECT
    'prime' AS item_type,
    COUNT(*) AS items_taken,
    COALESCE(SUM(sqft), 0) AS sqft_used
FROM items
WHERE item_type = 'prime'

UNION ALL

SELECT
    'non_prime' AS item_type,
    COUNT(*) AS items_taken,
    COALESCE(SUM(np.sqft), 0) AS sqft_used
FROM storage s
JOIN non_prime np
    ON np.item_id = s.item_id
WHERE s.rn > 0

ORDER BY item_type ASC;
