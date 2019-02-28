-- https://meta.discourse.org/t/43516/175?u=sidv
-- A query showing how many members open the Welcome PM

SELECT
COUNT(1) AS number_of_opens
FROM topics t
JOIN topic_users tu
ON tu.topic_id = t.id
JOIN users u
ON u.id = tu.user_id
WHERE t.user_id = -2
AND u.admin = false
AND tu.last_read_post_number IS NOT NULL
