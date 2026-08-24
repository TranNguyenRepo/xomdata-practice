-- Xom Data · Top 3 salaries per department
-- Problem: https://xomdata.com/practice/nightmare-top3-dept-001
-- Solved: 2026-08-24

with temp as
(SELECT 
    e.id,
    e.name, 
    e.salary,
    d.name as department,
    DENSE_RANK() over (PARTITION BY departmentId order by e.salary desc) as rnk
FROM EMPLOYEE E 
JOIN DEPARTMENT D
ON d.id = e.departmentId)

SELECT 
    Department,
    name as Employee, 
    salary as Salary
    -- rnk
FROM TEMP
WHERE RNK <= 3
ORDER BY Department, SALARY DESC, EMPLOYEE ASC;
