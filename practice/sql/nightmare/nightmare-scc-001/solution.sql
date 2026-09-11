-- Xom Data · Service clusters with dependency cycles
-- Problem: https://xomdata.com/practice/nightmare-scc-001
-- Solved: 2026-09-11

WITH RECURSIVE node AS
(
    SELECT 
        u AS start_node,
        u AS end_node,
        ',' || u || ',' AS path
    FROM (
        SELECT DISTINCT u AS u
        FROM edges

        UNION

        SELECT DISTINCT v AS u
        FROM edges
    )

    UNION ALL

    SELECT 
        n.start_node, 
        e.v AS end_node,
        n.path || e.v || ',' AS path
    FROM node n
    JOIN edges e
        ON n.end_node = e.u
    WHERE instr(n.path, ',' || e.v || ',') = 0
)

SELECT 
DISTINCT 
a.start_node as node, 
min(a.end_node) as scc_id

FROM node a
JOIN node b
on a.end_node = b.start_node
AND a.start_node = b.end_node
-- WHERE a.start_node >= a.end_node
GROUP BY a.start_node
ORDER BY a.start_node;
