-- https://meta.discourse.org/t/68756/8?u=sidv

-- [params]
-- topic_id :topic_id = 18438
SELECT u.username
FROM badge_posts p
JOIN topics t ON p.topic_id = t.id 
JOIN users u ON p.user_id  = u.id
WHERE t.id = :topic_id
GROUP BY p.user_id,u.username 
