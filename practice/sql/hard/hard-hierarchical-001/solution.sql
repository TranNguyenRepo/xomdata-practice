-- Xom Data · Total sales by org branch
-- Problem: https://xomdata.com/practice/hard-hierarchical-001
-- Solved: 2026-07-30

WITH RECURSIVE tree AS (
    -- Mỗi nhân viên thuộc team của chính mình
    SELECT
        id AS employee,
        id AS boss
    FROM agents

    UNION ALL

    -- Đi từ nhân viên hiện tại lên manager
    SELECT
        tree.employee,
        agents.manager_id AS boss
    FROM tree
    JOIN agents
        ON tree.boss = agents.id
    WHERE agents.manager_id IS NOT NULL
)

SELECT
    a.id AS agent_id,
    a.name AS agent_name,
    a.direct_sales,
    SUM(member.direct_sales) AS team_total
FROM agents a
JOIN tree
    ON a.id = tree.boss
JOIN agents member
    ON tree.employee = member.id
GROUP BY
    a.id,
    a.name,
    a.direct_sales
ORDER BY
    team_total DESC,
    agent_id ASC;
