-- https://meta.discourse.org/t/42560/7?u=sidv
-- WARNING: You might want to look further down this thread to see if anybody has sanity checked the query.
-- Please view the source to know how it works!

-- [params]
-- string :impersonate = system
-- string :exclude_groups_topics = staff
-- string :exclude_groups_replies = ,
-- string :exclude_category_slugs = staff,dev,simply-thank-you,was-it-you,wanted
-- int :reply_within_x_days = -1
-- int :pct_multiplier = 100
-- int :pct_places = 1



WITH
year_months AS (
  SELECT
    to_char(date(day),'YYYY-MM') as year_month
  FROM
    generate_series(
      (date_trunc('month', CURRENT_DATE) - INTERVAL '1 year' ),
      CURRENT_DATE,
      interval '1 month'
    ) AS day
),
impersonated_usernames AS (
 SELECT unnest(string_to_array( :impersonate, ',')) AS username
),
impersonated_users AS (
 SELECT id
    FROM users AS u
    JOIN impersonated_usernames iun ON iun.username = u.username
    WHERE iun.username = u.username
),
excluded_group_names_topics AS (
 SELECT unnest(string_to_array( :exclude_groups_topics, ',')) AS name
),
excluded_group_names_replies AS (
 SELECT unnest(string_to_array( :exclude_groups_replies, ',')) AS name
),
excluded_users_topics AS (
    SELECT user_id AS id
    FROM users AS u
    JOIN group_users AS gu ON gu.user_id = u.id
    JOIN groups AS g ON g.id = gu.group_id
    JOIN excluded_group_names_topics eg ON eg.name = g.name
    WHERE g.name = eg.name
),
excluded_users_replies AS (
    SELECT user_id AS id
    FROM users AS u
    JOIN group_users AS gu ON gu.user_id = u.id
    JOIN groups AS g ON g.id = gu.group_id
    JOIN excluded_group_names_replies eg ON eg.name = g.name
    WHERE g.name = eg.name
),
excluded_category_slugs AS (
 SELECT unnest(string_to_array( :exclude_category_slugs, ',')) AS slug
),
excluded_categories AS (
    SELECT id
    FROM categories AS c
    JOIN excluded_category_slugs ec ON ec.slug = c.slug
    WHERE ec.slug = c.slug
),
restricted_topics AS (
  SELECT
    t.id,
    t.created_at,
    t.user_id
  FROM
    topics AS t
  JOIN users u on u.id IN (SELECT id FROM impersonated_users)
  JOIN user_stats AS us ON us.user_id = u.id
  JOIN user_options AS uo ON uo.user_id = u.id
  JOIN categories c ON c.id = t.category_id
  LEFT JOIN topic_users tu ON tu.topic_id = t.id AND tu.user_id = u.id
  WHERE
    u.id IN (SELECT id FROM impersonated_users)
    /** test **
    AND t.created_at > (date_trunc('day', CURRENT_DATE) - INTERVAL '1 day' )
    AND t.created_at < (date_trunc('day', CURRENT_DATE) )
    ** test **/
    AND t.created_at > (date_trunc('month', CURRENT_DATE) - INTERVAL '1 year' )
    AND t.archetype <> 'private_message'
    AND t.deleted_at IS NULL
    AND (t.visible OR u.admin OR u.moderator)
    AND (
      NOT c.read_restricted OR u.admin OR category_id IN (
        SELECT c2.id FROM categories c2
        JOIN category_groups cg ON cg.category_id = c2.id
        JOIN group_users gu ON gu.user_id IN (SELECT id FROM impersonated_users)
          AND cg.group_id = gu.group_id
        WHERE c2.read_restricted
      )
    )
    AND t.user_id NOT IN (SELECT id FROM excluded_users_topics)
    AND t.category_id NOT IN (SELECT id from excluded_categories)
),
restricted_posts AS (
  SELECT
    p.id,
    p.created_at
  FROM
    posts AS p
  LEFT JOIN topics AS t ON p.topic_id = t.id
  JOIN users u on u.id IN (SELECT id FROM impersonated_users)
  JOIN user_stats AS us ON us.user_id = u.id
  JOIN user_options AS uo ON uo.user_id = u.id
  JOIN categories c ON c.id = t.category_id
  LEFT JOIN topic_users tu ON tu.topic_id = t.id AND tu.user_id = u.id
  WHERE
    u.id IN (SELECT id FROM impersonated_users)
    /** test **
    AND p.created_at > (date_trunc('day', CURRENT_DATE) - INTERVAL '1 day' )
    AND p.created_at < (date_trunc('day', CURRENT_DATE) )
    ** test **/
    AND p.created_at > (date_trunc('month', CURRENT_DATE) - INTERVAL '1 year' )
    AND t.archetype <> 'private_message'
    AND t.deleted_at IS NULL
    AND (t.visible OR u.admin OR u.moderator)
    AND (
      NOT c.read_restricted OR u.admin OR category_id IN (
        SELECT c2.id FROM categories c2
        JOIN category_groups cg ON cg.category_id = c2.id
        JOIN group_users gu ON gu.user_id IN (SELECT id FROM impersonated_users)
          AND cg.group_id = gu.group_id
        WHERE c2.read_restricted
      )
    )
    AND t.user_id NOT IN (SELECT id FROM excluded_users_topics)
    AND t.category_id NOT IN (SELECT id from excluded_categories)
),
qualifying_topics AS (
  SELECT
    rt.id,
    rt.created_at::date AS created_at,
    MIN(p.post_number) AS first_reply,
    COUNT(p) AS new_topic_posts
  FROM
    restricted_topics AS rt
  LEFT JOIN posts p ON
    p.topic_id = rt.id
    AND p.deleted_at IS NULL
    AND p.user_id != rt.user_id
    AND p.user_id NOT IN (SELECT id FROM excluded_users_replies)
    AND (
      ( :reply_within_x_days >= 0
        AND p.created_at < ( rt.created_at::date + ( :reply_within_x_days + 1 ) )
      )
      OR
      (
       :reply_within_x_days < 0
        AND to_char(date(p.created_at),'YYYY-MM') = to_char(date(rt.created_at),'YYYY-MM')
      )
    )
  WHERE
    rt.created_at > (date_trunc('month', CURRENT_DATE) - INTERVAL '1 year' )
  GROUP BY rt.id, rt.created_at
),
topic_year_month_rate AS (
    SELECT
        to_char(date(tt.created_at),'YYYY-MM') as year_month,
        COUNT(*) AS topics,
        SUM(new_topic_posts) AS new_topic_posts,
        SUM(CASE WHEN tt.first_reply IS NULL THEN 1 ELSE 0 END) AS no_response,
        SUM(CASE WHEN tt.first_reply IS NOT NULL THEN 1 ELSE 0 END) AS response
    FROM qualifying_topics AS tt
    GROUP BY
      year_month
    ORDER BY
      year_month
),
posts_year_month_rate AS (
    SELECT
        to_char(date(rp.created_at),'YYYY-MM') as year_month,
        COUNT(*) as posts
    FROM restricted_posts as rp
    GROUP BY
      year_month
    ORDER BY
      year_month
),
raw_year_month_rate AS (
  SELECT
    year_month,
    SUM(posts) AS posts,
    SUM(new_topic_posts) AS new_topic_posts,
    (SUM(posts) - SUM(new_topic_posts)) AS old_topic_posts,
    SUM(topics) AS topics,
    SUM(no_response) AS no_response,
    SUM(response) AS response
  FROM (
    SELECT year_month, topics, 0 AS posts, new_topic_posts, 0 AS old_topic_posts, no_response, response FROM topic_year_month_rate
    UNION ALL
    SELECT year_month, 0 AS topics, posts, 0 AS new_topic_posts, 0 AS old_topic_posts, 0 AS no_response, 0 AS response FROM posts_year_month_rate
  ) AS combined
  GROUP BY year_month
  ORDER BY year_month
),
year_month_rate AS (
    SELECT
      rymr.*,
      (CASE
        WHEN topics <= 0 THEN 0
        ELSE (
         ROUND( (:pct_multiplier + 0.0) * (
           (response * 1.0) / (topics * 1.0) 
          ), :pct_places)
        ) END
      ) AS response_rate
    FROM 
      raw_year_month_rate rymr
)

SELECT
 *
FROM
 year_months AS d
LEFT JOIN (
  SELECT * FROM year_month_rate
) AS t USING (year_month)
ORDER BY
  year_month
