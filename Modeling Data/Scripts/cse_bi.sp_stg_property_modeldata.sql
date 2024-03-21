CREATE OR REPLACE PROCEDURE cse_bi.sp_stg_property_modeldata(ploaddate datetime)		
	LANGUAGE plpgsql	
AS $$		
		
BEGIN 		
		
/*		
Author: Kate Drogaieva		
Purpose: This script populate STG_HO_LL_MODELDATA (staging table for FACT_HO_LL_MODELDATA)		
Comment: Due to back dated transactions it was made as a full refresh.		
		
Last Modification Date: 02/14/2023		
Back to Redshift!		
Modification Date: 07/06/2020		
Adjusting mid-term change based on multipolicyind and autohomeind (the same indicator for different products)		
Adding Limits for THEFA coverage (On-premises and Away from premises		
Modification Date: 10/25/2019		
Adjusting to the new structure v_stg_ho_ll_modeldata_coverage new structure		
*/		
		
		
		
		
		
		
/*		
1. Limits, Deductible and FullTermAmount for each coverage of interest  at each mid-term change		
*/		
drop table if exists d_CovA;		
create temporary table d_CovA as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovA 		
where d_CovA.act_modeldata ='CovA';		
		
		
drop table if exists d_CovB;		
create temporary table d_CovB as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovB 		
where act_modeldata = 'CovB';		
		
drop table if exists d_CovC;		
create temporary table d_CovC as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovC 		
where act_modeldata = 'CovC';		
		
		
drop table if exists d_CovD;		
create temporary table d_CovD as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovD 		
where act_modeldata='CovD';		
		
drop table if exists d_CovE;		
create temporary table d_CovE as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovE 		
where act_modeldata = 'CovE';		
		
drop table if exists d_CovF;		
create temporary table d_CovF as		
select SystemId, policy_uniqueid,risk_uniqueid, Deductible1 Deductible 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage d_CovF 		
where act_modeldata  = 'CovF';		
		
		
drop table if exists l_CovA;		
create temporary table l_CovA as 		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovA 		
where act_modeldata = 'CovA'; 		
		
drop table if exists l_CovB;		
create temporary table l_CovB as		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovB 		
where act_modeldata = 'CovB'; 		
		
		
drop table if exists l_CovC;		
create temporary table l_CovC as 		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovC 		
where act_modeldata = 'CovC'; 		
		
		
drop table if exists l_CovD;		
create temporary table l_CovD as 		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovD 		
where act_modeldata =  'CovD'; 		
		
drop table if exists l_CovE;		
create temporary table l_CovE as		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovE 		
where act_modeldata = 'CovE'; 		
		
		
drop table if exists l_CovF;		
create temporary table l_CovF as 		
select SystemId, policy_uniqueid,risk_uniqueid, LIMIT1, FullTermAmt 		
from fsbi_stg_spinn.vstg_property_modeldata_coverage l_CovF 		
where act_modeldata = 'CovF'; 		
		
		
		
/*		
2. (1)Active  Risks 		
related to  New Business, Renewal or  Endorsement transactions (2).		
(3) If there are more then one change in the same day, we use the last change at this day		
(1)It's possible when a transaction with newest BookDt has an older effective date 		
then effective transactions already in the system.		
*/		
		
		
		
