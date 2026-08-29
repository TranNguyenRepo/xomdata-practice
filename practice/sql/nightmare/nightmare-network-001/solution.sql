-- Xom Data · Friends of friends within 2 hops
-- Problem: https://xomdata.com/practice/nightmare-network-001
-- Solved: 2026-08-29

WITH friend as
(SELECT f1.user_a, f1.user_b
    FROM friendships f1
        UNION ALL
SELECT f2.user_b, f2.user_a
    FROM friendships f2
)
,
fof AS (

    SELECT
        f1.user_a AS user_id,
        f1.user_b,
        f2.user_a,
        f2.user_b AS friend_of_friend

    FROM friend f1

    JOIN friend f2
        ON f1.user_b = f2.user_a

    WHERE f2.user_b <> f1.user_a

    AND NOT EXISTS (
        SELECT 1
        FROM friend direct
        WHERE direct.user_a = f1.user_a
          AND direct.user_b = f2.user_b
    )
)

SELECT
    user_id,
    friend_of_friend,
    COUNT(*) AS n_mutual

FROM fof

GROUP BY
    user_id,
    friend_of_friend

ORDER BY
    user_id ASC,
    n_mutual DESC,
    friend_of_friend ASC;
