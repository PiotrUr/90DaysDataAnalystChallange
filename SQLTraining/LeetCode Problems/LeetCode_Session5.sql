
/*
LeetCode 5th Session
Created 2025-06-15 by PiotrUr
*/

/*
570. Managers with at Least 5 Direct Reports (Medium)
https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description/
*/

WITH DirectReportsCount AS (
SELECT
    managerId,
    COUNT(id) as ReportsCount
FROM
    Employee
GROUP BY
    managerId
HAVING
    COUNT(id) > 4
)
SELECT
    e2.name
FROM
    Employee e2
INNER JOIN 
    DirectReportsCount r ON r.managerId = e2.id

/*
585. Investments in 2016 (Medium)
https://leetcode.com/problems/investments-in-2016/description/
*/

WITH DuplicateTIVs AS (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
),
UniqueLocations AS (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
)
SELECT
    ROUND(SUM(i.tiv_2016), 2) AS tiv_2016
FROM
    Insurance i
JOIN DuplicateTIVs d
    ON i.tiv_2015 = d.tiv_2015
JOIN UniqueLocations u
    ON i.lat = u.lat AND i.lon = u.lon;

/*
602. Friend Requests II: Who Has the Most Friends (Medium)
https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/description/
*/

WITH RequestedFriends AS (
    SELECT
        requester_id AS id,
        COUNT(*) AS num
    FROM
        RequestAccepted
    GROUP BY requester_id
),
AcceptedFriends AS (
    SELECT
        accepter_id AS id,
        COUNT(*) AS num
    FROM
        RequestAccepted
    GROUP BY accepter_id
),
AllFriends AS (
    SELECT * FROM RequestedFriends
    UNION ALL
    SELECT * FROM AcceptedFriends
),
FriendCounts AS (
    SELECT
        id,
        SUM(num) AS num
    FROM AllFriends
    GROUP BY id
)
SELECT TOP 1 *
FROM FriendCounts
ORDER BY num DESC;