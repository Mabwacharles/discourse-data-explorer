-- Tracking User Edits
-- https://meta.discourse.org/t/75499/3?u=sidv
-- The first will give the number of revisions per post, the second gives the number of unique users who have edited a post.

-- First Query (modified by SidV)
-- [params]
-- int :limit
-- null string :interval = '7 days'
SELECT
pr.post_id,
count(pr.post_id) AS revisions,
pr.user_id
FROM post_revisions pr
WHERE pr.user_id <> 1
AND pr.updated_at >= current_timestamp - interval :interval
GROUP BY pr.post_id, pr.user_id
ORDER BY revisions DESC
LIMIT :limit

-- Second Query
-- [params]
-- int :limit
SELECT
pr.post_id,
COUNT(DISTINCT pr.user_id) AS reviser_count
FROM post_revisions pr
GROUP BY pr.post_id
ORDER BY reviser_count DESC
LIMIT :limit
