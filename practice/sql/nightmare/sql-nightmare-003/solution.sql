-- Xom Data · 3-month consecutive disbursement rate by department
-- Problem: https://xomdata.com/practice/sql-nightmare-003
-- Solved: 2026-08-02

select dept,
        month,
        sum(budget) over (PARTITION BY dept order by month rows between 2 preceding and current row) as roll3_budget, 
        sum(actual) over (PARTITION BY dept order by month rows between 2 preceding and current row) as roll3_actual,
        round(sum(actual) over (PARTITION BY dept order by month rows between 2 preceding and current row)*100.0/sum(budget) over (PARTITION BY dept order by month rows between 2 preceding and current row),2) as utilization_pct
    

from budgets
order by dept, month asc;