drop table if exists coveredrisk;		
create temporary table coveredrisk as 		
with cleaned_risks as (		
select 		
policy_uniqueid,		
cast(cvrsk_startdate as date) cvrsk_startdate,		
max(cvrsk_startdate) last_cvrsk_startdate_per_day		
from (		
select 		
cr.policy_uniqueid,		
cvrsk_startdate,		
spinn_systemid		
from fsbi_dw_spinn.dim_coveredrisk cr		
join fsbi_stg_spinn.vstg_modeldata_policyhistory f		
on f.SystemId=cr.spinn_systemid		
and f.PolicyRef=cr.policy_uniqueid		
where cvrsk_item_type='BUILDING'		
and cvrsk_item_uniqueid2='Unknown' --not BusinessOwners		
and f.TransactionCd in ('New Business','Renewal','Endorsement')		
) data		
group by 		
policy_uniqueid,		
cast(cvrsk_startdate as date)		
)		
select 		
cr.*		
from fsbi_dw_spinn.dim_coveredrisk cr		
join cleaned_risks 		
on cr.policy_uniqueid=cleaned_risks.policy_uniqueid		
and cr.cvrsk_startdate=cleaned_risks.last_cvrsk_startdate_per_day		
;		
		
		
		
		
		
		
/*3. There is no "Final" record in dim_coveredrisk		
with systemid=policy_uniqueid		
We need it to close the last entry in mid-term changes*/		
		
		
drop table if exists extend_dim_coveredrisk;		
create temporary table extend_dim_coveredrisk as 		
select *		
from		
(		
select 		
 coveredrisk_id		
,cvrsk_uniqueid		
,policy_uniqueid		
,policy_id		
,deleted_indicator		
,cvrsk_typedescription		
,cvrsk_item_id		
,cvrsk_item_uniqueid		
,cvrsk_item_type		
,cvrsk_item_id2		
,cvrsk_item_uniqueid2		
,cvrsk_item_type2		
,cvrsk_startdate		
,cvrsk_number		
,cvrsk_number2		
,cvrsk_item_naturalkey		
,cvrsk_item_naturalkey2		
,cvrsk_inceptiondate		
,cvrsk_inceptiondate2		
,policy_last_known_cvrsk_item_id		
,policy_last_known_cvrsk_item_id2		
,policy_term_last_known_cvrsk_item_id		
,policy_term_last_known_cvrsk_item_id2		
,spinn_systemid original_spinn_systemid		
,spinn_systemid		
,PolAppInconsistency_Flg		
,RiskIdDuplicates_Flg		
,RiskNumberDuplicates_Flg		
,RiskNaturalKeyDuplicates_Flg		
,RiskNaturalKey2Duplicates_Flg		
,ExcludedDrv_Flg		
,source_system		
,LoadDate		
from coveredrisk		
where policy_uniqueid<>'Unknown'		
union all		
select 		
 coveredrisk_id		
,dc.cvrsk_uniqueid		
,dc.policy_uniqueid		
,policy_id		
,deleted_indicator		
,cvrsk_typedescription		
,cvrsk_item_id		
,cvrsk_item_uniqueid		
,cvrsk_item_type		
,cvrsk_item_id2		
,cvrsk_item_uniqueid2		
,cvrsk_item_type2		
,cvrsk_startdate		
,cvrsk_number		
,cvrsk_number2		
,cvrsk_item_naturalkey		
,cvrsk_item_naturalkey2		
,cvrsk_inceptiondate		
,cvrsk_inceptiondate2		
,policy_last_known_cvrsk_item_id		
,policy_last_known_cvrsk_item_id2		
,policy_term_last_known_cvrsk_item_id		
,policy_term_last_known_cvrsk_item_id2		
,spinn_systemid original_spinn_systemid		
,cast(dc.policy_uniqueid as int) spinn_systemid		
,PolAppInconsistency_Flg		
,RiskIdDuplicates_Flg		
,RiskNumberDuplicates_Flg		
,RiskNaturalKeyDuplicates_Flg		
,RiskNaturalKey2Duplicates_Flg		
,ExcludedDrv_Flg		
,source_system		
,LoadDate		
from coveredrisk dc		
join (		
select policy_uniqueid, cvrsk_uniqueid, max(dc.spinn_systemid) id		
from coveredrisk dc		
where dc.policy_uniqueid<>'Unknown'		
group by policy_uniqueid, cvrsk_uniqueid		
) last_system		
on dc.spinn_systemId=last_system.id		
and dc.policy_uniqueid=last_system.policy_uniqueid		
and dc.cvrsk_uniqueid=last_system.cvrsk_uniqueid		
where dc.policy_uniqueid<>'Unknown'		
) d;		
		
		
drop table if exists coveredrisk;		
		
/*		
4. Main staging data select #tmp_PolicyRiskHistory		
based on stg_policyhistory plus all related info		
*/		
		
		
		
drop table if exists tmp_PolicyRiskHistory;		
create temporary table tmp_PolicyRiskHistory as 		
select distinct 		
  stg.SystemId		
