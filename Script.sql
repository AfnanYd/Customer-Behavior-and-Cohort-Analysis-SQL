-- Project: E-Commerce Customer Behavior & Cohort Analysis
-- Database System: PostgreSQL
-- Table Name: customer_transaction

  SELECT * FROM customer_transaction;
--DESCRIPTIVE ANALYS
--Berapa jumlah transaksi yang terjadi di tahun 2023?
  SELECT COUNT(*) AS jumlah_transaksi
  FROM customer_transaction
  WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31';
--Berapa jumlah customer uniqe di tahun 2023?
  SELECT COUNT (DISTINCT (customer_id)) AS jumlah_customer_unique
  FROM customer_transaction
  WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31';
--Berapa total revenue yang didapatkan di tahun 2023?
  SELECT SUM(purchase_amount_usd)
  FROM customer_transaction
--Ada berapa kategori product yang dijual di tahun 2023?
  SELECT COUNT(DISTINCT (category)) 
  FROM customer_transaction
  WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31'
--Ada Berapa product yang dijual di tahun 2023?
  SELECT COUNT(DISTINCT (item_purchased))
  FROM customer_transaction
  WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31'
--Berapa rata-rata umur customer yang bertransaksi di tahun 2023?
  SELECT ROUND(AVG(age))	AS average_customer_age
  FROM
  (
		SELECT DISTINCT customer_id, age
		FROM customer_transaction
		ORDER BY customer_id
  ) AS unique_customer

--Performance Sales & Growth Analysis
--Bagaimana overall performance GenggamData Store ditahun 2023 untuk jumlah order dan total sales ?
  SELECT 
		  EXTRACT(MONTH FROM order_date) AS Bulan,
		  COUNT (customer_id) AS jumlah_transaksi,
		  SUM (purchase_amount_usd) AS jumlah_sales
  FROM customer_transaction
  GROUP BY Bulan
  ORDER BY Bulan ASC
--Bagaimana overall performance berdasarkan kategori produk GenggamData Store ditahun 2023 untuk jumlah order dan total sales ?
  SELECT 
  		EXTRACT(MONTH FROM order_date) AS Bulan,
  		category,
  		COUNT (*) AS jumlah_transaksi,
  		SUM (purchase_amount_usd) AS jumlah_sales
  FROM customer_transaction
  GROUP BY Bulan, category
  ORDER BY Bulan,category ASC
---Total Order Performance per Category by Month 2023
  SELECT 
  		EXTRACT(MONTH FROM order_date) AS Bulan,
  		SUM(CASE WHEN category = 'Accessories' THEN 1 ELSE 0 END) AS Accessories,
  		SUM(CASE WHEN category = 'Clothing' THEN 1 ELSE 0 END) AS Clothing,
  		SUM(CASE WHEN category = 'Footwear' THEN 1 ELSE 0 END) AS Footwear,
  		SUM(CASE WHEN category = 'Outerwear' THEN 1 ELSE 0 END) AS Outerwear
  FROM customer_transaction
  GROUP BY Bulan
  ORDER BY Bulan ASC
---Total Sales Peformance per Category by Month 2023
  SELECT 
  		EXTRACT(MONTH FROM order_date) AS Bulan,
  		SUM(CASE WHEN category = 'Accessories' THEN purchase_amount_usd ELSE 0 END) AS Accessories,
  		SUM(CASE WHEN category = 'Clothing' THEN purchase_amount_usd ELSE 0 END) AS Clothing,
  		SUM(CASE WHEN category = 'Footwear' THEN purchase_amount_usd ELSE 0 END) AS Footwear,
  		SUM(CASE WHEN category = 'Outerwear' THEN purchase_amount_usd ELSE 0 END) AS Outerwear
  FROM customer_transaction
  GROUP BY Bulan
  ORDER BY Bulan ASC
--Bagaimana growth order dan sales GenggamData Store ditahun 2023 ?
  SELECT  
      Bulan,
  		ROUND(((jumlah_transaksi / LAG(jumlah_transaksi) OVER(ORDER BY Bulan))-1)*100,2) AS growth_order,
  		ROUND(((jumlah_sales / LAG(jumlah_sales) OVER(ORDER BY Bulan))-1)*100,2) AS growth_sales
  FROM 
  (
  	SELECT 
  			EXTRACT(MONTH FROM order_date) AS Bulan,
  			COUNT (*) :: numeric AS jumlah_transaksi,
  			SUM (purchase_amount_usd) AS jumlah_sales
  	FROM customer_transaction
  	GROUP BY Bulan
  	ORDER BY Bulan ASC
  ) AS growth
--Bagaimana growth order dan sales GenggamData Store ditahun 2023 berdasarkan produk kategori
  SELECT  
      Bulan,
  		category,
  		ROUND(((jumlah_transaksi / LAG(jumlah_transaksi) OVER(ORDER BY category, Bulan))-1)*100,1) AS growth_order,
  		ROUND(((jumlah_sales / LAG(jumlah_sales) OVER(ORDER BY category, Bulan))-1)*100,1) AS growth_sales
  FROM 
  (
  	SELECT 
  			EXTRACT(MONTH FROM order_date) AS Bulan,
  			category,
  			COUNT (*) :: numeric AS jumlah_transaksi,
  			SUM (purchase_amount_usd) AS jumlah_sales
  	FROM customer_transaction
  	GROUP BY Bulan, category
  	ORDER BY category
  ) AS growth
  ORDER BY category, bulan
