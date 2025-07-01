-- PostgreSQL example: 
-- This script sets up tables, creates a trigger for product logging, 
-- and demonstrates a MERGE statement for updating or inserting products.

CREATE TABLE categories ( 
    id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name TEXT,
    category_id INT REFERENCES categories(id)
    ON DELETE SET NULL
);

CREATE TABLE product_logs (
    id SERIAL PRIMARY KEY,
    log TEXT,
    logged_at TIMESTAMP DEFAULT now()
);

CREATE FUNCTION product_log_insert() RETURNS trigger AS $$
BEGIN
    INSERT INTO product_logs(log) VALUES ('Product added: ' || NEW.name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_product_insert
AFTER INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION product_log_insert();

MERGE INTO products AS p
USING (VALUES (1, 'apple', 1), (2, 'orange', 2)) AS new_product(id, name, category_id)
ON p.id = new_product.id
WHEN MATCHED THEN
    UPDATE SET name = new_product.name, category_id = new_product.category_id
WHEN NOT MATCHED THEN
    INSERT (id, name, category_id) VALUES (new_product.id, new_product.name, new_product.category_id);
