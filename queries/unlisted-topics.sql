-- https://meta.discourse.org/t/75545?u=sidv
-- List for invisible topics

-- [params]
-- int :limit
SELECT t.id, t.user_id, t.title, t.views
FROM topics t
WHERE t.visible = false
ORDER BY t.id desc
LIMIT :limit
-- /latest?status=unlisted
