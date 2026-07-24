-- Xom Data · Monthly income and expense report
-- Problem: https://xomdata.com/practice/medium-groupby-080
-- Solved: 2026-07-24

with temp
as
(select
        strftime('%Y-%m',transaction_date) as month,
        sum (case when type ='Thu' then amount else 0 end) as total_income,
        sum (case when type ='Chi' then amount else 0 end) as total_expense
from transactions
group by 1)

select *,
        total_income -total_expense as balance,
        sum(total_income -total_expense) over (order by month asc) as cumulative_balance,
        case 
            when total_income  > total_expense then 'Surplus'
            when total_income  < total_expense then 'Deficit'
            else 'Balanced'
            end as status
            

from temp;
