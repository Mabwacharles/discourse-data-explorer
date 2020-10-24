-- v3 source: https://meta.discourse.org/t/168098/3?u=sidv
-- From v1 but: How can I filter a specific badge?
-- v1 source: https://meta.discourse.org/t/43516/159?u=sidv

-- [params]
-- int :posts = 1
-- int :top = 10
-- string :badge_name = all badges

SELECT
username,
COUNT(ub.id) as badge_count
FROM user_badges ub
JOIN users u ON u.id = ub.user_id
JOIN user_stats us
ON us.user_id = ub.user_id
JOIN badges b ON b.id = ub.badge_id
WHERE us.post_count > :posts
AND (u.admin = 'f' AND u.moderator = 'f')
AND CASE
        WHEN 'all badges' = :badge_name
            THEN true
        ELSE b.name = :badge_name
    END
GROUP BY u.username
ORDER BY badge_count DESC
