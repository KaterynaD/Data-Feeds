CREATE OR REPLACE PROCEDURE cse_bi.sp_stg_auto_modeldata(ploaddate datetime)			
	LANGUAGE plpgsql		
AS $$			
			
BEGIN 			
			
			
			
			
/*			
Author: Kate Drogaieva			
Purpose: This script populate STG_AUTO_MODELDATA (staging table for FACT_AUTO_MODELDATA)			
Comment: Due to back dated transactions it was made as a full refresh.			
03/02/2023 - Back to redshift			
12/13/2019 - Using stg_policy_changes_v2 instead of stg_policy_changes			
11/13/2019 - LossDate was added in  v_auto_ClaimsForModel_Base. Slight adjustment of the select for claims			
10/25/2019 - Adjusting to the new structure v_stg_auto_modeldata_coverage new structure 			
03/24/2020 - Commented PrivatePassengerAuto condition to load all risk types			
*/			
			
			
/*			
1. LibilityOnly Risks - policies without Collision and Comprehencive coverages			
at each mid-term change			
*/			
			
			
			
drop table if exists LiabilityOnlyRisks;			
create temporary table  LiabilityOnlyRisks as			
select			
*			
from (			
select			
distinct 			
 f.Policy_Uniqueid			
,f.SystemId 			
,f.risk_uniqueid			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage f			
where act_modeldata in ('COLL',  'COMP',  'BI', 'UM', 'PD', 'Med')			
except			
 --auto policies with Comp and Collision			
select			
distinct f.Policy_Uniqueid			
,f.SystemId 			
,f.risk_uniqueid			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage f			
where act_modeldata in ('COLL', 'COMP')			
) d ;			
			
/*			
2. CompOnly Risks - policies with only Collision and Comprehencive coverages			
at each mid-term change			
*/			
			
			
drop table if exists CompOnlyRisks;			
create temporary table  CompOnlyRisks as			
select			
*			
from (			
select			
distinct f.Policy_Uniqueid			
,f.SystemId 			
,f.risk_uniqueid			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage f			
where act_modeldata in ('COLL',  'COMP') 			
except			
select			
distinct f.Policy_Uniqueid			
,f.SystemId 			
,f.risk_uniqueid			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage f			
where act_modeldata not in ('COLL', 'COMP')			
) d ;			
			
/*			
3. Driver Counts at each mid-term change			
*/			
			
			
drop table if exists CntDrv;			
create temporary table  CntDrv as			
select 			
cast(stg.PolicyRef	as varchar) Policy_Uniqueid,		
stg.SystemId,			
stg.ChangeDate,			
count(distinct case when stg.status='Active' then  stg.driver_uniqueid else null end) CntDrv,			
count(distinct case when stg.status='Active' and upper(stg.LicenseNumber) NOT like '%EXCLUDED%' and stg.DriverTypeCd in ('NonOperator', 'Excluded', 'UnderAged') then  stg.driver_uniqueid else null end) CntNonDrv,			
count(distinct case when stg.status='Active' and upper(stg.LicenseNumber) like '%EXCLUDED%'  then stg.driver_uniqueid else null end) CntExcludedDrv,			
min(case when stg.status='Active' then case when  DateDiff(year, stg.birthdt,p.pol_EffectiveDate)<=0 or stg.birthdt<='1900-01-01' then null else DateDiff(year, stg.birthdt,p.pol_EffectiveDate)  end else null end)   minDriverAge			
from fsbi_stg_spinn.vstg_auto_modeldata_drivers stg			
join fsbi_dw_spinn.dim_policy p			
on p.pol_uniqueid=cast(stg.PolicyRef	as varchar)		
group by 			
stg.PolicyRef,			
stg.SystemId,			
stg.ChangeDate	;		
			
			
			
/*			
4. Combined Limits, Deductible and FullTermAmount for each coverage of interst  at each mid-term change			
*/			
			
			
			
drop table if exists d;			
create temporary table  d as			
select  			
d.SystemId, 			
d.policy_uniqueid, 			
d.risk_uniqueid,			
checksum(LISTAGG( distinct ltrim(rtrim(d.act_modeldata))+'='+ltrim(rtrim(d.Deductible1)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(d.act_modeldata))))  Combined_Deductible			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage d			
where 	d.Deductible1 is not null		
group by d.SystemId, d.policy_uniqueid, d.risk_uniqueid;			
			
			
			
