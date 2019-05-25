-- https://meta.discourse.org/t/43516/211?u=sidv
-- Users In Specific Group(s) BUT NOT In Other Group(s)
-- Info: The Parameters have to be written as arrays. 
-- For example: {1,2,3}

-- [params]  
-- string :opt_in_groups
-- string :opt_out_groups
SELECT
   u.id AS user_id,
   g.id AS GROUP_ID 
FROM
   users u 
   join
      group_users gu 
      ON gu.user_id = u.id 
   join
      GROUPS g 
      ON g.id = gu.group_id 
WHERE
   g.id = ANY (:opt_in_groups::int[]) 
   AND u.id NOT IN 
   (
      SELECT
         u.id AS user_id 
      FROM
         users u 
         join
            group_users gu 
            ON gu.user_id = u.id 
         join
            GROUPS g 
            ON g.id = gu.group_id 
      WHERE
         g.id = ANY (:opt_out_groups::int[]) 
   )
ORDER BY
   u.primary_group_id
