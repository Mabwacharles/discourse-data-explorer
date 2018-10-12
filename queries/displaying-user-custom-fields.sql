-- https://meta.discourse.org/t/76648/4?u=sidv
-- It’ll require a little bit of modification to your exact setup. Add or remove the series of 5 lines which look like this:
-- MAX(CASE ucf.name WHEN 'user_field_1' THEN value END) AS first_field
-- to your exact number of custom fields (if you need more than 5, then add a line with user_field_6, user_field_7, etc.). 
-- You can also change first_field/second_field/etc. to a more descriptive name of what the field contains.
-- 

-- [params]
-- date :date_from = 1970-01-01
-- date :date_to = 2038-01-19
-- boolean :guess_domain = true
-- string :domain = https://example.com
WITH ss AS (
  SELECT CASE
    WHEN :guess_domain = true THEN concat('https://', split_part(value, '@', 2))
    ELSE :domain
  END AS domain
  FROM site_settings
  WHERE name = 'notification_email'
), cfs AS (
  SELECT
    u.id AS user_id,
    MAX(CASE ucf.name WHEN 'user_field_1' THEN value END) AS first_field,
    MAX(CASE ucf.name WHEN 'user_field_2' THEN value END) AS second_field,
    MAX(CASE ucf.name WHEN 'user_field_3' THEN value END) AS third_field,
    MAX(CASE ucf.name WHEN 'user_field_4' THEN value END) AS fourth_field,
    MAX(CASE ucf.name WHEN 'user_field_5' THEN value END) AS fifth_field
  FROM user_custom_fields AS ucf
  RIGHT JOIN users AS U on ucf.user_id = u.id
  GROUP BY u.id
)
SELECT
  ua.created_at,
  CASE
    WHEN ua.action_type = 1 THEN 'Like'
    WHEN ua.action_type = 4 THEN 'New Topic'
    WHEN ua.action_type = 5 THEN 'Topic Reply'
    WHEN ua.action_type = 12 THEN 'Message'
  END AS action,
  u.username,
  ucf.*,
  t.title AS topic_title,
  c.name AS category,
  pc.name AS parent_category,
  concat((SELECT domain from ss), '/t/', t.id, '/', (CASE WHEN p.post_number IS NOT NULL then p.post_number ELSE 1 END)) AS url
FROM user_actions AS ua
JOIN users AS u ON ua.user_id = u.id
LEFT JOIN cfs AS ucf on ucf.user_id = u.id
JOIN topics AS t ON ua.target_topic_id = t.id
LEFT JOIN posts AS p ON ua.target_post_id = p.id
LEFT JOIN categories AS c ON t.category_id = c.id
LEFT JOIN categories AS pc ON c.parent_category_id = pc.id
WHERE
  ua.user_id != -1
  AND
  ua.action_type IN (1, 4, 5, 12)
  AND
  ua.created_at BETWEEN :date_from AND :date_to
ORDER BY created_at DESC
