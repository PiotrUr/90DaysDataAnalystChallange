
/*
LeetCode 14th Session
Created 2025-08-16 by PiotrUr
*/

/*
1341. Movie Rating (Medium)
https://leetcode.com/problems/movie-rating/
*/

WITH TopRatingUser AS (
    SELECT TOP 1 
        u.name as top_user
    FROM MovieRating r
    LEFT JOIN Users u ON u.user_id = r.user_id
    GROUP BY r.user_id, u.name 
    ORDER BY COUNT(*) DESC, u.name
),
BestScoredMovieFeb20 AS (
    SELECT TOP 1
        m.title as top_movie
    FROM MovieRating r
    LEFT JOIN Movies m on m.movie_id = r.movie_id
    WHERE MONTH(created_at) = 2 AND YEAR(created_at) = 2020
    GROUP BY r.movie_id, m.title
    ORDER BY AVG(rating * 1.0) DESC, m.title
)
SELECT top_user AS results FROM TopRatingUser
UNION ALL
SELECT top_movie FROM BestScoredMovieFeb20

/*
1484. Group Sold Products By The Date (Easy)
https://leetcode.com/problems/group-sold-products-by-the-date/description/
*/

WITH DistinctProducts AS (
    SELECT
        sell_date,
        product
    FROM Activities
    GROUP BY sell_date, product
)
SELECT 
    sell_date, 
    COUNT(product) as 'num_sold',
    STRING_AGG (product , ',') 
        WITHIN GROUP (ORDER BY product ASC) as products
FROM DistinctProducts
GROUP BY sell_date
ORDER BY sell_date

/*
1587. Bank Account Summary II (Easy)
https://leetcode.com/problems/bank-account-summary-ii/description/
*/

SELECT
    u.name,
    SUM(t.amount) as balance
FROM Users u
LEFT JOIN Transactions t ON t.account = u.account
GROUP BY u.account, u.name
HAVING SUM(t.amount) > 10000
ORDER BY u.name