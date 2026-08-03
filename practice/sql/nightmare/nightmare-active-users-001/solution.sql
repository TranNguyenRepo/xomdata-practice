-- Xom Data · Users active 5+ consecutive days
-- Problem: https://xomdata.com/practice/nightmare-active-users-001
-- Solved: 2026-08-03

with temp
as
(select distinct
        l1.id,
        l1.login_date,
        ROW_NUMBER() over (PARTITION BY l1.id order by login_date) as rn


from logins l1),

sequences
as
(select  id, 
        -- login_date,
        date(login_date, '-' || rn || ' day') ,
        count() over (PARTITION BY id, date(login_date, '-' || rn || ' day') order by date(login_date, '-' || rn || ' day')) as cnt

from temp)

select  id from sequences
where cnt >= 5
GROUP BY id
order by id asc;
