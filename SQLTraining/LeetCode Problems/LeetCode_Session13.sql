
/*
LeetCode 12th Session
Created 2025-08-14 by PiotrUr
*/

/*
1179. Reformat Department Table (Easy)
https://leetcode.com/problems/reformat-department-table/description/
*/

SELECT 
    d.id,
    SUM(CASE WHEN d.month = 'Jan' THEN d.revenue ELSE NULL END) AS Jan_Revenue,
    SUM(CASE WHEN d.month = 'Feb' THEN d.revenue ELSE NULL END) AS Feb_Revenue,
    SUM(CASE WHEN d.month = 'Mar' THEN d.revenue ELSE NULL END) AS Mar_Revenue,
    SUM(CASE WHEN d.month = 'Apr' THEN d.revenue ELSE NULL END) AS Apr_Revenue,
    SUM(CASE WHEN d.month = 'May' THEN d.revenue ELSE NULL END) AS May_Revenue,
    SUM(CASE WHEN d.month = 'Jun' THEN d.revenue ELSE NULL END) AS Jun_Revenue,
    SUM(CASE WHEN d.month = 'Jul' THEN d.revenue ELSE NULL END) AS Jul_Revenue,
    SUM(CASE WHEN d.month = 'Aug' THEN d.revenue ELSE NULL END) AS Aug_Revenue,
    SUM(CASE WHEN d.month = 'Sep' THEN d.revenue ELSE NULL END) AS Sep_Revenue,
    SUM(CASE WHEN d.month = 'Oct' THEN d.revenue ELSE NULL END) AS Oct_Revenue,
    SUM(CASE WHEN d.month = 'Nov' THEN d.revenue ELSE NULL END) AS Nov_Revenue,
    SUM(CASE WHEN d.month = 'Dec' THEN d.revenue ELSE NULL END) AS Dec_Revenue
FROM Department d
GROUP BY d.id

/*
1527. Patients With a Condition (Easy)
https://leetcode.com/problems/patients-with-a-condition/description/
*/

SELECT *
FROM Patients
WHERE conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%'

/*
1581. Customer Who Visited but Did Not Make Any Transactions (Easy)
https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/description/
*/

SELECT 
    v.customer_id,
    COUNT(*) as count_no_trans
FROM Visits v
LEFT JOIN Transactions t ON t.visit_id = v.visit_id
WHERE t.visit_id IS NULL
GROUP BY v.customer_id
ORDER BY v.customer_id