, dc.original_spinn_systemid		
, dc.policy_id  		
, dc.policy_uniqueid		
, pg.Producer_Uniqueid		
, dc.coveredrisk_id	risk_id	
, dc.cvrsk_typedescription	RiskType	
, dc.cvrsk_uniqueid risk_uniqueid		
, dc.cvrsk_item_id building_id		
, b.SPInnBuilding_Id building_uniqueid		
, dc.cvrsk_number RiskCd		
, case when dc.deleted_indicator=1 then 'Deleted' else 'Active' end  status		
, case when dc.spinn_systemid=cast(dc.policy_uniqueid as int) then stg.transactioneffectivedt		
  else dc.cvrsk_startdate 		
  end changedate		
  --		
, b.UsageType		
, upper(replace(b.homegardcreditind	,'~','No')) homegardcreditind	
, upper(replace(b.sprinklersystem,'~','No')) sprinklersystem		
, upper(replace(b.landlordind,'~','No')) landlordind		
, upper(replace(b.cseagent,'~','No')) cseagent		
, upper(replace(b.rentersinsurance,'~','No')) RentersInsurance		
, upper(replace(b.FireAlarmType,'~','No')) FireAlarmType		
, upper(replace(b.BurglaryAlarmType,'~','No')) BurglaryAlarmType		
, upper(replace(b.WaterDetectionDevice,'~','No')) WaterDetectionDevice		
, upper(replace(b.NeighborhoodCrimeWatchInd,'~','No')) NeighborhoodCrimeWatchInd		
, upper(replace(b.PropertyManager,'~','No')) PropertyManager		
, upper(replace(b.earthquakeumbrellaind,'~','No')) earthquakeumbrellaind		
, upper(replace(b.MultiPolicyInd,'~','No')) MultiPolicyInd		
, upper(replace(b.AutoHomeInd,'~','No')) AutoHomeInd		
, upper(replace(b.MultiPolicyIndUmbrella,'~','No')) MultiPolicyIndUmbrella		
  --		
, upper(replace(CovADDRR_SecondaryResidence,'~','No')) CovADDRR_SecondaryResidence		
, CovADDRRPrem_SecondaryResidence		
  --		
, isnull(d_CovA.Deductible,'~') CovA_deductible		
, isnull(d_CovB.Deductible,'~') CovB_deductible		
, isnull(d_CovC.Deductible,'~') CovC_deductible		
, isnull(d_CovD.Deductible,'~') CovD_deductible		
, isnull(d_CovE.Deductible,'~') CovE_deductible		
, isnull(d_CovF.Deductible,'~') CovF_deductible		
  --		
, isnull(l_CovA.Limit1,'~')   CovA_Limit		
, isnull(l_CovB.Limit1,'~')   CovB_Limit		
, isnull(l_CovC.Limit1,'~')   CovC_Limit		
, isnull(l_CovD.Limit1,'~')   CovD_Limit		
, isnull(l_CovE.Limit1,'~')   CovE_Limit		
, isnull(l_CovF.Limit1,'~')   CovF_Limit		
 --		
, isnull(l_CovA.FullTermAmt,0)   CovA_FullTermAmt		
, isnull(l_CovB.FullTermAmt,0)   CovB_FullTermAmt		
, isnull(l_CovC.FullTermAmt,0)   CovC_FullTermAmt		
, isnull(l_CovD.FullTermAmt,0)   CovD_FullTermAmt		
, isnull(l_CovE.FullTermAmt,0)   CovE_FullTermAmt		
, isnull(l_CovF.FullTermAmt,0)   CovF_FullTermAmt		
, stg.TransactionCd		
,row_number() over(partition by dc.policy_uniqueid,dc.cvrsk_uniqueid order by   case when dc.spinn_systemid=cast(dc.policy_uniqueid as int) then stg.transactioneffectivedt		
  else dc.cvrsk_startdate 		
  end) rn_trn		
,count(*) over(partition by dc.policy_uniqueid,dc.cvrsk_uniqueid ) cn_trn		
,case when PolAppInconsistency_Flg='Y' then 'Yes' else 'No' end Quality_PolAppInconsistency_Flg		
,case when RiskIdDuplicates_Flg='Y' then 'Yes' else 'No' end Quality_RiskIdDuplicates_Flg		
		
from fsbi_stg_spinn.vstg_modeldata_policyhistory stg		
 --		
join extend_dim_coveredrisk dc		
on  stg.PolicyRef=dc.policy_uniqueid		
and stg.SystemId=dc.spinn_systemid		
 --		
