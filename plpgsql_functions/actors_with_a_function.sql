-- PL/pgSQL function to list actors whose last name starts with 'A'

CREATE  FUNCTION actors_with_a()
RETURNS VOID AS $$
    DECLARE
        actor_record RECORD;
    BEGIN
    FOR actor_record IN 
        SELECT first_name, last_name FROM actor 
        LOOP
        IF LEFT(actor_record.last_name, 1) = 'A' 
            THEN RAISE NOTICE 'Actor: %, %', actor_record.first_name, actor_record.last_name;
        END IF;
    END LOOP;
    END;
    $$ LANGUAGE plpgsql;