-- https://meta.discourse.org/t/43516/169?u=sidv
-- Number of active users per login method
-- Facebook vs Twitter vs Google vs Github

WITH target_user_ids AS (
SELECT
id
FROM users
WHERE staged = false
AND active = true
AND last_seen_at IS NOT NULL
)

SELECT (
       SELECT Count(DISTINCT user_id)
       FROM   google_user_infos
       WHERE user_id IN(SELECT id FROM target_user_ids)) AS google,
       (
       SELECT Count(DISTINCT user_id)
       FROM user_associated_accounts
       WHERE provider_name = 'facebook'
       AND user_id IN(SELECT id FROM target_user_ids)) AS facebook,
       (
       SELECT Count(DISTINCT user_id)
       FROM   github_user_infos
       WHERE user_id IN(SELECT id FROM target_user_ids)) AS github,
       (
       SELECT Count(DISTINCT user_id)
       FROM user_associated_accounts
       WHERE provider_name = 'twitter'
       AND user_id IN(SELECT id FROM target_user_ids)) AS twitter
