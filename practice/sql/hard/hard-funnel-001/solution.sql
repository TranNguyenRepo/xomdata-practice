-- Xom Data · 4-step onboarding conversion rate
-- Problem: https://xomdata.com/practice/hard-funnel-001
-- Solved: 2026-07-30

with step
as
(select 'signup' as step,   
        1 as ranking
UNION ALL
select 'verify_email' as step,   
        2 as ranking
UNION ALL
select 'first_login' as step,   
        3 as ranking
UNION ALL
select 'first_purchase' as step,   
        4 as ranking),
signup_count
as
(select count(case when event_name = 'signup' then 1 end) as signup_count

from events),

n_user
as
(select event_name, 
        count(distinct user_id) as n_users,
        signup_count
from events
cross join signup_count sc
group by 1 )

select step.step, COALESCE(n_users,0) as n_users, COALESCE(n_users*100.0/signup_count,0) as conversion_pct
from step
left join n_user 
on n_user.event_name = step.step
