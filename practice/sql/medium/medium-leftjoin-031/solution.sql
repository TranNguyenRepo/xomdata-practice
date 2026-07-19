-- Xom Data · Candidates not yet interviewed
-- Problem: https://xomdata.com/practice/medium-leftjoin-031
-- Solved: 2026-07-19

select 
    full_name, -- original columns input first
    email, 
    application_date,
    dense_rank() over (order by application_date asc, full_name) as queue_position,
    round(percent_rank() over (order by application_date ASC) * 100,2) as older_than_pct
from candidates c
left join interviews i
on c.id = i.candidate_id
where i.candidate_id is null
order by queue_position asc;
