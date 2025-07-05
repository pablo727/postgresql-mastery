-- Query to calculate film count, rank, and cumulative distribution by rating
SELECT
rating,
COUNT(*) film_count,
ROW_NUMBER() OVER(ORDER BY film_count DESC) rank,
CUME_DIST() OVER(ORDER BY film_count DESC) cumulative_distribution
FROM film
GROUP BY rating
HAVING film_count > 200;
