-- Xom Data · Chuỗi tháng ghé đều dài nhất
-- Problem: https://xomdata.com/practice/hard-streak-001
-- Solved: 2026-09-10

WITH TEMP AS
(SELECT
    DISTINCT
    customer_id,
    date(order_date, 'start of month') as month
    -- order_date    
FROM orders
ORDER BY customer_id, order_date)
, is_island as
(SELECT 
    customer_id,
    month,
    ROW_NUMBER() over (PARTITION BY customer_id order by month) as rn
FROM TEMP)
, groupup as
(SELECT *,
    date(month, '-' || rn || ' month') as island
FROM is_island)
, ranking as
(SELECT
    DISTINCT
    customer_id,
    count(customer_id) as cnt
FROM groupup
GROUP BY customer_id, island)
SELECT 
    customer_id,
    cnt as longest_streak
FROM
(SELECT 
    customer_id, 
    cnt,
    rank() over (PARTITION BY customer_id order by cnt desc) as ranking
FROM ranking)
WHERE ranking = 1
ORDER BY longest_streak desc, customer_id asc;
