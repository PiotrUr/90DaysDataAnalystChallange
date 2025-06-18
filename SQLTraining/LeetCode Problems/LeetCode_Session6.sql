
/*
LeetCode 6th Session
Created 2025-06-18 by PiotrUr
*/

/*
608. Tree Node (Medium)
https://leetcode.com/problems/tree-node/
*/

SELECT 
    id, 
    CASE
        WHEN p_id IS NULL THEN 'Root'
        WHEN id IN (SELECT p_id FROM Tree) then 'Inner'
        ELSE 'Leaf'
    END AS [type]
FROM Tree

/*
619. Biggest Single Number (Easy)
https://leetcode.com/problems/biggest-single-number/description/
*/

WITH SingleNumbers AS (
    SELECT
        TOP 1 num
    FROM
        MyNumbers
    GROUP BY
        num
    HAVING
        COUNT(num) = 1
    ORDER BY num DESC
)
SELECT
    MAX(num) as num
    FROM SingleNumbers

/*
620. Not Boring Movies (Easy)
https://leetcode.com/problems/not-boring-movies/description/
*/

SELECT *
FROM Cinema
WHERE
    id%2 = 1 AND
    description NOT LIKE '%boring%'
ORDER BY rating DESC

/*
626. Exchange Seats (Medium)
https://leetcode.com/problems/exchange-seats/
*/

SELECT
    CASE 
        WHEN id%2=0 THEN id-1
        WHEN id%2=1 AND id+1 NOT IN (SELECT id FROM seat) THEN id
        ELSE id+1 
    END AS id,
    student
FROM 
    seat 
ORDER BY id