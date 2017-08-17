-- https://meta.discourse.org/t/43516/3?u=sidv
-- Active Readers (Past Month)
-- Users with the most visits that include reading activity

select user_id, 
    count(1) as visits,
    sum(posts_read) as posts_read
from user_visits
where posts_read > 0
and visited_at > CURRENT_TIMESTAMP - INTERVAL '30 days'
group by user_id
order by visits desc, posts_read desc

-- Active Readers (Since N Days Ago)
-- Number of users who have read at least 1 post since N days ago

with intervals as (
    select
        n as start_time, 
        CURRENT_TIMESTAMP as end_time
    from generate_series(CURRENT_TIMESTAMP - INTERVAL '30 days',
                         CURRENT_TIMESTAMP - INTERVAL '1 day',
                         INTERVAL '1 days') n
),
latest_visits as (
    select 
        user_id, 
        max(visited_at) as visited_at
    from user_visits
    where posts_read > 0
    group by user_id
)
select 
  COUNT(1) as active_readers_since,
  CURRENT_TIMESTAMP - i.start_time as time_ago
FROM users u
left join latest_visits v
on u.id = v.user_id
right join intervals i
on v.visited_at >= i.start_time and v.visited_at < i.end_time
group by i.start_time, i.end_time
order by i.start_time desc
