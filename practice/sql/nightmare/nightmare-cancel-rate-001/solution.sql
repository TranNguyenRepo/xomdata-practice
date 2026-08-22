-- Xom Data · Daily trip cancellation rate (unbanned users/drivers only)
-- Problem: https://xomdata.com/practice/nightmare-cancel-rate-001
-- Solved: 2026-08-22

WITH TEMP AS
(SELECT  
    id, u.users_id, status,request_at, role, banned,
    count(id) over (PARTITION BY id) as cnt
        -- COUNT(CASE WHEN STATUS LIKE ('%cancelled%') THEN id END) as cancel_count
FROM Trips t
JOIN Users u
on u.users_id = t.client_id 
or u.users_id = t.driver_id
WHERE request_at BETWEEN '2024-01-01' AND '2024-01-03'
AND banned = 'No'
ORDER BY id)
,SEPARATE AS
(SELECT DISTINCT id, status,request_at
FROM TEMP
WHERE cnt % 2 = 0)
SELECT request_at as Day,
-- COUNT(request_at),
-- COUNT(CASE WHEN STATUS LIKE '%cancelled%' then status end) as cancel_count,
ROUND(COUNT(CASE WHEN STATUS LIKE '%cancelled%' then status end)*1.0/COUNT(request_at),2) as Cancellation_Rate
FROM SEPARATE group by request_at;
