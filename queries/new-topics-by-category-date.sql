-- https://meta.discourse.org/t/43516/91?u=sidv
-- Lists all new topics created with a given month, ordered by category and creation_date. 
-- The query accepts a "months_ago" parameter. It defaults to 0 to give you the stats for the current month.

-- [params]
-- int :months_ago = 1
-- int :limit

WITH query_period as (
    SELECT
        date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' as period_start,
        date_trunc('month', CURRENT_DATE) - INTERVAL ':months_ago months' + INTERVAL '1 month' - INTERVAL '1 second' as period_end
)

SELECT
    t.id as topic_id,
    t.category_id
FROM topics t
RIGHT JOIN query_period qp
    ON t.created_at >= qp.period_start
        AND t.created_at <= qp.period_end
WHERE t.user_id > 0
    AND t.category_id IS NOT NULL
ORDER BY t.category_id, t.created_at DESC
LIMIT :limit
