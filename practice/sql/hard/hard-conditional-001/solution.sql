-- Xom Data · Cumulative revenue from successful transactions only
-- Problem: https://xomdata.com/practice/hard-conditional-001
-- Solved: 2026-07-30

select 
        date,
        status,
        amount,
        sum((case when status = 'success' then 1
                           
        else 0
        end )*amount) over (order by date asc, status asc, id asc) as running_success_total 

from transactions
order by date asc, status asc, id asc;
