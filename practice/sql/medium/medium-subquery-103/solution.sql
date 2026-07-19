-- Xom Data · Products more expensive than the category average
-- Problem: https://xomdata.com/practice/medium-subquery-103
-- Solved: 2026-07-19

select  product_name, category, price, 
        price-avg_price as diff_from_avg, 
        round((price-avg_price)*100.0/nullif((avg_price),0),2) as pct_above

from (select product_name, category, price,
 avg(price) over (PARTITION BY category) as avg_price from products)
where price > avg_price
order by pct_above desc, product_name;
