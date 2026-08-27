-- Xom Data · Count primes up to N (Sieve)
-- Problem: https://xomdata.com/practice/nightmare-sieve-001
-- Solved: 2026-08-27

WITH RECURSIVE numbers AS
(
    SELECT 0 AS number
    
    UNION ALL
    
    SELECT number + 1
    FROM numbers
    CROSS JOIN config
    WHERE number + 1 <= config.n
)
, PRIME AS (SELECT 
DISTINCT
-- n.number,
d.number as sqrt_number
FROM numbers n
JOIN numbers d
    WHERE 
    -- d.number >= 2
    --   AND d.number <= sqrt(n.number)
    --   AND n.number % d.number = 0
d.number >= 2
AND d.number <= sqrt(n.number)
AND n.number >= 2)
, NOT_PRIME AS
(SELECT * FROM numbers
CROSS JOIN PRIME
where number >= 2
and number > sqrt_number
and number % sqrt_number = 0)
SELECT 
COUNT(number) as prime_count
FROM 
(SELECT n.number, p.number as prime
FROM NUMBERS n
LEFT JOIN NOT_PRIME p
ON n.number = p.number
WHERE n.number >= 2)
WHERE prime is null;
