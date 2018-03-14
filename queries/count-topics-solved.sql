-- https://meta.discourse.org/t/43516/91?u=sidv
-- Count of topics solved by regular members (defaults to last month)

-- [params]
-- int :months_ago = 1
-- int :limit

WITH query_period AS (
SELECT
date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' as period_start,
date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' + INTERVAL '1 month' - INTERVAL '1 second' as period_end
)

SELECT
ua.user_id,
count(1) AS solved_count
FROM user_actions ua
INNER JOIN query_period qp
ON ua.created_at >= qp.period_start
AND ua.created_at <= qp.period_end
INNER JOIN users u
ON u.id = ua.user_id
WHERE ua.action_type = 15
AND u.admin = 'f'
AND u.moderator = 'f'
GROUP BY ua.user_id
ORDER BY solved_count DESC
LIMIT :limit
