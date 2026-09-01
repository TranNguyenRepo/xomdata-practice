-- Xom Data · Route visiting every location exactly once
-- Problem: https://xomdata.com/practice/nightmare-hamilton-001
-- Solved: 2026-09-01

WITH RECURSIVE path AS
(
    SELECT 
        u as start, 
        v as step,
        u || '->' || v  as path,
        ',' || u || ',' || v || ',' as visited
    FROM edges

    UNION ALL
    SELECT 
        p.start, 
        e.v, 
        path || '->' || e.v,
        visited || e.v ||','
    FROM path p
    JOIN EDGES e 
    on p.step = e.u
    WHERE instr(visited, ',' || e.v || ',') = 0
)
,count_node as
(
SELECT COUNT(*) cnt FROM
    (SELECT 
        e1.u
    FROM edges e1
    UNION 
    SELECT 
        e2.v
    FROM edges e2)
)
,check_path as
(SELECT *,
    length(visited) - length(replace(visited, ',','')) -1 AS has_path
FROM path CROSS JOIN count_node)
,
complete_paths AS
(
    SELECT path
    FROM check_path
    WHERE has_path = cnt
)

SELECT
    CASE 
        WHEN COUNT(*) > 0 THEN 1
        ELSE 0
    END AS has_path,

    (
        SELECT path
        FROM complete_paths
        ORDER BY path
        LIMIT 1
    ) AS first_path

FROM complete_paths;
