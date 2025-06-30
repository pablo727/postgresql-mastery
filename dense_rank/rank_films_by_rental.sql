-- This query ranks movies by rental price within each category using DENSE_RANK().
-- It selects the top 3 films based on rental price in descending order, 
-- ensuring no gaps in the ranking sequence.

WITH cte1 AS (
    SELECT
    f.title movie_title,
    c.name category,
    SUM(f.rental_rate) rental_price
    FROM film f
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    GROUP BY f.title, c.name
),
cte2 AS (
SELECT 
movie_title,
category,
rental_price,
DENSE_RANK() OVER(PARTITION BY category ORDER BY rental_price DESC) rank
FROM cte1
)
SELECT
movie_title,
category,
rental_price,
rank
FROM cte2
WHERE rank <= 3
ORDER BY category, rank;
