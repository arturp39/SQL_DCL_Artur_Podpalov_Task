-- 1
CREATE USER rentaluser WITH PASSWORD 'rentalpassword';
GRANT CONNECT ON DATABASE dvd_rental_db TO rentaluser;

-- 2
GRANT SELECT ON customer TO rentaluser;

-- 3
CREATE ROLE rental_group;
GRANT rental_group TO rentaluser;

-- 4
GRANT INSERT, UPDATE ON TABLE rental TO rental_group;
SET ROLE rental_group;
SHOW ROLE;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (CURRENT_DATE, 120, 223, CURRENT_DATE, 4, NOW());

UPDATE rental SET return_date = '2024-02-05' WHERE rental_id = 2;

RESET ROLE;

-- 5
REVOKE INSERT ON TABLE rental FROM rental_group;
SET ROLE rentaluser;
SHOW ROLE;

-- should be denied
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (CURRENT_DATE, 321, 456, CURRENT_DATE, 5, NOW());

RESET ROLE;

-- 6
CREATE ROLE client_Hector_Poindexter LOGIN PASSWORD 'password_for_client';
GRANT SELECT ON rental TO client_Hector_Poindexter;
GRANT SELECT ON payment TO client_Hector_Poindexter;

SET ROLE client_Hector_Poindexter;

-- Query to verify that the user sees only their own data
SELECT * FROM rental WHERE customer_id = (SELECT customer_id FROM customer WHERE first_name = 'HECTOR' AND last_name = 'POINDEXTER');
SELECT * FROM payment WHERE customer_id = (SELECT customer_id FROM customer WHERE first_name = 'HECTOR' AND last_name = 'POINDEXTER');

RESET ROLE;

