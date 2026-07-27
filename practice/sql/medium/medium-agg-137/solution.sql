-- Xom Data · Investor trade summary
-- Problem: https://xomdata.com/practice/medium-agg-137
-- Solved: 2026-07-27

-- Summarize buy/sell totals per investor
with overall
as
(SELECT
  full_name,
  segment,
  count(t.id) as total_trades,
  COALESCE(sum( case when side ='buy' then t.amount end),0) as total_bought,
  COALESCE(sum( case when side ='sell' then t.amount end),0) as total_sold,
  -- case
  --     when sum(case when side = 'buy' then 1 end) = sum(case when side = 'sell'then 1 end) then 'Neutral'
  --     when sum(case when side = 'buy' then 1 end) > sum(case when side = 'sell'then 1 end) then 'Bull'
  --     else 'Bear'
  --     end as stance
  COALESCE(sum( case when side ='buy' then t.amount end),0) - COALESCE(sum( case when side ='sell' then t.amount end),0)  as net_position,
  case
      when COALESCE(sum( case when side ='buy' then t.amount end),0) = COALESCE(sum( case when side ='sell' then t.amount end),0) then 'Neutral'
      when COALESCE(sum( case when side ='buy' then t.amount end),0) > COALESCE(sum( case when side ='sell' then t.amount end),0) then 'Bull'
      else 'Bear'
      end as stance
FROM investors i
JOIN trades t ON t.investor_id = i.id
GROUP BY 1,2)

select  *,
        DENSE_RANK() over (PARTITION BY segment order by (total_bought+total_sold) desc) as rank_in_segment
from overall
order by (total_bought+total_sold) desc, full_name;
