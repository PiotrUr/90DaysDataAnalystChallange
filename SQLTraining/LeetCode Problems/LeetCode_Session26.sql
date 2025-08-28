
/*
LeetCode 26th Session
Created 2025-08-28 by PiotrUr
*/

/*
3657. Find Loyal Customers (Medium)
https://leetcode.com/problems/find-loyal-customers/description/
*/

WITH CustomerStats AS (
    SELECT
        customer_id,
        SUM(CASE
                WHEN transaction_type = 'purchase' THEN 1
                ELSE 0
            END) as transactions_count,
        DATEDIFF(day, MIN(transaction_date), MAX(transaction_date)) as active_days,
        SUM(CASE
                WHEN transaction_type = 'refund' THEN 1
                ELSE 0
            END) * 1.0 / COUNT(*) as refund_rate
    FROM
        customer_transactions
    GROUP BY customer_id
)
SELECT
    customer_id
FROM
    CustomerStats
WHERE
    transactions_count > 2 AND
    active_days > 29 AND
    refund_rate < 0.2

/*
3626. Find Stores with Inventory Imbalance (Medium)
https://leetcode.com/problems/find-stores-with-inventory-imbalance/description/
*/

WITH ProductsRanked AS (
    SELECT
        inventory_id,
        store_id,
        product_name,
        quantity,
        ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY price DESC) as expensive_rank,
        ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY price ASC) as cheap_rank
    FROM
        inventory
),
CheapestProducts AS (
    SELECT
        inventory_id,
        store_id,
        product_name,
        quantity
    FROM ProductsRanked
    WHERE 
        (cheap_rank = 1 AND
        expensive_rank > 2)
),
ExpensiveProducts AS (
    SELECT
        inventory_id,
        store_id,
        product_name,
        quantity
    FROM ProductsRanked
    WHERE 
        (expensive_rank = 1 AND
        cheap_rank > 2)
)
SELECT 
    c.store_id,
    s.store_name,
    s.location,
    e.product_name as most_exp_product,
    c.product_name as cheapest_product,
    ROUND(c.quantity * 1.00 / e.quantity, 2) as imbalance_ratio
FROM CheapestProducts c
LEFT JOIN ExpensiveProducts e ON c.store_id = e.store_id
LEFT JOIN stores s ON c.store_id = s.store_id
WHERE e.quantity < c.quantity
ORDER BY imbalance_ratio DESC, s.store_name ASC