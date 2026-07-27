-- Xom Data · Consultation revenue by doctor
-- Problem: https://xomdata.com/practice/medium-join-141
-- Solved: 2026-07-26

select 
        faculties.faculty_name,
        -- mv.doctor_id,
        d.full_name as doctor_name,
        count(mv.id) as visit_count,
        avg(mv.visit_fee) as avg_exam_fee,
        sum(mv.visit_fee) as total_exam_fee,
        rank() over (order by sum(mv.visit_fee) desc) as overall_rank,
        DENSE_RANK() over (PARTITION BY faculty_name order by sum(mv.visit_fee) desc) as rank_in_faculty 
from medical_visits mv
join doctors d
on d.id = mv.doctor_id
join faculties
on d.faculty_id =  faculties.id
group by 1,2
order by total_exam_fee desc, d.full_name
limit 15;
