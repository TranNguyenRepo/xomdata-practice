-- Xom Data · Maximum bipartite matching of candidates to openings
-- Problem: https://xomdata.com/practice/nightmare-bipartite-001
-- Solved: 2026-09-13

WITH RECURSIVE
numbered AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY candidate, position) AS rn,
        candidate,
        position
    FROM matches
)
,
search AS (

    SELECT
        0 AS rn,
        '' AS used_candidates,
        '' AS used_positions,
        0 AS matching_count

    UNION ALL

    SELECT
        n.rn,

        CASE
            WHEN instr(',' || s.used_candidates || ',', ',' || n.candidate || ',') = 0
             AND instr(',' || s.used_positions || ',', ',' || n.position || ',') = 0
            THEN s.used_candidates || ',' || n.candidate
            ELSE s.used_candidates
        END,

        CASE
            WHEN instr(',' || s.used_candidates || ',', ',' || n.candidate || ',') = 0
             AND instr(',' || s.used_positions || ',', ',' || n.position || ',') = 0
            THEN s.used_positions || ',' || n.position
            ELSE s.used_positions
        END,

        CASE
            WHEN instr(',' || s.used_candidates || ',', ',' || n.candidate || ',') = 0
             AND instr(',' || s.used_positions || ',', ',' || n.position || ',') = 0
            THEN s.matching_count + 1
            ELSE s.matching_count
        END

    FROM search s
    JOIN numbered n
        ON n.rn = s.rn + 1
)

SELECT
    MAX(matching_count) AS max_matching

FROM search;
