-- Divide customers into 5 payment quintiles using NTILE window function
WITH cte AS (
    SELECT
    c.customer_id cust_id,
    c.first_name || ' ' || c.last_name fullname,
    SUM(p.amount) total_payment
    FROM payment p
    INNER JOIN customer c ON p.customer_id = c.customer_id
    GROUP BY c.customer_id
)
SELECT
cust_id,
fullname,
NTILE(5) OVER(ORDER BY total_payment DESC) payment_quintile
FROM cte
ORDER BY total_payment DESC;