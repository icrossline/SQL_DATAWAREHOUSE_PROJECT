
PRINT '==============================='
PRINT 'TRUNCATING TABLE  silver.crm_cust_info'
PRINT '==============================='
	TRUNCATE TABLE silver.crm_cust_info;

PRINT '=================================================='
PRINT 'LOADING CLEAN DATA IN  TABLE  silver.crm_prd_info '
PRINT '=================================================='
INSERT INTO  silver.crm_cust_info( 
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,cst_gndr,
cst_create_date
)
--Query for cleaning data
Select  cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname)  as cst_lastname,
 --========================================================================
 -- CASE STATEMENT FOR REMOVING ABBREVIATIONS  FROM cst_marital_status
 -- ========================================================================
CASE 
	WHEN cst_marital_status = 'M' THEN 'Married'
	WHEN cst_marital_status = 'S' THEN 'Single'
	ELSE 'N/A'
END AS cst_marial_status,

 --========================================================================
 -- CASE STATEMENT FOR REMOVING ABBREVIATIONS  FROM cst_gndr
 -- ========================================================================
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	WHEN UPPER(TRIM(cst_gndr))= 'F' THEN 'Female'
	ELSE 'N/A'
END AS cst_gndr,
cst_create_date
from
 --========================================================================
 -- SUBQUERY FOR REMOVING Duplicate AND NULLS
 -- ========================================================================
(select *,
ROW_NUMBER() OVER( PARTITION BY cst_id  order by cst_create_date desc) as flag
FROM bronze.crm_cust_info 
WHERE cst_id IS NOT NULL)t
where flag = 1 ;




----------------------------------------------------------------------------------------------------------------------------
============================================================================================================================


PRINT '==============================='
PRINT 'TRUNCATING TABLE  silver.crm_prd_info '
PRINT '==============================='
	TRUNCATE TABLE silver.crm_prd_info;


PRINT '==============================='
PRINT 'LOADING CLEAN DATA  silver.crm_prd_info '
PRINT '==============================='
INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
    prd_key,
    prd_nm ,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt)
Select prd_id , 
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, 
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key ,
prd_nm ,
ISNULL(prd_cost,0) as prd_cost ,
CASE UPPER(TRIM(prd_line))
	WHEN 'R' THEN 'Roads'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'M' THEN 'Mountains'
	WHEN 'T' THEN 'Touring'
	ELSE 'N/A'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt  ,
CAST(DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS DATE) AS prd_end_dt
from bronze.crm_prd_info; 




---------------------------------------------------------------------------------------------------------------------------------
=================================================================================================================================

	
	
	
	
	PRINT '==============================='
PRINT 'TRUNCATING TABLE  silver.crm_sales_details '
PRINT '==============================='
TRUNCATE TABLE silver.crm_sales_details ;

PRINT '==========================================='
PRINT 'LOADING CLEAN DATA  silver.crm_sales_details '
PRINT '==========================================='
INSERT INTO silver.crm_sales_details 
(   sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT sls_ord_num ,
SUBSTRING(sls_prd_key,1,7) as sls_prd_key,
sls_cust_id,
CASE 
WHEN sls_order_dt < 0 OR LEN(sls_order_dt)!= 8 THEN NULL
ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)  
END AS sls_order_dt,
CASE 
WHEN sls_ship_dt < 0 OR LEN(sls_ship_dt)!= 8 THEN NULL
ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)  
END AS sls_ship_dt,
CASE 
WHEN sls_due_dt < 0 OR LEN(sls_due_dt)!= 8 THEN NULL
ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)  
END AS sls_due_dt,
ISNULL(sls_sales,0) as sls_sales,
sls_quantity,
ABS(ISNULL(sls_sales,0) * sls_quantity) AS sls_price
FROM  bronze.crm_sales_details;

