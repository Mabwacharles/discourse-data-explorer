-- https://meta.discourse.org/t/43516/98?u=sidv
-- check the "t.category_id" and put your categories id.

-- [params]
-- int :months_ago = 0

WITH query_period AS (
SELECT
date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' as period_start,
date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' + INTERVAL '1 month' - INTERVAL '1 second' as period_end
)

SELECT
t.category_id,

SUM (CASE WHEN (u.admin = 'false' OR u.moderator = 'false') THEN 1 ELSE 0 END) AS "Solved by Members",
SUM (CASE WHEN (u.admin = 't' OR u.moderator = 't') THEN 1 ELSE 0 END) AS "Solved by Staff"

FROM user_actions ua
JOIN topics t
ON t.id = ua.target_topic_id
JOIN query_period qp
ON ua.created_at >= qp.period_start
AND ua.created_at <= qp.period_end
JOIN users u
ON u.id = ua.user_id
WHERE t.category_id = ANY ('{1,2,3,4,5,6,7,8}'::int[])
AND ua.action_type = 15
GROUP BY t.category_id
LIMIT 10
