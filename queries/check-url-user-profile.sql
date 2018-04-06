-- https://meta.discourse.org/t/84718/4?u=sidv

-- [params]
-- int :limit = 150
-- string :url = %term%

SELECT 
    up.user_id, u.name, up.website, u.updated_at as updated, up.location, up.views as views
FROM user_profiles up, users u
WHERE up.user_id = u.id
AND (u.admin = 'f' AND u.moderator = 'f')
AND up.website ILIKE :url
ORDER BY views desc
LIMIT :limit



-- v2: https://meta.discourse.org/t/84718/5?u=sidv
-- The order by seems to work ok for me - may need to add a disclaimer saying they need to put whatever they are looking for in between the %% where you have the term in order to return it (some people may not know SQL).

-- [params]
-- int :limit = 150

SELECT 
    up.user_id, u.name, up.website, u.updated_at as updated, up.location, up.views as views
FROM user_profiles up, users u
WHERE up.user_id = u.id
AND (u.admin = 'f' AND u.moderator = 'f')
AND up.website IS NOT NULL
ORDER BY views desc
LIMIT :limit
