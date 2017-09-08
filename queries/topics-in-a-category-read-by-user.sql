-- https://meta.discourse.org/t/61641/4?u=sidv

SELECT tu.topic_id, tu.last_read_post_number FROM topics 
LEFT OUTER JOIN topic_users AS tu ON topics.id = tu.topic_id 
WHERE topics.category_id = 4 AND tu.user_id = 1 AND tu.last_visited_at IS NOT NULL
