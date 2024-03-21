DROP TABLE fsbi_dw_spinn.FACT_PROPERTY_MODELDATA;		
CREATE TABLE IF NOT EXISTS fsbi_dw_spinn.FACT_PROPERTY_MODELDATA		
(		
	modeldata_id INTEGER NOT NULL  ENCODE lzo	
	,systemidstart INTEGER NOT NULL  ENCODE lzo	
	,systemidend INTEGER NOT NULL  ENCODE lzo	
	,policy_id INTEGER NOT NULL  ENCODE lzo	
	,policy_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo	
	,policy_changes_id INTEGER NOT NULL  ENCODE lzo	
	,producer_id INTEGER NOT NULL  ENCODE lzo	
	,risk_id INTEGER NOT NULL  ENCODE lzo	
	,risk_uniqueid VARCHAR(100) NOT NULL  ENCODE lzo	
	,risknumber INTEGER NOT NULL  ENCODE lzo	
	,risktype VARCHAR(255) NOT NULL  ENCODE lzo	
	,building_id INTEGER NOT NULL  ENCODE lzo	
	,building_uniqueid VARCHAR(255) NOT NULL  ENCODE lzo	
	,startdatetm TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo	
	,enddatetm TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo	
	,startdate DATE NOT NULL  ENCODE lzo	
	,enddate DATE NOT NULL  ENCODE lzo	
	,allcov_wp NUMERIC(38,2)   ENCODE lzo	
	,allcov_lossinc NUMERIC(38,2)   ENCODE lzo	
	,allcov_lossdcce NUMERIC(38,2)   ENCODE lzo	
	,allcov_lossalae NUMERIC(38,2)   ENCODE lzo	
	,cova_wp NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_wp NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_wp NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_wp NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_wp NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_wp NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_deductible VARCHAR(255) NOT NULL  ENCODE lzo	
	,covb_deductible VARCHAR(255) NOT NULL  ENCODE lzo	
	,covc_deductible VARCHAR(255) NOT NULL  ENCODE lzo	
	,covd_deductible VARCHAR(255) NOT NULL  ENCODE lzo	
	,cove_deductible VARCHAR(255) NOT NULL  ENCODE lzo	
	,covf_deductible VARCHAR(255) NOT NULL  ENCODE lzo	
	,cova_limit VARCHAR(255) NOT NULL  ENCODE lzo	
	,covb_limit VARCHAR(255) NOT NULL  ENCODE lzo	
	,covc_limit VARCHAR(255) NOT NULL  ENCODE lzo	
	,covd_limit VARCHAR(255) NOT NULL  ENCODE lzo	
	,cove_limit VARCHAR(255) NOT NULL  ENCODE lzo	
	,covf_limit VARCHAR(255) NOT NULL  ENCODE lzo	
	,onpremises_theft_limit VARCHAR(255) NOT NULL  ENCODE lzo	
	,awayfrompremises_theft_limit VARCHAR(255) NOT NULL  ENCODE lzo	
	,quality_polappinconsistency_flg VARCHAR(3) NOT NULL  ENCODE lzo	
	,quality_riskidduplicates_flg VARCHAR(3) NOT NULL  ENCODE lzo	
	,quality_claimok_flg INTEGER NOT NULL  ENCODE lzo	
	,quality_claimpolicytermjoin_flg INTEGER NOT NULL  ENCODE lzo	
	,covabcdefliab_loss NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covabcdefliab_claim_count INTEGER NOT NULL  ENCODE lzo	
	,cat_covabcdefliab_loss NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cat_covabcdefliab_claim_count INTEGER NOT NULL  ENCODE lzo	
	,cova_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_dcce_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_dcce_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_dcce_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_dcce_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_dcce_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_dcce_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_dcce_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covb_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covc_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covd_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cove_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,covf_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_alae_nc_water NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_alae_nc_wh NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_alae_nc_tv NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_alae_nc_fl NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_alae_nc_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_alae_cat_fire NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,liab_il_alae_cat_ao NUMERIC(38,2) NOT NULL  ENCODE lzo	
	,cova_ic_nc_water INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_nc_water INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_nc_water INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_dcce_nc_water INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_dcce_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_dcce_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_dcce_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_dcce_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_dcce_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_dcce_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,cova_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covb_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covc_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covd_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,cove_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,covf_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_alae_nc_water INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_alae_nc_wh INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_alae_nc_tv INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_alae_nc_fl INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_alae_nc_ao INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_alae_cat_fire INTEGER NOT NULL  ENCODE lzo	
	,liab_ic_alae_cat_ao INTEGER NOT NULL  ENCODE lzo	
	,cova_fl INTEGER NOT NULL  ENCODE lzo	
	,cova_sf INTEGER NOT NULL  ENCODE lzo	
	,cova_ec INTEGER NOT NULL  ENCODE lzo	
	,covc_fl INTEGER NOT NULL  ENCODE lzo	
	,covc_sf INTEGER NOT NULL  ENCODE lzo	
	,covc_ec INTEGER NOT NULL  ENCODE lzo	
	,loaddate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE lzo	
)		
DISTSTYLE KEY		
 DISTKEY (policy_id)		
 SORTKEY (		
	startdatetm	
	)	
