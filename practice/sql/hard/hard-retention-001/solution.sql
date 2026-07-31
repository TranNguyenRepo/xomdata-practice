-- Xom Data · D7 and D30 retention rate
-- Problem: https://xomdata.com/practice/hard-retention-001
-- Solved: 2026-07-31

SELECT
    COALESCE(COUNT(DISTINCT s.user_id),0) AS total_users,

    COUNT(DISTINCT CASE
        WHEN date(a.active_date)
             BETWEEN date(s.signup_date,'+1 day')
                 AND date(s.signup_date,'+7 days')
        THEN s.user_id
    END) AS d7_retained,

    COALESCE(ROUND(
        COUNT(DISTINCT CASE
            WHEN date(a.active_date)
                 BETWEEN date(s.signup_date,'+1 day')
                     AND date(s.signup_date,'+7 days')
            THEN s.user_id
        END) * 100.0
        / COALESCE(COUNT(DISTINCT s.user_id),0),
        2
    ),0) AS d7_rate,

    COUNT(DISTINCT CASE
        WHEN date(a.active_date)
             BETWEEN date(s.signup_date,'+1 day')
                 AND date(s.signup_date,'+30 days')
        THEN s.user_id
    END) AS d30_retained,

    COALESCE(ROUND(
        COUNT(DISTINCT CASE
            WHEN date(a.active_date)
                 BETWEEN date(s.signup_date,'+1 day')
                     AND date(s.signup_date,'+30 days')
            THEN s.user_id
        END) * 100.0
        / COALESCE(COUNT(DISTINCT s.user_id),0),
        2
    ),0) AS d30_rate
FROM signups s
LEFT JOIN activity a
    ON s.user_id = a.user_id;
