CREATE OR REPLACE PROCEDURE cse_bi.sp_fact_auto_modeldata(ploaddate timestamp)
LANGUAGE plpgsql
AS $$
BEGIN
/* 
Author: Kate Drogaieva 
Purpose: This script populate FACT_AUTO_MODELDATA 
Comment: Due to back dated transactions it was made as a full refresh. 
ToDo: incremental refresh ignoring changes in expired policies 
03/07/2023: Back to Redshift 
12/13/2019: Using DIM_POLICY_CHANGES instead of DIM_POLICY_DISCOUNT_CHANGES 
11/27/2019: Fixed error in the insert into fact table. Distint is added to avoide duplications by claimrisk_id 
10/25/2019: All coverages, Limit and deductible in Limit and deductible columns, BILimit1530, UMBILimit1530, UIMBILimit1530 
*/
/*2. BI, UMBI, PD Limits and Coll, Comp deductibles columns for easy filtering and producer ID*/
drop table if exists stg_auto_modeldata0;
create temporary table stg_auto_modeldata0 as
select
stg.*
,isnull(p.producer_id,4) producer_id
,dc.policy_changes_id
-- 
-- 
,isnull(COLLcov.Deductible1,'~') coll_deductible
,isnull(COMPcov.Deductible1,'~') comp_deductible
,isnull(BIcov.Limit1,'~') bi_limit1
,isnull(BIcov.Limit2,'~') bi_limit2
,isnull(UMBIcov.Limit1,'~') umbi_limit1
,isnull(UMBIcov.Limit2,'~') umbi_limit2
,isnull(PDcov.Limit1,'~') pd_limit1
,isnull(PDcov.Limit2,'~') pd_limit2
-- 
from fsbi_stg_spinn.stg_auto_modeldata stg
join fsbi_dw_spinn.dim_policy_changes dc
on stg.policy_uniqueid=dc.policy_uniqueid
and stg.Startdatetm >= dc.valid_fromdate and stg.Startdatetm<dc.valid_todate
-- 
left outer join fsbi_stg_spinn.vstg_auto_modeldata_coverage BIcov
on stg.policy_uniqueid=BIcov.policy_uniqueid
and stg.SystemIdStart=BIcov.SystemId
and stg.risk_uniqueid=BIcov.risk_uniqueid
and BIcov.act_modeldata = 'BI'
left outer join fsbi_stg_spinn.vstg_auto_modeldata_coverage UMBIcov
on stg.policy_uniqueid=UMBIcov.policy_uniqueid
and stg.SystemIdStart=UMBIcov.SystemId
and stg.risk_uniqueid=UMBIcov.risk_uniqueid
and UMBIcov.act_modeldata = 'UMBI'
left outer join fsbi_stg_spinn.vstg_auto_modeldata_coverage PDcov
on stg.policy_uniqueid=PDcov.policy_uniqueid
and stg.SystemIdStart=PDcov.SystemId
and stg.risk_uniqueid=PDcov.risk_uniqueid
and PDcov.act_modeldata = 'PD'
left outer join fsbi_stg_spinn.vstg_auto_modeldata_coverage COLLcov
on stg.policy_uniqueid=COLLcov.policy_uniqueid
and stg.SystemIdStart=COLLcov.SystemId
and stg.risk_uniqueid=COLLcov.risk_uniqueid
and COLLcov.act_modeldata = 'COLL'
left outer join fsbi_stg_spinn.vstg_auto_modeldata_coverage COMPcov
on stg.policy_uniqueid=COMPcov.policy_uniqueid
and stg.SystemIdStart=COMPcov.SystemId
and stg.risk_uniqueid=COMPcov.risk_uniqueid
and COMPcov.act_modeldata = 'COMP'
-- 
left outer join fsbi_dw_spinn.DIM_PRODUCER p
on p.producer_uniqueid=isnull(stg.producer_uniqueid,'Unknown')
and stg.Startdatetm >= p.valid_fromdate and stg.Startdatetm<p.valid_todate;
/*3 Extending STG_AUTO_MODELDATA for all coverages*/
drop table if exists tmp_auto_modeldata;
create temporary table tmp_auto_modeldata as
select
stg.*
-- 
,cov.act_modeldata coveragecd
,isnull(cov.Limit1,'~') Limit1
,isnull(cov.Limit2,'~') Limit2
,isnull(cov.Deductible1,'~') Deductible
,cov.FullTermAmt wp
-- 
from stg_auto_modeldata0 stg
join fsbi_stg_spinn.vstg_auto_modeldata_coverage cov
on stg.policy_uniqueid=cov.policy_uniqueid
and stg.SystemIdStart=cov.SystemId
and stg.risk_uniqueid=cov.risk_uniqueid
and cov.act_modeldata in ('APMP','BI','COLL','COMP','CUSTE','CWAIV','LOAN','MP','OEM','PD','RIDESH','ROAD',
'RREIM','RRGAP','UIMBI','UIMPD','UMBI','UMPD')
;
drop table if exists stg_auto_modeldata0;
/*4 Claims*/
/*4.1 Only claims data. Non-claims not need aggregation and will be joined later*/
drop table if exists stg_auto_modeldata_claims;
create temporary table stg_auto_modeldata_claims as
select
stg.modeldata_id
,stg.coveragecd
-- 
,Quality_ClaimOk_Flg
,Quality_ClaimUnknownVIN_Flg
,Quality_ClaimUnknownVINNotListedDriver_Flg
,Quality_ClaimPolicyTermJoin_Flg
-- 
,c.claimrisk_id
,c.CatFlg
,c.AtFaultcd
,c.lossinc
,c.dcce
,sum(c.lossinc) over(partition by c.claimrisk_id) allcov_lossinc
,sum(c.dcce) over(partition by c.claimrisk_id) allcov_dcce
,c.BIlossinc1530
,c.UMBIlossinc1530
,c.UIMBIlossinc1530
from tmp_auto_modeldata stg
join fsbi_stg_spinn.vstg_auto_modeldata_claims c
on stg.claimrisk_id=c.claimrisk_id
and stg.coveragecd=c.coveragecd ;
/* 
4.2 Aggregate Claims data 
*/
drop table if exists tmp_fact_auto_modeldataset_claims_grouped;
create temporary table tmp_fact_auto_modeldataset_claims_grouped as
select
modeldata_id ,
-- 
CoverageCd,
-- 
count(distinct case when AtFaultcd='At Fault' then claimrisk_id else null end) AtFaultcdClaims_count,
-- 
--Cov Count 
count(distinct (case when lossinc >0 and lossinc <= 500 then claimrisk_id else null end)) COV_claim_count_le500,
count(distinct (case when lossinc >= 1000 then claimrisk_id else null end)) COV_claim_count_1000,
count(distinct (case when lossinc >= 1500 then claimrisk_id else null end)) COV_claim_count_1500,
count(distinct (case when lossinc >= 2000 then claimrisk_id else null end)) COV_claim_count_2000,
count(distinct (case when lossinc >= 2500 then claimrisk_id else null end)) COV_claim_count_2500,
count(distinct (case when lossinc >= 5000 then claimrisk_id else null end)) COV_claim_count_5k,
count(distinct (case when lossinc >= 10000 then claimrisk_id else null end)) COV_claim_count_10k,
count(distinct (case when lossinc >= 25000 then claimrisk_id else null end)) COV_claim_count_25k,
count(distinct (case when lossinc >= 50000 then claimrisk_id else null end)) COV_claim_count_50k,
count(distinct (case when lossinc >= 100000 then claimrisk_id else null end)) COV_claim_count_100k,
count(distinct (case when lossinc >= 250000 then claimrisk_id else null end)) COV_claim_count_250k,
count(distinct (case when lossinc >= 500000 then claimrisk_id else null end)) COV_claim_count_500k,
count(distinct (case when lossinc >= 750000 then claimrisk_id else null end)) COV_claim_count_750k,
count(distinct (case when lossinc >= 1000000 then claimrisk_id else null end)) COV_claim_count_1M,
count(distinct (case when lossinc > 0 then claimrisk_id else null end)) COV_claim_count ,
--Claim Count 
count(distinct (case when allcov_lossinc > 0 and allcov_lossinc<= 500 then claimrisk_id else null end)) claim_count_le500,
count(distinct (case when allcov_lossinc >= 1000 then claimrisk_id else null end)) claim_count_1000,
count(distinct (case when allcov_lossinc >= 1500 then claimrisk_id else null end)) claim_count_1500,
count(distinct (case when allcov_lossinc >= 2000 then claimrisk_id else null end)) claim_count_2000,
count(distinct (case when allcov_lossinc >= 2500 then claimrisk_id else null end)) claim_count_2500,
count(distinct (case when allcov_lossinc >= 5000 then claimrisk_id else null end)) claim_count_5k,
count(distinct (case when allcov_lossinc >= 10000 then claimrisk_id else null end)) claim_count_10k,
count(distinct (case when allcov_lossinc >= 25000 then claimrisk_id else null end)) claim_count_25k,
count(distinct (case when allcov_lossinc >= 50000 then claimrisk_id else null end)) claim_count_50k,
count(distinct (case when allcov_lossinc >= 100000 then claimrisk_id else null end)) claim_count_100k,
count(distinct (case when allcov_lossinc >= 250000 then claimrisk_id else null end)) claim_count_250k,
count(distinct (case when allcov_lossinc >= 500000 then claimrisk_id else null end)) claim_count_500k,
count(distinct (case when allcov_lossinc >= 750000 then claimrisk_id else null end)) claim_count_750k,
count(distinct (case when allcov_lossinc >= 1000000 then claimrisk_id else null end)) claim_count_1M,
count(distinct (case when allcov_lossinc > 0 then claimrisk_id else null end)) claim_count ,
--All coverages 
--nc 
sum(case when CatFlg='N' then allcov_lossinc else 0.00 end) nc_inc_loss,
--cat 
sum( case when CatFlg='Y' then allcov_lossinc else 0.00 end) cat_inc_loss ,
--nc 
sum( case when CatFlg='N' then allcov_dcce else 0.00 end) nc_inc_loss_dcce ,
--cat 
sum( case when CatFlg='Y' then allcov_dcce else 0.00 end) cat_inc_loss_dcce ,
--nc 
sum( case when CatFlg='N' then lossinc else 0.00 end) nc_cov_inc_loss ,
--cat 
sum( case when CatFlg='Y' then lossinc else 0.00 end) cat_cov_inc_loss ,
--nc dcce 
sum( case when CatFlg='N' then dcce else 0.00 end) nc_cov_inc_loss_dcce ,
--cat 
sum( case when CatFlg='Y' then dcce else 0.00 end) cat_cov_inc_loss_dcce ,
-- 
sum(BIlossinc1530) BIlossinc1530,
sum(UMBIlossinc1530) UMBIlossinc1530,
sum(UIMBIlossinc1530) UIMBIlossinc1530,
-- 
count(distinct Quality_ClaimOk_Flg) Quality_ClaimOk_Flg,
count(distinct Quality_ClaimUnknownVIN_Flg) Quality_ClaimUnknownVIN_Flg,
count(distinct Quality_ClaimUnknownVINNotListedDriver_Flg) Quality_ClaimUnknownVINNotListedDriver_Flg,
count(distinct Quality_ClaimPolicyTermJoin_Flg) Quality_ClaimPolicyTermJoin_Flg
-- 
from stg_auto_modeldata_claims m
group by
modeldata_id,
CoverageCd;
/* 
4.3 Capping Aggregated Claims data 
*/
drop table if exists tmp_fact_auto_modeldataset_claims_capped;
create temporary table tmp_fact_auto_modeldataset_claims_capped as
select
modeldata_id ,
-- 
CoverageCd,
-- 
AtFaultcdClaims_count,
-- 
--COV Claim Count 
COV_claim_count_le500,
COV_claim_count_1000,
COV_claim_count_1500,
COV_claim_count_2000,
COV_claim_count_2500,
COV_claim_count_5k,
COV_claim_count_10k,
COV_claim_count_25k,
COV_claim_count_50k,
COV_claim_count_100k,
COV_claim_count_250k,
COV_claim_count_500k,
COV_claim_count_750k,
COV_claim_count_1M,
COV_claim_count,
--Claim Count 
claim_count_le500,
claim_count_1000,
claim_count_1500,
claim_count_2000,
claim_count_2500,
claim_count_5k,
claim_count_10k,
claim_count_25k,
claim_count_50k,
claim_count_100k,
claim_count_250k,
claim_count_500k,
claim_count_750k,
claim_count_1M,
claim_count ,
--All coverages 
--nc 
case when 500>=nc_inc_loss then nc_inc_loss else 0.00 end nc_inc_loss_le500,
case when 1000<nc_inc_loss then 1000 else nc_inc_loss end nc_inc_loss_1000,
case when 1500<nc_inc_loss then 1500 else nc_inc_loss end nc_inc_loss_1500,
case when 2000<nc_inc_loss then 2000 else nc_inc_loss end nc_inc_loss_2000,
case when 2500<nc_inc_loss then 2500 else nc_inc_loss end nc_inc_loss_2500,
case when 5000<nc_inc_loss then 5000 else nc_inc_loss end nc_inc_loss_5k,
case when 10000<nc_inc_loss then 10000 else nc_inc_loss end nc_inc_loss_10k,
case when 25000<nc_inc_loss then 25000 else nc_inc_loss end nc_inc_loss_25k,
case when 50000<nc_inc_loss then 50000 else nc_inc_loss end nc_inc_loss_50k,
case when 100000<nc_inc_loss then 100000 else nc_inc_loss end nc_inc_loss_100k,
case when 250000<nc_inc_loss then 250000 else nc_inc_loss end nc_inc_loss_250k,
case when 500000<nc_inc_loss then 500000 else nc_inc_loss end nc_inc_loss_500k,
case when 750000<nc_inc_loss then 750000 else nc_inc_loss end nc_inc_loss_750k,
case when 1000000<nc_inc_loss then 1000000 else nc_inc_loss end nc_inc_loss_1M,
nc_inc_loss,
--cat 
case when 500>=cat_inc_loss then cat_inc_loss else 0.00 end cat_inc_loss_le500,
case when 1000<cat_inc_loss then 1000 else cat_inc_loss end cat_inc_loss_1000,
case when 1500<cat_inc_loss then 1500 else cat_inc_loss end cat_inc_loss_1500,
case when 2000<cat_inc_loss then 2000 else cat_inc_loss end cat_inc_loss_2000,
case when 2500<cat_inc_loss then 2500 else cat_inc_loss end cat_inc_loss_2500,
case when 5000<cat_inc_loss then 5000 else cat_inc_loss end cat_inc_loss_5k,
case when 10000<cat_inc_loss then 10000 else cat_inc_loss end cat_inc_loss_10k,
case when 25000<cat_inc_loss then 25000 else cat_inc_loss end cat_inc_loss_25k,
case when 50000<cat_inc_loss then 50000 else cat_inc_loss end cat_inc_loss_50k,
case when 100000<cat_inc_loss then 100000 else cat_inc_loss end cat_inc_loss_100k,
case when 250000<cat_inc_loss then 250000 else cat_inc_loss end cat_inc_loss_250k,
case when 500000<cat_inc_loss then 500000 else cat_inc_loss end cat_inc_loss_500k,
case when 750000<cat_inc_loss then 750000 else cat_inc_loss end cat_inc_loss_750k,
case when 1000000<cat_inc_loss then 1000000 else cat_inc_loss end cat_inc_loss_1M,
cat_inc_loss ,
--nc 
case when 500>=nc_inc_loss then nc_inc_loss+nc_inc_loss_dcce else 0.00 end nc_inc_loss_dcce_le500,
case when 1000<nc_inc_loss then 1000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_1000,
case when 1500<nc_inc_loss then 1500 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_1500,
case when 2000<nc_inc_loss then 2000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_2000,
case when 2500<nc_inc_loss then 2500 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_2500,
case when 5000<nc_inc_loss then 5000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_5k,
case when 10000<nc_inc_loss then 10000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_10k,
case when 25000<nc_inc_loss then 25000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_25k,
case when 50000<nc_inc_loss then 50000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_50k,
case when 100000<nc_inc_loss then 100000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_100k,
case when 250000<nc_inc_loss then 250000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_250k,
case when 500000<nc_inc_loss then 500000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_500k,
case when 750000<nc_inc_loss then 750000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_750k,
case when 1000000<nc_inc_loss then 1000000 else nc_inc_loss end+nc_inc_loss_dcce nc_inc_loss_dcce_1M,
nc_inc_loss+nc_inc_loss_dcce nc_inc_loss_dcce,
--cat 
case when 500>=cat_inc_loss then cat_inc_loss+cat_inc_loss_dcce else 0.00 end cat_inc_loss_dcce_le500,
case when 1000<cat_inc_loss then 1000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_1000,
case when 1500<cat_inc_loss then 1500 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_1500,
case when 2000<cat_inc_loss then 2000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_2000,
case when 2500<cat_inc_loss then 2500 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_2500,
case when 5000<cat_inc_loss then 5000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_5k,
case when 10000<cat_inc_loss then 10000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_10k,
case when 25000<cat_inc_loss then 25000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_25k,
case when 50000<cat_inc_loss then 50000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_50k,
case when 100000<cat_inc_loss then 100000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_100k,
case when 250000<cat_inc_loss then 250000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_250k,
case when 500000<cat_inc_loss then 500000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_500k,
case when 750000<cat_inc_loss then 750000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_750k,
case when 1000000<cat_inc_loss then 1000000 else cat_inc_loss end+cat_inc_loss_dcce cat_inc_loss_dcce_1M,
cat_inc_loss+cat_inc_loss_dcce cat_inc_loss_dcce,
--COV 
--nc 
case when 500>=nc_COV_inc_loss then nc_COV_inc_loss else 0.00 end nc_COV_inc_loss_le500,
case when 1000<nc_COV_inc_loss then 1000 else nc_COV_inc_loss end nc_COV_inc_loss_1000,
case when 1500<nc_COV_inc_loss then 1500 else nc_COV_inc_loss end nc_COV_inc_loss_1500,
case when 2000<nc_COV_inc_loss then 2000 else nc_COV_inc_loss end nc_COV_inc_loss_2000,
case when 2500<nc_COV_inc_loss then 2500 else nc_COV_inc_loss end nc_COV_inc_loss_2500,
case when 5000<nc_COV_inc_loss then 5000 else nc_COV_inc_loss end nc_COV_inc_loss_5k,
case when 10000<nc_COV_inc_loss then 10000 else nc_COV_inc_loss end nc_COV_inc_loss_10k,
case when 25000<nc_COV_inc_loss then 25000 else nc_COV_inc_loss end nc_COV_inc_loss_25k,
case when 50000<nc_COV_inc_loss then 50000 else nc_COV_inc_loss end nc_COV_inc_loss_50k,
case when 100000<nc_COV_inc_loss then 100000 else nc_COV_inc_loss end nc_COV_inc_loss_100k,
case when 250000<nc_COV_inc_loss then 250000 else nc_COV_inc_loss end nc_COV_inc_loss_250k,
case when 500000<nc_COV_inc_loss then 500000 else nc_COV_inc_loss end nc_COV_inc_loss_500k,
case when 750000<nc_COV_inc_loss then 750000 else nc_COV_inc_loss end nc_COV_inc_loss_750k,
case when 1000000<nc_COV_inc_loss then 1000000 else nc_COV_inc_loss end nc_COV_inc_loss_1M,
nc_COV_inc_loss ,
--cat 
case when 500>=cat_COV_inc_loss then cat_COV_inc_loss else 0.00 end cat_COV_inc_loss_le500,
case when 1000<cat_COV_inc_loss then 1000 else cat_COV_inc_loss end cat_COV_inc_loss_1000,
case when 1500<cat_COV_inc_loss then 1500 else cat_COV_inc_loss end cat_COV_inc_loss_1500,
case when 2000<cat_COV_inc_loss then 2000 else cat_COV_inc_loss end cat_COV_inc_loss_2000,
case when 2500<cat_COV_inc_loss then 2500 else cat_COV_inc_loss end cat_COV_inc_loss_2500,
case when 5000<cat_COV_inc_loss then 5000 else cat_COV_inc_loss end cat_COV_inc_loss_5k,
case when 10000<cat_COV_inc_loss then 10000 else cat_COV_inc_loss end cat_COV_inc_loss_10k,
case when 25000<cat_COV_inc_loss then 25000 else cat_COV_inc_loss end cat_COV_inc_loss_25k,
case when 50000<cat_COV_inc_loss then 50000 else cat_COV_inc_loss end cat_COV_inc_loss_50k,
case when 100000<cat_COV_inc_loss then 100000 else cat_COV_inc_loss end cat_COV_inc_loss_100k,
case when 250000<cat_COV_inc_loss then 250000 else cat_COV_inc_loss end cat_COV_inc_loss_250k,
case when 500000<cat_COV_inc_loss then 500000 else cat_COV_inc_loss end cat_COV_inc_loss_500k,
case when 750000<cat_COV_inc_loss then 750000 else cat_COV_inc_loss end cat_COV_inc_loss_750k,
case when 1000000<cat_COV_inc_loss then 1000000 else cat_COV_inc_loss end cat_COV_inc_loss_1M,
cat_COV_inc_loss ,
--nc dcce 
case when 500>=nc_COV_inc_loss then nc_COV_inc_loss+nc_COV_inc_loss_dcce else 0.00 end nc_COV_inc_loss_dcce_le500,
case when 1000<nc_COV_inc_loss then 1000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_1000,
case when 1500<nc_COV_inc_loss then 1500 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_1500,
case when 2000<nc_COV_inc_loss then 2000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_2000,
case when 2500<nc_COV_inc_loss then 2500 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_2500,
case when 5000<nc_COV_inc_loss then 5000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_5k,
case when 10000<nc_COV_inc_loss then 10000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_10k,
case when 25000<nc_COV_inc_loss then 25000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_25k,
case when 50000<nc_COV_inc_loss then 50000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_50k,
case when 100000<nc_COV_inc_loss then 100000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_100k,
case when 250000<nc_COV_inc_loss then 250000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_250k,
case when 500000<nc_COV_inc_loss then 500000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_500k,
case when 750000<nc_COV_inc_loss then 750000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_750k,
case when 1000000<nc_COV_inc_loss then 1000000 else nc_COV_inc_loss end+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce_1M,
nc_COV_inc_loss+nc_COV_inc_loss_dcce nc_COV_inc_loss_dcce,
--cat 
case when 500>=cat_COV_inc_loss then cat_COV_inc_loss+cat_COV_inc_loss_dcce else 0.00 end cat_COV_inc_loss_dcce_le500,
case when 1000<cat_COV_inc_loss then 1000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_1000,
case when 1500<cat_COV_inc_loss then 1500 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_1500,
case when 2000<cat_COV_inc_loss then 2000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_2000,
case when 2500<cat_COV_inc_loss then 2500 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_2500,
case when 5000<cat_COV_inc_loss then 5000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_5k,
case when 10000<cat_COV_inc_loss then 10000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_10k,
case when 25000<cat_COV_inc_loss then 25000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_25k,
case when 50000<cat_COV_inc_loss then 50000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_50k,
case when 100000<cat_COV_inc_loss then 100000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_100k,
case when 250000<cat_COV_inc_loss then 250000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_250k,
case when 500000<cat_COV_inc_loss then 500000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_500k,
case when 750000<cat_COV_inc_loss then 750000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_750k,
case when 1000000<cat_COV_inc_loss then 1000000 else cat_COV_inc_loss end+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce_1M,
cat_COV_inc_loss+cat_COV_inc_loss_dcce cat_COV_inc_loss_dcce,
-- 
BIlossinc1530 ,
UMBIlossinc1530 ,
UIMBIlossinc1530 ,
-- 
Quality_ClaimOk_Flg,
Quality_ClaimUnknownVIN_Flg,
Quality_ClaimUnknownVINNotListedDriver_Flg,
Quality_ClaimPolicyTermJoin_Flg
from tmp_fact_auto_modeldataset_claims_grouped m ;
drop table if exists tmp_fact_auto_modeldataset_claims_grouped;
drop table if exists stg_auto_modeldata_claims;
/*5 Final join modeldata (changes) without claims and claims aggregated data*/
truncate table fsbi_dw_spinn.fact_auto_modeldata;
insert into fsbi_dw_spinn.fact_auto_modeldata
select distinct
stg.modeldata_id ,
stg.SystemIdStart ,
stg.SystemIdEnd ,
stg.risk_id ,
stg.risktype ,
stg.policy_id ,
stg.policy_changes_id ,
stg.producer_id ,
stg.policy_uniqueid ,
stg.risk_uniqueid ,
stg.vehicle_id ,
stg.vehicle_uniqueid ,
stg.vin ,
stg.risknumber ,
stg.driver_id ,
stg.driver_uniqueid ,
stg.driverlicense ,
stg.drivernumber ,
stg.startdatetm ,
stg.enddatetm ,
stg.startdate ,
stg.enddate ,
stg.CntVeh ,
stg.CntDrv ,
stg.CntNonDrv ,
stg.CntExcludedDrv ,
stg.mindriverage ,
stg.VehicleInceptionDate ,
stg.DriverInceptionDate ,
stg.Liabilityonly_Flg ,
stg.Componly_Flg ,
stg.ExcludedDrv_Flg ,
isnull( f.atfaultcdclaims_count, 0) atfaultcdclaims_count ,
isnull( f.claim_count_le500, 0) claim_count_le500 ,
isnull( f.claim_count_1000, 0) claim_count_1000 ,
isnull( f.claim_count_1500, 0) claim_count_1500 ,
isnull( f.claim_count_2000, 0) claim_count_2000 ,
isnull( f.claim_count_2500, 0) claim_count_2500 ,
isnull( f.claim_count_5k, 0) claim_count_5k ,
isnull( f.claim_count_10k, 0) claim_count_10k ,
isnull( f.claim_count_25k, 0) claim_count_25k ,
isnull( f.claim_count_50k, 0) claim_count_50k ,
isnull( f.claim_count_100k, 0) claim_count_100k ,
isnull( f.claim_count_250k, 0) claim_count_250k ,
isnull( f.claim_count_500k, 0) claim_count_500k ,
isnull( f.claim_count_750k, 0) claim_count_750k ,
isnull( f.claim_count_1m, 0) claim_count_1m ,
isnull( f.claim_count, 0) claim_count ,
isnull( f.nc_inc_loss_le500, 0) nc_inc_loss_le500 ,
isnull( f.nc_inc_loss_1000, 0) nc_inc_loss_1000 ,
isnull( f.nc_inc_loss_1500, 0) nc_inc_loss_1500 ,
isnull( f.nc_inc_loss_2000, 0) nc_inc_loss_2000 ,
isnull( f.nc_inc_loss_2500, 0) nc_inc_loss_2500 ,
isnull( f.nc_inc_loss_5k, 0) nc_inc_loss_5k ,
isnull( f.nc_inc_loss_10k, 0) nc_inc_loss_10k ,
isnull( f.nc_inc_loss_25k, 0) nc_inc_loss_25k ,
isnull( f.nc_inc_loss_50k, 0) nc_inc_loss_50k ,
isnull( f.nc_inc_loss_100k, 0) nc_inc_loss_100k ,
isnull( f.nc_inc_loss_250k, 0) nc_inc_loss_250k ,
isnull( f.nc_inc_loss_500k, 0) nc_inc_loss_500k ,
isnull( f.nc_inc_loss_750k, 0) nc_inc_loss_750k ,
isnull( f.nc_inc_loss_1m, 0) nc_inc_loss_1m ,
isnull( f.nc_inc_loss, 0) nc_inc_loss ,
isnull( f.cat_inc_loss_le500, 0) cat_inc_loss_le500 ,
isnull( f.cat_inc_loss_1000, 0) cat_inc_loss_1000 ,
isnull( f.cat_inc_loss_1500, 0) cat_inc_loss_1500 ,
isnull( f.cat_inc_loss_2000, 0) cat_inc_loss_2000 ,
isnull( f.cat_inc_loss_2500, 0) cat_inc_loss_2500 ,
isnull( f.cat_inc_loss_5k, 0) cat_inc_loss_5k ,
isnull( f.cat_inc_loss_10k, 0) cat_inc_loss_10k ,
isnull( f.cat_inc_loss_25k, 0) cat_inc_loss_25k ,
isnull( f.cat_inc_loss_50k, 0) cat_inc_loss_50k ,
isnull( f.cat_inc_loss_100k, 0) cat_inc_loss_100k ,
isnull( f.cat_inc_loss_250k, 0) cat_inc_loss_250k ,
isnull( f.cat_inc_loss_500k, 0) cat_inc_loss_500k ,
isnull( f.cat_inc_loss_750k, 0) cat_inc_loss_750k ,
isnull( f.cat_inc_loss_1m, 0) cat_inc_loss_1m ,
isnull( f.cat_inc_loss, 0) cat_inc_loss ,
isnull( f.nc_inc_loss_dcce_le500, 0) nc_inc_loss_dcce_le500 ,
isnull( f.nc_inc_loss_dcce_1000, 0) nc_inc_loss_dcce_1000 ,
isnull( f.nc_inc_loss_dcce_1500, 0) nc_inc_loss_dcce_1500 ,
isnull( f.nc_inc_loss_dcce_2000, 0) nc_inc_loss_dcce_2000 ,
isnull( f.nc_inc_loss_dcce_2500, 0) nc_inc_loss_dcce_2500 ,
isnull( f.nc_inc_loss_dcce_5k, 0) nc_inc_loss_dcce_5k ,
isnull( f.nc_inc_loss_dcce_10k, 0) nc_inc_loss_dcce_10k ,
isnull( f.nc_inc_loss_dcce_25k, 0) nc_inc_loss_dcce_25k ,
isnull( f.nc_inc_loss_dcce_50k, 0) nc_inc_loss_dcce_50k ,
isnull( f.nc_inc_loss_dcce_100k, 0) nc_inc_loss_dcce_100k ,
isnull( f.nc_inc_loss_dcce_250k, 0) nc_inc_loss_dcce_250k ,
isnull( f.nc_inc_loss_dcce_500k, 0) nc_inc_loss_dcce_500k ,
isnull( f.nc_inc_loss_dcce_750k, 0) nc_inc_loss_dcce_750k ,
isnull( f.nc_inc_loss_dcce_1m, 0) nc_inc_loss_dcce_1m ,
isnull( f.nc_inc_loss_dcce, 0) nc_inc_loss_dcce ,
isnull( f.cat_inc_loss_dcce_le500, 0) cat_inc_loss_dcce_le500 ,
isnull( f.cat_inc_loss_dcce_1000, 0) cat_inc_loss_dcce_1000 ,
isnull( f.cat_inc_loss_dcce_1500, 0) cat_inc_loss_dcce_1500 ,
isnull( f.cat_inc_loss_dcce_2000, 0) cat_inc_loss_dcce_2000 ,
isnull( f.cat_inc_loss_dcce_2500, 0) cat_inc_loss_dcce_2500 ,
isnull( f.cat_inc_loss_dcce_5k, 0) cat_inc_loss_dcce_5k ,
isnull( f.cat_inc_loss_dcce_10k, 0) cat_inc_loss_dcce_10k ,
isnull( f.cat_inc_loss_dcce_25k, 0) cat_inc_loss_dcce_25k ,
isnull( f.cat_inc_loss_dcce_50k, 0) cat_inc_loss_dcce_50k ,
isnull( f.cat_inc_loss_dcce_100k, 0) cat_inc_loss_dcce_100k ,
isnull( f.cat_inc_loss_dcce_250k, 0) cat_inc_loss_dcce_250k ,
isnull( f.cat_inc_loss_dcce_500k, 0) cat_inc_loss_dcce_500k ,
isnull( f.cat_inc_loss_dcce_750k, 0) cat_inc_loss_dcce_750k ,
isnull( f.cat_inc_loss_dcce_1m, 0) cat_inc_loss_dcce_1m ,
isnull( f.cat_inc_loss_dcce, 0) cat_inc_loss_dcce ,
stg.coll_deductible ,
stg.comp_deductible ,
stg.bi_limit1 ,
stg.bi_limit2 ,
stg.umbi_limit1 ,
stg.umbi_limit2 ,
stg.pd_limit1 ,
stg.pd_limit2 ,
stg.coveragecd ,
stg.Limit1 ,
stg.Limit2 ,
stg.Deductible ,
stg.wp ,
isnull(f.cov_claim_count_le500 ,0) cov_claim_count_le500 ,
isnull(f.cov_claim_count_1000 ,0) cov_claim_count_1000 ,
isnull(f.cov_claim_count_1500 ,0) cov_claim_count_1500 ,
isnull(f.cov_claim_count_2000 ,0) cov_claim_count_2000 ,
isnull(f.cov_claim_count_2500 ,0) cov_claim_count_2500 ,
isnull(f.cov_claim_count_5k ,0) cov_claim_count_5k ,
isnull(f.cov_claim_count_10k ,0) cov_claim_count_10k ,
isnull(f.cov_claim_count_25k ,0) cov_claim_count_25k ,
isnull(f.cov_claim_count_50k ,0) cov_claim_count_50k ,
isnull(f.cov_claim_count_100k ,0) cov_claim_count_100k ,
isnull(f.cov_claim_count_250k ,0) cov_claim_count_250k ,
isnull(f.cov_claim_count_500k ,0) cov_claim_count_500k ,
isnull(f.cov_claim_count_750k ,0) cov_claim_count_750k ,
isnull(f.cov_claim_count_1m ,0) cov_claim_count_1m ,
isnull(f.cov_claim_count ,0) cov_claim_count ,
isnull(f.nc_cov_inc_loss_le500 ,0) nc_cov_inc_loss_le500 ,
isnull(f.nc_cov_inc_loss_1000 ,0) nc_cov_inc_loss_1000 ,
isnull(f.nc_cov_inc_loss_1500 ,0) nc_cov_inc_loss_1500 ,
isnull(f.nc_cov_inc_loss_2000 ,0) nc_cov_inc_loss_2000 ,
isnull(f.nc_cov_inc_loss_2500 ,0) nc_cov_inc_loss_2500 ,
isnull(f.nc_cov_inc_loss_5k ,0) nc_cov_inc_loss_5k ,
isnull(f.nc_cov_inc_loss_10k ,0) nc_cov_inc_loss_10k ,
isnull(f.nc_cov_inc_loss_25k ,0) nc_cov_inc_loss_25k ,
isnull(f.nc_cov_inc_loss_50k ,0) nc_cov_inc_loss_50k ,
isnull(f.nc_cov_inc_loss_100k ,0) nc_cov_inc_loss_100k ,
isnull(f.nc_cov_inc_loss_250k ,0) nc_cov_inc_loss_250k ,
isnull(f.nc_cov_inc_loss_500k ,0) nc_cov_inc_loss_500k ,
isnull(f.nc_cov_inc_loss_750k ,0) nc_cov_inc_loss_750k ,
isnull(f.nc_cov_inc_loss_1m ,0) nc_cov_inc_loss_1m ,
isnull(f.nc_cov_inc_loss ,0) nc_cov_inc_loss ,
isnull(f.cat_cov_inc_loss_le500 ,0) cat_cov_inc_loss_le500 ,
isnull(f.cat_cov_inc_loss_1000 ,0) cat_cov_inc_loss_1000 ,
isnull(f.cat_cov_inc_loss_1500 ,0) cat_cov_inc_loss_1500 ,
isnull(f.cat_cov_inc_loss_2000 ,0) cat_cov_inc_loss_2000 ,
isnull(f.cat_cov_inc_loss_2500 ,0) cat_cov_inc_loss_2500 ,
isnull(f.cat_cov_inc_loss_5k ,0) cat_cov_inc_loss_5k ,
isnull(f.cat_cov_inc_loss_10k ,0) cat_cov_inc_loss_10k ,
isnull(f.cat_cov_inc_loss_25k ,0) cat_cov_inc_loss_25k ,
isnull(f.cat_cov_inc_loss_50k ,0) cat_cov_inc_loss_50k ,
isnull(f.cat_cov_inc_loss_100k ,0) cat_cov_inc_loss_100k ,
isnull(f.cat_cov_inc_loss_250k ,0) cat_cov_inc_loss_250k ,
isnull(f.cat_cov_inc_loss_500k ,0) cat_cov_inc_loss_500k ,
isnull(f.cat_cov_inc_loss_750k ,0) cat_cov_inc_loss_750k ,
isnull(f.cat_cov_inc_loss_1m ,0) cat_cov_inc_loss_1m ,
isnull(f.cat_cov_inc_loss ,0) cat_cov_inc_loss ,
isnull(f.nc_cov_inc_loss_dcce_le500 ,0) nc_cov_inc_loss_dcce_le500 ,
isnull(f.nc_cov_inc_loss_dcce_1000 ,0) nc_cov_inc_loss_dcce_1000 ,
isnull(f.nc_cov_inc_loss_dcce_1500 ,0) nc_cov_inc_loss_dcce_1500 ,
isnull(f.nc_cov_inc_loss_dcce_2000 ,0) nc_cov_inc_loss_dcce_2000 ,
isnull(f.nc_cov_inc_loss_dcce_2500 ,0) nc_cov_inc_loss_dcce_2500 ,
isnull(f.nc_cov_inc_loss_dcce_5k ,0) nc_cov_inc_loss_dcce_5k ,
isnull(f.nc_cov_inc_loss_dcce_10k ,0) nc_cov_inc_loss_dcce_10k ,
isnull(f.nc_cov_inc_loss_dcce_25k ,0) nc_cov_inc_loss_dcce_25k ,
isnull(f.nc_cov_inc_loss_dcce_50k ,0) nc_cov_inc_loss_dcce_50k ,
isnull(f.nc_cov_inc_loss_dcce_100k ,0) nc_cov_inc_loss_dcce_100k ,
isnull(f.nc_cov_inc_loss_dcce_250k ,0) nc_cov_inc_loss_dcce_250k ,
isnull(f.nc_cov_inc_loss_dcce_500k ,0) nc_cov_inc_loss_dcce_500k ,
isnull(f.nc_cov_inc_loss_dcce_750k ,0) nc_cov_inc_loss_dcce_750k ,
isnull(f.nc_cov_inc_loss_dcce_1m ,0) nc_cov_inc_loss_dcce_1m ,
isnull(f.nc_cov_inc_loss_dcce ,0) nc_cov_inc_loss_dcce ,
isnull(f.cat_cov_inc_loss_dcce_le500 ,0) cat_cov_inc_loss_dcce_le500 ,
isnull(f.cat_cov_inc_loss_dcce_1000 ,0) cat_cov_inc_loss_dcce_1000 ,
isnull(f.cat_cov_inc_loss_dcce_1500 ,0) cat_cov_inc_loss_dcce_1500 ,
isnull(f.cat_cov_inc_loss_dcce_2000 ,0) cat_cov_inc_loss_dcce_2000 ,
isnull(f.cat_cov_inc_loss_dcce_2500 ,0) cat_cov_inc_loss_dcce_2500 ,
isnull(f.cat_cov_inc_loss_dcce_5k ,0) cat_cov_inc_loss_dcce_5k ,
isnull(f.cat_cov_inc_loss_dcce_10k ,0) cat_cov_inc_loss_dcce_10k ,
isnull(f.cat_cov_inc_loss_dcce_25k ,0) cat_cov_inc_loss_dcce_25k ,
isnull(f.cat_cov_inc_loss_dcce_50k ,0) cat_cov_inc_loss_dcce_50k ,
isnull(f.cat_cov_inc_loss_dcce_100k ,0) cat_cov_inc_loss_dcce_100k ,
isnull(f.cat_cov_inc_loss_dcce_250k ,0) cat_cov_inc_loss_dcce_250k ,
isnull(f.cat_cov_inc_loss_dcce_500k ,0) cat_cov_inc_loss_dcce_500k ,
isnull(f.cat_cov_inc_loss_dcce_750k ,0) cat_cov_inc_loss_dcce_750k ,
isnull(f.cat_cov_inc_loss_dcce_1m ,0) cat_cov_inc_loss_dcce_1m ,
isnull(f.cat_cov_inc_loss_dcce ,0) cat_cov_inc_loss_dcce ,
isnull(f.BIlossinc1530 ,0) BIlossinc1530 ,
isnull(f.UMBIlossinc1530 ,0) UMBIlossinc1530 ,
isnull(f.UIMBIlossinc1530 ,0) UIMBIlossinc1530 ,
stg.Quality_PolAppInconsistency_Flg ,
stg.Quality_RiskIdDuplicates_Flg ,
stg.Quality_ExcludedDrv_Flg ,
stg.Quality_ReplacedVIN_Flg ,
stg.Quality_ReplacedDriver_Flg ,
isnull( f.Quality_claimok_Flg, 0) Quality_claimok_Flg ,
isnull( f.Quality_claimunknownvin_Flg, 0) Quality_claimunknownvin_Flg ,
isnull( f.Quality_claimunknownvinnotlisteddriver_Flg, 0) Quality_claimunknownvinnotlisteddriver_Flg ,
isnull( f.Quality_claimpolicytermjoin_Flg, 0) Quality_claimpolicytermjoin_Flg ,
ploaddate loaddate
from tmp_auto_modeldata stg
left outer join tmp_fact_auto_modeldataset_claims_capped f
on f.modeldata_id=stg.modeldata_id
and f.coveragecd=stg.coveragecd;
drop table if exists tmp_fact_auto_modeldataset_claims_capped;
drop table if exists tmp_auto_modeldata;
END;


$$
;
