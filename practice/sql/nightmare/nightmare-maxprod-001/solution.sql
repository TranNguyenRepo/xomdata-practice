-- Xom Data · Maximum product subarray
-- Problem: https://xomdata.com/practice/nightmare-maxprod-001
-- Solved: 2026-08-29

WITH RECURSIVE multiplication AS
(
    SELECT 
        idx, 
        val,
        val as val_nex ,
        val as multiplication
    FROM arr
    
    UNION ALL
    SELECT
        arr.idx , 
        arr.val, 
        m.val_nex || '->' || arr.val ,
        m.multiplication * arr.val
    FROM multiplication m
    JOIN arr
    ON m.idx + 1 = arr.idx 
)
SELECT max(multiplication) as max_subarray_product FROM 
multiplication;
