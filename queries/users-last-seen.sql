-- https://meta.discourse.org/t/43516?u=sidv

with intervals as (
    select
        n as start_time, 
        CURRENT_TIMESTAMP as end_time
    from generate_series(CURRENT_TIMESTAMP - INTERVAL '140 days',
                         CURRENT_TIMESTAMP - INTERVAL '7 days',
                         INTERVAL '7 days') n
)
select 
  COUNT(1) as users_seen_since,
  CURRENT_TIMESTAMP - i.start_time as time_ago
FROM USERS u
right join intervals i
on u.last_seen_at >= i.start_time and u.last_seen_at < i.end_time
group by i.start_time, i.end_time
order by i.start_time desc
