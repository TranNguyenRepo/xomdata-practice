-- Xom Data · Validate a 4×4 Sudoku
-- Problem: https://xomdata.com/practice/nightmare-sudoku4x4-001
-- Solved: 2026-09-14

with temp as
(SELECT
    (row - 1) / 2 AS box_row,
    (col - 1) / 2 AS box_col,
    COUNT(DISTINCT val) AS cnt
FROM cells
GROUP BY box_row, box_col)
SELECT 
    CASE WHEN EXISTS
    ( SELECT 1 FROM temp WHERE cnt <> 4 ) THEN 0 ELSE 1
    END AS is_valid;
