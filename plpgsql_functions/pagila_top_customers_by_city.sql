-- Function: top_customers_by_city(city_name TEXT)
-- Description: Returns the top 3 customers by total rental payments
--              for a given city in the Pagila database.
-- Input: city_name (TEXT) - the name of the city to filter customers by.
-- Output: TABLE with columns fullname (TEXT) and total_amount (NUMERIC).
-- Notes: Uses payment_p2022_01 table for payments; adjust if needed.

CREATE OR REPLACE FUNCTION top_customers_by_city(city_name TEXT)
RETURNS TABLE(fullname TEXT, total_amount NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN 
    RETURN QUERY SELECT
        c.first_name || ' ' || c.last_name AS fullname,
        SUM(p.amount) AS total_amount
    FROM customer c
    INNER JOIN address a ON c.address_id = a.address_id
    INNER JOIN city ct ON a.city_id = ct.city_id
    INNER JOIN payment_p2022_01 p ON c.customer_id = p.customer_id
    WHERE ct.city = city_name
    GROUP BY c.first_name, c.last_name
    ORDER BY total_amount DESC
    LIMIT 3; 
END;
$$;