drop table if exists l1;			
create temporary table  l1 as			
select   			
l.SystemId, 			
l.policy_uniqueid, 			
l.risk_uniqueid,			
checksum(LISTAGG( distinct ltrim(rtrim(l.act_modeldata))+'='+ltrim(rtrim(l.Limit1)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(l.act_modeldata))))  Combined_Limit1			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage l			
where 	l.Limit1 is not null		
group by l.SystemId, l.policy_uniqueid, l.risk_uniqueid; 			
			
			
			
drop table if exists l2;			
create temporary table  l2 as			
select   			
l.SystemId, 			
l.policy_uniqueid, 			
l.risk_uniqueid,			
checksum(LISTAGG( distinct ltrim(rtrim(l.act_modeldata))+'='+ltrim(rtrim(l.Limit2)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(l.act_modeldata))))  Combined_Limit2			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage l			
where 	l.Limit2 is not null		
group by l.SystemId, l.policy_uniqueid, l.risk_uniqueid; 			
			
			
			
			
drop table if exists f;			
create temporary table  f as			
select   			
c.SystemId, 			
c.policy_uniqueid, 			
c.risk_uniqueid,			
checksum(LISTAGG( distinct ltrim(rtrim(c.act_modeldata))+'='+ltrim(rtrim(c.FullTermAmt)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(c.act_modeldata))))  Combined_FullTermAmt			
from fsbi_stg_spinn.vstg_auto_modeldata_coverage c			
group by c.SystemId, c.policy_uniqueid, c.risk_uniqueid; 			
			
			
			
			
			
/*			
5. (1)Active (not obsolete, joined to discarded items with record_version=-1) Risks 			
related to  New Business, Renewal or  Endorsement transactions (2).			
(3) If there are more then one change in the same day, we use the last change at this day			
(1)It's possible when a transaction with newest BookDt has an older effective date 			
then effective transactions already in the system.			
*/			
			
			
			
drop table if exists coveredrisk;			
create temporary table  coveredrisk as			
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
where cvrsk_item_type='VEHICLE'			
-- and cvrsk_typedescription='PrivatePassengerAuto'			
 --and dim_vehicle.record_version>-1 need more details how exclude not active transactions			
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
			
			
			
			
			
			
/*6. There is no "Final" record in dim_coveredrisk			
with systemid=policy_uniqueid			
We need it to close the last entry in mid-term changes*/			
			
			
drop table if exists extend_dim_coveredrisk;			
create temporary table  extend_dim_coveredrisk as			
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
select policy_uniqueid,  max(dc.spinn_systemid) id			
from coveredrisk dc			
where dc.policy_uniqueid<>'Unknown'			
group by policy_uniqueid			
) last_system			
on dc.spinn_systemId=last_system.id			
and dc.policy_uniqueid=last_system.policy_uniqueid			
where dc.policy_uniqueid<>'Unknown'			
) d;			
			
drop table if exists coveredrisk;			
			
/*select *			
from #extend_dim_coveredrisk			
where policy_uniqueid='903653'			
and cvrsk_uniqueid='Risk-1492337505-1254933222'			
order by cvrsk_startdate			
*/			
			
/*			
7. Main staging data select #tmp_PolicyRiskHistory			
based on stg_policyhistory plus all related info			
*/			
			
			
drop table if exists tmp_PolicyRiskHistory;			
create temporary table  tmp_PolicyRiskHistory as			
select distinct 			
  stg.SystemId			
, dc.original_spinn_systemid			
, dc.policy_id  			
, dc.policy_uniqueid			
, pg.Producer_Uniqueid			
, dc.coveredrisk_id	risk_id		
, dc.cvrsk_typedescription			
, dc.cvrsk_uniqueid risk_uniqueid			
, dc.cvrsk_item_id vehicle_id			
, v.SPInnVehicle_Id vehicle_uniqueid			
, dc.cvrsk_item_naturalkey  vin			
, dc.cvrsk_number RiskCd			
, dc.cvrsk_item_id2	driver_id		
, d.spinndriver_parentid driver_uniqueid			
, dc.cvrsk_item_naturalkey2   Driver			
, dc.cvrsk_number2 DriverNumber			
, case when dc.deleted_indicator=1 then 'Deleted' else 'Active' end  status			
, case when dc.spinn_systemid=cast(dc.policy_uniqueid as int) then stg.transactioneffectivedt			
  else dc.cvrsk_startdate 			
  end changedate			
