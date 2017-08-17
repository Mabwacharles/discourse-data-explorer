-- https://meta.discourse.org/t/43516/5?u=sidv 
-- This query assumes there is a group called team, and gives you the likes other users have received, split into likes from the team and likes from others

SELECT
    pl.user_id,
    SUM(pl.team_likes) as team_likes,
    SUM(pl.student_likes) as student_likes,
    SUM(pl.team_likes + pl.student_likes) as likes
FROM (
    SELECT -- count likes per post
        p.id as post_id_workaround,
        p.user_id as user_id,
        (
            SELECT count(*)
            FROM post_actions pa
            WHERE
                pa.post_id = p.id
                AND post_action_type_id = (
                            SELECT id FROM post_action_types WHERE name_key = 'like'
                )
                AND pa.user_id IN (
                    SELECT gu.user_id
                    FROM group_users gu
                    WHERE gu.group_id = ( SELECT id FROM groups WHERE name ilike 'team' ) 
                )
        ) as team_likes,
        (
            SELECT count(*)
            FROM post_actions pa
            WHERE
                pa.post_id = p.id
                AND post_action_type_id = (
                            SELECT id FROM post_action_types WHERE name_key = 'like'
                )
                AND pa.user_id NOT IN (
                    SELECT gu.user_id
                    FROM group_users gu
                    WHERE gu.group_id = ( SELECT id FROM groups WHERE name ilike 'team' ) 
                )
        ) as student_likes
    FROM badge_posts p
) AS pl
WHERE pl.user_id NOT IN (
    SELECT gu.user_id
    FROM group_users gu
    WHERE gu.group_id = ( SELECT id FROM groups WHERE name ilike 'team' ) 
)
GROUP BY pl.user_id
ORDER BY likes DESC
