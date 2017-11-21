-- https://meta.discourse.org/t/43516/68?u=sidv
-- Participation Histograms: Posts Created User Counts
-- Number of users who have created at least N posts over the specified time period.

-- [params]
-- int :from_days_ago = 0
-- int :duration_days = 28

with
t as (
  select 
    current_date::timestamp - ((:from_days_ago + :duration_days) * (INTERVAL '1 days')) as start,
    current_date::timestamp - (:from_days_ago * (INTERVAL '1 days')) as end
),
pc as (
  select user_id, 
      count(1) as posts_created
  from posts, t
  where created_at > t.start
  and created_at < t.end
  group by user_id
)
select
      case when posts_created >= 1 and posts_created <= 1    then '01'
          when posts_created >= 2 and posts_created <= 3   then '02 - 03'
          when posts_created >= 4 and posts_created <= 7   then '04 - 07'
          when posts_created >= 8 and posts_created <= 15  then '08 - 15'
          when posts_created >= 16 and posts_created <= 31  then '16 - 31'
          when posts_created >= 32 and posts_created <= 63  then '32 - 63'
          when posts_created >= 64 and posts_created <= 127  then '64 - 127'
          when posts_created >= 128 and posts_created <= 255  then '128 - 255'
          else '> 256'
      end as num_posts_created,
      count(*) as num_users
  from
      pc
  group by num_posts_created
  order by num_posts_created
