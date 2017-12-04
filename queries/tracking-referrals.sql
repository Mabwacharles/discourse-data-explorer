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
