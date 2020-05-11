-- https://meta.discourse.org/t/43516/279?u=sidv
-- some of stats from the admin report dashboard — but I’ve found them helpful to provide access to non-admin users

SELECT
    a.date,
    a.users,
    b.posts,
    c.topics,
    d.likes,
    e.pageviews
FROM
(
-- /admin/reports/signups
SELECT DATE(u.created_at), count(*) as users
  from users as u
    group by DATE(u.created_at)
) as a
LEFT JOIN
(
-- /admin/reports/posts
SELECT DATE(p.created_at), count(*) as posts
  from posts as p
  join topics as t on t.id = p.topic_id
    where p.deleted_at is null and
          p.post_type = 1 and
          t.archetype <> 'private_message'
    group by DATE(p.created_at)
) as b on a.date = b.date
LEFT JOIN
(
-- /admin/reports/topics
SELECT DATE(t.created_at), count(*) as topics
  from topics as t
    where t.archetype <> 'private_message' and
          t.deleted_at is null
    group by DATE(t.created_at)
) as c on a.date = c.date
LEFT JOIN
(
-- /admin/reports/likes
SELECT DATE(pa.created_at), count(*) as likes
  from post_actions as pa
    where pa.post_action_type_id = 2
    group by DATE(pa.created_at)
) as d on a.date = d.date
LEFT JOIN
(
-- /admin/reports/page_view_total_reqs
SELECT t.date, sum(t.count) as pageviews
  from application_requests as t
    where  t.req_type = 6 -- crawlers
        or t.req_type = 7 -- logged in
        or t.req_type = 8 -- anonymous
    group by t.date
) as e on a.date = e.date
order by date desc
