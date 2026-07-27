-- Xom Data · Rank hotels by room price within each destination
-- Problem: https://xomdata.com/practice/medium-join-155
-- Solved: 2026-07-26

select 
        h.hotel_name,
        h.star_class,
        d.destination_name,
        count(hr.id) as room_count,
        min(nightly_rate) as min_price,
        max(nightly_rate) as max_price,
        avg(nightly_rate) as avg_price,
        max(nightly_rate) - min(nightly_rate) as price_spread,
        rank() over (PARTITION BY destination_name order by avg(nightly_rate) desc) as rank_in_destination
from hotel_rooms hr
join  hotels h
on h.id = hr.hotel_id
join destinations d
on d.id = h.destination_id
group by 1
having room_count >= 2
order by destination_name, rank_in_destination asc, hotel_name;
