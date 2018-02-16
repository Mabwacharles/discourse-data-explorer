-- 
-- The idea comes from this topic: https://meta.discourse.org/t/80747?u=sidv
-- This query serves to filter the topics that have been pinned.
-- Of course you can change the query, or improve it, propose the change through a PR here in github. Thank you!
-- 

-- [params]
-- null string :interval = 3 year
-- int :limit
SELECT DISTINCT t.id, t.title, t.pinned_at, t.pinned_until, t.created_at, tu.cleared_pinned_at
FROM topics t, topic_users tu
WHERE t.id = tu.topic_id
AND t.created_at >= CURRENT_DATE - INTERVAL :interval
AND t.pinned_at IS NOT NULL
ORDER BY tu.cleared_pinned_at ASC 
LIMIT :limit
