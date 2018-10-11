-- https://meta.discourse.org/t/43516/148?u=sidv
-- Latest uploads with urls
-- v1

SELECT 
    id, 
    user_id, 
    original_filename,
    created_at,
    url,
    extension
FROM uploads
order by created_at desc
LIMIT 50

--
-- v2

-- [params]
-- int :limit = 50
SELECT 
    id, 
    user_id, 
    original_filename,
    created_at,
    url,
    extension
FROM uploads
order by created_at desc
LIMIT :limit
