
/*
LeetCode 27th Session
Created 2025-08-29 by PiotrUr
*/

/*
3601. Find Drivers with Improved Fuel Efficiency (Medium)
https://leetcode.com/problems/find-drivers-with-improved-fuel-efficiency/description/
*/

WITH FirstHalfEfficiency AS (
    SELECT
        driver_id,
        SUM((distance_km)/(fuel_consumed)) / COUNT(*) as efficiency
    FROM trips
    WHERE MONTH(trip_date) BETWEEN 1 AND 6
    GROUP BY driver_id
),
SecondHalfEfficiency AS (
    SELECT
        driver_id,
        SUM((distance_km)/(fuel_consumed)) / COUNT(*) as efficiency
    FROM trips
    WHERE MONTH(trip_date) BETWEEN 7 AND 12
    GROUP BY driver_id
)
SELECT
    h1.driver_id,
    d.driver_name,
    ROUND(h1.efficiency, 2) as first_half_avg,
    ROUND(h2.efficiency, 2) as second_half_avg,
    ROUND(h2.efficiency - h1.efficiency, 2) as efficiency_improvement
FROM FirstHalfEfficiency h1
INNER JOIN SecondHalfEfficiency h2 ON h1.driver_id = h2.driver_id
LEFT JOIN drivers d ON h1.driver_id = d.driver_id
WHERE h1.efficiency < h2.efficiency
ORDER BY efficiency_improvement DESC, d.driver_name

/*
3611. Find Overbooked Employees (Medium)
https://leetcode.com/problems/find-overbooked-employees/
*/

SET DATEFIRST 1;
WITH MeetingTimeWeekly AS (
    SELECT
        employee_id,
        DATEPART(week, meeting_date) as week_num,
        SUM(duration_hours) as hours_on_meetings,
        CASE
            WHEN 40 - SUM(duration_hours) < 20 THEN 1
            ELSE 0
        END as meeting_heavy
    FROM meetings
    GROUP BY employee_id, DATEPART(week, meeting_date)
),
MeetingHeavyEmployees AS (
    SELECT
        employee_id,
        SUM(meeting_heavy) as meeting_heavy_weeks 
    FROM MeetingTimeWeekly
    GROUP BY employee_id
    HAVING SUM(meeting_heavy) > 1
)
SELECT
    m.employee_id,
    e.employee_name,
    e.department,
    m.meeting_heavy_weeks
FROM MeetingHeavyEmployees m
LEFT JOIN employees e ON m.employee_id = e.employee_id
ORDER BY m.meeting_heavy_weeks DESC, e.employee_name