-- Xom Data · Median from a frequency distribution
-- Problem: https://xomdata.com/practice/nightmare-median-freq-001
-- Solved: 2026-08-13

WITH TEMP AS (
    SELECT
    *,
    SUM(frequency) OVER (ORDER BY number) as RUN_TOTAL,
    SUM(frequency) OVER () AS N
FROM NUMBERS
)

,POSITION AS (
    SELECT 
        *,
        CASE 
            WHEN N % 2 = 0 THEN (N)/2 -- EVEN
            WHEN N % 2 <> 0 THEN (N+1)/2 -- ODD
            END AS POS1,
        CASE 
            WHEN N % 2 = 0 THEN (N+2)/2 
            WHEN N % 2 <> 0 THEN (N+1)/2
        END AS POS2
    FROM TEMP
)
,CHAIN AS (
    SELECT *,
        COALESCE(LAG(RUN_TOTAL) OVER (ORDER BY RUN_TOTAL)+1,0) AS CHAIN
    FROM POSITION)
,FILTER_NUMBER AS(
    SELECT 
        *,
        CASE WHEN CHAIN<= POS1 and POS1 <= RUN_TOTAL THEN NUMBER END AS NUMBER1,
        CASE WHEN CHAIN<= POS2 and POS2 <= RUN_TOTAL THEN NUMBER END AS NUMBER2

        -- COALESCE(CASE WHEN POS2 <= RUN_TOTAL THEN NUMBER END,0)  AS NUMBER2
    FROM CHAIN)
SELECT 
        CASE
            WHEN N % 2 = 0 THEN (NUMBER1 + NUMBER2)*10.0 / 20
            ELSE NUMBER1
            END AS median
FROM (SELECT 
        DISTINCT n, 
        MAX(NUMBER1) OVER () AS NUMBER1,
        MAX(NUMBER2) OVER () AS NUMBER2
FROM FILTER_NUMBER);
