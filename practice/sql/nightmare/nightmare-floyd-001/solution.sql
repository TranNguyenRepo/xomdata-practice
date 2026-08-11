-- Xom Data · Shortest path between all node pairs (Floyd-Warshall)
-- Problem: https://xomdata.com/practice/nightmare-floyd-001
-- Solved: 2026-08-11

WITH RECURSIVE nodes AS (
    -- Lấy tất cả các kho xuất hiện trong bảng edges
    SELECT u AS n FROM edges
    UNION
    SELECT v AS n FROM edges
),
paths (u, v, cost, len) AS (
    -- Bước gốc: đi từ 1 kho về chính nó, tốn 0 đồng, 0 chặng
    SELECT n, n, 0, 0
    FROM nodes

    UNION ALL

    -- Bước đệ quy: nối thêm 1 chặng đường (1 cạnh) vào cuối đường đi đã có
    SELECT p.u, e.v, p.cost + e.cost, p.len + 1
    FROM paths p
    JOIN edges e ON p.v = e.u
    WHERE p.len < (SELECT COUNT(*) FROM nodes)  -- không cần đi quá (số kho) chặng
)
SELECT u, v, MIN(cost) AS min_cost
FROM paths
GROUP BY u, v
ORDER BY u, v;
