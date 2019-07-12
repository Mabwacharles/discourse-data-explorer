--
-- Users who’ve become active
-- Calculate what % of users, who joined within a certain timeframe, 
-- have posted X times, within a certain timeframe

-- [params]
-- date :user_date_from = 01.06.2019
-- date :user_date_to = 30.06.2019
-- date :post_date_from = 01.06.2019
-- date :post_date_to = 30.06.2019
-- int  :min_posts = 1


WITH user_activity AS (
    SELECT p.user_id, COUNT(p.id) as posts_count
    FROM posts p
	LEFT JOIN users u ON u.id = p.user_id
    LEFT JOIN topics t ON t.id = p.topic_id
    WHERE u.created_at::date BETWEEN :user_date_from::date AND :user_date_to::date
	  AND p.created_at::date BETWEEN :post_date_from::date AND :post_date_to::date
      AND p.deleted_at IS NULL
	  AND t.deleted_at IS NULL
      AND t.visible = TRUE
      AND t.closed = FALSE
      AND t.archived = FALSE
      AND t.archetype = 'regular'
        
    GROUP BY p.user_id
)

SELECT (t1.new_users_with_posts::float) / (t2.new_users::float) * 100 as percent_users_with_posts

FROM ( SELECT COUNT(user_id) as new_users_with_posts
       FROM user_activity
       WHERE posts_count >= :min_posts )
       as t1 
cross join
     ( SELECT COUNT(id) as new_users
       FROM users u
       WHERE u.created_at::date BETWEEN :user_date_from::date AND :user_date_to::date )
       as t2