, dd.Combined_Deductible			
, l1.Combined_Limit1			
, l2.Combined_Limit2			
, f.Combined_FullTermAmt			
--			
, CntDrv.CntDrv			
, CntDrv.CntNonDrv			
, CntDrv.CntExcludedDrv			
, CntDrv.minDriverAge			
, case when lor.policy_uniqueid is not null then 'Yes' else 'No' end LiabilityOnlyFlg			
, case when cor.policy_uniqueid is not null then 'Yes' else 'No' end CompOnlyFlg			
, stg.TransactionCd			
,row_number() over(partition by dc.policy_uniqueid,dc.cvrsk_uniqueid order by   case when dc.spinn_systemid=cast(dc.policy_uniqueid as int) then stg.transactioneffectivedt			
  else dc.cvrsk_startdate 			
  end) rn_trn			
,count(*) over(partition by dc.policy_uniqueid,dc.cvrsk_uniqueid ) cn_trn			
,cvrsk_inceptiondate VehicleInceptionDate			
,cvrsk_inceptiondate2 DriverInceptionDate			
,case when PolAppInconsistency_Flg='Y' then 'Yes' else 'No' end Quality_PolAppInconsistency_Flg			
,case when RiskIdDuplicates_Flg='Y' then 'Yes' else 'No' end Quality_RiskIdDuplicates_Flg			
,case when ExcludedDrv_Flg='Y' then 'Yes' else 'No' end Quality_ExcludedDrv_Flg			
			
from fsbi_stg_spinn.vstg_modeldata_policyhistory stg			
 --			
join extend_dim_coveredrisk dc			
on  stg.PolicyRef=dc.policy_uniqueid			
and stg.SystemId=dc.spinn_systemid			
and dc.cvrsk_item_type='VEHICLE'			
-- and dc.cvrsk_typedescription='PrivatePassengerAuto'			
 --			
join fsbi_dw_spinn.dim_vehicle v			
on v.vehicle_id=dc.cvrsk_item_id			
 --			
join fsbi_dw_spinn.dim_driver d			
on d.driver_id=dc.cvrsk_item_id2			
 --			
left outer join CntDrv CntDrv			
on stg.SystemId=CntDrv.SystemId			
and stg.PolicyRef=CntDrv.Policy_Uniqueid			
			
 --			
left outer join d dd			
on dd.SystemId=stg.SystemId			
and dd.policy_uniqueid=stg.PolicyRef			
and dd.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join l1	l1		
on l1.SystemId=stg.SystemId			
and l1.policy_uniqueid=stg.PolicyRef			
and l1.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join l2	l2		
on l2.SystemId=stg.SystemId			
and l2.policy_uniqueid=stg.PolicyRef			
and l2.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join f	f		
on f.SystemId=stg.SystemId			
and f.policy_uniqueid=stg.PolicyRef			
and f.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join  LiabilityOnlyRisks lor			
on lor.SystemId=stg.SystemId			
and lor.policy_uniqueid=stg.PolicyRef			
and lor.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join  CompOnlyRisks cor			
on cor.SystemId=stg.SystemId			
and cor.policy_uniqueid=stg.PolicyRef			
and cor.risk_uniqueid=dc.cvrsk_uniqueid			
 --			
left outer join fsbi_stg_spinn.vstg_auto_modeldata_producers pg			
on pg.SystemId=stg.Systemid			
and pg.Policy_Uniqueid=stg.PolicyRef			
 --			
where  stg.TransactionCd in ('New Business','Renewal','Endorsement', 'Final')			
and stg.ReplacedByTransactionNumber is null			
and stg.UnAppliedByTransactionNumber is null;			
			
			
drop table if exists extend_dim_coveredrisk;			
drop table if exists CntDrv;			
drop table if exists d;			
drop table if exists l1;			
drop table if exists l2;			
drop table if exists f;			
drop table if exists lor;			
drop table if exists cor;			
			
			
/*			
8. #data1 - #data3 - List of Vehicles  (VINs and Vehicle IDs separately because of replace VINs instead of adding a new Vehicle Id) 			
and Drivers			
Can be one query if it could be possible to calculate with			
an analytical function			
*/			
			
