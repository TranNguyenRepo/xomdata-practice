-- Xom Data · All consecutive login streaks per user
-- Problem: https://xomdata.com/practice/expert-final-gap-001
-- Solved: 2026-08-18

WITH TEMP AS
(SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY DATE) AS RN
FROM activities
WHERE TYPE = 'login')

SELECT 
    DISTINCT
    user_id, 
    min(date) over (PARTITION BY user_id,date(julianday(date) - rn)) AS start_date,
    max(date) over (PARTITION BY user_id,date(julianday(date) - rn)) AS end_date,
    count(date(julianday(date) - rn)) OVER (PARTITION BY user_id,date(julianday(date) - rn) ) as length
FROM TEMP
ORDER BY user_id asc, start_date asc ;
