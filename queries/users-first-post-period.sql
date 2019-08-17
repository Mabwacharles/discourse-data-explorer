-- https://meta.discourse.org/t/43516/227?u=sidv
-- Users with first post within period

-- [params]
-- date :start_date = 2019-08-01
-- date :end_date = 2019-08-10
SELECT username
FROM users u
JOIN user_stats us
ON u.id = us.user_id
WHERE us.first_post_created_at BETWEEN :start_date::date 
AND :end_date::date
