-- Xom Data · Connected components in a relationship network
-- Problem: https://xomdata.com/practice/nightmare-components-001
-- Solved: 2026-09-13

WITH RECURSIVE undirected as
(
    SELECT u, v 
    FROM edges 
    
    UNION
    SELECT v, u
    FROM edges
)
, path as
(
    SELECT
        u as start_point, 
        u as end_point,
        ',' || u || ',' as path
    FROM 
        (
            SELECT 
                DISTINCT u 
            FROM edges 
            UNION
            SELECT
                DISTINCT v
            FROM edges
        )

    UNION ALL
    SELECT 
        p.start_point,
        e.v, 
        path || e.v || ','
    FROM path p
    JOIN undirected e
    ON e.u = p.end_point
    WHERE instr(path, ',' || e.v || ',') = 0    
)

SELECT 
    p1.end_point as node, 
    min(p1.start_point) as component 
FROM path p1
GROUP BY p1.end_point
ORDER BY p1.end_point asc
;
