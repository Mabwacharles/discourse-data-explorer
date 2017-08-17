-- https://meta.discourse.org/t/43516/19?u=sidv

-- [params]
-- int :interval = 30

select username
from users
where last_posted_at > current_timestamp - interval ':interval' day
