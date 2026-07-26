-- Xom Data · Top 10 most-engaged posts
-- Problem: https://xomdata.com/practice/medium-groupby-097
-- Solved: 2026-07-25

with temp as (
    select u.full_name,
           p.post_type,
           p.post_date,
           (p.like_count + p.comment_count + p.share_count) as total_interactions,
           rank() over (order by (p.like_count + p.comment_count + p.share_count) desc) as overall_rank
    from posts p
    join users u on u.id = p.user_id
)
select full_name,
       post_type,
       post_date,
       total_interactions,
       overall_rank,
       row_number() over (partition by full_name order by total_interactions desc, post_date asc) as rank_in_author,
       round(total_interactions * 100.0 / max(total_interactions) over (), 2) as pct_of_top
from temp
order by overall_rank asc, full_name asc, rank_in_author asc
limit 10;
