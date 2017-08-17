-- https://meta.discourse.org/t/42560/8?u=sidv
-- Number of members added to Trust Level (TL) 1, 2 and 3 month-by-month over the past year.
-- Answering the question how many users actually sticking around and interacting with the community and progressing through the trust levels.

WITH
year_months AS (
  SELECT
    to_char(date(day),'YYYY-MM') as year_month
  FROM
    generate_series(
      (date_trunc('month', CURRENT_DATE) - INTERVAL '1 year' ),
      CURRENT_DATE,
      interval '1 month'
    ) AS day
),
qualifying_users AS (
  SELECT
    gu.user_id,
    to_char(date(gu.created_at),'YYYY-MM') as year_month,
    SUM(CASE WHEN g.name = 'trust_level_1' THEN 1 ELSE 0 END) AS tl1,
    SUM(CASE WHEN g.name = 'trust_level_2' THEN 1 ELSE 0 END) AS tl2,
    SUM(CASE WHEN g.name = 'trust_level_3' THEN 1 ELSE 0 END) AS tl3
  FROM group_users AS gu
  JOIN groups AS g ON g.id = gu.group_id
  WHERE
    gu.created_at > ( date_trunc('month', CURRENT_DATE) - INTERVAL '1 year' )
    AND ( g.name = 'trust_level_1' OR g.name = 'trust_level_2' OR g.name = 'trust_level_3' )
  GROUP BY
      gu.user_id,
      year_month
),
year_month_rate AS (
  SELECT
    year_month,
    SUM(tl1) AS tl1,
    SUM(tl2) AS tl2,
    SUM(tl3) AS tl3
  FROM qualifying_users q
  GROUP BY
      year_month
)



SELECT
 *
FROM
 year_months AS d
LEFT JOIN (
  SELECT * FROM year_month_rate
) AS t USING (year_month)
ORDER BY
  year_month
