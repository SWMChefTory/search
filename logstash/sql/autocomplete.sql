SELECT
    all_text.text,
    CAST(ROUND(SUM(all_text.weight)) AS UNSIGNED) AS count
FROM (
    SELECT
        yi.title AS text,
        1.0 AS weight
    FROM
        recipe r
    LEFT JOIN
        recipe_youtube_meta yi ON r.id = yi.recipe_id
    WHERE
        r.recipe_status = 'SUCCESS' AND yi.title IS NOT NULL

    UNION ALL

    SELECT
        i.name AS text,
        1.0 AS weight
    FROM
        recipe_ingredient i
    JOIN
        recipe r ON i.recipe_id = r.id
    WHERE
        r.recipe_status = 'SUCCESS'

    UNION ALL

    SELECT
        t.tag AS text,
        1.0 AS weight
    FROM
        recipe_tag t
    JOIN
        recipe r ON t.recipe_id = r.id
    WHERE
        r.recipe_status = 'SUCCESS'
    
    UNION ALL
    
    SELECT
        CONCAT(rdm.servings, '인분') AS text,
        0.1 AS weight
    FROM
        recipe_detail_meta rdm
    JOIN
        recipe r ON rdm.recipe_id = r.id
    WHERE
        r.recipe_status = 'SUCCESS'
        AND rdm.servings IS NOT NULL
) AS all_text
GROUP BY all_text.text;