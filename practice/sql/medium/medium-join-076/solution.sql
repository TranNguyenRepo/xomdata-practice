-- Xom Data · Showtime count and average ticket price per film
-- Problem: https://xomdata.com/practice/medium-join-076
-- Solved: 2026-07-26

with temp
as
(select 
        m.movie_name,
        m.genres,
        count(s.id) as showtime_count,
        avg(ticket_price) as avg_ticket_price,
        dense_rank() over (PARTITION BY m.genres order by avg(ticket_price) desc) as rank_in_genre

from movies m
join showtimes s 
on s.movie_id = m.id
group by 1,2)
select *, 
        first_value(movie_name) over (PARTITION BY genres order by rank_in_genre asc) as top_movie_in_genre
from temp
order by genres, rank_in_genre asc, movie_name;
