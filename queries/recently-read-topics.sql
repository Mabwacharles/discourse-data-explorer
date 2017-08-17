-- https://meta.discourse.org/t/43516/6?u=sidv
-- Show the topics with that have been opened by a given user in the past N days, sorted by the amount of time the user has spent in that topic

-- [params]
-- integer :user = 1
-- integer :since_days_ago = 7

with topic_timing as (
  select user_id, topic_id, sum(msecs) / 1000 as seconds
  from post_timings
  where user_id = :user
  group by user_id, topic_id
)
SELECT tv.topic_id,
    tv.user_id,
    tv.viewed_at,
    tt.seconds
from topic_views tv
left join topic_timing tt
on tv.topic_id = tt.topic_id
and tv.user_id = tt.user_id
where tv.user_id = :user
and viewed_at + :since_days_ago > CURRENT_TIMESTAMP
order by seconds desc
