-- https://meta.discourse.org/t/43516/197?u=sidv
-- Query that shows me topics where I’ve been mentioned… but haven’t responded after being mentioned
--

-- [params]
-- user_id :user
-- int :limit = 10

WITH mentions AS (
  SELECT target_topic_id, target_post_id, created_at
    FROM user_actions
   WHERE action_type = 7 -- mentions
     AND user_id = :user
), replies AS (
  SELECT target_topic_id, MAX(created_at) created_at
    FROM user_actions
   WHERE action_type = 5 -- replies
     AND user_id = :user
   GROUP BY target_topic_id    
)
SELECT DATE(m.created_at) mentioned_at, target_post_id post_id
FROM mentions m
JOIN replies r ON r.target_topic_id = m.target_topic_id
JOIN topics t ON t.id = m.target_topic_id
WHERE m.created_at > r.created_at
AND t.deleted_at IS NULL
AND NOT t.archived
AND NOT t.closed
ORDER BY m.created_at DESC
LIMIT :limit
