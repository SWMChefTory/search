SELECT
    BIN_TO_UUID(r.id) AS id,
    LOWER(r.market) AS market,
    yi.title,
    yi.channel_title,
    'recipe' AS scope,
    CONCAT(rdm.servings, '인분') AS servings_text,
    (
        SELECT COALESCE(JSON_ARRAYAGG(ri.name), JSON_ARRAY())
        FROM recipe_ingredient ri
        WHERE ri.recipe_id = r.id
    ) AS ingredients_json,
    (
        SELECT COALESCE(JSON_ARRAYAGG(rt.tag), JSON_ARRAY())
        FROM recipe_tag rt
        WHERE rt.recipe_id = r.id
    ) AS tags_json,
    r.created_at,
    r.updated_at
FROM recipe r
LEFT JOIN recipe_youtube_meta yi ON r.id = yi.recipe_id
LEFT JOIN recipe_detail_meta rdm ON r.id = rdm.recipe_id
WHERE
    r.recipe_status = 'SUCCESS'
    AND r.updated_at > :sql_last_value
ORDER BY r.updated_at ASC;