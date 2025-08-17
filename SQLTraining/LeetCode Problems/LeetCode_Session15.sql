
/*
LeetCode 15th Session
Created 2025-08-17 by PiotrUr
*/

/*
1393. Capital Gain/Loss (Medium)
https://leetcode.com/problems/capital-gainloss/
*/

SELECT
    stock_name,
    SUM(CASE
            WHEN operation = 'Buy' THEN price * -1
            ELSE price
        END
    ) as capital_gain_loss
FROM Stocks
GROUP BY stock_name
ORDER BY stock_name

/*
1633. Percentage of Users Attended a Contest (Easy)
https://leetcode.com/problems/percentage-of-users-attended-a-contest/description/
*/

SELECT
    contest_id,
    ROUND(COUNT([user_id]) * 1.0 / (SELECT COUNT(*) FROM Users) * 100, 2) as [percentage]
FROM Register
GROUP BY contest_id
ORDER BY [percentage] DESC, contest_id

/*
1661. Average Time of Process per Machine (Easy)
https://leetcode.com/problems/average-time-of-process-per-machine/description/
*/

SELECT 
    a1.machine_id, 
    ROUND(AVG(a2.timestamp-a1.timestamp), 3) as processing_time
FROM Activity a1
JOIN Activity a2 ON a1.machine_id = a2.machine_id AND 
                    a1.process_id = a2.process_id AND 
                    a1.activity_type = 'start' AND 
                    a2.activity_type = 'end'
GROUP BY a1.machine_id

/*
1667. Fix Names in a Table (Easy)
https://leetcode.com/problems/average-time-of-process-per-machine/description/
*/

SELECT
    [user_id],
    UPPER(LEFT([name], 1)) + LOWER(SUBSTRING([name], 2, LEN([name]))) as name
FROM Users
ORDER BY [user_id]