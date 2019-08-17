-- Non-PM topics that have not received a staff reply

-- [params]
-- int :limit = 10
-- int :category_id = 1
SELECT t.id topic_id, category_id
FROM topics t
WHERE t.deleted_at IS NULL
  AND t.category_id IS NOT NULL AND t.category_id <> :category_id
  AND t.id NOT IN (
    SELECT p.topic_id
    FROM posts p 
    JOIN users u ON p.user_id = u.id
    WHERE  u.admin = 't' OR u.moderator = 't'
      AND p.post_number > 1
  )
LIMIT :limit
