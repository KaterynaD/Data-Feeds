DROP TABLE if exists fsbi_dw_spinn.fact_auto_modeldata_v2;	
CREATE TABLE fsbi_dw_spinn.fact_auto_modeldata_v2	
(	
	modeldata_id INTEGER   ENCODE lzo
	,systemidstart INTEGER   ENCODE lzo
	,systemidend INTEGER   ENCODE lzo
	,risk_id INTEGER   ENCODE lzo
	,risktype VARCHAR(255)   ENCODE lzo
	,policy_id INTEGER   ENCODE lzo
	,policy_changes_id INTEGER NOT NULL  ENCODE lzo
	,producer_id INTEGER   ENCODE lzo
	,policy_uniqueid VARCHAR(20)   ENCODE lzo
	,risk_uniqueid VARCHAR(100)   ENCODE lzo
	,vehicle_id INTEGER   ENCODE lzo
	,vehicle_uniqueid VARCHAR(250)   ENCODE lzo
	,vin VARCHAR(100)   ENCODE lzo
	,risknumber INTEGER   ENCODE lzo
	,driver_id INTEGER   ENCODE lzo
	,driver_uniqueid VARCHAR(250)   ENCODE lzo
	,driverlicense VARCHAR(100)   ENCODE lzo
	,drivernumber INTEGER   ENCODE lzo
	,startdatetm TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,enddatetm TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,startdate DATE   ENCODE RAW
	,enddate DATE   ENCODE lzo
	,cntveh INTEGER   ENCODE lzo
	,cntdrv INTEGER   ENCODE lzo
	,cntnondrv INTEGER   ENCODE lzo
	,cntexcludeddrv INTEGER   ENCODE lzo
	,mindriverage INTEGER   ENCODE lzo
	,vehicleinceptiondate DATE   ENCODE lzo
	,driverinceptiondate DATE   ENCODE lzo
	,liabilityonly_flg VARCHAR(3)   ENCODE lzo
	,componly_flg VARCHAR(3)   ENCODE lzo
	,excludeddrv_flg VARCHAR(3)   ENCODE lzo
	,atfaultcdclaims_count INTEGER   ENCODE lzo
	,claim_count_le500 INTEGER   ENCODE lzo
	,claim_count_1000 INTEGER   ENCODE lzo
	,claim_count_1500 INTEGER   ENCODE lzo
	,claim_count_2000 INTEGER   ENCODE lzo
	,claim_count_2500 INTEGER   ENCODE lzo
	,claim_count_5k INTEGER   ENCODE lzo
	,claim_count_10k INTEGER   ENCODE lzo
	,claim_count_25k INTEGER   ENCODE lzo
	,claim_count_50k INTEGER   ENCODE lzo
	,claim_count_100k INTEGER   ENCODE lzo
	,claim_count_250k INTEGER   ENCODE lzo
	,claim_count_500k INTEGER   ENCODE lzo
	,claim_count_750k INTEGER   ENCODE lzo
	,claim_count_1m INTEGER   ENCODE lzo
	,claim_count INTEGER   ENCODE lzo
	,nc_inc_loss_le500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_1000 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_1500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_2000 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_2500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_5k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_10k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_25k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_50k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_100k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_250k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_500k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_750k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_1m NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_le500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_1000 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_1500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_2000 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_2500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_5k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_10k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_25k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_50k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_100k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_250k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_500k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_750k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_1m NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_le500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_1000 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_1500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_2000 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_2500 NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_5k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_10k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_25k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_50k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_100k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_250k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_500k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_750k NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce_1m NUMERIC(38,2)   ENCODE lzo
	,nc_inc_loss_dcce NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_le500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_1000 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_1500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_2000 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_2500 NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_5k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_10k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_25k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_50k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_100k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_250k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_500k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_750k NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce_1m NUMERIC(38,2)   ENCODE lzo
	,cat_inc_loss_dcce NUMERIC(38,2)   ENCODE lzo
	,coll_deductible VARCHAR(50)   ENCODE lzo
	,comp_deductible VARCHAR(50)   ENCODE lzo
	,bi_limit1 VARCHAR(50)   ENCODE lzo
	,bi_limit2 VARCHAR(50)   ENCODE lzo
	,umbi_limit1 VARCHAR(50)   ENCODE lzo
	,umbi_limit2 VARCHAR(50)   ENCODE lzo
	,pd_limit1 VARCHAR(50)   ENCODE lzo
	,pd_limit2 VARCHAR(50)   ENCODE lzo
	,coveragecd VARCHAR(6)   ENCODE lzo
	,limit1 VARCHAR(50)   ENCODE lzo
	,limit2 VARCHAR(50)   ENCODE lzo
	,deductible VARCHAR(50)   ENCODE lzo
	,wp NUMERIC(38,2)   ENCODE lzo
	,cov_claim_count_le500 NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_1000 NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_1500 NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_2000 NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_2500 NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_5k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_10k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_25k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_50k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_100k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_250k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_500k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_750k NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count_1m NUMERIC(12,2)   ENCODE lzo
	,cov_claim_count NUMERIC(12,2)   ENCODE lzo
	,nc_cov_inc_loss_le500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_1000 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_1500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_2000 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_2500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_5k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_10k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_25k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_50k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_100k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_250k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_500k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_750k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_1m NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_le500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_1000 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_1500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_2000 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_2500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_5k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_10k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_25k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_50k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_100k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_250k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_500k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_750k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_1m NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_le500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_1000 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_1500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_2000 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_2500 NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_5k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_10k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_25k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_50k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_100k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_250k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_500k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_750k NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce_1m NUMERIC(38,2)   ENCODE lzo
	,nc_cov_inc_loss_dcce NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_le500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_1000 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_1500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_2000 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_2500 NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_5k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_10k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_25k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_50k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_100k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_250k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_500k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_750k NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce_1m NUMERIC(38,2)   ENCODE lzo
	,cat_cov_inc_loss_dcce NUMERIC(38,2)   ENCODE lzo
	,bilossinc1530 INTEGER NOT NULL  ENCODE lzo
	,umbilossinc1530 INTEGER NOT NULL  ENCODE lzo
	,uimbilossinc1530 INTEGER NOT NULL  ENCODE lzo
	,quality_polappinconsistency_flg VARCHAR(3)   ENCODE lzo
	,quality_riskidduplicates_flg VARCHAR(3)   ENCODE lzo
	,quality_excludeddrv_flg VARCHAR(3)   ENCODE lzo
	,quality_replacedvin_flg VARCHAR(3)   ENCODE lzo
	,quality_replaceddriver_flg VARCHAR(3)   ENCODE lzo
	,quality_claimok_flg INTEGER   ENCODE lzo
	,quality_claimunknownvin_flg INTEGER   ENCODE lzo
	,quality_claimunknownvinnotlisteddriver_flg INTEGER   ENCODE lzo
	,quality_claimpolicytermjoin_flg INTEGER   ENCODE lzo
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo
)	
DISTSTYLE KEY	
 DISTKEY (policy_id)	
 SORTKEY (	
	startdatetm
	)
