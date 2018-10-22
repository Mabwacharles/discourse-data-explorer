-- https://meta.discourse.org/t/43516/151?u=sidv
-- Established users with trust-level locked to 0 or 1
-- v1

-- [params]
-- int :min_visited_days = 30
-- int :min_posts = 1

SELECT 
    id AS user_id,
    manual_locked_trust_level,
    days_visited,
    post_count
FROM 
    users u JOIN
        user_stats us ON u.id = us.user_id
WHERE 
    manual_locked_trust_level IN (0,1) AND
    days_visited >= :min_visited_days AND
    post_count >= :min_posts AND
    (silenced_till IS NULL OR silenced_till < NOW()) AND
    (suspended_till IS NULL OR suspended_till < NOW())
ORDER BY 
    days_visited DESC
    
--
--
--
-- v2:
-- Mod by SidV
-- Established users with trust-level locked to 0, 1 or 2
-- Add limit

-- [params]
-- int :min_visited_days = 30
-- int :min_posts = 1
-- int :limit = 10
SELECT 
    id AS user_id,
    manual_locked_trust_level,
    days_visited,
    post_count
FROM 
    users u JOIN
        user_stats us ON u.id = us.user_id
WHERE 
    manual_locked_trust_level IN (0,1,2) AND
    days_visited >= :min_visited_days AND
    post_count >= :min_posts AND
    (silenced_till IS NULL OR silenced_till < NOW()) AND
    (suspended_till IS NULL OR suspended_till < NOW())
ORDER BY 
    days_visited DESC
LIMIT :limit
