-- https://meta.discourse.org/t/43516/48?u=sidv

-- [params]
-- null int :period

SELECT users.username AS "Username",
directory_items.likes_received AS "Likes Received",
directory_items.likes_given AS "Likes Given",
directory_items.topic_count AS "Topics Created",
directory_items.post_count AS "Replied",
directory_items.days_visited AS "Vists",
directory_items.topics_entered AS "Viewed",
directory_items.posts_read AS "Read"
FROM users
JOIN  directory_items ON users.id =  directory_items.user_id
WHERE directory_items.period_type = :period
ORDER BY directory_items.likes_received DESC
