-- https://meta.discourse.org/t/43516/2?u=sidv

WITH all_users AS ( SELECT
  COUNT(users.id) AS user_count
  FROM users
  WHERE users.active 
  AND users.suspended_at IS NULL
  AND users.locale IS NOT NULL
)
, read_banner_topic AS ( SELECT 
  COUNT(topic_views.user_id) AS read_count
  FROM topic_views  
  WHERE topic_views.topic_id IN (
    SELECT topics.id 
    FROM topics 
    WHERE topics.archetype IS NOT NULL
    AND topics.archetype LIKE 'banner'
  )
  AND topic_views.user_id IS NOT NULL
)
, dismissed_banner AS ( SELECT 
  COUNT(user_profiles.user_id) AS dismissed_count
  FROM user_profiles
  WHERE user_profiles.dismissed_banner_key IS NOT NULL 
  AND user_profiles.dismissed_banner_key IN (
    SELECT topics.id 
    FROM topics 
    WHERE topics.archetype IS NOT NULL
    AND topics.archetype LIKE 'banner'
  )
  AND user_profiles.user_id IS NOT NULL
)
SELECT all_users.user_count
  , read_banner_topic.read_count
  , dismissed_banner.dismissed_count 
FROM all_users, read_banner_topic, dismissed_banner
