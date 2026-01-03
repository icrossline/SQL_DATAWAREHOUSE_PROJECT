--INSERTING DATA INTO TABLES USING BULK INSERT
--FULL LOAD (Truncate , insert)

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
DECLARE @start_time DATETIME , @endtime DATETIME
BEGIN
	SET @start_time = GETDATE()
	PRINT @start_time
	BEGIN TRY
	
	PRINT '=================================='
	PRINT ' TRUNCATING bronze.crm_cust_info'
	PRINT '=================================='

		TRUNCATE TABLE  bronze.crm_cust_info;

	PRINT '========================================'
	PRINT ' Loading Data into bronze.crm_cust_info'
	PRINT '========================================'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\abhiu\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
	PRINT '=================================='
	PRINT ' TRUNCATING bronze.crm_prd_info'
	PRINT '=================================='

		TRUNCATE TABLE  bronze.crm_prd_info;

	PRINT '========================================'
	PRINT ' Loading Data into bronze.crm_prd_info'
	PRINT '========================================'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\abhiu\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
	PRINT '======================================'
	PRINT ' TRUNCATING bronze.crm_sales_details'
	PRINT '======================================'
		TRUNCATE TABLE  bronze.crm_sales_details;

	PRINT '==========================================='
	PRINT ' Loading Data into bronze.crm_sales_details'
	PRINT '==========================================='
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\abhiu\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR =',',
			TABLOCK
		);

	PRINT '======================================'
	PRINT ' TRUNCATING bronze.erp_cust_az12'
	PRINT '======================================'

		TRUNCATE TABLE  bronze.erp_cust_az12;

	PRINT '==========================================='
	PRINT ' Loading Data into bronze.erp_cust_az12'
	PRINT '==========================================='
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\abhiu\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR =',',
			TABLOCK
		);

	PRINT '======================================'
	PRINT ' TRUNCATING bronze.erp_loc_a101'
	PRINT '======================================'
		TRUNCATE TABLE  bronze.erp_loc_a101;

	PRINT '==========================================='
	PRINT ' Loading Data into bronze.erp_loc_a101'
	PRINT '==========================================='
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\abhiu\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR =',',
			TABLOCK
		);

	PRINT '======================================'
	PRINT ' TRUNCATING bronze.erp_px_cat_g1v2'
	PRINT '======================================'
		TRUNCATE TABLE  bronze.erp_px_cat_g1v2;

	PRINT '==========================================='
	PRINT ' Loading Data into bronze.erp_px_cat_g1v2'
	PRINT '==========================================='

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\abhiu\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR =',',
			TABLOCK
	);
	
	END TRY

	BEGIN CATCH
		PRINT 'Error Message :' + error_message()
		PRINT 'Error Number:' + CAST(error_number() as Varchar(10)) 
	END CATCH

	SET @endtime = GETDATE()
	PRINT @endtime
	PRINT 'Load Duration' +  CAST(DATEDIFF( second ,@Start_time,@endtime) AS NVARCHAR(10)) + ' Seconds '
END;

===========================
Execute the procedure
===========================

EXEC bronze.load_bronze;
