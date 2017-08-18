-- https://meta.discourse.org/t/63981/4?u=sidv

-- [params]
-- string :interval = 1 year
SELECT  ua.acting_user_id, 
        count(case t.user_id when ua.acting_user_id then 1 else null end) as is_op, 
        count(case t.user_id when ua.acting_user_id then null else 1 end) as not_op,
        count(*) as total
FROM user_actions ua
LEFT JOIN topics t ON target_topic_id = t.id
WHERE action_type=15
AND ua.created_at >= CURRENT_DATE - INTERVAL :interval
GROUP BY ua.acting_user_id
ORDER BY total DESC
