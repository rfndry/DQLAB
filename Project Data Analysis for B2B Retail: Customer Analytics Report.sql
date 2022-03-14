--Memahami Table
SELECT * FROM orders_1 LIMIT 5;
SELECT * FROM orders_2 LIMIT 5;
SELECT * FROM customer LIMIT 5;

--Total penjualan dan revenue pada q1 & q2
SELECT
  SUM(quantity) AS total_penjualan, 
  SUM(quantity*priceEach) AS revenue
FROM
  orders_1
WHERE 
  status = 'shipped';
SELECT 
  SUM(quantity) AS total_penjualan, 
  SUM(quantity*priceEach) AS revenue
FROM 
  orders_2
WHERE 
  status = 'shipped';

--Menghitung persentas keseluruhan penjualan
SELECT 
  quarter, 
  SUM(quantity) AS total_penjualan,
  SUM(quantity*priceEach) AS revenue
FROM
  (
    SELECT 
      orderNumber, 
      status, 
      quantity, 
      priceEach, '1' AS quarter
    FROM 
      orders_1
    UNION
    SELECT 
      orderNumber,
      status, 
      quantity,
      priceEach, '2' AS quarter
    FROM 
      orders_2
  ) AS table_a
WHERE
  status = 'Shipped'
GROUP BY
  quarter;
  
--Menghitung penambahan customers
SELECT 
  quarter, 
  COUNT(DISTINCT customerID) AS total_customers
FROM 
  (
    SELECT
      customerID, 
      createDate,
      QUARTER(createDate) AS quarter
    FROM 
      customer
    WHERE 
      createDate BETWEEN '2004-01-01' AND '2004-06-30'
  ) AS tabel_b
GROUP BY 
  quarter;

--Menghitung customers yang melakukan transaksi
SELECT 
  quarter, 
  COUNT(DISTINCT customerID) AS total_customers
FROM
(
  SELECT customerID, createDate, QUARTER(createDate) AS quarter
  FROM customer
  WHERE createDate BETWEEN '2004-01-01' AND '2004-06-30'
) AS tabel_b
WHERE 
  customerID IN 
    (
    SELECT DISTINCT customerID FROM orders_1 
    UNION
    SELECT DISTINCT customerID FROM orders_2
    )
GROUP BY 
  quarter;
  
--Category product yang paling banyak diorder pada q2
SELECT 
  *
FROM
  ( 
    SELECT 
      categoryID,
      COUNT(DISTINCT orderNumber) AS total_order,
      SUM(quantity) AS total_penjualan
    FROM 
      (
        SELECT 
          productCode,
          orderNumber,
          quantity,
          status,
          LEFT(productCode,3) AS categoryID
        FROM 
          orders_2
        WHERE 
          status = 'Shipped'
      ) AS tabel_c
    GROUP BY 
      categoryID
  ) AS c
ORDER BY 
  total_order DESC;
  
--Jumlah customer yang aktif bertransaksi setelah transaksi pertamanya

#Menghitung total unik customers yang transaksi di quarter_1
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;
#output = 25

SELECT
  '1' AS quarter, 
  COUNT(DISTINCT customerID)*100/25 AS Q2
FROM 
  orders_1
WHERE 
  customerID IN 
    (
      SELECT 
        DISTINCT customerID 
      FROM 
        orders_2
    );
