/*
===========================================================================
DDL Script: Create Gold Views
===========================================================================
Script Purpose:



===========================================================================
Create Dimensions: gold.dim_customers
===========================================================================
This Script joins tables accross two source systems CRM and ERP using abd checks if
there are no duplicate customers and does data integration for gender as the same 
info is in two tables and creating a surrogate key in the Data Model and creating the customer
dimension
*/
CREATE VIEW gold.dim_customers AS
SELECT 
  	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
  	ci.cst_id AS customer_id,
  	ci.cst_key AS customer_number,
  	ci.cst_firstname AS first_name,
  	ci.cst_lastname AS last_name,
  	la.cntry AS country,
  	ci.cst_marital_status AS marital_status,
  		CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr -- CRM is the Master for Gender Info
  		ELSE COALESCE(ca.gen, 'N/A')
  	END AS gender,
  	ca.bdate AS birthdate,
  	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON		  ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid

/*
This scripts creates the product dimension for gold layer
*/
CREATE VIEW gold.dim_products AS
SELECT
  	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
  	pn.prd_id AS product_id,
  	pn.prd_key AS product_number,
  	pn.prd_nm AS product_name,
  	pn.cat_id AS category_id,
  	pc.cat AS category,
  	pc.subcat AS sub_category,
  	pc.maintenance AS maintenance,
  	pn.prd_cost AS product_cost,
  	pn.prd_line AS product_line,
    	pn.prd_start_dt AS start_date
  	FROM silver.crm_prd_info pn
  	LEFT JOIN silver.erp_px_cat_g1v2 pc
  	ON pn.cat_id = pc.id
  	WHERE prd_end_dt IS NULL -- Filters out all historical data

	/*
This script creates fact table for the gold layer and joining the two tables 
using surrogate keys for data lookup 
*/
CREATE VIEW gold.fact_sales AS 
SELECT
  sd.sls_ord_num,
  pr.product_key,
  cu.customer_key,
  sd.sls_order_dt AS order_date,
  sd.sls_ship_dt AS ship_dt,
  sd.sls_due_dt AS due_dt,
  sd.sls_sales AS sales,
  sd.sls_quantity AS quantity,
  sd.sls_price AS price
  FROM silver.crm_sales_details sd
  LEFT JOIN gold.dim_products pr
  ON sd.sls_prd_key = pr.product_number
  LEFT JOIN gold.dim_customers cu
  ON sd.sls_cust_id = cu.customer_id




	
