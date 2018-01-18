-- https://meta.discourse.org/t/43516/71?u=sidv
-- List of all new users within the past week and month: For Copy & Paste
-- SidV added params

-- [params]
-- null string :interval = 1 week
-- int :limit
select concat ('@', username)
from users
where created_at >= CURRENT_DATE - INTERVAL :interval
order by created_at desc 
limit :limit
