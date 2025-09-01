-- Shows a customer's rental history in chronological order using a recursive CTE

WITH RECURSIVE rental_chain AS (
  -- Anchor
  SELECT customer_id, first_name, rental_id, rental_date, film.title, category.name, 1 AS level
  FROM rental
  INNER JOIN inventory i ON rental.inventory_id = i.inventory_id
  INNER JOIN film f ON i.film_id = f.film_id
  INNER JOIN film_category fc ON f.film_id = fc.film_id
  INNER JOIN category ca ON fc.category_id = ca.category_id
  WHERE customer_id = 1
  ORDER BY rental_date ASC
  LIMIT 1

  UNION ALL

  -- Recursive
  SELECT r.customer_id, rc.first_name, r.rental_id, r.rental_date, f.title, ca.name, rc.level + 1
  FROM rental r
  INNER JOIN rental_chain rc ON r.customer_id = rc.customer_id
  AND r.rental_date > rc.rental_date
  INNER JOIN inventory i ON r.inventory_id = i.inventory_id
  INNER JOIN film f ON i.film_id = f.film_id
  INNER JOIN film_category fc ON f.film_id = fc.film_id
  INNER JOIN category ca ON fc.category_id = ca.category_id
)
SELECT *
FROM rental_chain
WHERE level <= 10
ORDER BY rental_date ASC;