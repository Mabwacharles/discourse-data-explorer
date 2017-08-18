-- https://meta.discourse.org/t/54429/7?u=sidv

--[params]
-- string :user_name = eviltrout
-- int :results_limit = 60

WITH us AS ( SELECT user_stats.user_id 
        , user_stats.likes_received AS us_lr 
        , user_stats.likes_given AS us_lg 
        , user_stats.topics_entered AS us_te 
        , user_stats.topic_count AS us_tc 
        , user_stats.post_count AS us_pc 
        , user_stats.days_visited AS us_dv 
        , user_stats.posts_read_count AS us_pr
      FROM user_stats 
      )
, di AS ( SELECT directory_items.user_id 
        , directory_items.likes_received AS di_lr 
        , directory_items.likes_given AS di_lg 
        , directory_items.topics_entered AS di_te 
        , directory_items.topic_count AS di_tc 
        , directory_items.post_count AS di_pc 
        , directory_items.days_visited AS di_dv 
        , directory_items.posts_read AS di_pr
        , directory_items.period_type AS di_pt 
      FROM directory_items 
      )
, u AS ( SELECT users.id
        , users.username AS u_u 
        , users.last_seen_at AS u_ls 
      FROM users 
      )
SELECT 
    us.user_id 
    , us.us_lr 
    , di.di_lr 
    , us.us_lg 
    , di.di_lg 
    , us.us_te 
    , di.di_te 
    , us.us_tc 
    , di.di_tc 
    , us.us_pc 
    , di.di_pc 
    , us.us_dv 
    , di.di_dv 
    , us.us_pr 
    , di.di_pr 
    , CASE WHEN di.di_pt = 1 THEN CURRENT_DATE - interval '1000 days' 
           WHEN di.di_pt = 2 THEN CURRENT_DATE - interval '365 days' 
           WHEN di.di_pt = 3 THEN CURRENT_DATE - interval '30 days' 
           WHEN di.di_pt = 4 THEN CURRENT_DATE - interval '7 days' 
           WHEN di.di_pt = 5 THEN CURRENT_DATE - interval '1 day' 
           WHEN di.di_pt = 6 THEN CURRENT_DATE - interval '90 days' 
           ELSE CURRENT_DATE END AS di_di_pt 
    , CASE WHEN (CASE WHEN di.di_pt = 1 THEN CURRENT_DATE - interval '1000 days' 
                WHEN di.di_pt = 2 THEN CURRENT_DATE - interval '365 days' 
                WHEN di.di_pt = 3 THEN CURRENT_DATE - interval '30 days' 
                WHEN di.di_pt = 4 THEN CURRENT_DATE - interval '7 days' 
                WHEN di.di_pt = 5 THEN CURRENT_DATE - interval '1 day' 
                WHEN di.di_pt = 6 THEN CURRENT_DATE - interval '90 days' 
                ELSE CURRENT_DATE END) < u.u_ls THEN '<' 
           WHEN (CASE WHEN di.di_pt = 1 THEN CURRENT_DATE - interval '1000 days' 
                WHEN di.di_pt = 2 THEN CURRENT_DATE - interval '365 days' 
                WHEN di.di_pt = 3 THEN CURRENT_DATE - interval '30 days' 
                WHEN di.di_pt = 4 THEN CURRENT_DATE - interval '7 days' 
                WHEN di.di_pt = 5 THEN CURRENT_DATE - interval '1 day' 
                WHEN di.di_pt = 6 THEN CURRENT_DATE - interval '90 days' 
                ELSE CURRENT_DATE END) > u.u_ls THEN '>' 
           ELSE '=' END AS di_u 
    , date_trunc('day', u.u_ls) AS u_u_ls 
FROM us, di, u  
WHERE u.u_u ILIKE CONCAT('%', :user_name, '%') 
AND di.user_id = us.user_id 
AND u.id = di.user_id 
ORDER BY us.user_id, di_di_pt 
LIMIT :results_limit
