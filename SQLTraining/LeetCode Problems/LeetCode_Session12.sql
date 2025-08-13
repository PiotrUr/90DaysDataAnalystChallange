
/*
LeetCode 12th Session
Created 2025-08-13 by PiotrUr
*/

/*
1327. List the Products Ordered in a Period (Easy)
https://leetcode.com/problems/list-the-products-ordered-in-a-period/description/
*/

WITH OrdersGroupped AS (
    SELECT
        product_id,
        SUM(unit) as unit
    FROM Orders
    WHERE MONTH(order_date) = 2 AND YEAR(order_date) = 2020
    GROUP BY product_id
    HAVING SUM(unit) >= 100
)
SELECT
    p.product_name,
    o.unit
FROM OrdersGroupped o
LEFT JOIN Products p ON p.product_id = o.product_id
ORDER BY o.unit DESC

/*
1378. Replace Employee ID With The Unique Identifier (Easy)
https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/description/
*/

SELECT
    u.unique_id,
    e.name
FROM Employees e
LEFT JOIN EmployeeUNI u ON u.id = e.id

/*
1407. Top Travellers (Easy)
https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/description/
*/

SELECT
    [name],
    COALESCE(SUM(r.distance), 0) as travelled_distance
FROM Users u
LEFT JOIN Rides r ON u.id = r.user_id
GROUP BY u.id, [name]
ORDER BY travelled_distance DESC, [name]