-- Xom Data · Inventory value using FIFO
-- Problem: https://xomdata.com/practice/sql-nightmare-007
-- Solved: 2026-08-18

WITH TEMP AS
(SELECT 
    i.*,
    s.demand_qty,
    SUM(quantity) over (ORDER BY batch_date) as cumulative_qty,
    SUM(quantity) OVER (
                            ORDER BY batch_date, batch_id
                            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                        ) AS PREV_CUMULATIVE
FROM inventory i
CROSS JOIN sales_demand s
ORDER BY batch_date)
,REMAINING AS
(SELECT 
    *,
    CASE 
        WHEN demand_qty > cumulative_qty then 0
        WHEN demand_qty < PREV_CUMULATIVE THEN quantity
        ELSE CUMULATIVE_QTY - demand_qty
        END AS remaining_qty
FROM TEMP)
SELECT 
    batch_id,
    batch_date,
    remaining_qty,
    unit_cost,
    remaining_qty * unit_cost as remaining_value
FROM REMAINING
WHERE remaining_qty > 0
ORDER BY batch_date asc, batch_id asc
;
