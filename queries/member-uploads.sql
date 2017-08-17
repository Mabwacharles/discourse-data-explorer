-- https://meta.discourse.org/t/43516/14?u=sidv
-- I put together this query to help find members that post a lot of uploads that potentially might lead to a problem.

WITH heavy_uploads AS ( SELECT 
    ( SUM(uploads.filesize) / 1024) AS sum_kb
  , COUNT(uploads.filesize) AS upload_count
  , ( (SUM(uploads.filesize) / COUNT(uploads.filesize)) / 1024) AS avg_weight_kb
  , uploads.user_id 
  FROM uploads
  GROUP BY uploads.user_id
)
SELECT heavy_uploads.sum_kb
 , heavy_uploads.upload_count
 , heavy_uploads.avg_weight_kb
 , heavy_uploads.user_id
FROM heavy_uploads 
WHERE heavy_uploads.sum_kb > 100
ORDER BY heavy_uploads.sum_kb DESC
