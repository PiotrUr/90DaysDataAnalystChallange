
/*
LeetCode 19th Session
Created 2025-08-21 by PiotrUr
*/

/*
3220. Odd and Even Transactions (Medium)
https://leetcode.com/problems/odd-and-even-transactions/
*/

SELECT 
    transaction_date,
    SUM(CASE
            WHEN amount%2 = 1 THEN amount
            ELSE 0
        END) as odd_sum,
    SUM(CASE
            WHEN amount%2 = 0 THEN amount
            ELSE 0
        END) as even_sum
FROM transactions
GROUP BY transaction_date
ORDER BY transaction_date

/*
185. Department Top Three Salaries (Hard)
https://leetcode.com/problems/department-top-three-salaries/description/
*/

WITH SalariesRanked AS (
    SELECT
        [name],
        salary,
        departmentId,
        DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC) as salary_rank
    FROM Employee
)
SELECT
    d.name as Department,
    s.name as Employee,
    s.Salary
FROM SalariesRanked s
LEFT JOIN Department d ON s.departmentId = d.id
WHERE s.salary_rank < 4

/*
262. Trips and Users (Hard)
https://leetcode.com/problems/trips-and-users/description/
*/

WITH ValidTrips AS (
    SELECT
        t.request_at,
        SUM(
            CASE
                WHEN t.status = 'cancelled_by_driver' OR t.status = 'cancelled_by_client' THEN 1
                ELSE 0
            END) as cancelled_count,
        COUNT (*) as total_trips
    FROM Trips t
    LEFT JOIN Users u1 ON t.client_id = u1.users_id
    LEFT JOIN Users u2 ON t.driver_id = u2.users_id
    WHERE
        u1.banned <> 'Yes' AND u2.banned <> 'Yes' AND
        request_at BETWEEN '2013-10-01' AND '2013-10-03'
    GROUP BY t.request_at
)
SELECT
    request_at as [Day],
    ROUND((cancelled_count * 1.0) / total_trips, 2) as [Cancellation Rate]
FROM ValidTrips
ORDER BY request_at