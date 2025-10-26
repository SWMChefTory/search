SELECT
    BIN_TO_UUID(r.id) AS id,
    yi.title,
    (
        SELECT
            COALESCE(JSON_ARRAYAGG(ri.name), JSON_ARRAY())
        FROM
            recipe_ingredient ri
        WHERE
            ri.recipe_id = r.id
    ) AS ingredients_json,
    (
        SELECT
            COALESCE(JSON_ARRAYAGG(rt.tag), JSON_ARRAY())
        FROM
            recipe_tag rt
        WHERE
            rt.recipe_id = r.id
    ) AS tags_json,
    r.created_at,
    r.updated_at
FROM
    recipe r
LEFT JOIN (
    SELECT recipe_id, title
    FROM recipe_youtube_meta
) yi ON r.id = yi.recipe_id
WHERE
    r.recipe_status = 'SUCCESS'
    AND r.updated_at > :sql_last_value
ORDER BY r.updated_at ASC