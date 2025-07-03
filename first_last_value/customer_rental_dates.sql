-- Window function exercise using FIRST_VALUE() and LAST_VALUE() 
-- Shows each customer's first and last rental dates from the rental table in Pagila

SELECT 
    customer_id,
    rental_id,
    rental_date,
FIRST_VALUE(rental_date) OVER(
    PARTITION BY customer_id
    ORDER BY rental_date ASC) AS first_rentals,
LAST_VALUE(rental_date) OVER(
    PARTITION BY customer_id
    ORDER BY rental_date ASC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_rentals
FROM rental;
