DROP TABLE if exists fsbi_stg_spinn.stg_property_modeldata;
CREATE TABLE  fsbi_stg_spinn.stg_property_modeldata
(
modeldata_id INTEGER   ENCODE az64
,claimrisk_id INTEGER   ENCODE az64
,systemidstart INTEGER   ENCODE az64
,systemidend INTEGER   ENCODE az64
,policy_id INTEGER   ENCODE az64 DISTKEY
,policy_uniqueid VARCHAR(100)   ENCODE lzo
,producer_uniqueid VARCHAR(100)   ENCODE lzo
,risk_id INTEGER   ENCODE az64
,risk_uniqueid VARCHAR(100)   ENCODE lzo
,risknumber INTEGER   ENCODE az64
,risktype VARCHAR(255)   ENCODE lzo
,building_id INTEGER   ENCODE az64
,building_uniqueid VARCHAR(255)   ENCODE lzo
,startdatetm TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
,enddatetm TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
,startdate DATE   ENCODE az64
,enddate DATE   ENCODE az64
,cova_deductible VARCHAR(255)   ENCODE lzo
,covb_deductible VARCHAR(255)   ENCODE lzo
,covc_deductible VARCHAR(255)   ENCODE lzo
,covd_deductible VARCHAR(255)   ENCODE lzo
,cove_deductible VARCHAR(255)   ENCODE lzo
,covf_deductible VARCHAR(255)   ENCODE lzo
,cova_limit VARCHAR(255)   ENCODE lzo
,covb_limit VARCHAR(255)   ENCODE lzo
,covc_limit VARCHAR(255)   ENCODE lzo
,covd_limit VARCHAR(255)   ENCODE lzo
,cove_limit VARCHAR(255)   ENCODE lzo
,covf_limit VARCHAR(255)   ENCODE lzo
,cova_fulltermamt NUMERIC(38,6)   ENCODE az64
,covb_fulltermamt NUMERIC(38,6)   ENCODE az64
,covc_fulltermamt NUMERIC(38,6)   ENCODE az64
,covd_fulltermamt NUMERIC(38,6)   ENCODE az64
,cove_fulltermamt NUMERIC(38,6)   ENCODE az64
,covf_fulltermamt NUMERIC(38,6)   ENCODE az64
,onpremises_theft_limit VARCHAR(255)   ENCODE lzo
,awayfrompremises_theft_limit VARCHAR(255)   ENCODE lzo
,quality_polappinconsistency_flg VARCHAR(3)   ENCODE lzo
,quality_riskidduplicates_flg VARCHAR(3)   ENCODE lzo
,quality_claimok_flg VARCHAR(100) ENCODE lzo
,quality_claimpolicytermjoin_flg VARCHAR(100) ENCODE lzo
,loaddate DATE   ENCODE az64
)
BACKUP no
SORTKEY 
(
startdatetm
) ;

COMMENT ON TABLE fsbi_stg_spinn.stg_property_modeldata IS 'Staging table for Homeowners and Dwelling modeling data';
