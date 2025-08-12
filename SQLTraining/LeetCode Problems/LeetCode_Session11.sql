
/*
LeetCode 11th Session
Created 2025-08-12 by PiotrUr
*/

/*
1251. Average Selling Price (Easy)
https://leetcode.com/problems/average-selling-price/
*/

SELECT 
    p.product_id,
    COALESCE(
        ROUND(SUM(us.units * pr.price) * 1.0 / NULLIF(SUM(us.units), 0), 2),
        0
    ) AS average_price
FROM Prices p
LEFT JOIN UnitsSold us 
    ON us.product_id = p.product_id
LEFT JOIN Prices pr 
    ON pr.product_id = p.product_id
    AND us.purchase_date BETWEEN pr.start_date AND pr.end_date
GROUP BY p.product_id
ORDER BY p.product_id;

/*
1280. Students and Examinations (Easy)
https://leetcode.com/problems/students-and-examinations/description/
*/

WITH ExaminationsSummary AS (
    SELECT 
        e.student_id,
        e.subject_name,
        COUNT(*) as attended_exams
    FROM Examinations e
    GROUP BY e.student_id, e.subject_name
)
SELECT 
    st.student_id,
    st.student_name,
    su.subject_name,
    ISNULL(es.attended_exams, 0) as attended_exams
FROM Students st
CROSS JOIN Subjects su
LEFT JOIN ExaminationsSummary es ON es.student_id = st.student_id AND es.subject_name = su.subject_name  
ORDER BY st.student_id, su.subject_name

/*
1321. Restaurant Growth (Medium)
https://leetcode.com/problems/restaurant-growth/description/
*/

WITH daily AS (
    SELECT
        visited_on,
        SUM(amount) AS day_amount
    FROM Customer
    GROUP BY visited_on
),
w AS (
    SELECT
        visited_on,
        SUM(day_amount) OVER (
            ORDER BY visited_on
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS sum7,
        AVG(day_amount * 1.0) OVER (
            ORDER BY visited_on
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS avg7,
        ROW_NUMBER() OVER (ORDER BY visited_on) AS rn
    FROM daily
)
SELECT
    visited_on,
    ROUND(sum7, 2) AS amount,
    ROUND(avg7, 2) AS average_amount
FROM w
WHERE rn >= 7
ORDER BY visited_on;