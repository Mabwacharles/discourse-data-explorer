-- Source https://meta.discourse.org/t/155413/2?u=sidv

-- [params]
-- int :user_id = 1
-- int :limit = 10

SELECT
    tv.user_id,
    title,
    viewed_at,
    views,
    t.user_id
FROM topics t
LEFT JOIN topic_views tv
    ON t.id = tv.topic_id
WHERE category_id IS NOT NULL
    AND tv.user_id = :user_id
ORDER BY viewed_at DESC
LIMIT :limit
