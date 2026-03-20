/*
========================================
Quality Checks
========================================
Script Purpose
This script performs quality checks for data consistency,accuracy,
and standardization across the 'silver' layer. In includes checks for:
  -Null or duplicate primary keys.
  -Unwanted spaces in string tables.
  -Data standardization and consistency.
  -Invald date ranges and orders.
  -Data consistency between related fields

Usage Notes:
  -Run these checks after data loading Silver layer.
  -Investigate and resolve any discrepancies found during the checks
========================================
*/
--========================================
--Checking 'silver.crm_cust_info
----========================================
--Check for Nulls or Duplicates in Primary Key
--Expectation : No Results

select cst_id,count(*) from silver.crm_cust_info
group by cst_id having count(*) > 1 OR cst_id IS NULL;

--Check for unwanted spaces
--Expectation : No Results
select cst_key from silver.crm_cust_info where cst_key != trim(cst_key);

--Data Standardization & Consistency
select distinct  cst_marital_status from silver.crm_cust_info;

--========================================
--Checking 'silver.crm_prd_info
----========================================
--Check for Nulls or Duplicates in Primary Key
--Expectation : No Results

select prd_id,count(*) from silver.crm_prd_info group by prd_id having count(*) > 1 OR prd_id IS NULL;

--Check for unwanted spaces
--Expectation : No Results

select prd_nm from silver.crm_prd_info where prd_nm != trim(prd_nm);

-- Check for NULLs or Negative Values in Cost
-- Expectation: No Results
select prd_cost from silver.crm_prd_info where prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
select distinct prd_line from silver.crm_prd_info;

-- Check for Invalid Date Orders (Start Date > End Date)
-- Expectation: No Results
select * from silver.crm_prd_info where prd_end_dt < prd_start_dt;

--========================================
--Checking 'silver.crm_sales_details'
--========================================
--Check For Invalid Dates
--Expectation : No Invalid Dates
select nullif(sls_due_dt,0) as sls_due_dt from bronze.crm_sales_details
where sls_due_dt<=0 or len(sls_due_dt)!=8 or sls_due_dt>20500101 or sls_due_dt<19000101

--Check for Invalid Date Orders (Order Date>Shipping/Due Dates)
--Expectation : No Results

select * from silver.crm_sales_details
where sls_order_dt>sls_ship_dt or sls_order_dt>sls_due_dt

--Check Data Consistency
--Expectation : No Results

select distinct sls_sales,sls_quantity,sls_price from silver.crm_sales_details
where sls_sales!=sls_quantity*sls_price or sls_sales is null
or sls_quantity is null or sls_price is null or sls_sales<=0 or sls_quantity<=0
or sls_price<=0 order by sls_sales,sls_quantity,sls_price

--========================================
--Checking 'silver.erp_cust_az12'
--========================================
--Identify Out-od-Range Dates
--Expectation : Birtdates between 1924-01-01 and Today
select distinct bdate from silver.erp_cust_az12
where bdate>'1924-01-01' or bdate<getdate()

--Data Standardization and Consistency

select distinct gen from silver.erp_cust_az12;

--========================================
--Checking 'silver.erp_loc_a101'
--========================================
--Data Standardization & Consistency

select distinct cntry from silver.erp_loc_a101
order by cntry

--========================================
--Checking 'silver.erp_px_cat_g1v1'
--========================================
--Check For Unwanted Spaces
--Expectation : No Results

select * from silver.erp_px_cat_g1v1
where cat != trim(cat) or subcat != trim(subcat) or maintance != trim(maintance);

--Data Standardization & Consistency

select distinct maintance from silver.erp_px_cat_g1v1
