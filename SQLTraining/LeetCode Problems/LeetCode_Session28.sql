
/*
LeetCode 28th Session
Created 2025-08-30 by PiotrUr
*/

/*
3374. First Letter Capitalization II (Hard)
https://leetcode.com/problems/first-letter-capitalization-ii/
*/

WITH SplitWords AS (
    SELECT 
        uc.content_id,
        uc.content_text,
        [value] AS word,
        ROW_NUMBER() OVER(PARTITION BY uc.content_id ORDER BY (SELECT NULL)) AS word_pos
    FROM user_content uc
    CROSS APPLY STRING_SPLIT(uc.content_text, ' ')
),
TransformWords AS (
    SELECT 
        content_id,
        content_text,
        word_pos,
        STRING_AGG(UPPER(LEFT(part, 1)) + LOWER(SUBSTRING(part, 2, LEN(part))), '-') 
            WITHIN GROUP (ORDER BY part_id) AS converted_word
    FROM (
        SELECT 
            sw.content_id,
            sw.content_text,
            sw.word_pos,
            part_id,
            [value] AS part
        FROM SplitWords sw
        CROSS APPLY STRING_SPLIT(sw.word, '-') p
        CROSS APPLY (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS part_id) r
    ) parts
    GROUP BY content_id, content_text, word_pos
),
Reconstructed AS (
    SELECT 
        content_id,
        content_text,
        STRING_AGG(converted_word, ' ') WITHIN GROUP (ORDER BY word_pos) AS converted_text
    FROM TransformWords
    GROUP BY content_id, content_text
)
SELECT 
    content_id,
    content_text AS original_text,
    converted_text
FROM Reconstructed
ORDER BY content_id;