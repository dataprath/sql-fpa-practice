/*
========================================================
Quality Checks for Silver Layer
========================================================
Script Purpose: Checking the data quality before loading the data into Silver Layer
*/
-- Checking Data Quality issues for Customer info table
-- Check for Nulls or Duplicates in Primary Key 
-- Expectations: No Results 

SELECT
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for unwanted Spaces
-- Expectations: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Check for Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info

-- Checking Data Quality issue for Product info table
-- Checking for duplicates in Primary Key
-- Expectations: No Results
SELECT 
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Checking if the Product Name has unwanted spaces
-- Expectations: No Results

SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for Nulls or Negative Numbers
-- Expectations: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Check for data standardization and consistency 
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for Invalid Date Orders
SELECT * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- Checks for Invalide Date Orders in Sales Table 
SELECT * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_ship_dt

-- Checks for data consistency between Sales, Quantity and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL
OR sls_quantity IS NULL
OR sls_price IS NULL
OR sls_sales <= 0 
OR sls_quantity <= 0 
OR sls_price <= 0 
ORDER BY sls_sales, sls_quantity, sls_price

SELECT * FROM silver.crm_sales_details

-- Checks for cid in the cust AZ12
SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL
	ELSE bdate
END AS bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'Male') THEN 'Male'
	 ELSE 'N/A'
END AS gen
FROM bronze.erp_cust_az12

-- Checks for invalid bdates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Checks for Data standardization for gender in cust AZ12
SELECT DISTINCT gen
FROM silver.erp_cust_az12

SELECT * from silver.erp_cust_az12


-- Checks for Data for loc A101
SELECT
REPLACE(cid, '-', '') cid,
cntry
FROM bronze.erp_loc_a101 WHERE REPLACE(cid, '-', '') NOT IN
(SELECT cst_key FROM bronze.crm_cust_info)

-- Checks for Data Standardization & Consistency
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry

-- Transformation Query 
SELECT
REPLACE(cid, '-', '') cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
	ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101 

--Checks for data consistency in px cat g1v2
SELECT
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2

--Checks for unwanted spaces in Category 
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Checks for Data Standardization
SELECT DISTINCT
maintenance 
FROM bronze.erp_px_cat_g1v2
