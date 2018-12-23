-- top-users-by-badges-v1.sql
-- https://meta.discourse.org/t/43516/159?u=sidv
-- SQL to display a list of users (top 10 maybe), 
-- ordered by the total number of Badges they have?

-- [params]
-- int :posts = 100
-- int :top = 10
SELECT u.username, count(ub.id) as "Badges"
FROM user_badges ub, users u, user_stats us
WHERE u.id = ub.user_id
AND u.id = us.user_id
AND us.post_count > :posts
AND (u.admin = 'f' AND u.moderator = 'f')
GROUP BY u.username
ORDER BY count(ub.id) desc
LIMIT :top