/*-----------------------------------------------------------------------------*/			
			
			
drop table if exists data1;			
create temporary table  data1 as			
select  			
t1.Policy_UniqueId, 			
t1.SystemId,			
checksum(LISTAGG( distinct ltrim(rtrim(t1.vehicle_uniqueid)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(t1.vehicle_uniqueid))))  listvehids			
from tmp_PolicyRiskHistory t1			
group by Policy_UniqueId, SystemId	;		
			
			
drop table if exists data2;			
create temporary table  data2 as			
select  			
t1.Policy_UniqueId, 			
t1.SystemId,			
checksum(LISTAGG( distinct ltrim(rtrim(t1.vin)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(t1.vin))))  listvins			
from tmp_PolicyRiskHistory t1			
group by Policy_UniqueId, SystemId	;		
			
			
drop table if exists data3;			
create temporary table  data3 as			
select  			
t1.Policy_UniqueId, 			
t1.SystemId,			
checksum(LISTAGG( distinct ltrim(rtrim(t1.driver)) , ','  ) WITHIN GROUP (order by ltrim(rtrim(t1.driver))))  listdrivers			
from tmp_PolicyRiskHistory t1			
group by Policy_UniqueId, SystemId	;		
			
			
			
			
			
/*			
9. Total number of vehicles by Policy term			
*/			
			
			
drop table if exists VINById;			
create temporary table  VINById as			
select 			
Policy_Uniqueid,			
vehicle_uniqueid,			
count(distinct vin) cnt			
from tmp_PolicyRiskHistory			
group by Policy_Uniqueid,			
vehicle_uniqueid;			
			
			
			
/*			
10. List of vehicles and Drivers together			
*/			
drop table if exists Veh;			
create temporary table  Veh as			
select			
 data.Policy_Uniqueid, 			
 data.SystemId,			
 data.changedate,			
 data.CntDrv,			
 listvehids,			
 listvins,			
 listdrivers,			
 count(distinct case when Status='Active' then vin else null end) Cnt			
 from tmp_PolicyRiskHistory data			
 join data1 			
 on data.policy_uniqueid=data1.policy_uniqueid			
 and data.SystemId=data1.SystemId			
 join data2 			
 on data.policy_uniqueid=data2.policy_uniqueid			
 and data.SystemId=data2.SystemId			
 join data3 			
 on data.policy_uniqueid=data3.policy_uniqueid			
 and data.SystemId=data3.SystemId			
 group by data.Policy_Uniqueid, 			
 data.SystemId,			
 data.changedate,			
 data.CntDrv,			
 listvehids,			
 listvins,			
 listdrivers;			
			
drop table if exists data1;			
drop table if exists data2;			
drop table if exists data3;			
			
/*11.Calculated Limits, Deductibles, FullTrm amount Changed Flags 			
1 if something important changed  comparing to the next record			
and we need to add one more row in the model dataset			
*/			
			
			
drop table if exists VinFlgs;			
create temporary table  VinFlgs as			
 select 			
  data.Policy_Uniqueid			
, SystemId  			
, vin			
, changedate			
, case when upper(Driver)<>lag(upper(Driver)) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeAssignedDrvFlg			
, case when upper(Status)<>lag(upper(Status)) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeVehStatusFlg			
, case when upper(vin)<>lag(upper(vin)) over (partition by data.Policy_Uniqueid, Vehicle_Uniqueid  order by data.changedate) then 1 else 0 end ChangeVehVINFlg			
, case when Combined_Limit1<>lag(Combined_Limit1) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeCombined_Limit1Flg			
, case when Combined_Limit2<>lag(Combined_Limit2) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeCombined_Limit2Flg			
, case when Combined_Deductible<>lag(Combined_Deductible) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeCombined_DeductibleFlg			
--			
, case when Combined_FullTermAmt<>lag(Combined_FullTermAmt) over (partition by data.Policy_Uniqueid, vin  order by data.changedate) then 1 else 0 end ChangeCombined_FullTermAmtFlg			
--			
from tmp_PolicyRiskHistory data;			
			
			
			
			
/*			
12. Changes in number drivers or vehicles when we need to generate a new row			
*/			
			
			
			
