-- https://meta.discourse.org/t/68397/6?u=sidv
-- 

SELECT u.id as user_id, cf.value
FROM users u
LEFT JOIN user_custom_fields cf 
ON (cf.user_id = u.id and cf.name like 'user_field_1')
WHERE cf.value IS DISTINCT FROM 'true'
