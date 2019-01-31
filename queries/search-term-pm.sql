-- https://meta.discourse.org/t/43516/115?u=sidv
-- Replace WELCOME-TITLE-from-discobot by the exact title of your welcome message, 
-- so that all welcome messages generated automatically are excluded.

-- [params]
-- int :limit = 10
-- string :term = %term%
SELECT p.user_id, p.topic_id, p.post_number, p.raw, p.created_at::date
FROM posts p
LEFT JOIN topics t on t.id = p.topic_id
WHERE t.archetype = 'private_message'
  AND t.title <> 'WELCOME-TITLE-from-discobot'
  AND p.created_at::date > now()::date - 8
  AND p.raw ILIKE :term
ORDER BY p.created_at DESC
LIMIT :limit
