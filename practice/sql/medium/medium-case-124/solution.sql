-- Xom Data · Classify student academic performance
-- Problem: https://xomdata.com/practice/medium-case-124
-- Solved: 2026-07-11

select t.full_name, t.student_code,
round(avg(s.final_score),2)  as avg_score, 
case
    when avg(s.final_score) >= 9 then 'Excellent'
    when avg(s.final_score) >= 8 then 'Good'
    when avg(s.final_score) >= 7 then 'Fair'
    when avg(s.final_score) >= 5 then 'Average'
    else 'Poor' end as grade,
dense_rank() over (order by avg(s.final_score) desc) as class_rank
from students t
join scores s
on t.id = s.student_id
group by t.full_name, t.student_code
order by avg_score desc, student_code asc
limit 20;
