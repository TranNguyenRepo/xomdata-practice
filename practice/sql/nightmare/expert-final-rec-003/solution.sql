-- Xom Data · Raw material cost of finished goods (multi-level BoM)
-- Problem: https://xomdata.com/practice/expert-final-rec-003
-- Solved: 2026-09-10

WITH RECURSIVE bom AS
(
    -- 1. Tầng đầu tiên
    SELECT
        i.product_id AS root_product_id,
        i.material_id,
        i.quantity AS total_quantity
    FROM ingredients i

    UNION ALL

    -- 2. Đi xuống tầng tiếp theo
    SELECT
        b.root_product_id,
        i.material_id,
        b.total_quantity * i.quantity AS total_quantity
    FROM bom b
    JOIN ingredients i
        ON b.material_id = i.product_id
)
,
leaf_cost AS
(
    -- 3. Chỉ lấy nguyên liệu ở tầng lá
    SELECT
        b.root_product_id AS product_id,
        b.material_id,
        b.total_quantity,
        p.selling_price,
        b.total_quantity * p.selling_price AS cost
    FROM bom b
    JOIN products p
        ON b.material_id = p.id
    WHERE b.material_id NOT IN (
        SELECT product_id
        FROM ingredients
    )
)
,
total AS
(
    SELECT
        product_id,
        SUM(cost) AS total_cost
    FROM leaf_cost
    GROUP BY product_id
)

SELECT
    t.product_id,
    p.name,
    t.total_cost
FROM total t
JOIN products p
    ON t.product_id = p.id
WHERE t.product_id NOT IN (
    SELECT material_id
    FROM ingredients
)
ORDER BY t.product_id;
