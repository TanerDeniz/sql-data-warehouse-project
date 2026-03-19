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


