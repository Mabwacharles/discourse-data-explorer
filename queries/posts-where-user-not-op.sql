-- https://meta.discourse.org/t/104472/2?u=sidv
-- The number of posts by a user on topics where the user is not the OP

-- [params]
-- string :user_id = 3
SELECT count(posts.id) FROM posts
JOIN topics ON topics.id = posts.topic_id
WHERE posts.user_id = :user_id 
AND NOT topics.user_id = :user_id
AND posts.deleted_at IS NULL
AND topics.deleted_at IS NULL
AND topics.archetype = 'regular'
