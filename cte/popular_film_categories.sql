-- List top 5 film categories by total rentals using a CTE
WITH cte AS (
    SELECT
     COUNT(*) AS rental_count,
     ct.name AS category
    FROM rental r
    INNER JOIN inventory i ON r.inventory_id = i.inventory_id
    INNER JOIN film f ON i.film_id = f.film_id
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category ct ON fc.category_id = ct.category_id
    GROUP BY ct.name
)
SELECT 
 category,
 rental_count
 FROM cte
 ORDER BY rental_count DESC
 LIMIT 5;
