---
This plugin allows admins to run SQL queries against the live Discourse database, 
including parameterized queries and formatting for several common column types.

More info: https://meta.discourse.org/t/data-explorer-plugin/32566
---

# List of Queries

* Fetch top 10 posts by likes received in the last month [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/top-posts-by-likes.sql)
* Users Last Seen [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/users-last-seen.sql)
  + Since N Weeks Ago
  + Since N Days Ago
* Banner Stats [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/banner-stats.sql)
* Top Quality Users [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/top-quality-users.sql)
* Posts Read (Daily) [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/posts-read-daily.sql)
* Posts Read Percentiles [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/posts-read-percentiles.sql)
* Active Readers [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/active-readers.sql)
  + Active Readers (Past Month)
  + Active Readers (Since N Days Ago)
* Topic Participation [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/topic-participation.sql)
* Count new TL1, TL2, TL3 users past 12 months [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/new-users-tl.sql)
* Likes from the team [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/likes-from-the-team.sql)
* Recently Read Topics by User [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/recently-read-topics.sql)
* Member Uploads [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/member-uploads.sql)
* Users active in last x days [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/users-active.sql)
* Who has been sending the most messages in the last week? [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/user-most-pm-last-w.sql)
* User’s directory [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/user-directory.sql)
* User's stats [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/user-stats.sql)
* Who is making SOLVED [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/who-is-marking-solved.sql)
* Solved stats per user [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/solved-stats-per-user.sql)
* Most Common Likers [SQL](https://github.com/SidVal/discourse-data-explorer/blob/queries/queries/most-common-likers.sql)


<!---
* [SQL]()
* [SQL]()
* [SQL]()
* [SQL]()
* [SQL]()
-->

## Declaring Parameters

```
-- [params]
-- null string_list :words
-- null string_list :categories
-- user_id :user_id
-- int :limit = 150

WITH words AS (
 SELECT unnest(string_to_array( :words, ',' )) word
),
cats1 AS (
 SELECT unnest(string_to_array( :categories, ',')) cat
),
-- ...
AND p.user_id = :user_id
-- ...
LIMIT :limit
```

## Errors
:warning: For new errors please [open a issue here](https://github.com/SidVal/discourse-data-explorer/issues) and PUT the URL from [meta discussion from discourse.org](https://meta.discourse.org)

**Note!** There are some strange problem with `int` parameter:
[![](https://meta-s3-cdn.global.ssl.fastly.net/original/3X/8/9/890aed880946c4bdb02f7af0f585dea8c6e6aa86.png)](https://meta.discourse.org/t/strange-problem-with-data-explorer/57751)

If you have that error, please delete the value declaration for int parameters.

For example, for 
`-- int :limit = 150` :arrow_right: `-- int :limit` 

And do not forget to save query, and complete the parameter before execute it.

