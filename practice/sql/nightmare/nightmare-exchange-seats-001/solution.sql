-- Xom Data · Swap seats in pairs (1↔2, 3↔4, …)
-- Problem: https://xomdata.com/practice/nightmare-exchange-seats-001
-- Solved: 2026-08-13

WITH TYPE AS (
    SELECT
    *,
    CASE
        WHEN ID % 2 = 0 THEN 'EVEN'
        ELSE 'ODD'
        END AS TYPE
    FROM SEATS)

SELECT
    -- t.id,
    CASE WHEN t.ID < MAX(t.ID) OVER () AND t.TYPE = 'ODD' THEN t.ID + 1
         WHEN t.ID < MAX(t.ID) OVER () AND t.TYPE = 'EVEN' THEN t.ID - 1
         WHEN t.ID = MAX(t.ID) OVER () AND t.TYPE = 'ODD' THEN t.ID
         WHEN t.ID = MAX(t.ID) OVER () AND t.TYPE = 'EVEN' THEN t.ID - 1

    END AS id,
    s.student  
FROM TYPE t
LEFT JOIN SEATS s
ON t.id = s.id
ORDER BY id asc ;
