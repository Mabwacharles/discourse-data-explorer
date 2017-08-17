-- https://meta.discourse.org/t/43516/3?u=sidv
-- Number of posts read for users in each percentile

with tentiles as (
    select posts_read_count as read, 
    ntile(10) 
    over (order by posts_read_count) as tentile 
    from user_stats
)
select (tentile - 1) * 10 as percentile,
    min(read) as min_posts_read, 
    max(read) as max_posts_read
from tentiles
group by tentile
order by tentile desc
