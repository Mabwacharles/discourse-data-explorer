-- https://meta.discourse.org/t/75040/3?u=sidv
-- Tracking Referrals

-- [params]
-- int :limit
-- null string :interval = 91 days
select user_id, 
    invited_by_id
from invites
where created_at > CURRENT_TIMESTAMP - INTERVAL :interval
and user_id > 1
limit :limit

--v2

-- [params]
-- int :limit
-- null string :interval = 91 days
select i.user_id, 
    u.username as "Invitado por",
    i.created_at,
    i.deleted_at
from invites i, users u
where u.id = i.invited_by_id
and i.created_at > CURRENT_TIMESTAMP - INTERVAL :interval
and i.user_id > 1
order by i.created_at desc
limit :limit
