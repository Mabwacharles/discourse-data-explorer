-- https://meta.discourse.org/t/74574/5?u=sidv
-- Top 50 posters
-- Returns the top 50 posters for a given monthly period. 
-- Results are ordered by post_count. It accepts a ‘months_ago’ parameter, defaults to 1 to give results for the most 
-- recently completed calendar month.

-- [params]
-- int :months_ago = 1
WITH query_period AS (
SELECT
date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' as period_start,
date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' + INTERVAL '1 month' - INTERVAL '1 second' as period_end
),

user_posts_in_period AS (
SELECT
p.user_id
FROM posts p
INNER JOIN query_period qp
ON p.created_at >= qp.period_start
AND p.created_at <= qp.period_end
WHERE p.user_id > 0
)

SELECT
up.user_id,
count(1) as post_count
FROM user_posts_in_period up
GROUP BY up.user_id
ORDER BY post_count DESC
LIMIT 50

