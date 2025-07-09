-- Recursive CTE: Traverse films by shared genre
-- Starts from each film and recursively finds others within the same genre
-- Uses an array path to track visited film_ids and avoid cycles
-- Depth is incremented at each recursion level

WITH RECURSIVE category_film AS (
    SELECT
    film_id AS id,
    title AS movie,
    category AS genre, 
    0 AS depth,
    ARRAY[film_id] AS path
    FROM film f
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    
    UNION ALL 

    SELECT 
    f.film_id AS id,
    f.title AS movie,
    c.name AS genre,
    depth + 1,
    path || f.film_id
    FROM category_film
    INNER JOIN category c ON category_film.genre =  c.name
    INNER JOIN film_category fc ON c.category_id = fc.category_id
    INNER JOIN film f ON fc.film_id = f.film_id
    WHERE film_id != ALL(path)
)
SELECT * FROM category_film;
