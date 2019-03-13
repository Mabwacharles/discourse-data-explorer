-- https://meta.discourse.org/t/43516/187?u=sidv
-- A query showing how many members open the Welcome PM for "x" months?
--

-- [params]
-- int :months_ago = 1
WITH query_period as (
    SELECT
        date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' as period_start,
        date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' + INTERVAL '1 month' - INTERVAL '1 second' as period_end
)
SELECT
COUNT(1) AS number_of_opens
FROM topics t
JOIN topic_users tu
ON tu.topic_id = t.id
RIGHT JOIN query_period qp
    ON t.created_at >= qp.period_start
JOIN users u
ON u.id = tu.user_id
WHERE t.user_id = -2
AND u.admin = false
AND tu.last_read_post_number IS NOT NULL
AND t.created_at <= qp.period_end