join fsbi_dw_spinn.dim_building b		
on b.building_id=dc.cvrsk_item_id		
 --		
left outer join d_CovA	d_CovA	
on d_CovA.SystemId=stg.SystemId		
and d_CovA.policy_uniqueid=stg.PolicyRef		
and d_CovA.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join d_CovB	d_CovB	
on d_CovB.SystemId=stg.SystemId		
and d_CovB.policy_uniqueid=stg.PolicyRef		
and d_CovB.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join d_CovC	d_CovC	
on d_CovC.SystemId=stg.SystemId		
and d_CovC.policy_uniqueid=stg.PolicyRef		
and d_CovC.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join d_CovD	d_CovD	
on d_CovD.SystemId=stg.SystemId		
and d_CovD.policy_uniqueid=stg.PolicyRef		
and d_CovD.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join d_CovE	d_CovE	
on d_CovE.SystemId=stg.SystemId		
and d_CovE.policy_uniqueid=stg.PolicyRef		
and d_CovE.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join d_CovF	d_CovF	
on d_CovF.SystemId=stg.SystemId		
and d_CovF.policy_uniqueid=stg.PolicyRef		
and d_CovF.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
 --		
left outer join l_CovA	l_CovA	
on l_CovA.SystemId=stg.SystemId		
and l_CovA.policy_uniqueid=stg.PolicyRef		
and l_CovA.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join l_CovB	l_CovB	
on l_CovB.SystemId=stg.SystemId		
and l_CovB.policy_uniqueid=stg.PolicyRef		
and l_CovB.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join l_CovC	l_CovC	
on l_CovC.SystemId=stg.SystemId		
and l_CovC.policy_uniqueid=stg.PolicyRef		
and l_CovC.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join l_CovD	l_CovD	
on l_CovD.SystemId=stg.SystemId		
and l_CovD.policy_uniqueid=stg.PolicyRef		
and l_CovD.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join l_CovE	l_CovE	
on l_CovE.SystemId=stg.SystemId		
and l_CovE.policy_uniqueid=stg.PolicyRef		
and l_CovE.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join l_CovF	l_CovF	
on l_CovF.SystemId=stg.SystemId		
and l_CovF.policy_uniqueid=stg.PolicyRef		
and l_CovF.risk_uniqueid=dc.cvrsk_uniqueid		
 --		
left outer join fsbi_dw_spinn.DIM_POLICY_CHANGES pg		
on  stg.PolicyRef=pg.policy_uniqueid		
and stg.TransactionEffectiveDt >= pg.valid_fromdate and stg.TransactionEffectiveDt<pg.valid_todate		
 --		
where  stg.TransactionCd in ('New Business','Renewal','Endorsement', 'Final')		
and stg.ReplacedByTransactionNumber is null		
and stg.UnAppliedByTransactionNumber is null;		
		
		
		
drop table if exists d_CovA;		
drop table if exists d_CovB;		
drop table if exists d_CovC;		
drop table if exists d_CovD;		
drop table if exists d_CovE;		
drop table if exists d_CovF;		
		
		
		
drop table if exists l_CovA;		
drop table if exists l_CovB;		
drop table if exists l_CovC;		
drop table if exists l_CovD;		
drop table if exists l_CovE;		
drop table if exists l_CovF;		
		
drop table if exists extend_dim_coveredrisk;		
/*		
5. Changes in Risks		
*/		
		
/*-----------------------------------------------------------------------------*/		
		
drop table if exists data1;		
create temporary table data1 as 		
with d1 as (		
select  		
t0.Policy_UniqueId, 		
t0.SystemId,		
count(distinct t0.risk_uniqueid) CntRisks		
from tmp_PolicyRiskHistory t0		
group by Policy_UniqueId, SystemId		
)		
,d2 as (select  		
t0.Policy_UniqueId, 		
t0.SystemId,		
checksum(LISTAGG( distinct risk_uniqueid , ','  ) WITHIN GROUP (order by risk_uniqueid))  listrisks		
from tmp_PolicyRiskHistory t0		
group by Policy_UniqueId, SystemId	)	
select		
d1.Policy_UniqueId, 		
d1.SystemId,		
CntRisks,		
listrisks		
from d1 join d2		
on d1.Policy_UniqueId=d2.Policy_UniqueId		
and d1.SystemId=d2.SystemId		
order by d1.Policy_UniqueId, d1.SystemId;		
		
		
		
		
		
