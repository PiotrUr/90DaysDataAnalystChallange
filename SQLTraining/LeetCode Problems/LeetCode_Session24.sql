
/*
LeetCode 24th Session
Created 2025-08-26 by PiotrUr
*/

/*
3451. Find Invalid IP Addresses (Hard)
https://leetcode.com/problems/find-invalid-ip-addresses/description/
*/

WITH ip_parts AS (
    SELECT
        l.ip,
        ip_clean = LTRIM(RTRIM(l.ip)),
        dot_count = LEN(l.ip) - LEN(REPLACE(l.ip, '.', '')),
        a = PARSENAME(LTRIM(RTRIM(l.ip)), 4),
        b = PARSENAME(LTRIM(RTRIM(l.ip)), 3),
        c = PARSENAME(LTRIM(RTRIM(l.ip)), 2),
        d = PARSENAME(LTRIM(RTRIM(l.ip)), 1)
    FROM logs AS l
),
invalids AS (
    SELECT
        ip,
        is_invalid =
            CASE
                WHEN dot_count <> 3 THEN 1
                WHEN a IS NULL OR b IS NULL OR c IS NULL OR d IS NULL
                     OR TRY_CONVERT(int, a) IS NULL
                     OR TRY_CONVERT(int, b) IS NULL
                     OR TRY_CONVERT(int, c) IS NULL
                     OR TRY_CONVERT(int, d) IS NULL
                THEN 1
                WHEN (LEN(a) > 1 AND LEFT(a,1) = '0')
                  OR (LEN(b) > 1 AND LEFT(b,1) = '0')
                  OR (LEN(c) > 1 AND LEFT(c,1) = '0')
                  OR (LEN(d) > 1 AND LEFT(d,1) = '0')
                THEN 1
                WHEN TRY_CONVERT(int, a) > 255
                  OR TRY_CONVERT(int, b) > 255
                  OR TRY_CONVERT(int, c) > 255
                  OR TRY_CONVERT(int, d) > 255
                THEN 1
                ELSE 0
            END
    FROM ip_parts
)
SELECT
    ip,
    COUNT(*) as invalid_count
FROM invalids
WHERE is_invalid = 1
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC

/*
3436. Find Valid Emails (Easy)
https://leetcode.com/problems/find-valid-emails/description/
*/

SELECT 
    [user_id],
    email
FROM Users
WHERE 
    LEN(email) - LEN(REPLACE(email, '@', '')) = 1
    AND email LIKE '%.com'
    AND LEFT(email, CHARINDEX('@', email) - 1) NOT LIKE '%[^a-zA-Z0-9_]%'
    AND SUBSTRING(
            email,
            CHARINDEX('@', email) + 1,
            LEN(email) - CHARINDEX('@', email) - 4
        ) NOT LIKE '%[^a-zA-Z]%'
ORDER BY [user_id]

/*
1517. Find Users With Valid E-Mails (Easy)
https://leetcode.com/problems/find-users-with-valid-e-mails/description/
*/

SELECT
    [user_id],
    name,
    mail
FROM Users
WHERE
    LEN(mail) - LEN(REPLACE(mail, '@', '')) = 1
    AND RIGHT(mail, LEN('@leetcode.com')) COLLATE Latin1_General_CS_AS = '@leetcode.com'
    AND CHARINDEX('@', mail) > 1
    AND SUBSTRING(mail, 1, 1) LIKE '[A-Za-z]'
    AND LEFT(mail, CHARINDEX('@', mail) - 1) NOT LIKE '%[^A-Za-z0-9_.-]%'
ORDER BY [user_id]
