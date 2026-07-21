-- Xom Data · Top 10 most-borrowed books
-- Problem: https://xomdata.com/practice/medium-subquery-198
-- Solved: 2026-07-20

with loan_count
as
(select b.*, 
        count(b.id) as borrow_count

from books b
join book_loans l
on l.book_id = b.id
group by 1,2,3,4,5
),

reservations_count as
(
select b.id,
        count(b.id) as pending_reservation

from books b
join reservations r
on r.book_id = b.id
where status = 'ready_pickup'
group by 1
),
engagement_view as
(select lc.*, 
        COALESCE(rc.pending_reservation, 0) as pending_reservation,
        borrow_count + COALESCE(rc.pending_reservation, 0) as engagement,
        DENSE_RANK() over (order by (borrow_count + COALESCE(rc.pending_reservation, 0)) desc) as overall_rank
 from loan_count lc
left join reservations_count rc
on rc.id = lc.id)

select e.title, 
       a.full_name as authors,
       p.publisher_name, 
       g.genre_name, 
       borrow_count,
       pending_reservation, 
       engagement,
       overall_rank,
       rank() over (partition by genre_name order by engagement desc) as rank_in_genre

from engagement_view e
join authors a
on e.author_id = a.id
join publishers p
on e.publisher_id = p.id
join genres g
on e.genre_id = g.id
order by overall_rank asc, title
limit 10;
