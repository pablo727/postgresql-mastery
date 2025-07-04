-- Top 5 film categories by total revenue using CTEs and window functions.
-- Based on Pagila dataset, partitioned table: payment_p2022_01.
-- Aggregates total revenue per category and ranks them by descending revenue.

WITH cte1 AS (
    SELECT
        c.name AS category,
        SUM(p.amount) AS total_revenue
    FROM payment_p2022_01 p
    INNER JOIN rental r ON p.rental_id = r.rental_id
    INNER JOIN inventory i ON r.inventory_id = i.inventory_id
    INNER JOIN film_category fc ON i.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.name
),
cte2 AS (
    SELECT
        category,
        total_revenue,
        RANK() OVER(ORDER BY total_revenue DESC) AS category_rank,
    FROM cte1
)
SELECT
    category,
    total_revenue,
    category_rank,
FROM cte2
WHERE category_rank <= 5
ORDER BY category_rank;

