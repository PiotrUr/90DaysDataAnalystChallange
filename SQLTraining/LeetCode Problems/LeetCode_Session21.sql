
/*
LeetCode 21st Session
Created 2025-08-23 by PiotrUr
*/

/*
3465. Find Products with Valid Serial Numbers (Easy)
https://leetcode.com/problems/find-products-with-valid-serial-numbers/description/
*/

SELECT product_id, product_name, description
FROM products
WHERE 
    description COLLATE Latin1_General_CS_AS LIKE '% SN[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' OR
    description COLLATE Latin1_General_CS_AS LIKE '% SN[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9] %' OR
    description COLLATE Latin1_General_CS_AS LIKE 'SN[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9] %'
ORDER BY product_id

/*
3475. DNA Pattern Recognition  (Medium)
https://leetcode.com/problems/dna-pattern-recognition/description/
*/

SELECT
    sample_id,
    dna_sequence,
    species,
    CASE
        WHEN dna_sequence LIKE 'ATG%' THEN 1
        ELSE 0
    END as has_start,
    CASE
        WHEN 
            dna_sequence LIKE '%TAA' OR
            dna_sequence LIKE '%TAG' OR
            dna_sequence LIKE '%TGA'
            THEN 1
        ELSE 0
    END as has_stop,
    CASE
        WHEN dna_sequence LIKE '%ATAT%' THEN 1
        ELSE 0
    END as has_atat,
    CASE
        WHEN dna_sequence LIKE '%GGG%' THEN 1
        ELSE 0
    END as has_ggg
FROM Samples
ORDER BY sample_id

/*
3482. Analyze Organization Hierarchy  (Hard)
https://leetcode.com/problems/dna-pattern-recognition/description/
*/

WITH Levels AS (
    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.salary,
        1 AS [level]
    FROM Employees e
    WHERE e.manager_id IS NULL

    UNION ALL

    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.salary,
        l.level + 1
    FROM Employees e
    JOIN Levels l
      ON e.manager_id = l.employee_id
),
Closure AS (
    SELECT
        e.employee_id AS manager_id,
        e.employee_id AS subordinate_id,
        e.salary      AS subordinate_salary
    FROM Employees e

    UNION ALL

    SELECT
        c.manager_id,
        e.employee_id,
        e.salary
    FROM Closure c
    JOIN Employees e
      ON e.manager_id = c.subordinate_id
),
Agg AS (
    SELECT
        manager_id AS employee_id,
        COUNT(*) - 1         AS team_size,
        SUM(subordinate_salary) AS budget
    FROM Closure
    GROUP BY manager_id
)
SELECT
    l.employee_id,
    l.employee_name,
    l.level,
    a.team_size,
    a.budget
FROM Levels l
JOIN Agg a
  ON a.employee_id = l.employee_id
ORDER BY
    l.level ASC,
    a.budget DESC,
    l.employee_name ASC