
/*
LeetCode 2nd Session
Created 2025-06-07 by PiotrUr
*/

/*
176. Second Highest Salary (Medium)
https://leetcode.com/problems/second-highest-salary/description/
*/

SELECT
    MAX(salary) as SecondHighestSalary
FROM
    Employee
WHERE
    salary NOT IN (SELECT MAX(salary)
                   FROM Employee);

/*
177. Nth Highest Salary (Medium)
https://leetcode.com/problems/nth-highest-salary/description/
*/

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
    SELECT Salary 
    FROM Employee e1
    WHERE 
        (N - 1) = (SELECT COUNT(DISTINCT(Salary)) 
                   FROM Employee e2 
                   WHERE e2.Salary > e1.Salary )
  );
END;

--Faster Version using dense_rank()

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      SELECT salary 
      FROM
      (
      select salary,
      dense_rank() OVER (order by salary desc) as rnk
      FROM Employee) as ranked
      where rnk = N
      LIMIT 1
  );
END

/*
197. Rising Temperature (Easy)
https://leetcode.com/problems/rising-temperature/description/
*/

SELECT
    w1.id
FROM
    Weather w1, Weather w2
WHERE
    DATEDIFF(w1.recordDate,w2.recordDate) = 1 AND
    w1.temperature > w2.temperature