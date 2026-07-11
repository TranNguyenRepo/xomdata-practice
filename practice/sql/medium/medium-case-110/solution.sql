-- Xom Data · Classify products by sales velocity
-- Problem: https://xomdata.com/practice/medium-case-110
-- Solved: 2026-07-11

select p.name, p.categories,
sum(t.quantity) as total_sold, 
case
    when sum(t.quantity) >= 100 then 'Best Seller'
    when sum(t.quantity) >= 50 then 'Average'
    else 'Slow Mover'
    end as classification, 
dense_rank() over (partition by p.categories order by sum(t.quantity) desc) as rank_in_cat,
round(sum(t.quantity)*100.0/sum(sum(t.quantity)) over (partition by p.categories),2) as pct_of_cat_total


from products p
join transactions t
on p.id = t.product_id
group by p.id,  p.name , p.categories
order by p.categories, rank_in_cat, p.name ;
