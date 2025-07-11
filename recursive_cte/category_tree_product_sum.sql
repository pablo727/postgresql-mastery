-- Recursively traverses category → subcategory tree,
-- joins with products, and aggregates total price.

WITH RECURSIVE category_subcategory AS(
    SELECT 
        category_id,
        name,
        parent_id,
        category_id AS root_category_id,
        0 AS depth
    FROM category c
    WHERE parent_id IS NULL

    UNION ALL

    SELECT 
        c.category_id,
        c.name,
        c.parent_id,
        cs.root_category_id,
        cs.depth + 1
    FROM category c
    INNER JOIN category_subcategory cs ON c.parent_id = cs.category_id
)

SELECT
    cs.category_id,
    cs.name,
    cs.parent_id,
    cs.root_category_id,
    cs.depth,
    SUM(price) total_spent
FROM category_subcategory cs
INNER JOIN product pr ON pr.category_id = category_subcategory.category_id
GROUP BY 
    cs.category_id,
    cs.name,
    cs.parent_id,
    cs.root_category_id,
    cs.depth
ORDER BY depth
LIMIT 10;

