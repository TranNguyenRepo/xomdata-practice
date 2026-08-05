-- Xom Data · Longest consecutive login streak
-- Problem: https://xomdata.com/practice/sql-nightmare-001
-- Solved: 2026-08-05

WITH TEMP
AS
(SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) AS RN,
    DATE(
        login_date,
        '-' || ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY login_date
        ) || ' days'
    ) AS COMPARISON
FROM LOGINS),
COUNT_STREAK
AS
(SELECT  user_id,
        COMPARISON,    
        COUNT(COMPARISON) OVER (PARTITION BY user_id,COMPARISON ORDER BY COMPARISON ) AS CNT
        
FROM TEMP
ORDER BY user_id, CNT desc)
SELECT 
        user_id,
        MAX(CNT) as max_streak
FROM COUNT_STREAK
group by user_id;
