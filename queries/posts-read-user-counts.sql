-- https://meta.discourse.org/t/43516/68?u=sidv
-- Participation Histograms: Posts Read User Counts
-- Number of users who have read at least N posts over the specified time period.

-- [params]
-- int :from_days_ago = 0
-- int :duration_days = 28

with
t as (
  select 
    current_date::timestamp - ((:from_days_ago + :duration_days) * (INTERVAL '1 days')) as start,
    current_date::timestamp - (:from_days_ago * (INTERVAL '1 days')) as end
),
read_visits as (
    select user_id, 
        count(1) as visits,
        sum(posts_read) as posts_read
    from user_visits, t
    where posts_read >= 1
    and visited_at > t.start
    and visited_at < t.end
    group by user_id
)
select
      case when posts_read >= 1 and posts_read <= 1    then '0001'
          when posts_read >= 2 and posts_read <= 3   then '0002 - 03'
          when posts_read >= 4 and posts_read <= 7   then '0004 - 07'
          when posts_read >= 8 and posts_read <= 15  then '0008 - 15'
          when posts_read >= 16 and posts_read <= 40  then '0016 - 31'
          when posts_read >= 32 and posts_read <= 63  then '0032 - 63'
          when posts_read >= 64 and posts_read <= 127  then '0064 - 127'
          when posts_read >= 128 and posts_read <= 255  then '0128 - 255'
          when posts_read >= 256 and posts_read <= 511  then '0256 - 511'
          when posts_read >= 512 and posts_read <= 1023  then '0512 - 1023'
          when posts_read >= 1024 and posts_read <= 2047  then '1024 - 2047'
          else '>= 2048'
      end as num_posts_read,
      count(*) as num_users
  from
      read_visits
  group by num_posts_read
  order by num_posts_read
