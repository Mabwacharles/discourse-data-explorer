-- https://meta.discourse.org/t/43516/102?u=sidv
-- To get a list of users that excludes the members of a group, you could try something like this. This will exclude the members of the ‘staff’ group. It should be possible to rework your query to use this.

WITH group_users AS (
SELECT user_id
FROM group_users gu
JOIN groups g
ON g.id = gu.group_id
WHERE g.name = 'staff'
)

SELECT
u.id AS user_id
FROM users u
WHERE u.id NOT IN (SELECT * FROM group_users)
ORDER BY user_id
