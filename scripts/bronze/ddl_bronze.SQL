/* 
This script bulk inserts the data from the source system - using the source where the file is stored 
and it has been give specifications to load from the second row as the first row headers are defined by us 
in the table load scripts, it also specifies that the fields are seperated by commas and to execute it in
a systematic manner it has a specified Tablock - and loads the bronze layer tables - CRM and ERP and also gives the Load 
Duration of the scripts and also shows errors if any.
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
  	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
  	BEGIN TRY
  		SET @batch_start_time = GETDATE();
  		PRINT '====================================';
  		PRINT 'Loading Bronze Layer';
  		PRINT '====================================';
  
  		PRINT '------------------------------------';
  		PRINT 'Loading CRM Tables';
  		PRINT '------------------------------------';

  		SET @start_time = GETDATE();
  		PRINT '>> Truncating Table:bronze.crm_cust_info '
  		TRUNCATE TABLE bronze.crm_cust_info;
  		PRINT '>> Inserting Table into :bronze.crm_cust_info '
  		BULK INSERT bronze.crm_cust_info
  		FROM 'C:\Users\prath\OneDrive\Desktop\portfolio\SQL Project\datasets\source_crm\cust_info.csv'
  		WITH (
  			FIRSTROW = 2,
  			FIELDTERMINATOR = ',',
  			TABLOCK 
  		);
  		SET @end_time = GETDATE();
  		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
  		PRINT '>>---------';

-- Loading Product Information Table
  		SET @start_time = GETDATE();
  		PRINT '>> Truncating Table:bronze.crm_prd_info ';
  		TRUNCATE TABLE bronze.crm_prd_info;
  		PRINT '>> Inserting : bronze.crm_prd_info ';
  		BULK INSERT bronze.crm_prd_info
  		FROM 'C:\Users\prath\OneDrive\Desktop\portfolio\SQL Project\datasets\source_crm\prd_info.csv'
  		WITH (
  			FIRSTROW = 2,
  			FIELDTERMINATOR = ',',
  			TABLOCK 
  		);
  		SET @end_time = GETDATE();
  		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
  		PRINT '>>---------';

-- Loading Sales Details Table 
  		SET @start_time = GETDATE();
  		PRINT '>> Truncating Table:bronze.crm_sales_details';
  		TRUNCATE TABLE bronze.crm_sales_details;
  		PRINT '>> Inserting Table into:bronze.crm_sales_details';
  		BULK INSERT bronze.crm_sales_details
  		FROM 'C:\Users\prath\OneDrive\Desktop\portfolio\SQL Project\datasets\source_crm\sales_details.csv'
  		WITH (
  			FIRSTROW = 2,
  			FIELDTERMINATOR = ',',
  			TABLOCK 
  		);
  		SET @end_time = GETDATE();
  		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
  		PRINT '>>---------';

-- Loading ERP customer AZ12 table
  		SET @start_time = GETDATE();
  		PRINT '>> Truncating Table:bronze.erp_cust_az12';
  		TRUNCATE TABLE bronze.erp_cust_az12;
  		PRINT '>> Inserting Table into:bronze.erp_cust_az12';
  		BULK INSERT bronze.erp_cust_az12
  		FROM 'C:\Users\prath\OneDrive\Desktop\portfolio\SQL Project\datasets\source_erp\cust_az12.csv'
  		WITH (
  			FIRSTROW = 2,
  			FIELDTERMINATOR = ',',
  			TABLOCK 
  		);
  		SET @end_time = GETDATE();
  		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
  		PRINT '>>---------';
  
  		PRINT '------------------------------------';
  		PRINT 'Loading ERP Tables';
  		PRINT '------------------------------------';

-- Loading ERP local A101 table
  		SET @start_time = GETDATE();
  		PRINT '>> Truncating Table:bronze.erp_loc_a101';
  		TRUNCATE TABLE bronze.erp_loc_a101;
  		PRINT '>> Inserting Table into :bronze.erp_loc_a101'
  		BULK INSERT bronze.erp_loc_a101
  		FROM 'C:\Users\prath\OneDrive\Desktop\portfolio\SQL Project\datasets\source_erp\loc_a101.csv'
  		WITH (
  			FIRSTROW = 2,
  			FIELDTERMINATOR = ',',
  			TABLOCK 
  		);
  		SET @end_time = GETDATE();
  		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
  		PRINT '>>---------';

-- Loading PX Category G1V2 table
  		SET @start_time = GETDATE();
  		PRINT '>> Truncating Table:bronze.erp_px_cat_g1v2';
  		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
  		PRINT '>> Inserting Table into :bronze.erp_px_cat_g1v2';
  		BULK INSERT bronze.erp_px_cat_g1v2
  		FROM 'C:\Users\prath\OneDrive\Desktop\portfolio\SQL Project\datasets\source_erp\px_cat_g1v2.csv'
  		WITH (
  				FIRSTROW = 2,
  				FIELDTERMINATOR = ',',
  				TABLOCK 
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
			PRINT '>>---------';

			SET @batch_end_time = GETDATE();
			PRINT 'Loading Bronze layer is Finished';
			PRINT '>> Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
			END TRY
			BEGIN CATCH
				PRINT '==================================';
				PRINT 'ERROR OCCURED LOADING BRONZE LAYER';
				PRINT 'ERROR MSG' + ERROR_MESSAGE();
				PRINT 'ERROR MSG' + CAST (ERROR_NUMBER() AS NVARCHAR);
				PRINT 'ERROR MSG' + CAST (ERROR_STATE()  AS NVARCHAR);
				PRINT '==================================';
			END CATCH
		END
