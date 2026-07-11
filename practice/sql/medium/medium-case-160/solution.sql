-- Xom Data · Delivery performance by size class
-- Problem: https://xomdata.com/practice/medium-case-160
-- Solved: 2026-07-11

WITH temp AS (
  SELECT t.vehicle_type, t.capacity_tons,
         COUNT(d.id) AS shipment_count,
         CASE WHEN t.capacity_tons >= 10 THEN 'Large Truck'
              WHEN t.capacity_tons >= 5  THEN 'Medium Truck'
              ELSE 'Small Truck' END AS size_class,
         SUM(CASE WHEN d.results = 'success' THEN 1 ELSE 0 END) AS delivered
  FROM trucks t
  JOIN shipments s ON t.id = s.truck_id
  JOIN deliveries d ON s.id = d.shipment_id
  GROUP BY t.vehicle_type, t.capacity_tons
),
temp1 AS (
  SELECT *, ROUND(delivered * 100.0 / shipment_count, 2) AS delivery_rate
  FROM temp
)
SELECT *,
       RANK() OVER (PARTITION BY size_class ORDER BY delivery_rate DESC) AS rank_in_size
FROM temp1
ORDER BY size_class, rank_in_size, vehicle_type;
