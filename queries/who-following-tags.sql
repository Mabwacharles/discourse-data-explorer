-- https://meta.discourse.org/t/2?u=sidv

SELECT 
    name, 
    user_id, 
    notification_level 
FROM tag_users tu 
    JOIN tags t ON tu.tag_id = t.id
    
