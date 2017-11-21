-- https://meta.discourse.org/t/43516/67?u=sidv
-- User participation

-- [params]
-- int :from_days_ago = 0
-- int :duration_days = 30

with
t as (
  select 
    CURRENT_TIMESTAMP - ((:from_days_ago + :duration_days) * (INTERVAL '1 days')) as start,
    CURRENT_TIMESTAMP - (:from_days_ago * (INTERVAL '1 days')) as end
),
pr as (
    select user_id, 
        count(1) as visits,
        sum(posts_read) as posts_read
    from user_visits, t
    where posts_read > 0
    and visited_at > t.start
    and visited_at < t.end
    group by user_id
),
pc as (
  select user_id, 
      count(1) as posts_created
  from posts, t
  where created_at > t.start
  and created_at < t.end
  group by user_id
),
ttopics as (
 select user_id, posts_count
  from topics, t
  where created_at > t.start
  and created_at < t.end
),
tc as (
  select user_id, 
      count(1) as topics_created
  from ttopics
  group by user_id
),
twr as (
  select user_id, 
      count(1) as topics_with_replies
  from ttopics
  where posts_count > 1
  group by user_id
),
tv as (
 select user_id, 
        count(distinct(topic_id)) as topics_viewed
  from topic_views, t
  where viewed_at > t.start
  and viewed_at < t.end
  group by user_id
),
likes as (
  select 
      post_actions.user_id as given_by_user_id, 
      posts.user_id as received_by_user_id
  from t, post_actions
  left join posts
  on post_actions.post_id = posts.id
  where post_actions.created_at > t.start
  and post_actions.created_at < t.end
  and post_action_type_id = 2

),
lg as (
  select given_by_user_id as user_id, 
      count(1) as likes_given
  from likes
  group by user_id
),
lr as (
  select received_by_user_id as user_id, 
      count(1) as likes_received
  from likes
  group by user_id
),
e as (
  select email, user_id
  from user_emails u
  where u.primary = true
)
select pr.user_id,
       username,
       name,
       email,
       visits, 
       coalesce(topics_viewed,0) as topics_viewed,
       coalesce(posts_read,0) as posts_read, 
       coalesce(posts_created,0) as posts_created,
       coalesce(topics_created,0) as topics_created,
       coalesce(topics_with_replies,0) as topics_with_replies,
       coalesce(likes_given,0) as likes_given,
       coalesce(likes_received,0) as likes_received
from pr
left join tv using (user_id)
left join pc using (user_id)
left join tc using (user_id)
left join twr using (user_id)
left join lg using (user_id)
left join lr using (user_id)
left join e using (user_id)
left join users on pr.user_id = users.id
order by 
  visits desc, 
  posts_read desc, 
  posts_created desc
