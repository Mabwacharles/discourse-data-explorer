-- https://meta.discourse.org/t/43516/31?u=sidv

SELECT user_id, count(*) AS message_count
FROM topics
WHERE archetype = 'private_message' AND subtype = 'user_to_user'
AND age(created_at) < interval '7 days'
GROUP BY user_id
ORDER BY message_count DESC
