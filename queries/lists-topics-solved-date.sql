-- https://meta.discourse.org/t/43516/91?u=sidv
-- Returns topics solved by regular users over a given monthly period, ordered by solution_date. 
-- The query accepts a ‘months_ago’ parameter, defaults to 0 to give the results for the current month.

-- [params]
-- int :months_ago = 1
-- int :limit

WITH query_period AS (
SELECT
date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' as period_start,
date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' + INTERVAL '1 month' - INTERVAL '1 second' as period_end
)

SELECT
ua.target_topic_id,
ua.target_post_id
FROM user_actions ua
INNER JOIN query_period qp
ON ua.created_at >= qp.period_start
AND ua.created_at <= qp.period_end
INNER JOIN users u
ON u.id = ua.user_id
WHERE ua.action_type = 15
AND (u.admin = 'f' AND u.moderator = 'f')
ORDER BY ua.created_at DESC
LIMIT :limit