;	
	
COMMENT ON TABLE fsbi_dw_spinn.fact_auto_modeldata_v2 IS 'The base of vauto_modeldata_allcov. There is a complex way to build mid-term changes from TransactionHistory, Risk, Vehicle, DriverInfo, DriverLink, Coverage, Limit, Deductible, and other claims related tables';	
	
	
	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.risk_id IS 'Foreign Key (link)  to DIM_COVEREDRISK ';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.policy_id IS 'Foreign Key (link)  to DIM_POLICY ';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.policy_changes_id IS 'Foreign Key (link)  to DIM_POLICY_CHANGES ';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.producer_id IS 'Foreign Key (link)  to VDIM_PRODUCER ';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.policy_uniqueid IS 'PolicyRef';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.vehicle_id IS 'Foreign Key (link)  to DIM_VEHICLE ';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.vehicle_uniqueid IS 'SPINN Vehicle Id';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.driver_id IS 'Foreign Key (link)  to DIM_DRIVER ';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.startdatetm IS 'Exact Mid-Term Start date';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.enddatetm IS 'Exact Mid-Term End Date';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.startdate IS 'Exact Mid-Term Start date or Jan 1 next year if  a mid-term covers more then one year.';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.enddate IS 'Exact Mid-Term End date or Dec 31  if  a mid-term covers more then one year.';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.cntveh IS 'Number of all vehicles in this mid-term change';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.cntdrv IS 'Number of all active drivers in this mid-term change, including non-assigned: count(distinct case when stg.status=`Active` then  stg.driver_uniqueid else null end) ';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.cntnondrv IS 'Number of excluded drivers: count(distinct case when stg.status=`Active` and upper(stg.LicenseNumber) like `%EXCLUDED%`  then stg.driver_uniqueid else null end)';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.cntexcludeddrv IS 'Number of Non drivers: count(distinct case when stg.status=`Active` and upper(stg.LicenseNumber) NOT like `%EXCLUDED%` and stg.DriverTypeCd in (`NonOperator`, `Excluded`, `UnderAged`) then  stg.driver_uniqueid else null end)';	
COMMENT ON COLUMN fsbi_dw_spinn.fact_auto_modeldata_v2.mindriverage IS 'A minimal driver age per this mid-term change. Non assigned drivers are taken into account';	
