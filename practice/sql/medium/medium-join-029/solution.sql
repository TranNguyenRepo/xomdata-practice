-- Xom Data · Instructor teaching load
-- Problem: https://xomdata.com/practice/medium-join-029
-- Solved: 2026-07-26

with temp 
as
(select 
        l.full_name,
        l.academic_degree,
        count(distinct s.id) as subjects_taught,
        rank() over (order by count(distinct s.id) desc) as workload_rank
from lecturers l
join subjects s
on l.id = s.lecturer_id
group by 1)
select *, 
        sum(subjects_taught) over (order by subjects_taught desc, full_name) as cumulative_subjects
from temp
order by workload_rank asc, full_name;
