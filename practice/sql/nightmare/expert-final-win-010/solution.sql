-- Xom Data · Median employee revenue per department
-- Problem: https://xomdata.com/practice/expert-final-win-010
-- Solved: 2026-08-17

WITH TEMP AS (SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY departments) AS RN,
    AVG(revenue) OVER (PARTITION BY departments) AS avg_revenue,
    COUNT(*) OVER (PARTITION BY departments) AS CNT
FROM SALES)
SELECT 
        departments,
        cnt as employee_count,
        avg_revenue,
        AVG(revenue) AS median_revenue
FROM TEMP
WHERE RN IN ((CNT+1)/2, (CNT+2)/2)
GROUP BY departments
ORDER BY departments, RN;
