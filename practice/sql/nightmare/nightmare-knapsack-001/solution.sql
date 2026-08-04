-- Xom Data · Optimal product selection within a weight limit (0/1 knapsack)
-- Problem: https://xomdata.com/practice/nightmare-knapsack-001
-- Solved: 2026-08-04

WITH RECURSIVE tree AS
(
    -- trạng thái ban đầu
    SELECT
        '' AS selected_id,
        '' AS selected_name,
        0 AS last_id,
        0 AS total_weight,
        0 AS total_value,
        0 AS mask

    UNION ALL

    -- chọn thêm item
    SELECT
        CASE
            WHEN t.selected_id = '' THEN CAST(i.id AS TEXT)
            ELSE t.selected_id || ',' || CAST(i.id AS TEXT)
        END,

        CASE
            WHEN t.selected_name = '' THEN i.name
            ELSE t.selected_name || ', ' || i.name
        END,

        i.id,

        t.total_weight + i.weight,

        t.total_value + i.value,

        -- bật bit của item được chọn
        t.mask | (1 << (i.id - 1))

    FROM tree t
    JOIN items i
      ON i.id > t.last_id
),

result AS
(
    SELECT
        selected_id,
        selected_name,
        total_weight,
        total_value,
        mask,

        -- tạo chuỗi tie-break: id lớn -> id nhỏ
        (
            SELECT group_concat(
                CASE
                    WHEN (mask & (1 << (id-1))) != 0
                    THEN '1'
                    ELSE '0'
                END,
                ''
            )
            FROM (
                SELECT id
                FROM items
                ORDER BY id DESC
            )
        ) AS sort_key

    FROM tree
    CROSS JOIN constraints
    WHERE total_weight <= capacity
)

SELECT
    total_value AS best_value,
    total_weight AS used_weight,
    selected_name AS selected_items
FROM result
ORDER BY
    total_value DESC,
    sort_key ASC
LIMIT 1;
