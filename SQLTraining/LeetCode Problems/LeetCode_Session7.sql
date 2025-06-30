
/*
LeetCode 7th Session
Created 2025-06-30 by PiotrUr
*/

/*
627. Swap Salary (Easy)
https://leetcode.com/problems/swap-salary/
*/

UPDATE SALARY SET
    sex = 
    CASE sex 
        WHEN 'f' THEN 'm'
        ELSE 'f'
    END

/*
1050. Actors and Directors Who Cooperated At Least Three Times (Easy)
https://leetcode.com/problems/actors-and-directors-who-cooperated-at-least-three-times/description/
*/

SELECT DISTINCT
    actor_id,
    director_id
FROM
    ActorDirector
GROUP BY
    actor_id, director_id
HAVING
    COUNT(actor_id) > 2

--Alternatively with ROW_NUMBER()

SELECT
    actor_id, 
    director_id
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY actor_id, director_id ORDER BY actor_id) AS RN 
    FROM ActorDirector
) A
WHERE 
    A.RN = 3

/*
1045. Customers Who Bought All Products (Medium)
https://leetcode.com/problems/customers-who-bought-all-products/description/
*/

SELECT
    customer_id
FROM
    Customer
GROUP BY
    customer_id
HAVING
    COUNT(DISTINCT(product_key)) = (
        SELECT COUNT(*) FROM Product
    )

/*
1068. Product Sales Analysis I (Easy)
https://leetcode.com/problems/product-sales-analysis-i/description/
*/

SELECT
    p.product_name,
    s.year,
    s.price
FROM
    Sales s
JOIN
    Product p ON s.product_id = p.product_id

/*
1070. Product Sales Analysis III (Medium)
https://leetcode.com/problems/product-sales-analysis-iii/description/
*/

WITH FirstYearSale AS (
    SELECT
        product_id,
        MIN([year]) as first_year
    FROM
        Sales
    GROUP BY
        product_id
)
SELECT
    fy.product_id,
    fy.first_year,
    s.quantity,
    s.price
FROM
    FirstYearSale fy
JOIN
    Sales s ON fy.product_id = s.product_id AND fy.first_year = s.[year]

--Alternatively with ROW_NUMBER() (not accepted because of different order)

SELECT
    product_id,
    [year] as first_year,
    quantity,
    price
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY [year]) AS RN
    FROM
        Sales
) S
WHERE
    S.RN = 1