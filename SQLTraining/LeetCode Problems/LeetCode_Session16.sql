
/*
LeetCode 16th Session
Created 2025-08-12 by PiotrUr
*/

/*
1683. Invalid Tweets (Easy)
https://leetcode.com/problems/invalid-tweets/description/
*/

SELECT 
    tweet_id
FROM Tweets
WHERE LEN(content) > 15

/*
1693. Daily Leads and Partners (Easy)
https://leetcode.com/problems/daily-leads-and-partners/description/
*/

SELECT
    date_id,
    make_name,
    COUNT(DISTINCT lead_id) as unique_leads,
    COUNT(DISTINCT partner_id) as unique_partners
FROM DailySales
GROUP BY date_id, make_name

/*
1693. Daily Leads and Partners (Easy)
https://leetcode.com/problems/daily-leads-and-partners/description/
*/

SELECT
    [user_id],
    COUNT(*) as followers_count
FROM Followers
GROUP BY [user_id]

/*
1731. The Number of Employees Which Report to Each Employee (Easy)
https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/description/
*/

SELECT
    e2.employee_id,
    e2.name,
    COUNT(e1.employee_id) as reports_count,
    ROUND(SUM(e1.age) / CAST(COUNT(e1.age) as float), 0) as average_age
FROM Employees e1
JOIN Employees e2 ON e2.employee_id = e1.reports_to
GROUP BY e2.employee_id, e2.name
ORDER BY e2.employee_id

/*
1741. Find Total Time Spent by Each Employee (Easy)
https://leetcode.com/problems/find-total-time-spent-by-each-employee/
*/

SELECT
    event_day as [day],
    emp_id,
    SUM(out_time - in_time) as total_time
FROM Employees
GROUP BY event_day, emp_id
ORDER BY event_day, emp_id

/*
1757. Recyclable and Low Fat Products (Easy)
https://leetcode.com/problems/recyclable-and-low-fat-products/
*/

SELECT
    product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y'
ORDER BY product_id

/*
1789. Primary Department for Each Employee (Easy)
https://leetcode.com/problems/primary-department-for-each-employee/
*/

SELECT 
    employee_id, 
    department_id
FROM Employee
WHERE
    primary_flag = 'Y' OR
    employee_id IN (
        SELECT 
            employee_id
        FROM Employee
        GROUP BY employee_id
        HAVING COUNT(department_id) = 1
    )