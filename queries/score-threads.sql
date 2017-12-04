-- Idea: https://meta.discourse.org/t/40956?u=sidv
-- Let’s build a list of topics from particular categories published in the last 7 days that had comments, sorted by popularity
-- SidV added params to the query.

-- [params]
-- int :limit
-- null string :interval = 7 days
SELECT score, t.views, t.title, u.username, t.id 
FROM topics t
LEFT JOIN categories c ON c.id = t.category_id
LEFT JOIN users u ON u.id = t.user_id
WHERE c.name IN (
    'Name 1', 'Name 2', 'Name 3'
    )
  AND t.created_at >= current_timestamp - interval :interval
  AND t.posts_count >= 2
  AND t.visible = true
  AND t.closed = false
  AND t.archived = false
  AND t.pinned_globally = false
  AND t.archetype = 'regular'
ORDER BY score DESC
LIMIT :limit
