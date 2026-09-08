-- Xom Data · Word break
-- Problem: https://xomdata.com/practice/nightmare-wordbreak-001
-- Solved: 2026-09-08

WITH RECURSIVE word as
(
    SELECT 
        0 as position,
        '' as word
    FROM input

    UNION ALL
    SELECT
    word.position + length(dict.word) AS position,
    dict.word
FROM word
JOIN input
JOIN dict
    ON substr(
        input.s,
        word.position + 1,
        length(dict.word)
    ) = dict.word
)
SELECT 
    CASE
        WHEN MAX(position) = length(s) then 1
        else 0 end as can_break 
FROM word
CROSS JOIN input;
