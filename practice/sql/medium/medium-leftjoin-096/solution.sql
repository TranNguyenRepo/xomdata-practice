-- Xom Data · Accounts with no posts
-- Problem: https://xomdata.com/practice/medium-leftjoin-096
-- Solved: 2026-07-27

select 
        u.full_name,
        u.username,
        u.account_type,
        ROW_NUMBER() over (order by created_at asc, full_name) as signup_order,
        ntile(4) over (order by created_at asc) as tenure_quartile

from posts p
right join users u
on u.id = p.user_id
group by 1,2,3
having count(p.id)  = 0
order by signup_order asc;
