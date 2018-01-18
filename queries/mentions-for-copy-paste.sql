-- https://meta.discourse.org/t/43516/71?u=sidv
-- List of all new users within the past week and month: For Copy & Paste
-- Hi, can anyone provide a data explorer query that provides a list of all new users within the past week and month? It’d be ideal if the format was so they were already @mentioned, making it easy to copy-paste it into a new post that welcomes these new members to the community.
-- SidV added params

-- [params]
-- null :interval = '1 week'
-- int :limit = 10
select concat ('@', username)
from users
where created_at >= CURRENT_DATE - INTERVAL :interval
order by created_at desc 
limit :limit
