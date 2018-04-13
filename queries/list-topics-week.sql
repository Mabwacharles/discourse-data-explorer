-- https://meta.discourse.org/t/85103/4?u=sidv
-- 

--[params]
--string :interval = 1 week
--int :limit
SELECT id, title, created_at as posted
FROM topics
WHERE age(created_at) < interval :interval
AND archetype != 'private_message'
GROUP BY id
ORDER BY created_at DESC
LIMIT :limit

-- v2 (list with link to topic)
-- https://meta.discourse.org/t/85103/7?u=sidv

--[params]
--string :interval = 1 week
--int :limit
SELECT tu.topic_id, t.title, t.created_at as posted
FROM topics t, topic_users tu
WHERE t.id = tu.topic_id 
AND age(t.created_at) < interval :interval
AND t.archetype != 'private_message'
GROUP BY tu.topic_id, t.title, t.created_at
ORDER BY t.created_at DESC
LIMIT :limit