drop table if exists PolicyRefFlgs;			
create temporary table  PolicyRefFlgs as			
select			
  Policy_Uniqueid			
, Systemid			
, ChangeDate			
, case when Veh.Cnt<>lag(Veh.Cnt) over (partition by Policy_Uniqueid  order by changedate) then 1 else 0 end ChangeVehFlg			
, case when CntDrv<>lag(CntDrv) over (partition by Policy_Uniqueid  order by changedate) then 1 else 0 end AddDrvFlg			
, case when listvehids<>lag(listvehids) over (partition by Policy_Uniqueid  order by changedate) then 1 else 0 end ChangeVehId2			
, case when upper(listvins)<>lag(upper(listvins)) over (partition by Policy_Uniqueid  order by changedate) then 1 else 0 end ChangeVehFlg2			
, case when upper(listdrivers)<>lag(upper(listdrivers)) over (partition by Policy_Uniqueid  order by changedate) then 1 else 0 end ChangeDrvFlg2			
from Veh;			
			
			
			
/*			
13. Combining all flags into 1 field			
*/			
			
			
drop table if exists OneFlg;			
create temporary table  OneFlg as			
select 			
VinFlgs.Policy_Uniqueid,			
VinFlgs.SystemId,			
VinFlgs.ChangeDate,			
case when sum(ChangeAssignedDrvFlg)+			
sum(ChangeVehStatusFlg) +			
sum(ChangeVehVINFlg) +			
sum(ChangeVehFlg)+			
sum(AddDrvFlg)+			
sum(ChangeVehFlg2)+			
sum(ChangeDrvFlg2)+			
sum(ChangeVehId2)+			
sum(ChangeCombined_Limit1Flg)+			
sum(ChangeCombined_Limit2Flg)+			
sum(ChangeCombined_DeductibleFlg)+			
sum(ChangeCombined_FullTermAmtFlg)>=1 then 1 else 0 end Flg			
from VinFlgs			
join PolicyRefFlgs			
on VinFlgs.Policy_Uniqueid=PolicyRefFlgs.Policy_Uniqueid			
and VinFlgs.SystemId=PolicyRefFlgs.SystemId			
group by VinFlgs.Policy_Uniqueid, VinFlgs.SystemId, VinFlgs.ChangeDate;			
			
drop table if exists VinFlgs;			
drop table if exists PolicyRefFlgs;			
			
/*			
14. Joining Counts and Flags together			
Adjusting Flag to 1 (Change, first or last change) or 0			
*/			
			
			
drop table if exists final_data2;			
create temporary table  final_data2 as			
select 			
  data.* 			
, Veh.Cnt CntVeh			
, case when OneFlg.Flg>0 or data.rn_trn=1 or data.rn_trn=data.cn_trn then 1 else 0 end Flg			
from tmp_PolicyRiskHistory data			
join Veh Veh			
on data.Policy_Uniqueid=Veh.Policy_Uniqueid			
and data.SystemId =Veh.SystemId 			
join  OneFlg			
on data.Policy_Uniqueid=OneFlg.Policy_Uniqueid			
and data.SystemId =OneFlg.SystemId	;		
			
			
			
drop table if exists Veh;			
drop table if exists OneFlg;			
drop table if exists tmp_PolicyRiskHistory;			
/*			
15. Final mid-term changes			
*/ 			
			
			
drop table if exists stg_auto_modeldata_1;			
create temporary table  stg_auto_modeldata_1 as			
with data3 as (			
select 			
  data2.*			
, changedate StartDateTm			
, case 			
   when VINById.Cnt>1 then			
     coalesce(lead(changedate) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid,    vin order by changedate),lead(changedate) over (partition by data2.Policy_Uniqueid, vin,  data2.vehicle_uniqueid order by changedate), lead(changedate) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid order by changedate), lead(changedate) over (partition by data2.Policy_Uniqueid,  vin order by changedate) )			
   else	 		
     coalesce(lead(changedate) over (partition by data2.Policy_Uniqueid, vin,  data2.vehicle_uniqueid order by changedate),lead(changedate) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid, vin order by changedate), lead(changedate) over (partition by data2.Policy_Uniqueid,  vin order by changedate), lead(changedate) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid order by changedate))			
   end EndDateTm			
