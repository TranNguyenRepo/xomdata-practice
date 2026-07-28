-- Xom Data · Book count and average price by genre
-- Problem: https://xomdata.com/practice/medium-coalesce-040
-- Solved: 2026-07-27

with temp
as
(select
        g.genre_name,
        COALESCE(count(b.id),0) as book_count,
        COALESCE(avg(b.price),0) as avg_price,
        COALESCE(min(b.price),0) as min_price,
        COALESCE(max(b.price),0) as max_price,
        COALESCE(max(b.price),0) - COALESCE(min(b.price),0) as price_range
from books b
right join genres g
on g.id = b.genre_id
group by 1)
select *,
        rank() over (order by book_count desc) as coverage_rank ,
        ntile(3) over (order by book_count desc) as library_focus

from temp
order by coverage_rank asc, genre_name;
