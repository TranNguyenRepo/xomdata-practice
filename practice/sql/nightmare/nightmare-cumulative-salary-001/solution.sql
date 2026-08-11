-- Xom Data · 3-month rolling payroll (excluding each employee's latest month)
-- Problem: https://xomdata.com/practice/nightmare-cumulative-salary-001
-- Solved: 2026-08-11

WITH
TEMP
AS
(SELECT 
        ID, 
        MONTH, 
        SALARY,
        MAX(MONTH) OVER (PARTITION BY ID) AS EMPLOYEE_MAX
FROM EMPLOYEE
-- WHERE MONTH < 
ORDER BY ID, MONTH)
SELECT  ID, 
        MONTH, 
        -- SALARY,
        SUM(Salary) OVER (PARTITION BY ID ORDER BY MONTH ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS SALARY
FROM TEMP
WHERE MONTH < EMPLOYEE_MAX
ORDER BY ID, MONTH DESC;
