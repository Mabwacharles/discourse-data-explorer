--[params]
-- int :limit = 50
-- string :topics_id = {100,200}
select u.email, u.user_id, t.id, t.title
from user_emails u, topics t
WHERE t.user_id = u.user_id
AND u.primary = true
AND t.id = ANY (:topics_id::int[])
ORDER BY t.id asc
LIMIT :limit
