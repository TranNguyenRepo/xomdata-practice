-- Xom Data · Longest rising price run over N trading sessions
-- Problem: https://xomdata.com/practice/nightmare-lis-001
-- Solved: 2026-08-20

WITH RECURSIVE CALENDAR AS
(SELECT
    day,
    price as current_price,
    cast(price as text) as sequence
FROM PRICES

UNION ALL
SELECT 
    p.day, 
    p.price as current_price,
    c.sequence || ',' || p.price
FROM CALENDAR c
JOIN prices p
ON p.price > c.current_price
and p.day > c.day
)
,SEQUENCE AS
(SELECT *,
    LENGTH(sequence) -  LENGTH(REPLACE(sequence,',',''))+1 as length,
    RANK() OVER (ORDER BY LENGTH(sequence) - LENGTH(REPLACE(sequence, ',', '')) + 1 DESC, sequence ASC) AS RNK
FROM CALENDAR)
SELECT distinct
    length as lis_length,
    sequence as lis_sequence
FROM SEQUENCE
WHERE RNK = 1;
