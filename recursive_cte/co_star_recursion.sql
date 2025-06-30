-- Recursive CTE to find all actors connected to Nick Wahlberg via shared films.
-- One of the toughest joins I’ve done so far.
-- Took several iterations to get right. Keeping it here as part of my SQL journey.

WITH RECURSIVE cte AS (
    SELECT
    a1.actor_id AS star_actor_id,
    a2.actor_id AS co_star_id,
    f.film_id,
    1 as depth
    FROM film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
    JOIN actor a1 ON fa1.actor_id = a1.actor_id
    JOIN actor a2 ON a2.actor_id = fa2.actor_id
    JOIN film f ON f.film_id = fa1.film_id
    WHERE a1.first_name = 'Nick' 
    AND a1.last_name = 'Wahlberg'
    AND a1.actor_id != a2.actor_id
    
    UNION ALL

    SELECT
    cte.star_actor_id,
    fa2.actor_id AS co_star_id,
    f.film_id,
    cte.depth + 1
    FROM cte
    JOIN film_actor fa1 ON cte.co_star_id = fa1.actor_id
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
    JOIN film f ON f.film_id = fa1.film_id
    WHERE fa1.actor_id != fa2.actor_id
)
SELECT DISTINCT 
a.first_name || ' ' || a.last_name AS connected_actor,
depth
FROM cte
JOIN actor a ON cte.co_star_id = a.actor_id
ORDER BY depth, connected_actor;
