-- Xom Data · Detect anomalous days vs the average
-- Problem: https://xomdata.com/practice/hard-anomaly-001
-- Solved: 2026-07-26

with base as (
    select date, value,
           avg(value) over () as mean
    from daily_metrics
),
stats as (
    select date, value, mean,
           sqrt(avg((value - mean) * (value - mean)) over ()) as stddev
    from base
),
scored as (
    select date, value, mean, stddev,
           case when stddev = 0 then 0
                else (value - mean) / stddev
           end as z_score
    from stats
)
select date,
       value,
       round(mean, 2)    as mean,
       round(stddev, 2)  as stddev,
       round(z_score, 2) as z_score,
       case when z_score > 2  then 'high'
            when z_score < -2 then 'low'
            else 'normal'
       end as flag
from scored
order by date asc;
