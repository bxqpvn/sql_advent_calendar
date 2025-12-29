-- SQL Advent Calendar - Day 12
-- Title: North Pole Network Most Active Users
-- Difficulty: hard
--
-- Question:
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--

-- Table Schema:
-- Table: npn_users
--   user_id: INT
--   user_name: VARCHAR
--
-- Table: npn_messages
--   message_id: INT
--   sender_id: INT
--   sent_at: TIMESTAMP
--

-- My Solution:

with mess_count as (
select
sent_at::date as sent_date,
user_name,
count(mes.message_id) as message_count
from npn_users usr
left join npn_messages mes
on usr.user_id = mes.sender_id
group by sent_at::date, user_name
),
ranked_users as (
select
sent_date,
user_name,
message_count,
rank() over (partition by sent_date order by message_count desc) as rnk
from mess_count
)
select
sent_date,
user_name,
message_count
from ranked_users
where rnk = 1
order by sent_date asc
