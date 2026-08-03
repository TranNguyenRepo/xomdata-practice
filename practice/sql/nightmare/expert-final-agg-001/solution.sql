-- Xom Data · Quarterly sales per employee (2024)
-- Problem: https://xomdata.com/practice/expert-final-agg-001
-- Solved: 2026-08-02

select 
        employee_id, 
        COALESCE(sum(case when quarter = 1 then revenue end),0) as Q1,
        COALESCE(sum(case when quarter = 2 then revenue end),0) as Q2,
        COALESCE(sum(case when quarter = 3 then revenue end),0) as Q3,
        COALESCE(sum(case when quarter = 4 then revenue end),0) as Q4
from sales
where year = 2024
GROUP BY employee_id
ORDER BY employee_id asc;
