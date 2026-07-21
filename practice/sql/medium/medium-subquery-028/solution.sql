-- Xom Data · Students above the subject average
-- Problem: https://xomdata.com/practice/medium-subquery-028
-- Solved: 2026-07-21

with
avg_score 
as
(select 
    subject_id, 
    student_id, 
    final_score, 
    round(avg(g.final_score) over (partition by g.subject_id),2) as subject_avg 
from students s
join grades g
on s.id = g.student_id)
select s.full_name, 
        b.subject_name,
        a.final_score,
        a.subject_avg,
        a.final_score -  a.subject_avg as diff_from_avg

from avg_score a
join students s
on s.id = a.student_id
join subjects b
on b.id = a.subject_id
where a.final_score > a.subject_avg
order by diff_from_avg desc, b.subject_name, s.full_name;
