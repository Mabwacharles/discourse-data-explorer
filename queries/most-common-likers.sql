-- https://meta.discourse.org/t/32566?u=sidv

WITH pairs AS (
    SELECT p.user_id liked, pa.user_id liker
    FROM post_actions pa
    LEFT JOIN posts p ON p.id = pa.post_id
    WHERE post_action_type_id = 2
)
SELECT liker liker_user_id, liked liked_user_id, count(*)
FROM pairs
GROUP BY liked, liker
ORDER BY count DESC
