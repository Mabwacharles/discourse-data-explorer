-- https://meta.discourse.org/t/43516/153?u=sidv
-- List of usernames with tag name

-- [params]
-- text :tag_name
SELECT tp.user_id, COUNT(tt.tag_id)
FROM topic_tags tt
INNER JOIN tags t ON t.id = tt.tag_id
INNER JOIN topics tp ON tp.id = tt.topic_id
WHERE t.name = :tag_name
GROUP BY tp.user_id, tt.tag_id
