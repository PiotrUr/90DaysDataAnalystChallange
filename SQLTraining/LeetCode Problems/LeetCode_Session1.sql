
/*
LeetCode 1st Session
Created 2025-06-04 by PiotrUr
*/

/*
175. Combine Two Tables
https://leetcode.com/problems/combine-two-tables/
*/

SELECT 
    a.firstName
    ,a.lastName
    ,b.city
    ,b.state
FROM
    Person a
LEFT JOIN Address b ON a.personId = b.personId

/*
181. Employees Earning More Than Their Managers
https://leetcode.com/problems/employees-earning-more-than-their-managers/description/
*/

SELECT
    a.name as Employee
FROM
    Employee a
LEFT JOIN
    Employee b ON a.managerId = b.id
WHERE
    a.salary > b.salary


/*
182. Duplicate Emails
https://leetcode.com/problems/duplicate-emails/description/
*/

SELECT
    email as Email
FROM
    Person
GROUP BY
    Email
HAVING
    COUNT(email)>1

/*
183. Customers Who Never Order
https://leetcode.com/problems/customers-who-never-order/
*/

Select
    c.name as Customers
FROM
    Customers c
LEFT JOIN Orders o ON c.id = o.customerID
WHERE
    o.customerID IS NULL

/*
196. Delete Duplicate Emails
https://leetcode.com/problems/delete-duplicate-emails/description/
*/

DELETE p FROM 
    Person p
    ,Person q 
WHERE 
    p.Id>q.Id AND 
    q.Email=p.Email