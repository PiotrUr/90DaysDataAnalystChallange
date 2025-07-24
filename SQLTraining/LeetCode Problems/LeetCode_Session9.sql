
/*
LeetCode 9th Session
Created 2025-07-24 by PiotrUr
*/

/*
1158. Market Analysis I (Medium)
https://leetcode.com/problems/market-analysis-i/
*/

WITH Orders2019 AS (
    SELECT
        buyer_id,
        COUNT(*) as orders_in_2019
    FROM Orders
    WHERE YEAR(order_date) = 2019
    GROUP BY buyer_id
)
SELECT 
    u.user_id as buyer_id,
    u.join_date,
    ISNULL(o.orders_in_2019, 0) as orders_in_2019
FROM Users u
LEFT JOIN Orders2019 o ON o.buyer_id = u.user_id 

/*
1164. Product Price at a Given Date (Medium)
https://leetcode.com/problems/product-price-at-a-given-date/description/
*/

WITH PricesTillDate AS (
    SELECT 
        product_id,
        new_price,
        ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY change_date DESC) AS RN
    FROM Products
    WHERE change_date <= '2019-08-16'
)
SELECT
    DISTINCT p.product_id,
    ISNULL(pr.new_price, 10) as price
FROM Products p
LEFT JOIN PricesTillDate pr ON pr.product_id = p.product_id
WHERE RN = 1 OR RN IS NULL

/*
1174. Immediate Food Delivery II (Medium)
https://leetcode.com/problems/immediate-food-delivery-ii/
*/

WITH OrdersRanked AS (
    SELECT *, 
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as RN, 
        CASE 
            WHEN order_date = customer_pref_delivery_date THEN 1.0 
            ELSE 0 
        END as 'immediate'
    FROM Delivery
)

SELECT ROUND(SUM(immediate)/COUNT(immediate)*100,2) as 'immediate_percentage'
FROM OrdersRanked
WHERE RN = 1