;		
		
COMMENT ON TABLE fsbi_dw_spinn.FACT_PROPERTY_MODELDATA IS 'The base of vproperty_modeldata_allcov. There is a complex way to build mid-term changes from TransactionHistory, Risk, Building and other claim related tables.';		
		
		
		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.modeldata_id IS 'Mid-Term change unique identifier. It''s repeated for different coverages in the same mid-term change.	 ';	
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.systemidstart IS 'Exact mid-term start SystemId from Application';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.systemidend IS 'Exact mid-term end SystemId from Application';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.policy_id IS 'Foreign Key (link)  to DIM_POLICY ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.policy_uniqueid IS 'PolicyRef in PolicyStats or SystemId in any other related table';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.policy_changes_id IS 'Foreign Key (link)  to DIM_POLICY_CHANGES ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.producer_id IS 'Foreign Key (link)  to VDIM_PRODUCER ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.risk_id IS 'Foreign Key (link)  to DIM_COVEREDRISK ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.building_id IS 'Foreign Key (link)  to DIM_BUILDING ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.startdatetm IS 'Exact Mid-Term Start date';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.enddatetm IS 'Exact Mid-Term End Date';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.startdate IS 'Exact Mid-Term Start date or Jan 1 next year if  a mid-term covers more then one year.';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.enddate IS ' 	case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end	Exact Mid-Term End date or Dec 31  if  a mid-term covers more then one year.';
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.allcov_wp IS ' 	Total Policy WP 	including discounts but not fees. Total from Coverage List in SPINN UI Dwelling ';
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.allcov_lossinc IS ' 	Total for all coverages Paid and Incurred Losses 	See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.allcov_lossdcce IS ' 	Total for all coverages DCCE	Only DCCE, no IL added See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.allcov_lossalae IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.quality_polappinconsistency_flg IS 'Sometimes the latest known policy state is different from latest application data due to manual updates. I try to use "policy" instead of "aplication" data';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.quality_riskidduplicates_flg IS 'Different risks have the same number in SPINN. SPINN issue.';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.quality_claimok_flg IS 'Claim is joined without an issue';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.quality_claimpolicytermjoin_flg IS 'There is an issue joining a claim to a specific mid-term change because of cancellations. It''s joined to a first mid-term change (record) per policy term.  In many cases there is just one record per policy term in homeowners policies.';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covabcdefliab_loss IS ' 	Total Coverage A thru LIAB groups Paid and Incurred Loss';	
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covabcdefliab_claim_count IS ' 	Total Coverage A thru LIAB groups Claim Count';	
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cat_covabcdefliab_loss IS ' 	Catastrophe Total Coverage A thru LIAB groups  Paid and Incurred Loss';	
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cat_covabcdefliab_claim_count IS ' 	Total Coverage A thru LIAB groups Claim Count';	
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cova_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covb_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covc_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covd_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.cove_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.covf_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.liab_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.FACT_PROPERTY_MODELDATA.loaddate IS 'Data last refresh date';		
