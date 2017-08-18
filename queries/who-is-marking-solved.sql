-- https://meta.discourse.org/t/63981/4?u=sidv

SELECT acting_user_id, target_topic_id, target_post_id, created_at FROM user_actions
WHERE action_type=15
ORDER BY created_at DESC
