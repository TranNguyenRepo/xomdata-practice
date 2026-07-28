-- Xom Data · 7-day moving average of revenue
-- Problem: https://xomdata.com/practice/hard-frame-001
-- Solved: 2026-07-27

select

        date,
        amount as revenue, 
        round(avg(amount) over (order by date asc rows BETWEEN 6 preceding and current row),2) as ma7

from daily_revenue
order by date asc;