, case 			
   when VINById.Cnt>1 then			
     coalesce(lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid,    vin order by changedate),lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid, vin,  data2.vehicle_uniqueid order by changedate), lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid order by changedate), lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  vin order by changedate) )			
   else	 		
     coalesce(lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid, vin,  data2.vehicle_uniqueid order by changedate),lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid, vin order by changedate), lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  vin order by changedate), lead(original_spinn_systemid) over (partition by data2.Policy_Uniqueid,  data2.vehicle_uniqueid order by changedate))			
   end SystemIdEnd			
from final_data2 data2			
join VINById VINById	 		
on data2.Policy_Uniqueid=VINById.Policy_Uniqueid			
and data2.vehicle_uniqueid=VINById.vehicle_uniqueid			
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
			
drop table if exists VINById;			
drop table if exists final_data2;			
			
/*-----------------           16           ------------------------------------------*/			
/*----------------SPLITTING MID-TERM CHANGES FOR Calendar/Accident Year data---------*/			
/*----------------NUMBER OF CHANGES IS INCREASED HERE--------------------------------*/			
/*----------------FIRST ROW INDICATORS MUST BE CALCULATED HERE NOW-------------------*/			
/*----------------IMPORTANT !!! MODELDATA_ID is changed HERE-------------------------*/			
			
			
			
drop table if exists stg_auto_modeldata_2;			
create temporary table  stg_auto_modeldata_2 as			
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
,cast(to_char(startdatetm, 'yyyy') as int) startyear			
,cast(to_char(enddatetm, 'yyyy') as int) endyear			
from stg_auto_modeldata_1 d)			
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
			
drop table if exists stg_auto_modeldata_1;			
			
			
/*17. Joining claims			
It's possible to have more then 1 claim per mid term			
Modeldata_id becomes not unique at this step			
Only Claims for modeldata are used			
17-1. Main join with dim_claimrisk			
*/			
			
			
			
