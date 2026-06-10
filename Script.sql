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

--PERFORMANCE SALES & GROWTH ANALYSIS
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

--PROMOTIONAL COST EFFICIENCY
--menghitung burn rate dari promosi yang dilakukan overall berdasarkan bulan.
	SELECT 
			Bulan,
			total_sales,
			promotional_values,
			burn_rate
	FROM
	(
		SELECT 
				EXTRACT(MONTH FROM order_date) AS Bulan,
				SUM(purchase_amount_usd) AS total_sales,
				ROUND(SUM(discount/100 * purchase_amount_usd),2) AS promotional_values,
				ROUND(SUM(discount/100 * purchase_amount_usd) / SUM (purchase_amount_usd)*100,2) AS burn_rate
		FROM customer_transaction
		GROUP BY Bulan
		ORDER BY Bulan ASC
	) AS PCE
--Menghitung burn rate dari promosi yang dilakukan overall berdasarkan product category dan bulan
SELECT 
		Bulan,
		category,
		total_sales,
		promotional_values,
		burn_rate
FROM
(
	SELECT 
			EXTRACT(MONTH FROM order_date) AS Bulan,
			category,
			SUM(purchase_amount_usd) AS total_sales,
			ROUND(SUM(discount/100 * purchase_amount_usd),2) AS promotional_values,
			ROUND(SUM(discount/100 * purchase_amount_usd) / SUM (purchase_amount_usd)*100,2) AS burn_rate
	FROM customer_transaction
	GROUP BY Bulan, category
	ORDER BY Bulan ASC, category
) AS PCE

--COHORT ANALYSIS
WITH first_invoice AS 
(
 	SELECT 
			customer_id,
  			MIN(order_date) AS firstinvoice
 	FROM customer_transaction
	GROUP BY customer_id
 	ORDER BY firstinvoice
),

cohort_index AS
(
	SELECT 
		ct.customer_id,
    	ct.order_date,
    	fi.firstinvoice,
    	EXTRACT(MONTH FROM ct.order_date) - EXTRACT(MONTH FROM fi.firstinvoice) AS cohort_index
	FROM customer_transaction AS ct
	LEFT JOIN first_invoice as fi
	ON ct.customer_id = fi.customer_id
	ORDER BY ct.customer_id, ct.order_date
),

cohort_month AS 
(
	SELECT 
		EXTRACT(MONTH FROM ci.firstinvoice) AS cohort_month,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 0 THEN ci.customer_id END)::numeric AS m0,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 1 THEN ci.customer_id END)::numeric AS m1,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 2 THEN ci.customer_id END)::numeric AS m2,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 3 THEN ci.customer_id END)::numeric AS m3,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 4 THEN ci.customer_id END)::numeric AS m4,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 5 THEN ci.customer_id END)::numeric AS m5,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 6 THEN ci.customer_id END)::numeric AS m6,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 7 THEN ci.customer_id END)::numeric AS m7,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 8 THEN ci.customer_id END)::numeric AS m8,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 9 THEN ci.customer_id END)::numeric AS m9,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 10 THEN ci.customer_id END)::numeric AS m10,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 11 THEN ci.customer_id END)::numeric AS m11
	FROM cohort_index AS ci
	GROUP BY cohort_month
	ORDER BY cohort_month
)

SELECT 
	cm.cohort_month,
    ROUND((cm.m0/cm.m0)*100) AS m0,
    ROUND((cm.m1/cm.m0)*100) AS m1,
    ROUND((cm.m2/cm.m0)*100) AS m2,
    ROUND((cm.m3/cm.m0)*100) AS m3,
    ROUND((cm.m4/cm.m0)*100) AS m4,
    ROUND((cm.m5/cm.m0)*100) AS m5,
    ROUND((cm.m6/cm.m0)*100) AS m6,
    ROUND((cm.m7/cm.m0)*100) AS m7,
    ROUND((cm.m8/cm.m0)*100) AS m8,
    ROUND((cm.m9/cm.m0)*100) AS m9,
    ROUND((cm.m10/cm.m0)*100) AS m10,
    ROUND((cm.m11/cm.m0)*100) AS m11
FROM cohort_month AS cm

--CHURN RATE
WITH first_invoice AS 
(
	SELECT 
		customer_id,
   		MIN(order_date) AS firstinvoice
 	FROM customer_transaction
 	GROUP BY customer_id
 	ORDER BY firstinvoice
),

cohort_index AS
(
	SELECT 
		ct.customer_id,
    	ct.order_date,
    	fi.firstinvoice,
    	EXTRACT(MONTH FROM ct.order_date) - EXTRACT(MONTH FROM fi.firstinvoice) AS cohort_index
	FROM customer_transaction AS ct
	LEFT JOIN first_invoice as fi
	ON ct.customer_id = fi.customer_id
	ORDER BY ct.customer_id, ct.order_date
),

cohort_month AS 
(
	SELECT 
		EXTRACT(MONTH FROM ci.firstinvoice) AS cohort_month,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 0 THEN ci.customer_id END)::numeric AS m0,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 1 THEN ci.customer_id END)::numeric AS m1,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 2 THEN ci.customer_id END)::numeric AS m2,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 3 THEN ci.customer_id END)::numeric AS m3,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 4 THEN ci.customer_id END)::numeric AS m4,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 5 THEN ci.customer_id END)::numeric AS m5,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 6 THEN ci.customer_id END)::numeric AS m6,
   	 	COUNT(DISTINCT CASE WHEN ci.cohort_index = 7 THEN ci.customer_id END)::numeric AS m7,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 8 THEN ci.customer_id END)::numeric AS m8,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 9 THEN ci.customer_id END)::numeric AS m9,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 10 THEN ci.customer_id END)::numeric AS m10,
    	COUNT(DISTINCT CASE WHEN ci.cohort_index = 11 THEN ci.customer_id END)::numeric AS m11
	FROM cohort_index AS ci
	GROUP BY cohort_month
	ORDER BY cohort_month
)

SELECT 
	cm.cohort_month,
    100 - ROUND(((cm.m0)/cm.m0)*100) AS m0,
    100 - ROUND(((cm.m1)/cm.m0)*100) AS m1,
    100 - ROUND(((cm.m2)/cm.m0)*100) AS m2,
    100 - ROUND(((cm.m3)/cm.m0)*100) AS m3,
    100 - ROUND(((cm.m4)/cm.m0)*100) AS m4,
    100 - ROUND(((cm.m5)/cm.m0)*100) AS m5,
    100 - ROUND(((cm.m6)/cm.m0)*100) AS m6,
    100 - ROUND(((cm.m7)/cm.m0)*100) AS m7,
    100 - ROUND(((cm.m8)/cm.m0)*100) AS m8,
    100 - ROUND(((cm.m9)/cm.m0)*100) AS m9,
    100 - ROUND(((cm.m10)/cm.m0)*100) AS m10,
    100 - ROUND(((cm.m11)/cm.m0)*100) AS m11
FROM cohort_month AS cm
