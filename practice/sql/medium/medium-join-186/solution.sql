-- Xom Data · Goals and cards by team
-- Problem: https://xomdata.com/practice/medium-join-186
-- Solved: 2026-07-23

with 
goals_and_penalty 
as
(select    p.team_id,
                -- p.id as player_id,
                count(distinct p.id) as player_count,
                count(distinct g.id) as total_goals_scored,
                count(distinct l.id) as penalty_count
            from players p
            left join penalties l
            on p.id = l.player_id
            left join goals g
            on p.id = g.player_id
            group by 1)
select 
        t.team_name, 
        t.city,
        player_count,
        total_goals_scored,
        penalty_count,
        round(total_goals_scored*1.0/player_count,2) goals_per_player ,
        round(penalty_count*1.0/player_count,2) cards_per_player,
        rank() over (order by total_goals_scored desc) as scoring_rank,
        sum(total_goals_scored) over (order by total_goals_scored desc) as cumulative_goals 
from goals_and_penalty gp
join teams t
on t.id = gp.team_id
group by  t.team_name, 
        t.city
order by scoring_rank asc, team_name;
