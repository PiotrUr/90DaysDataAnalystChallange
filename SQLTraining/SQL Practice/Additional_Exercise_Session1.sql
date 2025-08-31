/*
Additional_Exercise_Session1
Created 2025-08-31 by PiotrUr
*/

/* ========================================================================
   SQL Challenge 1: E-commerce Category Revenue Analysis (Medium)
   ------------------------------------------------------------------------
   Tables:
     Orders(order_id, customer_id, order_date, total_amount)
     OrderItems(order_id, product_id, quantity, unit_price)
     Products(product_id, category, brand)

   Task:
     Find the TOP 3 categories by total revenue in the last quarter.
     For each category, display:
       - category
       - total revenue
       - total number of distinct orders
       - average order value (total revenue / total orders)

   Requirements:
     - Consider only the last calendar quarter relative to today.
     - Sort results by revenue descending.
========================================================================= */

SELECT TOP 3
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) * 1.0 / COUNT(DISTINCT oi.order_id) AS avg_order_value
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE o.order_date >= DATEADD(QUARTER, DATEDIFF(QUARTER, 0, GETDATE()) - 1, 0)
  AND o.order_date < DATEADD(QUARTER, DATEDIFF(QUARTER, 0, GETDATE()), 0)
GROUP BY p.category
ORDER BY total_revenue DESC;


/* ========================================================================
   SQL Challenge 2: Employee Attendance Analysis (Medium/Hard)
   ------------------------------------------------------------------------
   Table:
     Attendance(emp_id, emp_name, attendance_date, status)
       where status ∈ ('Present', 'Absent', 'Remote')

   Task:
     For each employee, calculate:
       - Percentage of presence ("Present") in the last 90 days
       - The longest streak of consecutive days without "Absent"

   Requirements:
     - Sort results ascending by presence percentage.
     - Show emp_id, emp_name, presence_percentage, longest_streak.
========================================================================= */

WITH RecentAttendance AS (
    SELECT 
        emp_id,
        emp_name,
        attendance_date,
        [status]
    FROM Attendance
    WHERE attendance_date >= DATEADD(DAY, -90, CAST(GETDATE() AS DATE))
),
PresenceStats AS (
    SELECT 
        emp_id,
        emp_name,
        COUNT(CASE WHEN status = 'Present' THEN 1 END) * 1.0 / COUNT(*) AS presence_percentage
    FROM RecentAttendance
    GROUP BY emp_id, emp_name
),
Streaks AS (
    SELECT 
        emp_id,
        emp_name,
        attendance_date,
        [status],
        CASE WHEN [status] = 'Absent' THEN 0 ELSE 1 END AS is_present,
        ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY attendance_date) -
        ROW_NUMBER() OVER (PARTITION BY emp_id, CASE WHEN [status] = 'Absent' THEN 0 ELSE 1 END ORDER BY attendance_date) AS grp
    FROM RecentAttendance
),
LongestStreak AS (
    SELECT 
        emp_id,
        emp_name,
        MAX(COUNT(*)) OVER (PARTITION BY emp_id) AS longest_streak
    FROM Streaks
    WHERE is_present = 1
    GROUP BY emp_id, emp_name, grp
)
SELECT 
    ps.emp_id,
    ps.emp_name,
    ps.presence_percentage,
    ISNULL(ls.longest_streak, 0) AS longest_streak
FROM PresenceStats ps
LEFT JOIN LongestStreak ls ON ps.emp_id = ls.emp_id
ORDER BY ps.presence_percentage ASC;


/* ========================================================================
   SQL Challenge 3: User Retention Cohort Analysis (Hard)
   ------------------------------------------------------------------------
   Table:
     UserLogins(user_id, login_date)

   Task:
     Build a Cohort Analysis:
       - Define each user's cohort as the month of their first login
         (e.g. '2025-01').
       - For each cohort, show the number of active users in:
           month_offset = 0 (cohort month),
           month_offset = 1 (1 month later),
           month_offset = 2, etc.
       - Calculate month_offset as the difference in months between
         first_login and login_date.

   Output columns:
     cohort_month, month_offset, active_users

   Requirements:
     - Order results by cohort_month ascending, then month_offset ascending.
========================================================================= */

WITH FirstLogins AS (
    SELECT 
        user_id,
        MIN(login_date) AS first_login
    FROM UserLogins
    GROUP BY user_id
),
Cohorts AS (
    SELECT 
        fl.user_id,
        FORMAT(fl.first_login, 'yyyy-MM') AS cohort_month,
        ul.login_date,
        DATEDIFF(MONTH, fl.first_login, ul.login_date) AS month_offset
    FROM FirstLogins fl
    JOIN UserLogins ul ON fl.user_id = ul.user_id
),
ActiveUsers AS (
    SELECT 
        cohort_month,
        month_offset,
        COUNT(DISTINCT user_id) AS active_users
    FROM Cohorts
    GROUP BY cohort_month, month_offset
)
SELECT 
    cohort_month,
    month_offset,
    active_users
FROM ActiveUsers
ORDER BY cohort_month ASC, month_offset ASC;