-- https://meta.discourse.org/t/43516/3?u=sidv
-- Total number of new posts read by all users per day

SELECT visited_at as day,
count(1) as users,
sum(posts_read) as posts_read,
sum(posts_read) / count(1) as avg_posts_read_per_user
FROM user_visits 
group by visited_at
order by visited_at desc
