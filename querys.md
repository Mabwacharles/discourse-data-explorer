---
```sql
code
```
---

# List of Queries

## Fetch top 10 posts by likes received in the last month
>Fetch top 10 posts by likes received in the last month, excluding administrators. If the likes count equals, prioritize the posts that were created earlier.

```sql
SELECT p.id as post_id, p.like_count as like_count
FROM posts p
LEFT JOIN topics t ON t.id = p.topic_id
LEFT JOIN users u ON u.id = p.user_id
WHERE p.created_at >= CURRENT_DATE - INTERVAL '1 month'
  AND NOT u.admin
  AND NOT u.blocked
ORDER BY p.like_count DESC, p.created_at ASC
LIMIT 10
```
