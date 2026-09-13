-- Xom Data · Maximum loot from non-adjacent houses (House Robber)
-- Problem: https://xomdata.com/practice/nightmare-houserobber-001
-- Solved: 2026-09-13

WITH RECURSIVE dp AS (

    -- Nhà đầu tiên
    SELECT
        idx,
        0 AS prev_best,
        val AS current_best
    FROM houses
    WHERE idx = 1

    UNION ALL

    -- Nhà tiếp theo
    SELECT
        h.idx,
        dp.current_best AS prev_best,
        MAX(
            dp.current_best,
            dp.prev_best + h.val
        ) AS current_best
    FROM dp
    JOIN houses h
        ON h.idx = dp.idx + 1
)

SELECT
    MAX(current_best) AS max_loot
FROM dp;
