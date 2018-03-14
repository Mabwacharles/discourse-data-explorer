-- https://meta.discourse.org/t/43516/90?u=sidv
-- Here’s a query to identify the users who have “liked” the most flagged posts, where the flags have been “agreed” by a moderator

-- [params]
-- int :limit
SELECT likes.user_id, count(*) as count 
FROM post_actions pa 
    JOIN post_action_types pat ON pa.post_action_type_id = pat.id
    JOIN post_actions likes ON likes.post_id = pa.post_id AND
        likes.post_action_type_id = 2
WHERE 
    pat.is_flag AND
    pat.name_key NOT IN ('notify_user') AND
    pa.agreed_by_id IS NOT NULL
GROUP BY 
    likes.user_id
ORDER BY 
    count DESC
LIMIT :limit
