-- https://meta.discourse.org/t/43516/3?u=sidv
-- Users with the most visits that include reading activity

select user_id, 
    count(1) as visits,
    sum(posts_read) as posts_read
from user_visits
where posts_read > 0
and visited_at > CURRENT_TIMESTAMP - INTERVAL '30 days'
group by user_id
order by visits desc, posts_read desc
