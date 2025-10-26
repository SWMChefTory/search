SELECT
    all_text.text,
    COUNT(*) AS count
FROM (
    SELECT
    yi.title AS text
    FROM
    recipe r
    LEFT JOIN
    recipe_youtube_meta yi ON r.id = yi.recipe_id
    WHERE
    r.recipe_status = 'SUCCESS' AND yi.title IS NOT NULL

    UNION ALL

    SELECT
    t.tag AS text
    FROM
    recipe_tag t
    JOIN
    recipe r ON t.recipe_id = r.id
    WHERE
    r.recipe_status = 'SUCCESS'
    ) AS all_text
GROUP BY
    all_text.text;