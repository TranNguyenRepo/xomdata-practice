-- Xom Data · Minimum-cost delivery route
-- Problem: https://xomdata.com/practice/nightmare-tsp-001
-- Solved: 2026-08-30

WITH RECURSIVE nodes AS
(
    SELECT
        min,
        e.v AS current,
        ',' || min || ',' || e.v || ',' AS visited,
        e.cost
    FROM edges e
    CROSS JOIN (
        SELECT MIN(u) AS min
        FROM edges
    ) s
    WHERE e.u = s.min

    UNION ALL

    SELECT
        min,
        e1.v AS current,
        visited || e1.v || ',',
        nodes.cost + e1.cost
    FROM nodes
    JOIN edges e1
        ON e1.u = current
    WHERE instr(visited, ',' || e1.v || ',') = 0
)
, node_counts as
(SELECT COUNT(*) cnt 
FROM
(    SELECT DISTINCT u 
    FROM edges 
    UNION 
    SELECT DISTINCT v
    FROM edges
)
)
, back_to_min as
(SELECT 
    nodes.*, 
    length(nodes.visited) -  length(replace(nodes.visited, ',','')) - 1 as node_count,
    nc.cnt
FROM nodes
CROSS JOIN node_counts nc
WHERE length(nodes.visited) -  length(replace(nodes.visited, ',','')) - 1  = nc.cnt)
SELECT 
    min(total_cost) as min_tour_cost
FROM 
(SELECT
    b.min, 
    b.current, 
    e.v as return_home, 
    b.visited, 
    b.cost + e.cost as total_cost, 
    b.node_count, b.cnt
FROM back_to_min b
JOIN edges e
ON e.u = b.current
WHERE min = e.v);
