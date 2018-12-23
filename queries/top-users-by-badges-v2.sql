-- top-users-by-badges-v2.sql
-- https://meta.discourse.org/t/43516/161?u=sidv
-- 

-- [params]
-- int :posts = 100
-- int :top = 10
SELECT u.username, count(ub.id) as "Badges"
FROM user_badges ub, users u, user_stats us, badges b
WHERE u.id = ub.user_id
AND u.id = us.user_id
AND b.id = ub.badge_id
AND us.post_count > :posts
AND (u.admin = 'f' AND u.moderator = 'f')
AND b.multiple_grant = 'f'
GROUP BY u.username
ORDER BY count(ub.id) desc
LIMIT :top
