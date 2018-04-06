-- [params]
-- int :limit = 15
-- int :posts = 10

SELECT ua.user_id, u.name, us.post_count, us.topic_count, us.read_faq
FROM user_avatars ua, users u, user_stats us 
WHERE ua.user_id = u.id
AND u.id = us.user_id
AND (u.admin = 'f' AND u.moderator = 'f')
AND (ua.custom_upload_id IS NULL AND ua.gravatar_upload_id IS NULL)
AND us.post_count > :posts
ORDER BY us.post_count desc
LIMIT :limit
