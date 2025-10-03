--------------EXPERIMENT-6-----------
------------------------MEDIUM PROBLEM----------------------------
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    gender VARCHAR(10)
);

-- Sample data
INSERT INTO employees (emp_name, gender) VALUES
('Tanmay', 'Male'),
('Aniket', 'Female'),
('Jyoti', 'Male'),
('Rohan', 'Female'),
('Keshav', 'Male');

select * from EMPLOYEES;
----CREATING A PROCEDURE----
CREATE OR REPLACE PROCEDURE count_employees_by_gender(
     IN input_gender VARCHAR,
	 OUT total_count int
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(*) INTO total_count
    FROM employees
    WHERE gender = input_gender;
END;
$$;

---CALLING THE PROCEDURE-----
DO $$
DECLARE
    result INT;
BEGIN
    CALL count_employees_by_gender('Male', result);
    RAISE NOTICE 'TOTAL EMPLOYEES OF GENDER Male ARE %', result;
END;
$$;


---------------------------HARD PROBLEM -----------------------------------
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2),
    quantity_remaining INT,
    quantity_sold INT DEFAULT 0
);

INSERT INTO products (product_name, price, quantity_remaining) VALUES
('Smartphone', 30000, 50),
('Tablet', 20000, 30),
('Laptop', 60000, 20);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT,
    total_price NUMERIC(10,2),
    sale_date TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE PROCEDURE place_order(
    IN p_product_id INT,
    IN p_quantity INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    available_stock INT;
    product_price NUMERIC(10,2);
BEGIN
    SELECT quantity_remaining, price
    INTO available_stock, product_price
    FROM products
    WHERE product_id = p_product_id;

    IF available_stock IS NULL THEN
        RAISE NOTICE 'Product ID % does not exist!', p_product_id;
    ELSIF available_stock >= p_quantity THEN
        -- LOGGING THE ORDER
        INSERT INTO sales (product_id, quantity, total_price)
        VALUES (p_product_id, p_quantity, p_quantity * product_price);

        UPDATE products
        SET quantity_remaining = quantity_remaining - p_quantity,
            quantity_sold = quantity_sold + p_quantity
        WHERE product_id = p_product_id;

        RAISE NOTICE 'Product sold successfully!';
    ELSE
        RAISE NOTICE 'Insufficient Quantity Available!';
    END IF;
END;
$$;


CALL PLACE_ORDER(2,20); --PRODUCT SOLD SUCCESSFULLY AND QUANTITY_REMAINING COLUMN SET TO -20 AND DATA LOGGED TO SALES TABLE
SELECT * FROM SALES;
SELECT * FROM PRODUCTS;
CALL PLACE_ORDER(3,100); --INSUFFICIENT QUANTITY AVAILABLE

