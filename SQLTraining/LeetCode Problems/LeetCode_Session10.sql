
/*
LeetCode 10th Session
Created 2025-07-26 by PiotrUr
*/

/*
1193. Monthly Transactions I (Medium)
https://leetcode.com/problems/monthly-transactions-i/description/
*/

WITH Totals AS(
    SELECT
        FORMAT(trans_date, 'yyyy-MM') AS [month],
        country,
        COUNT(*) as trans_count,
        SUM(amount) as trans_total_amount
    FROM Transactions
    GROUP BY FORMAT(trans_date, 'yyyy-MM'), country
),
Approved AS(
    SELECT
        FORMAT(trans_date, 'yyyy-MM') AS [month],
        country,
        COUNT(*) as approved_count,
        SUM(amount) as approved_total_amount
    FROM Transactions
    WHERE [state] = 'approved'
    GROUP BY FORMAT(trans_date, 'yyyy-MM'), country
)
SELECT
    t.[month],
    t.country,
    t.trans_count,
    ISNULL(a.approved_count, 0) as approved_count,
    t.trans_total_amount,
    ISNULL(a.approved_total_amount, 0) as approved_total_amount
FROM Totals t
LEFT JOIN Approved a ON a.[month] = t.[month] AND a.country = t.country
ORDER BY t.[month], t.country

/*
1204. Last Person to Fit in the Bus (Medium)
https://leetcode.com/problems/last-person-to-fit-in-the-bus/description/
*/

WITH RunningWeight AS (
SELECT
    person_name, 
    SUM(weight) OVER(ORDER BY turn 
     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
          AS [total_weight]
FROM [Queue]
)
SELECT TOP 1 person_name
FROM RunningWeight
WHERE total_weight <= 1000
ORDER BY total_weight DESC

/*
1211. Queries Quality and Percentage (Easy)
https://leetcode.com/problems/queries-quality-and-percentage/description/
*/

SELECT
    query_name,
    ROUND(SUM(rating * 1.0 / position) / COUNT(query_name), 2) AS quality,
    ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(query_name), 2) AS poor_query_percentage
FROM Queries
WHERE query_name IS NOT NULL
GROUP BY query_name
ORDER BY query_name DESC