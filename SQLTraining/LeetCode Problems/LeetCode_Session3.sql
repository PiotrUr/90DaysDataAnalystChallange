
/*
LeetCode 3rd Session
Created 2025-06-08 by PiotrUr
*/

/*
511. Game Play Analysis I (Easy)
https://leetcode.com/problems/game-play-analysis-i/description/
*/

SELECT
    player_id,
    MIN(event_date) as first_login
FROM
    Activity
GROUP BY
    player_id

/*
577. Employee Bonus (Easy)
https://leetcode.com/problems/employee-bonus/
*/

SELECT
    E.name,
    B.bonus
FROM
    Employee as E
LEFT JOIN
    Bonus as B ON E.empId = B.empId
WHERE
    IFNULL(B.bonus,0) < 1000

/*
584. Find Customer Referee (Easy)
https://leetcode.com/problems/find-customer-referee/description/
*/

SELECT
    name
FROM
    Customer
WHERE
    referee_id <> 2 OR
    referee_id IS NULL

/*
586. Customer Placing the Largest Number of Orders (Easy)
https://leetcode.com/problems/customer-placing-the-largest-number-of-orders/description/
*/

SELECT
    customer_number
FROM
    Orders
GROUP BY
    customer_number
ORDER BY
    COUNT(order_number) DESC LIMIT 1

/*
595. Big Countries (Easy)
https://leetcode.com/problems/big-countries/description/
*/

SELECT
    name,
    population,
    area
FROM
    World
WHERE
    area >= 3000000 OR
    population >= 25000000

/*
178. Rank Scores (Medium)
https://leetcode.com/problems/rank-scores/description/
*/

SELECT
    score,
    DENSE_RANK() OVER( ORDER BY score DESC) AS [rank]
FROM
    Scores
ORDER BY
    [rank]

/*
180. Consecutive Numbers (Medium)
https://leetcode.com/problems/consecutive-numbers/description/
*/

SELECT
    DISTINCT(l1.num) as ConsecutiveNums
FROM
    Logs l1, Logs l2, Logs l3
WHERE
    (l1.id = l2.id-1 AND
    l1.num = l2.num)
    AND
    (l1.id = l3.id-2 AND
    l1.num = l3.num)

--USING LAG() and LEAD() Functions

WITH consecutive_nums AS (
    SELECT num,
           LAG(num, 1) OVER (ORDER BY id) AS prev_num,
           LEAD(num, 1) OVER (ORDER BY id) AS next_num   
    FROM logs
)
SELECT DISTINCT num AS ConsecutiveNums
FROM consecutive_nums
WHERE prev_num = num AND num = next_num

/*
184. Department Highest Salary (Medium)
https://leetcode.com/problems/department-highest-salary/description/
*/

WITH max_per_depart AS (
    SELECT MAX(salary) as max_salary,
        departmentId
    FROM Employee
    GROUP BY departmentId
)
SELECT
    d.name as Department,
    e.name as Employee,
    m.max_salary as Salary
FROM
    Employee e
LEFT JOIN
    max_per_depart m ON e.departmentId = m.departmentId
LEFT JOIN
    Department d ON e.departmentId = d.ID
WHERE
    e.salary = m.max_salary