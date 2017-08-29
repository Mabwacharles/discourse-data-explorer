-- https://meta.discourse.org/t/68972/4?u=sidv

SELECT id, title, user, category_id  FROM topics 
WHERE pinned_at IS NOT NULL AND pinned_globally = TRUE
