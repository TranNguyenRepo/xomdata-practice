-- Xom Data · Frequently co-purchased product pairs
-- Problem: https://xomdata.com/practice/sql-nightmare-004
-- Solved: 2026-08-03

with 

temp 
as
(select distinct
        o1.user_id,
        -- o2.user_id,
        o1.product_id as product_a ,
        o2.product_id as product_b,
        concat(o1.product_id ,o2.product_id) as key_cnt

from orders o1
left join orders o2
on o1.user_id = o2.user_id
and o1.product_id < o2.product_id)

select  product_a,
product_b,
        count(*) as co_buyers
 from temp
 where product_a is not null
 and product_b is not null
 GROUP BY product_a, product_b;
