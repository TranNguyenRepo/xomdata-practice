-- Xom Data · Transaction count and amount by month
-- Problem: https://xomdata.com/practice/medium-datefunction-045
-- Solved: 2026-07-16

select strftime('%Y-%m', transaction_date) AS month,
count(id) as transaction_count,
sum(amount) as total_amount,
sum(amount) - lag(sum(amount)) over (ORDER BY strftime('%Y-%m', transaction_date)) as mom_delta
from transactions
group by month;
