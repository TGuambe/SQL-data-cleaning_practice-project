CREATE TABLE cafe_sales(transaction_id TEXT, item TEXT, quantity TEXT, price_per_unit TEXT, total_spent TEXT,
payment_method TEXT, location TEXT, transaction_date TEXT);

SELECT * FROM cafe_sales;

--1. Identify Duplicates
WITH duplicates AS(
SELECT *, ROW_NUMBER() OVER(PARTITION BY transaction_id, item, quantity, price_per_unit, total_spent, payment_method,
location, transaction_date) AS row_num FROM cafe_sales
)
SELECT * FROM duplicates 
WHERE row_num >1;

SELECT transaction_id, COUNT(*)
FROM cafe_sales 
GROUP BY transaction_id
HAVING COUNT(*) > 1;

--No Duplicates Found

--2. Standardisation
SELECT * FROM cafe_sales;

--Create staging Table
CREATE TABLE cafe_sales2(transaction_id TEXT, item TEXT, quantity TEXT, price_per_unit TEXT, total_spent TEXT,
payment_method TEXT, location TEXT, transaction_date TEXT);

INSERT INTO cafe_sales2
SELECT * FROM cafe_sales;

SELECT * FROM cafe_sales2;

--Removing Whitespace
SELECT *, TRIM(transaction_id) FROM cafe_sales2;
UPDATE cafe_sales2
SET transaction_id = TRIM(transaction_id);

SELECT DISTINCT(TRIM(item)) FROM cafe_sales2;
UPDATE cafe_sales2
SET item = TRIM(item);

SELECT DISTINCT(TRIM(quantity)) FROM cafe_sales2;
UPDATE cafe_sales2
SET quantity = TRIM(quantity);

SELECT *, TRIM(price_per_unit) FROM cafe_sales2;
UPDATE cafe_sales2
SET price_per_unit = TRIM(price_per_unit);

SELECT *, TRIM(total_spent) FROM cafe_sales2;
UPDATE cafe_sales2
SET total_spent = TRIM(total_spent);

SELECT *, (TRIM(payment_method)) FROM cafe_sales2;
UPDATE cafe_sales2
SET payment_method = TRIM(payment_method);

SELECT *, (TRIM(location)) FROM cafe_sales2;
UPDATE cafe_sales2
SET location = TRIM(location);

SELECT *, (TRIM(transaction_date)) FROM cafe_sales2;
UPDATE cafe_sales2
SET transaction_date = TRIM(transaction_date);

SELECT * FROM cafe_sales2;

--Dealing with ERROR & UNKNOWN values
--Items
SELECT * FROM cafe_sales2
WHERE item = 'ERROR'
OR item = 'UNKNOWN';

UPDATE cafe_sales2
SET item = NULL
WHERE item = 'ERROR'
OR item = 'UNKNOWN';

SELECT * FROM cafe_sales2;

--Quantity
SELECT * FROM cafe_sales2
WHERE quantity = 'ERROR'
OR quantity = 'UNKNOWN';

UPDATE cafe_sales2
SET quantity = NULL
WHERE quantity = 'ERROR'
OR quantity = 'UNKNOWN';

SELECT * FROM cafe_sales2;

--Price per Unit
SELECT * FROM cafe_sales2
WHERE price_per_unit = 'ERROR'
OR price_per_unit = 'UNKNOWN';

UPDATE cafe_sales2
SET price_per_unit = NULL
WHERE price_per_unit = 'ERROR'
OR price_per_unit = 'UNKNOWN';

SELECT * FROM cafe_sales2;

--total_spent
SELECT * FROM cafe_sales2
WHERE total_spent = 'ERROR'
OR total_spent = 'UNKNOWN';

UPDATE cafe_sales2
SET total_spent = NULL
WHERE total_spent = 'ERROR'
OR total_spent = 'UNKNOWN';

SELECT * FROM cafe_sales2;

--payment_method
SELECT * FROM cafe_sales2
WHERE payment_method = 'ERROR'
OR payment_method = 'UNKNOWN';

UPDATE cafe_sales2
SET payment_method = NULL
WHERE payment_method = 'ERROR'
OR payment_method = 'UNKNOWN';

SELECT * FROM cafe_sales2;

--location
SELECT * FROM cafe_sales2
WHERE location = 'ERROR'
OR location = 'UNKNOWN';

UPDATE cafe_sales2
SET location = NULL
WHERE location = 'ERROR'
OR location = 'UNKNOWN';

SELECT * FROM cafe_sales2;

--transaction_date
SELECT * FROM cafe_sales2
WHERE transaction_date = 'ERROR'
OR transaction_date = 'UNKNOWN';

UPDATE cafe_sales2
SET transaction_date = NULL
WHERE transaction_date = 'ERROR'
OR transaction_date = 'UNKNOWN';

SELECT * FROM cafe_sales2;

--Dealing with NULL values
SELECT * FROM cafe_sales2
WHERE quantity IS NULL
AND price_per_unit IS NOT NULL
AND total_spent IS NOT NULL;

ALTER TABLE cafe_sales2
ALTER COLUMN price_per_unit TYPE NUMERIC(10,2) USING price_per_unit::NUMERIC(10,2);

SELECT * FROM cafe_sales2;

ALTER TABLE cafe_sales2
ALTER COLUMN quantity TYPE INT USING quantity::INT,
ALTER COLUMN total_spent TYPE NUMERIC(10,2) USING total_spent::NUMERIC(10,2);

UPDATE cafe_sales2
SET quantity = total_spent/price_per_unit
WHERE quantity IS NULL
AND price_per_unit IS NOT NULL
AND total_spent IS NOT NULL;

SELECT * FROM cafe_sales2
WHERE price_per_unit IS NULL
AND quantity IS NOT NULL
AND total_spent IS NOT NULL;

UPDATE cafe_sales2
SET price_per_unit = total_spent/quantity
WHERE price_per_unit IS NULL
AND quantity IS NOT NULL
AND total_spent IS NOT NULL;

SELECT * FROM cafe_sales2;

SELECT * FROM cafe_sales2
WHERE total_spent IS NULL
AND quantity IS NOT NULL
AND price_per_unit IS NOT NULL;

UPDATE cafe_sales2
SET total_spent = price_per_unit*quantity
WHERE total_spent IS NULL
AND quantity IS NOT NULL
AND price_per_unit IS NOT NULL;

SELECT * FROM cafe_sales2;

ALTER TABLE cafe_sales2
ALTER COLUMN transaction_date TYPE DATE USING transaction_date::DATE;

SELECT * FROM cafe_sales2;

SELECT * FROM cafe_sales2
WHERE total_spent IS NULL
AND item IS NULL
AND price_per_unit IS NULL;

DELETE FROM cafe_sales2
WHERE total_spent IS NULL
AND item IS NULL
AND price_per_unit IS NULL;
