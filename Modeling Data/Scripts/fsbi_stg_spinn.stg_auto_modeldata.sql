DROP TABLE IF EXISTS fsbi_stg_spinn.stg_auto_modeldata;
CREATE TABLE  fsbi_stg_spinn.stg_auto_modeldata
(
modeldata_id BIGINT   ENCODE az64
,claimrisk_id INTEGER   ENCODE az64
,SystemIdStart INTEGER   ENCODE lzo
,systemidend INTEGER   ENCODE az64
,risk_id INTEGER   ENCODE az64
,risktype VARCHAR(255)   ENCODE lzo
,policy_id INTEGER   ENCODE az64 DISTKEY
,policy_uniqueid VARCHAR(20)   ENCODE RAW
,producer_uniqueid VARCHAR(20)   ENCODE lzo
,risk_uniqueid VARCHAR(100)   ENCODE RAW
,vehicle_id INTEGER   ENCODE az64
,vehicle_uniqueid VARCHAR(250)   ENCODE lzo
,vin VARCHAR(100)   ENCODE RAW
,risknumber  INTEGER   ENCODE az64
,driver_id INTEGER   ENCODE az64
,driver_uniqueid VARCHAR(250)   ENCODE lzo
,driverlicense VARCHAR(100)   ENCODE lzo
,drivernumber INTEGER   ENCODE az64
,startdatetm TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
,enddatetm TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
,startdate DATE   ENCODE RAW
,enddate DATE   ENCODE az64
,cntveh BIGINT   ENCODE az64
,cntdrv BIGINT   ENCODE az64
,cntnondrv BIGINT   ENCODE az64
,cntexcludeddrv BIGINT   ENCODE az64
,mindriverage INTEGER   ENCODE az64
,vehicleinceptiondate DATE  ENCODE az64
,driverinceptiondate DATE   ENCODE az64
,Liabilityonly_Flg VARCHAR(3)   ENCODE lzo
,Componly_Flg VARCHAR(3)   ENCODE lzo
,excludeddrv_flg VARCHAR(3)   ENCODE lzo
,quality_polappinconsistency_flg VARCHAR(3)   ENCODE lzo
,quality_riskidduplicates_flg VARCHAR(3)   ENCODE lzo
,quality_excludeddrv_flg VARCHAR(3)   ENCODE lzo
,quality_replacedvin_flg VARCHAR(3)   ENCODE lzo
,quality_replaceddriver_flg VARCHAR(3)   ENCODE lzo
,quality_claimok_flg VARCHAR(100)  ENCODE lzo
,quality_claimunknownvin_flg VARCHAR(100)   ENCODE lzo
,quality_claimunknownvinnotlisteddriver_flg VARCHAR(100)   ENCODE lzo
,quality_claimpolicytermjoin_flg VARCHAR(100)  ENCODE lzo
,loaddate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
)
BACKUP no
SORTKEY 
(
startdatetm
) ;


;


COMMENT ON TABLE fsbi_stg_spinn.stg_auto_modeldata IS 'Staging table for Auto modeling data';
