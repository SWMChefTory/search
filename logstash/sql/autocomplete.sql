SELECT
    all_text.market,
    all_text.text,
    'recipe' AS scope,
    CAST(ROUND(SUM(all_text.weight)) AS UNSIGNED) AS count
FROM (
    SELECT
        LOWER(r.market) AS market,
        yi.title AS text,
        1.0 AS weight
    FROM recipe r
    LEFT JOIN recipe_youtube_meta yi ON r.id = yi.recipe_id
    WHERE r.recipe_status = 'SUCCESS' AND yi.title IS NOT NULL

    UNION ALL

    SELECT
        LOWER(r.market) AS market,
        yi.channel_title AS text,
        0.5 AS weight
    FROM recipe r
    LEFT JOIN recipe_youtube_meta yi ON r.id = yi.recipe_id
    WHERE r.recipe_status = 'SUCCESS' AND yi.channel_title IS NOT NULL

    UNION ALL

    SELECT
        LOWER(r.market) AS market,
        i.name AS text,
        1.0 AS weight
    FROM recipe_ingredient i
    JOIN recipe r ON i.recipe_id = r.id
    WHERE r.recipe_status = 'SUCCESS'

    UNION ALL

    SELECT
        LOWER(r.market) AS market,
        t.tag AS text,
        1.0 AS weight
    FROM recipe_tag t
    JOIN recipe r ON t.recipe_id = r.id
    WHERE r.recipe_status = 'SUCCESS'

    UNION ALL

    SELECT
        LOWER(r.market) AS market,
        CONCAT(rdm.servings, '인분') AS text,
        0.1 AS weight
    FROM recipe_detail_meta rdm
    JOIN recipe r ON rdm.recipe_id = r.id
    WHERE r.recipe_status = 'SUCCESS'
      AND rdm.servings IS NOT NULL
) AS all_text
GROUP BY all_text.market, all_text.text;