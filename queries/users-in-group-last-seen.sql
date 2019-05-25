-- https://meta.discourse.org/t/43516/211?u=sidv
-- Users (In Specific Group) Last Seen Since N Days Ago

-- [params] 
-- int :member_group 
-- int :days_since_last_activity 
SELECT u.id                AS user_id, 
       Age(u.last_seen_at) AS last_seen, 
       g.id                AS GROUP_ID 
FROM   users u 
       join group_users gu 
         ON gu.user_id = u.id 
       join GROUPS g 
         ON g.id = gu.group_id 
WHERE  Age(u.last_seen_at) >= ( :days_since_last_activity * '1 day' :: interval ) 
       AND g.id = :member_group 
ORDER  BY u.last_seen_at
