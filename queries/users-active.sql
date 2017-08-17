-- https://meta.discourse.org/t/43516/19?u=sidv

-- [params]
-- int :interval = 30

select username
from users
where last_posted_at > current_timestamp - interval ':interval' day


-- https://meta.discourse.org/t/43516/23?u=sidv

-- [params]
-- date :date_from
-- date :date_to
-- int  :min_posts = 1

WITH user_activity AS (
    SELECT p.user_id, count (p.id) as posts_count
    FROM posts p
    LEFT JOIN topics t ON t.id = p.topic_id
    WHERE p.created_at::date BETWEEN :date_from::date AND :date_to::date
        AND t.deleted_at IS NULL
        AND t.visible = TRUE
        AND t.closed = FALSE
        AND t.archived = FALSE
        AND t.archetype = 'regular'
        AND p.deleted_at IS NULL
        
    GROUP BY p.user_id
)
SELECT COUNT(user_id)
FROM user_activity
WHERE posts_count >= :min_posts
