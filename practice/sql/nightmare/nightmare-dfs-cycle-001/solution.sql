-- Xom Data · Detect and output the shortest cycle in a directed graph (DFS)
-- Problem: https://xomdata.com/practice/nightmare-dfs-cycle-001
-- Solved: 2026-08-23

WITH RECURSIVE PATHS AS (

    -- Start with ONE node, not an edge
    SELECT
        u AS start_node,
        u AS current_node,
        '->' || CAST(u AS TEXT) || '->' AS path
    FROM (
        SELECT u FROM edges
        UNION
        SELECT v FROM edges
    )

    UNION ALL

    -- Move to a new node
    SELECT
        p.start_node,
        e.v AS current_node,
        p.path || CAST(e.v AS TEXT) || '->' AS path
    FROM PATHS p
    JOIN edges e
        ON e.u = p.current_node
    WHERE
        INSTR(
            p.path,
            '->' || CAST(e.v AS TEXT) || '->'
        ) = 0
),

CYCLES AS (

    -- Look at the next edge.
    -- If its destination already exists in the path,
    -- we found a cycle.
    SELECT
        substr(
            p.path,
            INSTR(
                p.path,
                '->' || CAST(e.v AS TEXT) || '->'
            ) + 2
        )
        || CAST(e.v AS TEXT) AS cycle_nodes

    FROM PATHS p

    JOIN edges e
        ON e.u = p.current_node

    WHERE
        INSTR(
            p.path,
            '->' || CAST(e.v AS TEXT) || '->'
        ) > 0
),

RANKED AS (

    SELECT
        cycle_nodes,

        ROW_NUMBER() OVER (
            ORDER BY
                LENGTH(cycle_nodes),
                cycle_nodes
        ) AS rn

    FROM CYCLES
)

SELECT
    1 AS has_cycle,
    cycle_nodes
FROM RANKED
WHERE rn = 1

UNION ALL

SELECT
    0 AS has_cycle,
    NULL AS cycle_nodes
WHERE NOT EXISTS (
    SELECT 1
    FROM CYCLES
);