/*6. Calculated Limits, Deductibles, FullTrm amount Changed Flags 		
1 if something important changed  comparing to the next record		
and we need to add one more row in the model dataset		
*/		
		
		
		
drop table if exists OneFlg;		
create temporary table OneFlg as 		
 select 		
  data.Policy_Uniqueid		
, data.SystemId  		
, risk_uniqueid		
, changedate		
, case when Status<>lag(Status) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CntRisks<>lag(CntRisks) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when ListRisks<>lag(ListRisks) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when homegardcreditind<>lag(homegardcreditind) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when cseagent<>lag(cseagent) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when landlordind<>lag(landlordind) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when UsageType<>lag(UsageType) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when RentersInsurance<>lag(RentersInsurance) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when sprinklersystem<>lag(sprinklersystem) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when FireAlarmType<>lag(FireAlarmType) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when BurglaryAlarmType<>lag(BurglaryAlarmType) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when WaterDetectionDevice<>lag(WaterDetectionDevice) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when NeighborhoodCrimeWatchInd<>lag(NeighborhoodCrimeWatchInd) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when PropertyManager<>lag(PropertyManager) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when earthquakeumbrellaind<>lag(earthquakeumbrellaind) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end		
+ case when MultiPolicyInd<>lag(MultiPolicyInd) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when AutoHomeInd<>lag(AutoHomeInd) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when MultiPolicyIndUmbrella<>lag(MultiPolicyIndUmbrella) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when CovADDRR_SecondaryResidence<>lag(CovADDRR_SecondaryResidence) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when CovADDRRPrem_SecondaryResidence<>lag(CovADDRRPrem_SecondaryResidence) over (partition by data.Policy_Uniqueid order by data.changedate) then 1 else 0 end 		
+ case when CovA_Limit<>lag(CovA_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovB_Limit<>lag(CovB_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovC_Limit<>lag(CovC_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovD_Limit<>lag(CovD_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovE_Limit<>lag(CovE_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovF_Limit<>lag(CovF_Limit) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
--		
+ case when CovA_deductible<>lag(CovA_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovB_deductible<>lag(CovB_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovC_deductible<>lag(CovC_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovD_deductible<>lag(CovD_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovE_deductible<>lag(CovE_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovF_deductible<>lag(CovF_deductible) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
--		
+ case when CovA_FullTermAmt<>lag(CovA_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovB_FullTermAmt<>lag(CovB_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovC_FullTermAmt<>lag(CovC_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovD_FullTermAmt<>lag(CovD_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovE_FullTermAmt<>lag(CovE_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end 		
+ case when CovF_FullTermAmt<>lag(CovF_FullTermAmt) over (partition by data.Policy_Uniqueid, Risk_Uniqueid  order by data.changedate) then 1 else 0 end Flg		
--		
from tmp_PolicyRiskHistory data		
join data1		
on data.policy_uniqueid=data1.policy_uniqueid		
and data.SystemId=data1.SystemId;		
		
		
drop table if exists data1;		
		
		
/*		
7. Joining Counts and Flags together		
Adjusting Flag to 1 (Change, first or last change) or 0		
*/		
		
		
		
drop table if exists final_data2;		
create temporary table final_data2 as 		
select 		
  data.* 		
, case when OneFlg.Flg>0 or data.rn_trn=1 or data.rn_trn=data.cn_trn then 1 else 0 end Flg		
from tmp_PolicyRiskHistory data		
join OneFlg		
on data.Policy_Uniqueid=OneFlg.Policy_Uniqueid		
and data.SystemId =OneFlg.SystemId	;	
		
drop table if exists OneFlg;		
		
/*		
8. Final mid-term changes		
*/ 		
		
		
		
drop table if exists stg_ho_ll_modeldata_1;		
create temporary table stg_ho_ll_modeldata_1 as 		
with data3 as (		
select 		
  data2.*		
, changedate StartDateTm		
, lead(changedate) over (partition by data2.Policy_Uniqueid,  data2.risk_uniqueid order by changedate) EndDateTm		
, lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid, data2.risk_uniqueid order by changedate) SystemIdEnd		
from final_data2 data2		
where Flg=1		
)		
select 		
row_number() over(order by SystemId) modeldata_id	,	
data3.*		
from data3		
where status='Active'		
and EndDateTm is not null		
and abs(datediff(day,dateadd(sec, 100, StartDatetm),dateadd(sec, 100, EndDateTm)))>0		
order by Policy_Uniqueid,StartDatetm;		
		
drop table if exists final_data2;		
		
		
		
		
/*-----------------           9            ------------------------------------------*/		
/*----------------SPLITTING MID-TERM CHANGES FOR Calendar/Accident Year data---------*/		
/*----------------NUMBER OF CHANGES IS INCREASED HERE--------------------------------*/		
/*----------------FIRST ROW INDICATORS MUST BE CALCULATED HERE NOW-------------------*/		
/*----------------IMPORTANT !!! MODELDATA_ID is changed HERE-------------------------*/		
		
		
		
drop table if exists stg_ho_ll_modeldata_2;		
create temporary table stg_ho_ll_modeldata_2 as 		
with 		
dim_year as 		
/*dim_year from dim_month*/		
(select cast(mon_year as int) y, mon_startdate startdate, dateadd(month, 11, mon_enddate) enddate 		
 from fsbi_dw_spinn.dim_month		
 where mon_monthinyear=1)		
,data as 		
/*Start Year and End Year of midterm changes*/		
(select		
d.*		
,cast(datepart(year, startdatetm) as int) startyear		
,cast(datepart(year, enddatetm) as int) endyear		
from stg_ho_ll_modeldata_1 d)		
,data_adjusted as		
/*Splitted StartDate and EndDate based on year*/ 		
(select  distinct 		
 row_number() over(order by SystemId) modeldata_id_adjusted	       	
,case 		
  when  data.startyear<>data.endyear then 		
   case 		
    when data.startyear=dim_year.y then cast(data.startdatetm as date) 		
    when data.endyear=dim_year.y then dim_year.startdate		
   end  		
  else cast(data.startdatetm as date)		
 end startdate		
,case 		
  when  data.startyear<>data.endyear then		
   case 		
    when data.startyear=dim_year.y then  dateadd(day,1,dim_year.enddate)		   
    when data.endyear=dim_year.y then cast(data.enddatetm as date) 		
   end 		
  else cast(data.enddatetm as date)  		
 end enddate,		
data.*		
from data 		
join dim_year 		
on (data.startyear=dim_year.y or data.endyear=dim_year.y)		
)		
select		
data.*		
from data_adjusted data;		
		
drop table if exists stg_ho_ll_modeldata_1;		
		
/*10. Joining claims		
It's possible to have more then 1 claim per mid term		
Modeldata_id becomes not unique at this step		
Only Claims for modeldata are used		
10-1. Main join with dim_claimrisk		
*/		
		
		
		
		
drop table if exists stg_ho_ll_modeldata_3;		
create temporary table stg_ho_ll_modeldata_3 as 		
with claims1 as (		
select 		
clr.CLAIMRISK_ID,		
clr.clrsk_lossdate lossdate,		
clr.audit_id,		
cr.policy_uniqueid,		
cr.cvrsk_uniqueid risk_uniqueid,		
cr.spinn_systemid claim_SystemId		
from fsbi_dw_spinn.dim_claimrisk clr		
join fsbi_dw_spinn.dim_coveredrisk cr		
on clr.COVEREDRISK_ID=cr.coveredrisk_id		
and clr.policy_uniqueid=cr.policy_uniqueid		
join  fsbi_stg_spinn.vstg_property_modeldata_claims cb		
on clr.CLAIMRISK_ID=cb.CLAIMRISK_ID		
where clr.clrsk_item_type='BUILDING'		
)		
,claims2 as (		
select 		
c.claimrisk_id,		
lossdate,		
audit_id,		
stg.policy_uniqueid,		
stg.risk_uniqueid,		
stg.SystemId		
from  stg_ho_ll_modeldata_2 stg		
join claims1 c		
on c.claim_SystemId>=stg.SystemId and c.claim_SystemId<stg.SystemIdEnd 		/*Claim in a middle of a mid-term change*/
and datepart(year, c.lossdate)=datepart(year, stg.StartDate)  /*LossDate in the mid term change splitted by year*/		
and c.lossdate>=cast(stg.StartDateTm as date) and c.lossdate<=cast(stg.EndDateTm as date) /*LossDate in the mid term change important if a mid-term change not splitted by year*/		
and c.policy_uniqueid=stg.policy_uniqueid		
and c.risk_uniqueid=stg.risk_uniqueid		
union		
select 		
c.claimrisk_id,		
lossdate,		
audit_id,		
stg.policy_uniqueid,		
stg.risk_uniqueid,		
stg.SystemId		
from  stg_ho_ll_modeldata_2 stg		
join claims1 c		
on c.claim_SystemId=stg.SystemIdEnd		/*Claim at the edge of a mid-term change*/
and datepart(year, c.lossdate)=datepart(year, stg.StartDate)  /*LossDate in the mid term change splitted by year*/		
and c.lossdate>=cast(stg.StartDateTm as date) and c.lossdate<=cast(stg.EndDateTm as date)/*LossDate in the mid term change important if a mid-term change not splitted by year*/		
and c.policy_uniqueid=stg.policy_uniqueid		
and c.risk_uniqueid=stg.risk_uniqueid		
)		
,claims3 as (		
select claimrisk_id,		
lossdate,		
audit_id,		
policy_uniqueid,		
risk_uniqueid,		
min(SystemId) SystemId		
from claims2		
group by claimrisk_id,		
lossdate,		
audit_id,		
policy_uniqueid,		
risk_uniqueid		
)		
select		
c.claimrisk_id,		
0 audit_id,		
stg.*,		
row_number() over(partition by stg.policy_uniqueid order by stg.startdate,stg.risk_uniqueid) FirstRecinPolicyTermInd		
from stg_ho_ll_modeldata_2 stg		
left outer join claims3 c		
on stg.SystemId=c.SystemId		
and stg.policy_uniqueid=c.policy_uniqueid		
and stg.risk_uniqueid=c.risk_uniqueid		
and datepart(year, c.lossdate)=datepart(year, stg.StartDate);		
		
		
		
/*10-2. LossDate is beyond any mid term change		
can not be joined.		
In most cases they are claims with wrong Loss Date*/		
		
		
drop table if exists cb;		
create temporary table cb as 		
select *		
from fsbi_stg_spinn.vstg_property_modeldata_claims;		
		
		
		
drop table if exists nf;		
create temporary table nf as		
select c.* 		
from fsbi_dw_spinn.dim_claimrisk c		
join  cb		
on c.CLAIMRISK_ID=cb.CLAIMRISK_ID		
left outer join stg_ho_ll_modeldata_3 stg		
on c.claimrisk_id=stg.claimrisk_id		
where clrsk_item_type='BUILDING'		
and stg.modeldata_id_adjusted is null		
and coveredrisk_id<>0;		
		
drop table if exists cb;		
		
/*10-3. Join not joined claims  to first change by policy term only*/		
		
		
drop table if exists stg_FirstRecinPolicyTerm;		
create temporary table stg_FirstRecinPolicyTerm as		
with data as (		
select 		
nf.CLAIMRISK_ID,		
29 audit_id,		
stg.*,		
/*we may have more then one claim per first policy_uniqueid*/		
row_number() over(partition by nf.CLAIMRISK_ID,stg.policy_uniqueid order by stg.startdate,stg.risk_uniqueid) FirstRecinPolicyTermInd		
from nf		
join fsbi_dw_spinn.dim_coveredrisk cr		
on nf.coveredrisk_id=cr.coveredrisk_id		
join stg_ho_ll_modeldata_2 stg 		
on nf.policy_uniqueid=stg.policy_uniqueid		
and cr.cvrsk_uniqueid=stg.risk_uniqueid		
)		
select		
data.*		
from data		
where FirstRecinPolicyTermInd=1;		
		
drop table if exists nf;		
drop table if exists stg_ho_ll_modeldata_2;		
		
		
/*10-4. Delete first before insert the same*/		
delete from stg_ho_ll_modeldata_3		
where modeldata_id_adjusted in (select modeldata_id_adjusted from stg_FirstRecinPolicyTerm)		
and claimrisk_id is null;		
		
		
/*10-5. Insert first records with missing claims*/		
insert into stg_ho_ll_modeldata_3		
select		
*		
from stg_FirstRecinPolicyTerm;		
		
/*Test		
		
 -- These claims are not in the dataset because the correspondent policies were cancelled		
 -- 00503780 (CAH0760010, 297101)		
 -- 00512190 (CAH0334800, 482484)		
 -- 00444905 (CAH0766850, 207491)		
		
select cr.clrsk_lossdate,  cb.* 		
from cb cb		
join fsbi_dw_spinn.dim_claimrisk cr		
on cb.claimrisk_id=cr.claimrisk_id		
left outer join stg_ho_ll_modeldata_3 stg		
on cb.claimrisk_id=stg.CLAIMRISK_ID		
where stg.modeldata_id_adjusted is null		
		
		
		
 --only NULL claimrisk_id*		
select claimrisk_id,		
count(distinct modeldata_id)		
from stg_ho_ll_modeldata_3		
group by claimrisk_id		
having count(distinct modeldata_id)>1;		
		
 --Nothing		
select modeldata_id_adjusted,		
count(*),		
count(distinct claimrisk_id)		
from stg_ho_ll_modeldata_3		
group by modeldata_id_adjusted		
having count(*)>1		
and count(distinct claimrisk_id)=1;		
		
		
*/		
		
/*11. Main insert into the staging table*/		
truncate table fsbi_stg_spinn.stg_property_modeldata;		
insert into fsbi_stg_spinn.stg_property_modeldata		
select 		
    modeldata_id_adjusted modeldata_id,		
	claimrisk_id,	
	cast(stg.SystemId as int) SystemIdStart,	
	SystemIdEnd,	
	policy_id,	
	stg.policy_uniqueid,	
	Producer_Uniqueid,	
	Risk_id,	
	stg.Risk_uniqueid,	
	RiskCd RiskNumber,	
	RiskType,	
	Building_id,	
	Building_uniqueid,	
	StartDateTm,	
	EndDateTm,	
	StartDate,	
	EndDate,	
	CovA_deductible,	
	CovB_deductible,	
	CovC_deductible,	
	CovD_deductible,	
	CovE_deductible,	
	CovF_deductible,	
	CovA_Limit,	
	CovB_Limit,	
	CovC_Limit,	
	CovD_Limit,	
	CovE_Limit,	
	CovF_Limit,	
	CovA_FullTermAmt,	
	CovB_FullTermAmt,	
	CovC_FullTermAmt,	
	CovD_FullTermAmt,	
	CovE_FullTermAmt,	
	CovF_FullTermAmt,	
	isnull(cov.Limit1,'~') OnPremises_Theft_Limit,	
	isnull(cov.Limit2,'~') AwayFromPremises_Theft_Limit,	
	Quality_PolAppInconsistency_Flg,	
	Quality_RiskIdDuplicates_Flg,	
    case when audit_id in (25) then claimrisk_id end Quality_ClaimOk_Flg,		
    case when audit_id in (29,33) then claimrisk_id end 	Quality_ClaimPolicyTermJoin_Flg,	
	pLoadDate LoadDate	
from 	stg_ho_ll_modeldata_3	stg
left outer join fsbi_stg_spinn.vstg_property_modeldata_coverage cov		
on cov.SystemId=stg.SystemId		
and cov.Policy_Uniqueid=stg.policy_uniqueid		
and cov.Risk_Uniqueid=stg.risk_uniqueid		
and cov.act_modeldata='THEFA'		
order by cast(stg.policy_uniqueid as int) desc, StartDateTm, riskcd;		
		
		
		
/*12. There is an issue in TransactionHistory where some Unapplied Endorsements are not marked as Uanapplied		
Just delete these data		
Policy Uniqueid 2 is a particular case where mid-term SystemId=2 is teh same as PolicyRef=2*/		
		
		
drop table if exists to_delete;		
create temporary table to_delete as		
select modeldata_id		
from fsbi_stg_spinn.stg_property_modeldata m		
join fsbi_stg_spinn.vstg_modeldata_policyhistory ph		
on m.policy_uniqueid=ph.PolicyRef		
and m.SystemIdStart=ph.SystemId		
where 		
ph.TransactionCd='Final'		
and m.policy_uniqueid<>'2'		
order by Startdatetm;		
		
delete from fsbi_stg_spinn.stg_property_modeldata 		
where modeldata_id in (select modeldata_id from to_delete);		
		
drop table if exists to_delete;		
		
END;		
		
$$		
;		
