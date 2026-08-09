-- Xom Data · Employee levels in the org chart
-- Problem: https://xomdata.com/practice/sql-nightmare-005
-- Solved: 2026-08-09

WITH RECURSIVE managers AS (
    SELECT 
        id,
        name, 
        manager_id,
        1 as depth
    FROM EMPLOYEES 
    WHERE ID = 1 -- GET THE ROOT

    UNION

    SELECT 
            e.id, 
            e.name, 
            e.manager_id,
            ceo.depth + 1
    FROM employees e
    JOIN managers ceo ON ceo.id = e.manager_id
)
select id, name, depth from managers
order by id asc;
