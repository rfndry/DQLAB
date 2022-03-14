--Memahami Table
SELECT * FROM orders_1 LIMIT 5;
SELECT * FROM orders_2 LIMIT 5;
SELECT * FROM customer LIMIT 5;

--Total penjualan dan revenue pada q1 & q2
SELECT
  SUM(quantity) AS total_penjualan, 
  SUM(quantity*priceEach) AS revenue
FROM orders_1
WHERE status = 'shipped';
SELECT SUM(quantity) AS total_penjualan, 
SUM(quantity*priceEach) AS revenue
FROM orders_2
WHERE status = 'shipped';
