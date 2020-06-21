-- Source: https://meta.discourse.org/t/155413/2?u=sidv

-- [params]
-- int :topic_id = 1
-- int :limit = 100

SELECT
    title,
    viewed_at,
    tv.user_id
FROM topics t
LEFT JOIN topic_views tv
    ON t.id = tv.topic_id
WHERE category_id IS NOT NULL
    AND tv.user_id IS NOT NULL
    AND t.id = :topic_id
ORDER BY viewed_at DESC
LIMIT :limit
