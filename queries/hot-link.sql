-- https://meta.discourse.org/t/91471?u=sidv
-- How to check the uniqueness of users in “hot link” badge?
-- For this query you need to know your user's id

-- [params]
-- int :limit = 10
-- int :id = 1
SELECT tl.user_id, post_id, current_timestamp granted_at, tl.clicks
FROM topic_links tl
JOIN posts p  ON p.id = post_id    AND p.deleted_at IS NULL
JOIN topics t ON t.id = p.topic_id AND t.deleted_at IS NULL AND t.archetype <> 'private_message'
WHERE NOT tl.internal
AND tl.clicks >= 300
AND tl.user_id = :id
GROUP BY tl.user_id, tl.post_id, tl.clicks
LIMIT :limit
