-- Xom Data · Subset with an exact target sum
-- Problem: https://xomdata.com/practice/nightmare-subsetsum-001
-- Solved: 2026-09-14

WITH RECURSIVE arr AS
(
    SELECT 
        id, 
        ',' || id || ',' as used_id,
        value as total_value,
        0 as amount
    FROM items
    -- WHERE total_value < amount

    UNION ALL
    SELECT 
        i.id, 
        used_id || i.id || ',',
        a.total_value + i.value,
        target.amount
    FROM arr a
    JOIN items i
    ON a.id < i.id
    CROSS JOIN target
    -- WHERE a.total_value + i.value = target.amount
)
SELECT
    CASE
        WHEN (SELECT amount FROM target) = 0 THEN 1
        WHEN EXISTS (
            SELECT 1
            FROM arr
            WHERE total_value = (SELECT amount FROM target)
        ) THEN 1
        ELSE 0
    END AS has_subset;
