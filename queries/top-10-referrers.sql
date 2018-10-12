-- https://meta.discourse.org/t/43516/149?u=sidv
-- Top 10 referrers over the last month

SELECT  COUNT(*) AS count_all, incoming_domains.name 
AS incoming_domains_name 
FROM "incoming_links" 
INNER JOIN "posts" ON "posts"."id" = "incoming_links"."post_id" 
AND ("posts"."deleted_at" IS NULL) 
INNER JOIN "topics" ON "topics"."id" = "posts"."topic_id" 
AND ("topics"."deleted_at" IS NULL) 
INNER JOIN "incoming_referers" ON "incoming_referers"."id" = "incoming_links"."incoming_referer_id" 
INNER JOIN "incoming_domains" ON "incoming_domains"."id" = "incoming_referers"."incoming_domain_id" 
WHERE (topics.archetype = 'regular') 
AND ("topics"."deleted_at" IS NULL) 
AND (incoming_links.created_at > date_trunc('month', CURRENT_DATE) - INTERVAL '30 days' 
AND incoming_links.created_at < date_trunc('month', CURRENT_DATE)) 
GROUP BY incoming_domains.name 
ORDER BY count_all DESC LIMIT 10
