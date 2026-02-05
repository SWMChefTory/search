SELECT
    BIN_TO_UUID(r.id) AS id,
    r.updated_at
FROM
    recipe r
WHERE
    r.recipe_status IN ('BLOCK', 'FAILED')
    AND r.updated_at > :sql_last_value
ORDER BY r.updated_at ASC