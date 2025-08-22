
/*
LeetCode 19th Session
Created 2025-08-22 by PiotrUr
*/

/*
601. Human Traffic of Stadium (Hard)
https://leetcode.com/problems/human-traffic-of-stadium/
*/

WITH TrafficCheck AS (
    SELECT
        id,
        visit_date,
        people,
        LEAD(people, 1) OVER (ORDER BY id) as n1_people,
        LEAD(people, 2) OVER (ORDER BY id) as n2_people,
        LAG(people, 1) OVER (ORDER BY id) as n_minus1_people,
        LAG(people, 2) OVER (ORDER BY id) as n_minus2_people
    FROM Stadium
)
SELECT
    id,
    visit_date,
    people
FROM TrafficCheck
WHERE 
    (people >= 100 AND
    n1_people >= 100 AND
    n2_people >= 100) 
    OR
    (people >= 100 AND
    n_minus1_people >= 100 AND
    n_minus2_people >= 100) 
    OR
    (
    n1_people >= 100 AND
    people >= 100 AND
    n_minus1_people >= 100)
ORDER BY id

/*
3421. Find Students Who Improved (Medium)
https://leetcode.com/problems/find-students-who-improved/
*/

WITH FirstScores AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY student_id, [subject] ORDER BY student_id, [subject], exam_date     ASC) as first_score_order
    FROM Scores
),
LatestScores AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY student_id, [subject] ORDER BY student_id, [subject], exam_date DESC) as latest_score_order
    FROM Scores
),
MultipleAttemptsSubjects AS (
    SELECT
        student_id,
        [subject]
    FROM Scores
    GROUP BY student_id, [subject]
    HAVING COUNT(*) > 1
)
SELECT
    s.student_id,
    s.subject,
    f.score as first_score,
    l.score as latest_score 
FROM MultipleAttemptsSubjects s
LEFT JOIN FirstScores f ON s.student_id = f.student_id AND s.subject = f.subject
LEFT JOIN LatestScores l ON s.student_id = l.student_id AND s.subject = l.subject
WHERE 
    first_score_order = 1 AND
    latest_score_order = 1 AND
    f.score < l.score