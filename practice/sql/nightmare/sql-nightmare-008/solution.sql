-- Xom Data · Score customers by RFM
-- Problem: https://xomdata.com/practice/sql-nightmare-008
-- Solved: 2026-08-11

WITH TEMP
AS
(select
    DISTINCT
    customer_id, 
    JULIANDAY(MAX(txn_date) OVER ()) - JULIANDAY(MAX(TXN_DATE) OVER (PARTITION BY customer_id)) + 1 AS RECENCY,
    -- txn_date,
    -- amount,
    COUNT(txn_date) OVER (PARTITION BY customer_id) AS FREQUENCY,
    SUM(AMOUNT) OVER (PARTITION BY customer_id) AS MONETARY
    -- MAX(TXN_DATE) OVER (PARTITION BY customer_id) AS LATEST_PURCHASE_DATE
    -- MAX(txn_date) OVER () AS LATEST_DATE
from transactions
ORDER BY customer_id)
,
SCORE AS
(SELECT 
        *,
        NTILE(5) OVER (ORDER BY RECENCY DESC) AS R_SCORE,
        NTILE(5) OVER (ORDER BY FREQUENCY ASC) AS F_SCORE,
        NTILE(5) OVER (ORDER BY MONETARY ASC) AS M_SCORE

FROM TEMP)
SELECT *,
        ROUND(R_SCORE * 0.4 + F_SCORE* 0.3+ M_SCORE* 0.3,2) AS RFM_SCORE
FROM SCORE
ORDER BY RFM_SCORE DESC, CUSTOMER_ID ASC;
