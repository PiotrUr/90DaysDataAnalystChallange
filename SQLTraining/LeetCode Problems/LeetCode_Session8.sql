
/*
LeetCode 8th Session
Created 2025-07-14 by PiotrUr
*/

/*
1075. Project Employees I (Easy)
https://leetcode.com/problems/project-employees-i/
*/

SELECT 
    p.project_id,
    ROUND(AVG(1.0 * experience_years), 2) as average_years
FROM Project p
LEFT JOIN Employee e ON p.employee_id = e.employee_id
GROUP BY p.project_id
ORDER BY p.project_id

/*
1084. Sales Analysis III (Easy)
https://leetcode.com/problems/sales-analysis-iii/description/
*/

WITH ProductsInScope AS (
    SELECT DISTINCT product_id
    FROM Sales
    WHERE sale_date BETWEEN '2019-01-01' AND '2019-03-31'
),
ProductsOutOfScope AS (
    SELECT DISTINCT product_id
    FROM Sales
    WHERE sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31'
)
SELECT
    s.product_id,
    p.product_name
FROM ProductsInScope s
JOIN Product p ON s.product_id = p.product_id
WHERE p.product_id NOT IN (SELECT product_id FROM ProductsOutOfScope)

/*
1141. User Activity for the Past 30 Days I (Easy)
https://leetcode.com/problems/user-activity-for-the-past-30-days-i/description/
*/

SELECT 
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN DATEADD(day, -29, '2019-07-27') AND '2019-07-27'
GROUP BY activity_date
ORDER BY activity_date

/*
1148. Article Views I (Easy)
https://leetcode.com/problems/article-views-i/description/
*/

SELECT DISTINCT viewer_id AS id
FROM Views
WHERE viewer_id = author_id
ORDER BY viewer_id