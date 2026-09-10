-- Xom Data · Scholarship-eligible students
-- Problem: https://xomdata.com/practice/easy-where-010
-- Solved: 2026-09-10

SELECT 
    full_name, 
    student_code,
    avg_score
FROM students
WHERE avg_score >= 8.0
ORDER BY avg_score desc;
