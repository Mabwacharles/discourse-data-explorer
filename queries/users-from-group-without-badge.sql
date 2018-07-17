-- https://meta.discourse.org/t/43516/118?u=sidv
-- Give me all the users from group VIP where badge Certified does not exist

-- [params]
-- int :limit = 10
-- string :badge_name = Certified
-- int :group_id = 42
WITH exclude_badge AS (
SELECT gu.user_id
FROM badges b, user_badges ub, users u, group_users gu
WHERE u.id = ub.user_id
AND ub.badge_id = b.id
AND u.id = gu.user_id
AND b.name = :badge_name
AND gu.group_id = :group_id
)

SELECT
u.id AS user_id, gu.group_id
FROM users u, group_users gu
WHERE u.id = gu.user_id
and gu.group_id = :group_id
and u.id NOT IN (SELECT * FROM exclude_badge)
ORDER BY user_id
LIMIT :limit
