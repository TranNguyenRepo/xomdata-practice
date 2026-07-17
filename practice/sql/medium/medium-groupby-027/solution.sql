-- Xom Data · Average score per subject
-- Problem: https://xomdata.com/practice/medium-groupby-027
-- Solved: 2026-07-16

select s.subject_name, 
        s.credits,
        count(s.id) as student_count,
        round(avg(g.final_score),2) as avg_score,
        round(count(case when g.final_score >=5 then 1 end)*100.0/nullif(count(*) ,0),2)  as pass_rate,
        rank() over (order by avg(g.final_score) desc) as rank_by_avg, 
        NTILE(4) OVER (ORDER BY avg(g.final_score) DESC, subject_name ASC) AS difficulty_quartile
from subjects s
join grades g
on s.id = g.subject_id
group by 1,2, s.id;
