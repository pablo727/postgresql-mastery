-- 📊 Ranks customers by total rental spend
-- per country using CTEs and window functions.
-- Filters countries with at least 5 customers
-- and returns top 2 spenders per country.

WITH cte1 AS (
    SELECT
        c.first_name || ' ' || c.last_name AS fullname,
        co.country country,
        SUM(p.amount) total_spent,
        COUNT(r.rental_id) rental_count
    FROM customer c
    INNER JOIN rental r ON c.customer_id = r.customer_id
    INNER JOIN payment_p2022_01 p ON r.rental_id = p.rental_id
    INNER JOIN address a ON c.address_id = a.address_id
    INNER JOIN city ct ON a.city_id = ct.city_id
    INNER JOIN country co ON ct.country_id = co.country_id
    GROUP BY fullname, co.country
),
cte2 AS (
    SELECT 
        fullname,
        country,
        total_spent,
        rental_count,
        RANK() OVER(PARTITION BY cte1.country ORDER BY cte1.total_spent DESC) AS rank
    FROM cte1 
),
cte3 AS (
    SELECT  
        cte1.country
    FROM cte1
    INNER JOIN cte2 ON cte1.country = cte2.country
    GROUP BY cte1.country
    HAVING COUNT(*) >= 5
)

SELECT 
    fullname,
    country,
    total_spent,
    rental_count,
    rank
FROM cte2
WHERE rank <= 2
AND country IN (SELECT country FROM cte3)
ORDER BY country;

