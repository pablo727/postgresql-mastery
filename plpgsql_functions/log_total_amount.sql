-- Logs total amount spent by a customer if it exceeds the given threshold.
-- Inserts a message into the customer_logs table.

CREATE OR REPLACE FUNCTION log_total_amount (
    customer_id_input NUMERIC, threshold INT
    )
RETURNS void $$
DECLARE 
    total_amount NUMERIC
BEGIN
    SELECT SUM(amount) INTO total_amount FROM payment
    WHERE customer_id = customer_id_input
    GROUP BY customer_id;
    IF COALESCE(total_amount, 0) >= threshold
    THEN
        INSERT INTO customer_logs(
            customer_id, message, logged_at
            )
        VALUES (customer_id_input, 'Total spent: ' || total_amount, now());
    END IF;
END;
$$ LANGUAGE plpgsql;

