
/*
LeetCode 23rd Session
Created 2025-08-25 by PiotrUr
*/

/*
3554. Find Category Recommendation Pairs (Hard)
https://leetcode.com/problems/find-category-recommendation-pairs/
*/

SELECT
    i2.category as category1,
    i1.category as category2,
    COUNT(DISTINCT p1.user_id) as customer_count
FROM ProductPurchases p1
LEFT JOIN ProductPurchases p2 ON p1.user_id = p2.user_id
LEFT JOIN ProductInfo i1 ON p1.product_id = i1.product_id
LEFT JOIN ProductInfo i2 ON p2.product_id = i2.product_id
WHERE 
    i1.category > i2.category
GROUP BY i1.category, i2.category
HAVING COUNT(DISTINCT p1.user_id) >= 3
ORDER BY COUNT(DISTINCT p1.user_id) DESC, i2.category, i1.category

/*
3564. Seasonal Sales Analysis (Medium)
https://leetcode.com/problems/seasonal-sales-analysis/description/
*/

WITH sales_season AS (
  SELECT
    CASE
      WHEN DATEPART(MONTH, s.sale_date) IN (12, 1, 2) THEN 'Winter'
      WHEN DATEPART(MONTH, s.sale_date) IN (3, 4, 5)  THEN 'Spring'
      WHEN DATEPART(MONTH, s.sale_date) IN (6, 7, 8)  THEN 'Summer'
      ELSE 'Fall'
    END as season,
    p.category,
    s.quantity,
    CAST(s.quantity * s.price AS DECIMAL(18,2)) as revenue
  FROM sales s
  INNER JOIN products p
    ON p.product_id = s.product_id
),
agg AS (
  SELECT
    season,
    category,
    SUM(quantity) as total_quantity,
    CAST(SUM(revenue) AS DECIMAL(18,2)) as total_revenue
  FROM sales_season
  GROUP BY season, category
),
ranked AS (
  SELECT
    season,
    category,
    total_quantity,
    total_revenue,
    ROW_NUMBER() OVER (
      PARTITION BY season
      ORDER BY total_quantity DESC, total_revenue DESC, category
    ) as rn
  FROM agg
)
SELECT
  season,
  category,
  total_quantity,
  total_revenue
FROM ranked
WHERE rn = 1
ORDER BY season;

/*
3580. Find Consistently Improving Employees (Medium)
https://leetcode.com/problems/find-consistently-improving-employees/description/
*/

WITH ReviewsRanked AS (
SELECT
    employee_id,
    rating,
    review_date,
    ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY review_date DESC) as rn,
    LEAD(rating, 1) OVER (PARTITION BY employee_id ORDER BY review_date DESC) as n_minus_1_rating,
    LEAD(rating, 2) OVER (PARTITION BY employee_id ORDER BY review_date DESC) as n_minus_2_rating
FROM performance_reviews

)
SELECT
    r.employee_id,
    e.name,
    r.rating - r.n_minus_2_rating as improvement_score
FROM ReviewsRanked r
LEFT JOIN employees e ON r.employee_id = e.employee_id
WHERE 
    rn = 1 AND
    n_minus_2_rating < n_minus_1_rating AND
    n_minus_1_rating < rating
ORDER BY improvement_score DESC, e.name