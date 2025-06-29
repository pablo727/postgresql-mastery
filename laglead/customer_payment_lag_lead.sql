-- Show previous and next payment amounts per customer using LAG and LEAD,
-- and calculate difference from previous payment.
WITH cte AS(
SELECT 
p.customer_id cust_id,
p.payment_date pay_date,
p.amount amount,
LAG(p.amount) OVER(PARTITION BY customer_id ORDER BY p.payment_date) previous_amount,
LEAD(p.amount) OVER(PARTITION BY customer_id ORDER BY p.payment_date) next_amount
FROM payment p
)
SELECT
cust_id,
pay_date,
amount,
previous_amount,
next_amount,
(amount - COALESCE(previous_amount, 0)) difference_amount
FROM cte
ORDER BY cust_id, pay_date;
