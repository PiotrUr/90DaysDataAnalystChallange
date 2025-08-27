
/*
LeetCode 25th Session
Created 2025-08-27 by PiotrUr
*/

/*
3642. Find Books with Polarized Opinions (Easy)
https://leetcode.com/problems/find-books-with-polarized-opinions/description/
*/

WITH stats AS (
    SELECT
        rs.book_id,
        COUNT(*)                                          as total_sessions,
        MIN(rs.session_rating)                            as min_rating,
        MAX(rs.session_rating)                            as max_rating,
        SUM(CASE WHEN rs.session_rating <= 2
                   OR rs.session_rating >= 4 THEN 1 ELSE 0 END) as extreme_cnt,
        MAX(CASE WHEN rs.session_rating >= 4 THEN 1 ELSE 0 END)  as has_high,
        MAX(CASE WHEN rs.session_rating <= 2 THEN 1 ELSE 0 END)  as has_low
    FROM reading_sessions rs
    GROUP BY rs.book_id
),
scored AS (
    SELECT
        s.book_id,
        rating_spread = s.max_rating - s.min_rating,
        polarization_score = CAST(1.0 * s.extreme_cnt / NULLIF(s.total_sessions, 0) AS DECIMAL(5,2)),
        s.total_sessions,
        s.has_high,
        s.has_low
    FROM stats s
)
SELECT
    b.book_id,
    b.title,
    b.author,
    b.genre,
    b.pages,
    scored.rating_spread,
    scored.polarization_score
FROM scored
JOIN books b
  ON b.book_id = scored.book_id
WHERE
    scored.total_sessions >= 5
    AND scored.has_high = 1
    AND scored.has_low  = 1
    AND scored.polarization_score >= 0.60
ORDER BY
    scored.polarization_score DESC,
    b.title DESC;

/*
3586. Find COVID Recovery Patients (Medium)
https://leetcode.com/problems/find-covid-recovery-patients/submissions/1750711795/
*/

WITH first_pos AS (
    SELECT
        ct.patient_id,
        MIN(ct.test_date) as first_positive_date
    FROM covid_tests ct
    WHERE ct.result = 'Positive'
    GROUP BY ct.patient_id
),
first_neg_after AS (
    SELECT
        fp.patient_id,
        MIN(ct.test_date) as first_negative_after_pos
    FROM first_pos fp
    JOIN covid_tests ct
      ON ct.patient_id = fp.patient_id
     AND ct.result = 'Negative'
     AND ct.test_date > fp.first_positive_date
    GROUP BY fp.patient_id
)
SELECT
    p.patient_id,
    p.patient_name,
    p.age,
    DATEDIFF(DAY, fp.first_positive_date, fn.first_negative_after_pos) as recovery_time
FROM first_pos fp
JOIN first_neg_after fn
  ON fn.patient_id = fp.patient_id
JOIN patients p
  ON p.patient_id = fp.patient_id
ORDER BY
    recovery_time ASC,
    p.patient_name ASC