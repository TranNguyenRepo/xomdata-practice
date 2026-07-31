-- Xom Data · Most common 3-step user path
-- Problem: https://xomdata.com/practice/hard-pathanalysis-001
-- Solved: 2026-07-31

WITH page_paths AS (
    SELECT
        user_id,
        page,
        LEAD(page, 1) OVER (PARTITION BY user_id ORDER BY viewed_at) AS next_page,
        LEAD(page, 2) OVER (PARTITION BY user_id ORDER BY viewed_at) AS next_next_page
    FROM page_views
)
SELECT
    CONCAT_WS(' > ', page, next_page, next_next_page) AS path,
    COUNT(DISTINCT user_id) AS n_users
FROM page_paths
WHERE next_page IS NOT NULL
  AND next_next_page IS NOT NULL
GROUP BY path
ORDER BY n_users DESC, path ASC
LIMIT 10;
