
/*
LeetCode 22nd Session
Created 2025-08-24 by PiotrUr
*/

/*
3497. Analyze Subscription Conversion (Medium)
https://leetcode.com/problems/analyze-subscription-conversion/
*/

WITH FreeTrialAvgDuration AS (
    SELECT
        [user_id],
        ROUND(SUM(activity_duration) * 1.0 / COUNT(*), 2) as trial_avg_duration
    FROM UserActivity
    WHERE activity_type = 'free_trial'
    GROUP BY [user_id]
),
PaidAvgDuration AS (
    SELECT
        [user_id],
        ROUND(SUM(activity_duration) * 1.0 / COUNT(*), 2) as paid_avg_duration
    FROM UserActivity
    WHERE activity_type = 'paid'
    GROUP BY [user_id]
)
SELECT
    p.user_id, 
    f.trial_avg_duration,
    p.paid_avg_duration
FROM PaidAvgDuration p
INNER JOIN FreeTrialAvgDuration f ON p.user_id = f.user_id
ORDER BY p.user_id

/*
3497. Analyze Subscription Conversion (Medium)
https://leetcode.com/problems/analyze-subscription-conversion/
*/

WITH UniqueProductPairs AS (
SELECT
    p1.product_id as product1_id,
    p2.product_id as product2_id,
    COUNT(*) as customer_count
FROM ProductPurchases p1
LEFT JOIN ProductPurchases p2 ON p1.user_id = p2.user_id
WHERE 
    p2.product_id > p1.product_id
GROUP BY p1.product_id, p2.product_id
HAVING COUNT(*) >= 3
)
SELECT
    pp.product1_id,
    pp.product2_id,
    i1.category as product1_category,
    i2.category as product2_category,
    customer_count
FROM UniqueProductPairs pp
LEFT JOIN ProductInfo i1 ON pp.product1_id = i1.product_id
LEFT JOIN ProductInfo i2 ON pp.product2_id = i2.product_id
ORDER BY pp.customer_count DESC, pp.product1_id, pp.product2_id

/*
3570. Find Books with No Available Copies (Easy)
https://leetcode.com/problems/find-books-with-no-available-copies/
*/

WITH CurrentlyBorrowed AS (
    SELECT 
        book_id,
        COUNT(*) as current_borrowers
    FROM borrowing_records
    WHERE return_date IS NULL
    GROUP BY book_id
)
SELECT 
    b.book_id,         
    b.title,           
    b.author,          
    b.genre,           
    b.publication_year,
    c.current_borrowers
FROM library_books b 
INNER JOIN CurrentlyBorrowed c ON b.book_id = c.book_id
WHERE b.total_copies - c.current_borrowers = 0
ORDER BY c.current_borrowers DESC, b.title