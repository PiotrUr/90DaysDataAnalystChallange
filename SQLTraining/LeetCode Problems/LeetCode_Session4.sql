
/*
LeetCode 4th Session
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

WITH FirstLogins AS (
    SELECT
        player_id,
        MIN(event_date) AS first_login_date
    FROM Activity
    GROUP BY player_id
),
NextDayLogins AS (
    SELECT
        a.player_id
    FROM Activity a
    INNER JOIN FirstLogins f
        ON a.player_id = f.player_id
        AND a.event_date = DATEADD(DAY, 1, f.first_login_date)
)

SELECT
    ROUND(
        CAST(COUNT(DISTINCT n.player_id) AS FLOAT) /
        (SELECT COUNT(DISTINCT player_id) FROM Activity),
        2
    ) AS fraction
FROM NextDayLogins n;