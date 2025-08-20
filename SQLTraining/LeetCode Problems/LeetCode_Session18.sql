
/*
LeetCode 18th Session
Created 2025-08-20 by PiotrUr
*/

/*
1934. Confirmation Rate (Medium)
https://leetcode.com/problems/confirmation-rate/
*/

WITH ConfirmationRates AS (
    SELECT
        [user_id],
        ROUND(
            SUM(CASE
                    WHEN [action] = 'confirmed' THEN 1 ELSE 0
                END) * 1.00 / COUNT(*), 2) as confirmation_rate
    FROM Confirmations
    GROUP BY [user_id]
)
SELECT
    s.user_id,
    COALESCE(r.confirmation_rate, 0) as confirmation_rate
FROM Signups s
LEFT JOIN ConfirmationRates r ON r.user_id = s.user_id

/*
1965. Employees With Missing Information (Easy)
https://leetcode.com/problems/employees-with-missing-information/description/
*/

SELECT 
    e.employee_id
FROM Employees e
LEFT JOIN Salaries s ON e.employee_id = s.employee_id
WHERE s.employee_id IS NULL
UNION
SELECT 
    s.employee_id
FROM Salaries s
LEFT JOIN  Employees e ON e.employee_id = s.employee_id
WHERE  e.employee_id IS NULL
ORDER BY employee_id

/*
1978. Employees Whose Manager Left the Company (Easy)
https://leetcode.com/problems/employees-whose-manager-left-the-company/description/
*/

SELECT 
    e1.employee_id
FROM Employees e1
LEFT JOIN Employees e2 ON e1.manager_id = e2.employee_id
WHERE 
    e1.manager_id IS NOT NULL AND
    e1.salary < 30000 AND
    e2.employee_id IS NULL
ORDER BY e1.employee_id

/*
2356. Number of Unique Subjects Taught by Each Teacher (Easy)
https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher/
*/

SELECT
    teacher_id,
    COUNT(DISTINCT subject_id) as cnt
FROM Teacher
GROUP BY teacher_id