-- source: https://meta.discourse.org/t/43516/30

SELECT 
    sum(p.score) / count(p) as "average score per post", 
    count(p.id) as post_count, 
    p.user_id
FROM posts p
JOIN users u ON u.id = p.user_id
WHERE p.created_at >= CURRENT_DATE - INTERVAL '6 month'
  AND NOT u.admin
  AND NOT u.blocked
  AND u.active
GROUP by user_id, u.views
HAVING count(p.id) > 50
ORDER BY sum(p.score) / count(p) DESC
LIMIT 20
