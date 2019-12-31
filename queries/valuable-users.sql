-- https://meta.discourse.org/t/43516/254?u=sidv
-- Most valuable users in the given/chosen period of time
-- You can use this one to pull daily, weekly, or total stats by user over a specified time range.

-- coverage: 'week', 'all', or 'date'
-- [params]
-- date :start_date = 2019-08-27
-- date :end_date = 2019-09-30
-- text :coverage = week

WITH date_range AS (
SELECT date_trunc('day', dd):: date AS "date", EXTRACT(week from date_trunc('day', dd):: date) AS "week"
FROM generate_series
        ( :start_date::timestamp 
        , :end_date::timestamp
        , '1 day'::interval) dd
), likes_given AS (
SELECT u.id, dr.date, dr.week, count(pa.*) AS "likes"
FROM date_range dr
FULL JOIN users u ON (1=1)
LEFT JOIN post_actions pa ON (pa.created_at:: date = dr.date and post_action_type_id=2 AND user_id = u.id)
GROUP BY dr.date, dr.week, u.id
ORDER BY u.id, dr.date
), posts_summary AS (SELECT u.id, u.username, u.created_at, dr.*, count(p.id) - count(t.id) AS replies, count(t.id) AS topics, COALESCE(sum(p.like_count),0) AS likes_received
from date_range dr
FULL OUTER JOIN users u ON (1=1)
LEFT JOIN posts p ON (p.user_id = u.id AND p.created_at::date=dr.date AND p.deleted_at IS NULL)
LEFT JOIN topics t ON (t.user_id = u.id AND t.created_at::date = dr.date AND p.topic_id = t.id AND t.deleted_at IS NULL)
GROUP BY u.id, dr.date, dr.week
ORDER BY u.id, dr.date), 
visits AS (SELECT u.id, dr.*, COALESCE(sum(posts_read),0) AS posts_read, COALESCE(sum(time_read),0) AS time_read, COUNT(uv.*) AS visits
FROM date_range dr
FULL OUTER JOIN users u ON (1=1)
LEFT JOIN user_visits uv ON (uv.user_id = u.id AND visited_at = dr.date)
GROUP BY u.id, dr.date, dr.week
ORDER BY u.id, dr.date
)

SELECT ps.id, ps.username, ps.created_at, CASE
WHEN :coverage::text = 'week' THEN ps.week::text
WHEN :coverage::text = 'all' THEN '-1'
ELSE ps.date::text
END  AS period, sum(ps.replies) AS replies, sum(ps.topics) AS topics, sum(ps.likes_received) AS likes_received, sum(lg.likes) AS likes_given, COALESCE(sum(posts_read),0) AS posts_read, COALESCE(sum(time_read),0) AS time_read, SUM(visits) AS visits
FROM posts_summary ps
LEFT JOIN likes_given lg ON (ps.date = lg.date AND ps.id = lg.id)
LEFT JOIN visits v ON (v.id = ps.id AND v.date = ps.date)
GROUP BY ps.id, ps.username, ps.created_at, CASE 
WHEN :coverage::text = 'week' THEN ps.week::text
WHEN :coverage::text = 'all' THEN '-1'
ELSE ps.date::text
END  
ORDER BY ps.id, CASE
WHEN :coverage::text = 'week' THEN ps.week::text
WHEN :coverage::text = 'all' THEN '-1'
ELSE ps.date::text
END
