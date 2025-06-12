
/*
LeetCode 3rd Session
Created 2025-06-12 by PiotrUr
*/

/*
596. Classes With at Least 5 Students (Easy)
https://leetcode.com/problems/classes-with-at-least-5-students/
*/

SELECT
    class
FROM
    Courses
GROUP BY
    class
HAVING
    COUNT(student) >= 5

/*
607. Sales Person (Easy)
https://leetcode.com/problems/sales-person/description/
*/

SELECT
    sp.name
FROM
    SalesPerson sp
WHERE
    sp.sales_id NOT IN(
        SELECT o.sales_id FROM Orders o
        LEFT JOIN Company c ON o.com_id = c.com_id
        WHERE c.name = 'RED'
    )

/*
610. Triangle Judgement (Easy)
https://leetcode.com/problems/triangle-judgement/description/
*/

SELECT *,
    CASE
        WHEN x + y > z AND
             x + z > y AND
             z + y > x THEN 'Yes'
        ELSE 'No'
    END as triangle
FROM
    Triangle

/*
550. Game Play Analysis IV (Medium)
https://leetcode.com/problems/game-play-analysis-iv/description/
*/

-- NOT FINISHED --

/*
-- First login date per user
WITH first_login AS (
    SELECT MIN(event_date) as first_log_date
    FROM Activity
    GROUP BY player_id)
SELECT *, first_login
FROM
    Activity

-- Count of all players
SELECT
    DISTINCT COUNT (player_id)
FROM
    Activity

-- Consecutive day count
WITH consecutive_days AS (
    SELECT player_id,
        
)

SELECT 
    *, 
    LAG(event_date,1) OVER (ORDER BY player_id, event_date) AS [previous_date],
    LAG(player_id,1) OVER (ORDER BY player_id, event_date) AS [previous_player]
FROM Activity
WHERE
    player_id = [previous_player]
--    previous_date = DATEADD(day,1,event_date)
ORDER BY player_id, event_date
*/
