-- https://meta.discourse.org/t/43516/91?u=sidv
-- Time to respond by staff (monthly)
-- Average time to first staff response for topics created by regular users in a given time period for a hard-coded array of categories. The categories array can be changed (see the source for more info)

-- [params]
-- int :months_ago = 1
-- int :limit

WITH query_period AS (
SELECT
date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' as period_start,
date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' + INTERVAL '1 month' - INTERVAL '1 second' as period_end
),
staff_responses AS (
SELECT
DISTINCT ON (p.topic_id)
p.topic_id,
p.created_at,
t.category_id,
DATE_TRUNC('minute', p.created_at - t.created_at) AS response_time
FROM posts p
JOIN topics t
ON t.id = p.topic_id
AND t.category_id = ANY ('{46,25,43,40,44,35,22,7,20,17,6,12}'::int[])
JOIN users u
ON u.id = p.user_id
WHERE p.post_number > 1
AND u.admin = 't' OR u.moderator = 't'
ORDER BY p.topic_id, p.created_at
),
user_topics AS (
SELECT
t.id
FROM topics t
JOIN users u
ON u.id = t.user_id
WHERE u.admin = 'f' AND u.moderator = 'f'
)

SELECT
sr.category_id,
AVG(sr.response_time) AS "Average First Response Time",
COUNT(1) AS "Topics Responded to"
FROM staff_responses sr
JOIN query_period qp
ON sr.created_at >= qp.period_start
AND sr.created_at <= qp.period_end
JOIN user_topics t
ON t.id = sr.topic_id
GROUP BY sr.category_id
LIMIT :limit
