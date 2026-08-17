-- Xom Data · Allocate contract revenue across years
-- Problem: https://xomdata.com/practice/nightmare-prorate-001
-- Solved: 2026-08-17

WITH RECURSIVE year AS (
    SELECT
        *,
        STRFTIME('%Y', start_date) AS Y1,
        STRFTIME('%Y', end_date) AS Y2,
        julianday(end_date) - julianday(start_date) + 1 as days
    FROM contracts
),

calendar AS (
    SELECT *
    FROM year

    UNION ALL

    SELECT
        id,
        amount,
        start_date,
        end_date,
        Y1 + 1 as Y1,
        Y2,
        days
    FROM calendar
    WHERE CAST(Y1 AS INTEGER) < CAST(Y2 AS INTEGER)
)

SELECT id as contract_id,
        CAST(Y1 AS INTEGER) as year, 
        round((amount/days) *
        (julianday(MIN(end_date,Y1 || '-12-31'))
        -
        julianday(MAX(start_date,Y1 || '-01-01')) + 1),2) as prorated_amount -- get the max value as that is the actual start date of contracts
FROM calendar
order by contract_id, year asc;
