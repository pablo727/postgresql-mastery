-- Demo: Using partial indexes to optimize filtered queries
-- Includes EXPLAIN ANALYZE to confirm index usage
-- Table: support_tickets (is_open, created_at)
-- Index: Partial on created_at where is_open = TRUE

CREATE INDEX idx_open_tickets_created
ON support_tickets(created_at)
WHERE is_open = TRUE;

SELECT * 
FROM support_tickets
WHERE is_open = TRUE 
ORDER BY created_at DESC;

EXPLAIN ANALYZE 
SELECT *
FROM support_tickets
WHERE is_open = TRUE
ORDER BY created_at DESC
LIMIT 10;
