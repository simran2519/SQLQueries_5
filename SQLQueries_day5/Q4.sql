-- 4.Problem statement
-- Table: Friends

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- | activity      | varchar |
-- +---------------+---------+
-- id is the id of the friend and primary key for this table.
-- name is the name of the friend.
-- activity is the name of the activity which the friend takes part in.
-- Table: Activities

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+
-- id is the primary key for this table.
-- name is the name of the activity.


-- Write an SQL query to find the names of all the activities with neither maximum, nor minimum number of participants.

-- Return the result table in any order. Each activity in table Activities is performed by any person in the table Friends.

-- The query result format is in the following example:

-- Friends table:
-- +------+--------------+---------------+
-- | id   | name         | activity      |
-- +------+--------------+---------------+
-- | 1    | Jonathan D.  | Eating        |
-- | 2    | Jade W.      | Singing       |
-- | 3    | Victor J.    | Singing       |
-- | 4    | Elvis Q.     | Eating        |
-- | 5    | Daniel A.    | Eating        |
-- | 6    | Bob B.       | Horse Riding  |
-- +------+--------------+---------------+

-- Activities table:
-- +------+--------------+
-- | id   | name         |
-- +------+--------------+
-- | 1    | Eating       |
-- | 2    | Singing      |
-- | 3    | Horse Riding |
-- +------+--------------+

-- Result table:
-- +--------------+
-- | activity     |
-- +--------------+
-- | Singing      |
-- +--------------+

-- Eating activity is performed by 3 friends, maximum number of participants, (Jonathan D. , Elvis Q. and Daniel A.)
-- Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
-- Singing is performed by 2 friends (Victor J. and Jade W.)

Use AVI;

-- Create Friends table
CREATE TABLE Friends (
    id int PRIMARY KEY,
    name varchar(255),
    activity varchar(255),
    FOREIGN KEY (activity) REFERENCES Activities(name)
);

-- Create Activities table
CREATE TABLE Activities (
    id int PRIMARY KEY,
    name varchar(255)
);

-- Insert values into the Activities table
INSERT INTO Activities (id, name) VALUES
(1, 'Eating'),
(2, 'Singing'),
(3, 'Horse Riding');

-- Insert values into the Friends table
INSERT INTO Friends (id, name, activity) VALUES
(1, 'Jonathan D.', 'Eating'),
(2, 'Jade W.', 'Singing'),
(3, 'Victor J.', 'Singing'),
(4, 'Elvis Q.', 'Eating'),
(5, 'Daniel A.', 'Eating'),
(6, 'Bob B.', 'Horse Riding');


WITH ActivityParticipants AS (
    SELECT 
        a.name AS activity_name,
        COUNT(f.id) AS num_participants
    FROM 
        Activities a
    JOIN 
        Friends f ON a.name = f.activity
    GROUP BY 
        a.name
),
MinMaxParticipants AS (
    SELECT 
        MIN(num_participants) AS min_participants,
        MAX(num_participants) AS max_participants
    FROM 
        ActivityParticipants
)
SELECT 
    activity_name
FROM 
    ActivityParticipants
CROSS JOIN 
    MinMaxParticipants
WHERE 
    num_participants NOT IN (min_participants, max_participants);