drop table if exists stg_auto_modeldata_3;			
create temporary table  stg_auto_modeldata_3 as			
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
join fsbi_stg_spinn.vstg_auto_modeldata_claims cb			
on clr.CLAIMRISK_ID=cb.CLAIMRISK_ID			
where clr.clrsk_item_type='VEHICLE'			
)			
,claims2 as (			
select 			
c.claimrisk_id,			
lossdate,			
audit_id,			
stg.policy_uniqueid,			
stg.risk_uniqueid,			
stg.SystemId			
from  stg_auto_modeldata_2 stg			
join claims1 c			
on c.claim_SystemId>=stg.SystemId and c.claim_SystemId<stg.SystemIdEnd 			
and to_char(c.lossdate,'yyyy')=to_char(stg.StartDate,'yyyy')  /*LossDate in the mid term change splitted by year*/			
and c.lossdate>=stg.StartDateTm and c.lossdate<=stg.EndDateTm /*LossDate in the mid term change important if a mid-term change not splitted by year*/			
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
from  stg_auto_modeldata_2 stg			
join claims1 c			
on c.claim_SystemId=stg.SystemIdEnd			
and to_char(c.lossdate,'yyyy')=to_char(stg.StartDate,'yyyy')  /*LossDate in the mid term change splitted by year*/			
and c.lossdate>=stg.StartDateTm and c.lossdate<=stg.EndDateTm /*LossDate in the mid term change important if a mid-term change not splitted by year*/			
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
c.audit_id,			
stg.*,			
row_number() over(partition by stg.policy_uniqueid order by stg.startdate,stg.risk_uniqueid,stg.vin) FirstRecinPolicyTermInd			
from stg_auto_modeldata_2 stg			
left outer join claims3 c			
on stg.SystemId=c.SystemId			
and stg.policy_uniqueid=c.policy_uniqueid			
and stg.risk_uniqueid=c.risk_uniqueid			
and to_char(c.lossdate,'yyyy')=to_char(stg.StartDate,'yyyy');			
			
			
			
/*17-2. LossDate is beyond any mid term change			
can not be joined.			
In most cases they are claims with wrong Loss Date*/			
			
			
			
			
drop table if exists nf;			
create temporary table  nf as			
select c.* 			
from fsbi_dw_spinn.dim_claimrisk c			
join  fsbi_stg_spinn.vstg_auto_modeldata_claims cb			
on c.CLAIMRISK_ID=cb.CLAIMRISK_ID			
left outer join stg_auto_modeldata_3 stg			
on c.claimrisk_id=stg.claimrisk_id			
where clrsk_item_type='VEHICLE'			
and stg.modeldata_id_adjusted is null			
and coveredrisk_id<>0;			
			
			
			
/*17-3. Join not joined claims  to first change by policy term only*/			
			
			
drop table if exists stg_FirstRecinPolicyTerm;			
create temporary table  stg_FirstRecinPolicyTerm as			
with data as (			
select 			
nf.CLAIMRISK_ID,			
29 audit_id,			
stg.*,			
/*we may have more then one claim per first policy_uniqueid*/			
row_number() over(partition by nf.CLAIMRISK_ID,stg.policy_uniqueid order by stg.startdate,stg.risk_uniqueid,stg.vin) FirstRecinPolicyTermInd			
from nf			
join fsbi_dw_spinn.dim_coveredrisk cr			
on nf.coveredrisk_id=cr.coveredrisk_id			
join stg_auto_modeldata_2 stg 			
on nf.policy_uniqueid=stg.policy_uniqueid			
and cr.cvrsk_uniqueid=stg.risk_uniqueid			
)			
select			
data.*			
from data			
where FirstRecinPolicyTermInd=1;			
			
drop table if exists nf;			
drop table if exists stg_auto_modeldata_2;			
			
/*17-4. Delete first before insert the same*/			
delete from stg_auto_modeldata_3			
where modeldata_id_adjusted in (select modeldata_id_adjusted from stg_FirstRecinPolicyTerm)			
and claimrisk_id is null;			
			
			
/*17-5. Insert first records with missing claims*/			
insert into stg_auto_modeldata_3			
select			
*			
from stg_FirstRecinPolicyTerm;			
			
drop table if exists stg_FirstRecinPolicyTerm	;		
			
			
/*Test*/			
			
/*only NULL claimrisk_id*/			
/*select claimrisk_id,			
count(distinct modeldata_id)			
from stg_auto_modeldata_3			
group by claimrisk_id			
having count(distinct modeldata_id)>1;*/			
			
/*Nothing*/			
/*select modeldata_id_adjusted,			
count(*),			
count(distinct claimrisk_id)			
from stg_auto_modeldata_3			
group by modeldata_id_adjusted			
having count(*)>1			
and count(distinct claimrisk_id)=1;*/			
			
			
/*36/14 Flat cancelled*/			
/*			
select c.* 			
from fsbi_dw_spinn.dim_claimrisk c			
join  fsbi_stg_spinn.vstg_auto_modeldata_claims cb			
on c.CLAIMRISK_ID=cb.CLAIMRISK_ID			
left outer join stg_auto_modeldata_3 stg			
on c.claimrisk_id=stg.claimrisk_id			
where clrsk_item_type='VEHICLE'			
and stg.modeldata_id_adjusted is null			
and coveredrisk_id<>0;			
*/			
			
/*18. Final insert into main staging table*/			
			
truncate table fsbi_stg_spinn.stg_auto_modeldata;			
insert into fsbi_stg_spinn.stg_auto_modeldata			
(			
modeldata_id,			
claimrisk_id,			
SystemIdStart,			
SystemIdEnd,			
risk_id,			
risktype,			
policy_id,			
policy_uniqueid,			
Producer_Uniqueid,			
risk_uniqueid,			
vehicle_id,			
vehicle_uniqueid,			
vin,			
risknumber,			
driver_id,			
driver_uniqueid,			
driverlicense,			
drivernumber,			
startdatetm,			
enddatetm,			
startdate,			
enddate,			
CntVeh,			
CntDrv,			
CntNonDrv,			
CntExcludedDrv,			
mindriverage,			
VehicleInceptionDate,			
DriverInceptionDate,			
Liabilityonly_Flg,			
Componly_Flg,			
ExcludedDrv_Flg,			
Quality_PolAppInconsistency_Flg,			
Quality_RiskIdDuplicates_Flg,			
Quality_ExcludedDrv_Flg,			
Quality_ReplacedVIN_Flg,			
Quality_ReplacedDriver_Flg,			
Quality_ClaimOk_Flg ,			
Quality_ClaimUnknownVIN_Flg ,			
Quality_ClaimUnknownVINNotListedDriver_Flg ,			
Quality_ClaimPolicyTermJoin_Flg ,			
LoadDate			
)			
with ReplacedVIN as (select policy_uniqueid, vehicle_uniqueid,			
count(distinct vin)		cnt	
from stg_auto_modeldata_3			
group by policy_uniqueid, vehicle_uniqueid			
having count(distinct vin)>1)			
,ReplacedDriver as (select policy_uniqueid, driver_uniqueid,			
count(distinct Driver)		cnt	
from stg_auto_modeldata_3			
group by policy_uniqueid, driver_uniqueid			
having count(distinct driver)>1)			
select			
modeldata_id_adjusted modeldata_id,			
claimrisk_id,			
cast(SystemId as int) SystemIdStart,			
SystemIdEnd	,		
risk_id,			
cvrsk_typedescription	,		
policy_id	,		
stg.policy_uniqueid	,		
Producer_Uniqueid ,			
risk_uniqueid	,		
vehicle_id	,		
stg.vehicle_uniqueid	,		
vin	,		
RiskCd	,		
driver_id	,		
stg.driver_uniqueid	,		
Driver	,		
DriverNumber	,		
startdatetm	,		
enddatetm	,		
startdate,			
enddate,			
CntVeh	,		
CntDrv	,		
CntNonDrv	,		
CntExcludedDrv	,		
minDriverAge	,		
VehicleInceptionDate,			
DriverInceptionDate,			
LiabilityOnlyFlg	,		
CompOnlyFlg		,	
case when CntExcludedDrv>0  then 'Yes' else 'No' end ExcludedDrv_Flg,			
Quality_PolAppInconsistency_Flg,			
Quality_RiskIdDuplicates_Flg,			
Quality_ExcludedDrv_Flg,			
case when ReplacedVIN.policy_uniqueid is not null then 'Yes' else 'No' end Quality_ReplacedVIN_Flg,			
case when ReplacedDriver.policy_uniqueid is not null then 'Yes' else 'No' end Quality_ReplacedDriver_Flg,			
case when audit_id in (25,26,27) then claimrisk_id end Quality_ClaimOk_Flg,			
case when audit_id=30 then claimrisk_id end Quality_ClaimUnknownVIN_Flg,			
case when audit_id in (31,32) then claimrisk_id end  Quality_ClaimUnknownVINNotListedDriver_Flg	,		
case when audit_id in (29,33) then claimrisk_id end 	Quality_ClaimPolicyTermJoin_Flg,		
ploaddate LoadDate			
from stg_auto_modeldata_3 stg			
left outer join ReplacedVIN			
on stg.policy_uniqueid=ReplacedVIN.policy_uniqueid			
and stg.vehicle_uniqueid=ReplacedVIN.vehicle_uniqueid			
left outer join ReplacedDriver			
on stg.policy_uniqueid=ReplacedDriver.policy_uniqueid			
and stg.driver_uniqueid=ReplacedDriver.driver_uniqueid;			
			
drop table if exists stg_auto_modeldata_3;			
/*19. There is an issue in TransactionHistory where some Unapplied Endorsements are not marked as Uanapplied			
Just delete these data			
*/			
			
drop table if exists to_delete;			
create temporary table  to_delete as			
select modeldata_id			 
from fsbi_stg_spinn.stg_auto_modeldata m			
join fsbi_stg_spinn.vstg_modeldata_policyhistory ph			
on m.policy_uniqueid=ph.PolicyRef			
and m.SystemIdStart=ph.SystemId			
where 			
ph.TransactionCd='Final'			
order by Startdatetm;			
			
delete from fsbi_stg_spinn.stg_auto_modeldata 			
where modeldata_id in (select modeldata_id from to_delete);			
			
drop table if exists to_delete;			
			
END;			
			
$$			
;			
