-- https://meta.discourse.org/t/120808/4?u=sidv
-- I was wondering how you calculate the time to first response in your reports.


-- [params]
-- int :limit = 50
SELECT t.id AS topic_id, AVG(t.hours)::float AS hours, t.created_at
FROM (
  SELECT t.id, t.created_at::date AS created_at, EXTRACT(EPOCH FROM MIN(p.created_at) - t.created_at)::float / 3600.0 AS hours
  FROM topics t
  LEFT JOIN posts p ON p.topic_id = t.id
  WHERE t.archetype = 'regular'
  AND t.deleted_at IS NULL
  AND p.deleted_at IS NULL
  AND p.post_number > 1
  AND p.user_id != t.user_id
  AND p.post_type = 1
  GROUP BY t.id
) t
GROUP BY t.created_at, t.id
ORDER BY hours DESC
LIMIT :limit
