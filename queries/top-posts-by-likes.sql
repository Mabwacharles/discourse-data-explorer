-- https://meta.discourse.org/t/32566/9?u=sidv

SELECT p.id as post_id, p.like_count as like_count
FROM posts p
LEFT JOIN topics t ON t.id = p.topic_id
LEFT JOIN users u ON u.id = p.user_id
WHERE p.created_at >= CURRENT_DATE - INTERVAL '1 month'
  AND NOT u.admin
  AND u.active = true
ORDER BY p.like_count DESC, p.created_at ASC
LIMIT 10
