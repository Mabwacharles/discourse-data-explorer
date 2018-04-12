-- https://meta.discourse.org/t/85103/4?u=sidv
-- 

--[params]
--string :interval = 1 month
--int :limit
SELECT id, title, created_at as posted
FROM topics
WHERE age(created_at) < interval :interval
AND archetype != 'private_message'
GROUP BY id
ORDER BY created_at DESC
LIMIT :limit
