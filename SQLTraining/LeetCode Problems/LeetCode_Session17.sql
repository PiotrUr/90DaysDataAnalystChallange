
/*
LeetCode 17th Session
Created 2025-08-19 by PiotrUr
*/

/*
1795. Rearrange Products Table (Easy)
https://leetcode.com/problems/rearrange-products-table/description/
*/

SELECT
    product_id,
    'store1' as store,
    store1 as price
FROM Products
WHERE store1 IS NOT NULL
UNION
SELECT
    product_id,
    'store2' as store,
    store2 as price
FROM Products
WHERE store2 IS NOT NULL
UNION
SELECT
    product_id,
    'store3' as store,
    store3 as price
FROM Products
WHERE store3 IS NOT NULL

/*
1873. Calculate Special Bonus (Easy)
https://leetcode.com/problems/calculate-special-bonus/description/
*/

SELECT
    employee_id,
    CASE
        WHEN employee_id%2 = 1 AND LEFT([name], 1) <> 'M' THEN salary
        ELSE 0
    END as bonus
FROM Employees
ORDER BY employee_id

/*
1890. The Latest Login in 2020 (Easy)
https://leetcode.com/problems/the-latest-login-in-2020/
*/

SELECT
    [user_id],
    MAX(time_stamp) as last_stamp
FROM Logins
WHERE YEAR(time_stamp) = 2020
GROUP BY [user_id]

/*
1907. Count Salary Categories (Medium)
https://leetcode.com/problems/count-salary-categories/description/
*/

WITH LowIncome as (
    SELECT account_id
    FROM Accounts
    WHERE income < 20000
),
AverageIncome as (
    SELECT account_id
    FROM Accounts
    WHERE income BETWEEN 20000 AND 50000
),
HighIncome as (
    SELECT account_id
    FROM Accounts
    WHERE income > 50000
)
SELECT 
    'Low Salary' as category, 
    COUNT(*) as accounts_count
FROM LowIncome
UNION
SELECT 
    'Average Salary' as category, 
    COUNT(*) as accounts_count
FROM AverageIncome
UNION
SELECT 
    'High Salary' as category, 
    COUNT(*) as accounts_count
FROM HighIncome