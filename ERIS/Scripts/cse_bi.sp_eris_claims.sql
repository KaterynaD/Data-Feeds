CREATE OR REPLACE PROCEDURE cse_bi.sp_eris_claims(ploaddate timestamp)
LANGUAGE plpgsql
AS $$
BEGIN
/*-------Feature conversion is used in several parts of the process independently ------------------------------*/
drop table if exists covx;
create temporary table covx as
select distinct
covx.covx_asl as aslob,
covx.act_rag as rag,
left(covx.coveragetype,1) as feature_type,
covx.covx_code as feature,
isnull(covx.act_eris,'OTH') as feature_map
from public.dim_coverageextension covx;
/*--slightly different way of getting policy and claims attributes in SPINN and WINS claims----------------------*/
/*--it's possible a claim has mix of WINs and SPINN transactions ------------------------------------------------*/
/*--some of them only DW based and WINs transaction has higher date then SPINN-----------------------------------*/
/*--attributes can be populated in SPINN transactions but not in WINs--------------------------------------------*/
/*--the final set up is in the main select ----------------------------------------------------------------------*/
/*--1. Latest transaction ---------------------------------------------------------------------------------------*/
drop table if exists tmp_da_spinn;
create temporary table tmp_da_spinn as
select
f.claim_number,
f.claimant,
f.feature,
max(acct_date) acct_date
from public.vmfact_claimtransaction_blended f
where (f.source_system='SPINN')
group by f.claim_number,
f.claimant,
f.feature;
drop table if exists tmp_da_wins;
create temporary table tmp_da_wins as
select f.claim_number,
f.claimant,
f.feature,
max(f.acct_date) acct_date
from public.vmfact_claimtransaction_blended f
left outer join tmp_da_spinn
on f.claim_number=tmp_da_spinn.claim_number
where (f.source_system='WINS')
and tmp_da_spinn.claim_number is null
group by f.claim_number,
f.claimant,
f.feature;
/*--2.SPINN based claims data -----------------------------------------------------------------------------------*/
drop table if exists tmp_dc_spinn;
create temporary table tmp_dc_spinn as
select distinct
f.claim_number,
f.claimant,
f.feature,
max(catastrophe_id) catastrophe_id,
max(loss_cause) loss_cause,
max(policy_state) policy_state,
max(company) company,
max(carrier) carrier,
max(policy_number) policy_number,
case
when upper(substring(max(policy_number),3,1))='A' then 'AU'
when upper(substring(max(policy_number),3,1))='B' then 'OTH'
when upper(substring(max(policy_number),3,1))='E' then 'OTH'
when upper(substring(max(policy_number),3,1))='F' then 'DF'
when upper(substring(max(policy_number),3,1))='H' then 'HO'
when upper(substring(max(policy_number),3,1))='M' then 'OTH'
when upper(substring(max(policy_number),3,1))='Q' then 'OTH'
when upper(substring(max(policy_number),3,1))='R' then 'AU'
when upper(substring(max(policy_number),3,1))='U' then 'OTH'
end LOB ,
max(policyref) policyref,
max(poleff_date) poleff_date,
max(polexp_date) polexp_date,
max(v.producer_status) producer_status
from public.vmfact_claimtransaction_blended f
join fsbi_dw_spinn.vdim_producer_lookup v
on f.producer_code=v.prdr_number
join tmp_da_spinn tmp_da
on f.claim_number=tmp_da.claim_number
and f.acct_date=tmp_da.acct_date
where (f.source_system='SPINN')
group by f.claim_number,
f.claimant,
f.feature
having LOB is not null;
/*--2.WINs based claims data -----------------------------------------------------------------------------------*/
drop table if exists tmp_dc_wins;
create temporary table tmp_dc_wins as
select distinct
f.claim_number,
f.claimant,
f.feature,
max(catastrophe_id) catastrophe_id,
max(loss_cause) loss_cause,
max(policy_state) policy_state,
max(company) company,
max(carrier) carrier,
max(policy_number) policy_number,
case
when upper(substring(max(policy_number),3,1))='A' then 'AU'
when upper(substring(max(policy_number),3,1))='B' then 'OTH'
when upper(substring(max(policy_number),3,1))='E' then 'OTH'
when upper(substring(max(policy_number),3,1))='F' then 'DF'
when upper(substring(max(policy_number),3,1))='H' then 'HO'
when upper(substring(max(policy_number),3,1))='M' then 'OTH'
when upper(substring(max(policy_number),3,1))='Q' then 'OTH'
when upper(substring(max(policy_number),3,1))='R' then 'AU'
when upper(substring(max(policy_number),3,1))='U' then 'OTH'
end LOB ,
max(policyref) policyref,
max(poleff_date) poleff_date,
max(polexp_date) polexp_date,
isnull(max(v.producer_status),'Unknown') producer_status
from public.vmfact_claimtransaction_blended f
left outer join fsbi_dw_spinn.vdim_producer_lookup v
on f.producer_code=v.prdr_number
join tmp_da_wins tmp_da
on f.claim_number=tmp_da.claim_number
and f.acct_date=tmp_da.acct_date
where (f.source_system='WINS')
group by f.claim_number,
f.claimant,
f.feature
having LOB is not null;
/*--2.SPINN and WINs based claims data together-----------------------------------------------------------------------------------*/
drop table if exists tmp_dc;
create temporary table tmp_dc as
select *, 'SPINN' source_system from tmp_dc_spinn
union all
select *, 'WINS' source_system from tmp_dc_wins;

/*-------------------------------------Only Liability or Property Claims----------------*/
drop table if exists tmp_only_liab_170;
create temporary table tmp_only_liab_170 as
with a as (select claim_number, claimant
from public.vmfact_claimtransaction_blended
group by claim_number, claimant
having count(distinct feature_type)=1)
select distinct f.claim_number,f.claimant
from public.vmfact_claimtransaction_blended f
join a
on f.claim_number=a.claim_number
and f.claimant=a.claimant
where f.aslob='170'
and f.feature_type='L';
drop table if exists tmp_only_liab_040;
create temporary table tmp_only_liab_040 as
with a as (select claim_number, claimant
from public.vmfact_claimtransaction_blended
group by claim_number, claimant
having count(distinct feature_type)=1)
select distinct f.claim_number,f.claimant
from public.vmfact_claimtransaction_blended f
join a
on f.claim_number=a.claim_number
and f.claimant=a.claimant
where f.aslob='040'
and f.feature_type='L';
/*-------------------------------------Reported Count is based on transactional level----------------*/
drop table if exists tmp_reported_count;
create temporary table tmp_reported_count as
select
f.claim_number,
f.claimant,
case
when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map
when substring(tmp_dc.Policy_number,3,1) in ('F','H') then
case
when pe.AltSubTypeCd='DF1' then '03'
when pe.AltSubTypeCd='DF3' then '03'
when pe.AltSubTypeCd='DF6' then '06'
when pe.AltSubTypeCd='FL1-Basic' then '03'
when pe.AltSubTypeCd='FL1-Vacant' then '03'
when pe.AltSubTypeCd='FL2-Broad' then '03'
when pe.AltSubTypeCd='FL3-Special' then '03'
when pe.AltSubTypeCd='Form3' then '03'
when pe.AltSubTypeCd='HO3' then '03'
when pe.AltSubTypeCd='HO4' then '04'
when pe.AltSubTypeCd='HO6' then '06'
when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3'
when pe.AltSubTypeCd='PA' then 'OTH'
end
else 'OTH'
end Feature,
case
when f.aslob='010' then 'SP'
when f.aslob='021' then 'SP'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'SP'
when f.aslob='120' then 'SP'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'SP'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'AC'
end LOB2,
case
when f.aslob='010' then 'DF'
when f.aslob='021' then 'DF'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'OTH'
when f.aslob='120' then 'OTH'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'DF'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'APD'
end LOB3,
case
when f.aslob='010' then 'PROP'
when f.aslob='021' then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040' then 'LIAB'
when f.aslob='090' then 'PROP'
when f.aslob='120' then 'PROP'
when f.aslob='160' then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'
when f.aslob='191' then 'LIAB'
when f.aslob='192' then 'LIAB'
when f.aslob='211' then 'PROP'
when f.aslob='220' then 'PROP'
end FeatureType,
min(cast(date_part(year, f.acct_date) as varchar)+'0'+cast(date_part(quarter, f.acct_date) as varchar)) quarter_id,
min(acct_date) reported_count_date
from public.vmfact_claimtransaction_blended f
join tmp_dc
on tmp_dc.claim_number=f.claim_number
left outer join covx
on f.feature=covx.feature
and f.feature_type=covx.feature_type
and f.aslob=covx.aslob
and f.rag=covx.rag
left outer join fsbi_dw_spinn.dim_policyextension pe
on tmp_dc.PolicyRef=pe.policy_uniqueid
and tmp_dc.source_system='SPINN'
left outer join tmp_only_liab_170 l
on f.claim_number=l.claim_number
and f.claimant=l.claimant
left outer join tmp_only_liab_040 l040
on f.claim_number=l040.claim_number
and f.claimant=l040.claimant
where f.acct_date>=dateadd(year,-12, GetDate())
and (
f.loss_paid>=0.5 or f.loss_reserve>=0.5 or f.aoo_paid>=0.5 or f.aoo_reserve>=0.5 or f.dcc_paid>=0.5 or f.dcc_reserve>=0.5 or f.salvage_received>=0.5 or f.subro_received>=0.5
)
group by
f.claim_number,
f.claimant,
case
when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map
when substring(tmp_dc.Policy_number,3,1) in ('F','H') then
case
when pe.AltSubTypeCd='DF1' then '03'
when pe.AltSubTypeCd='DF3' then '03'
when pe.AltSubTypeCd='DF6' then '06'
when pe.AltSubTypeCd='FL1-Basic' then '03'
when pe.AltSubTypeCd='FL1-Vacant' then '03'
when pe.AltSubTypeCd='FL2-Broad' then '03'
when pe.AltSubTypeCd='FL3-Special' then '03'
when pe.AltSubTypeCd='Form3' then '03'
when pe.AltSubTypeCd='HO3' then '03'
when pe.AltSubTypeCd='HO4' then '04'
when pe.AltSubTypeCd='HO6' then '06'
when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3'
when pe.AltSubTypeCd='PA' then 'OTH'
end
else 'OTH'
end,
case
when f.aslob='010' then 'SP'
when f.aslob='021' then 'SP'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'SP'
when f.aslob='120' then 'SP'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'SP'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'AC'
end,
case
when f.aslob='010' then 'DF'
when f.aslob='021' then 'DF'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'OTH'
when f.aslob='120' then 'OTH'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'DF'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'APD'
end,
case
when f.aslob='010' then 'PROP'
when f.aslob='021' then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040' then 'LIAB'
when f.aslob='090' then 'PROP'
when f.aslob='120' then 'PROP'
when f.aslob='160' then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'
when f.aslob='191' then 'LIAB'
when f.aslob='192' then 'LIAB'
when f.aslob='211' then 'PROP'
when f.aslob='220' then 'PROP'
end;


/*-------------------------------------Closed Count is based on transactional level----------------*/
drop table if exists tmp_closed_count;
create temporary table tmp_closed_count as
with data as (
select
f.claim_number,
f.claimant,
case
when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map
when substring(tmp_dc.Policy_number,3,1) in ('F','H') then
case
when pe.AltSubTypeCd='DF1' then '03'
when pe.AltSubTypeCd='DF3' then '03'
when pe.AltSubTypeCd='DF6' then '06'
when pe.AltSubTypeCd='FL1-Basic' then '03'
when pe.AltSubTypeCd='FL1-Vacant' then '03'
when pe.AltSubTypeCd='FL2-Broad' then '03'
when pe.AltSubTypeCd='FL3-Special' then '03'
when pe.AltSubTypeCd='Form3' then '03'
when pe.AltSubTypeCd='HO3' then '03'
when pe.AltSubTypeCd='HO4' then '04'
when pe.AltSubTypeCd='HO6' then '06'
when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3'
when pe.AltSubTypeCd='PA' then 'OTH'
end
else 'OTH'
end Feature,
case
when f.aslob='010' then 'SP'
when f.aslob='021' then 'SP'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'SP'
when f.aslob='120' then 'SP'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'SP'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'AC'
end LOB2,
case
when f.aslob='010' then 'DF'
when f.aslob='021' then 'DF'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'OTH'
when f.aslob='120' then 'OTH'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'DF'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'APD'
end LOB3,
case
when f.aslob='010' then 'PROP'
when f.aslob='021' then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040' then 'LIAB'
when f.aslob='090' then 'PROP'
when f.aslob='120' then 'PROP'
when f.aslob='160' then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'
when f.aslob='191' then 'LIAB'
when f.aslob='192' then 'LIAB'
when f.aslob='211' then 'PROP'
when f.aslob='220' then 'PROP'
end FeatureType,
f.acct_date acct_date,
cast(date_part(year, f.acct_date) as varchar)+'0'+cast(date_part(quarter, f.acct_date) as varchar) quarter_id,
sum(f.loss_reserve + f.aoo_reserve + f.dcc_reserve) trn_reserve
from public.vmfact_claimtransaction_blended f
join tmp_dc
on tmp_dc.claim_number=f.claim_number
left outer join covx
on f.feature=covx.feature
and f.feature_type=covx.feature_type
and f.aslob=covx.aslob
and f.rag=covx.rag
left outer join fsbi_dw_spinn.dim_policyextension pe
on tmp_dc.PolicyRef=pe.policy_uniqueid
and tmp_dc.source_system='SPINN'
left outer join tmp_only_liab_170 l
on f.claim_number=l.claim_number
and f.claimant=l.claimant
left outer join tmp_only_liab_040 l040
on f.claim_number=l040.claim_number
and f.claimant=l040.claimant
where f.acct_date>=dateadd(year,-12, GetDate())
group by
f.claim_number,
f.claimant,
case
when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map
when substring(tmp_dc.Policy_number,3,1) in ('F','H') then
case
when pe.AltSubTypeCd='DF1' then '03'
when pe.AltSubTypeCd='DF3' then '03'
when pe.AltSubTypeCd='DF6' then '06'
when pe.AltSubTypeCd='FL1-Basic' then '03'
when pe.AltSubTypeCd='FL1-Vacant' then '03'
when pe.AltSubTypeCd='FL2-Broad' then '03'
when pe.AltSubTypeCd='FL3-Special' then '03'
when pe.AltSubTypeCd='Form3' then '03'
when pe.AltSubTypeCd='HO3' then '03'
when pe.AltSubTypeCd='HO4' then '04'
when pe.AltSubTypeCd='HO6' then '06'
when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3'
when pe.AltSubTypeCd='PA' then 'OTH'
end
else 'OTH'
end,
case
when f.aslob='010' then 'SP'
when f.aslob='021' then 'SP'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'SP'
when f.aslob='120' then 'SP'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'SP'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'AC'
end,
case
when f.aslob='010' then 'DF'
when f.aslob='021' then 'DF'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'OTH'
when f.aslob='120' then 'OTH'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'DF'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'APD'
end,
case
when f.aslob='010' then 'PROP'
when f.aslob='021' then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040' then 'LIAB'
when f.aslob='090' then 'PROP'
when f.aslob='120' then 'PROP'
when f.aslob='160' then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'
when f.aslob='191' then 'LIAB'
when f.aslob='192' then 'LIAB'
when f.aslob='211' then 'PROP'
when f.aslob='220' then 'PROP'
end,
f.acct_date,
cast(date_part(year, f.acct_date) as varchar)+'0'+cast(date_part(quarter, f.acct_date) as varchar)
having
sum(f.loss_reserve + f.aoo_reserve + f.dcc_reserve)<0.5
)
select
claim_number,
claimant,
feature,
LOB2,
LOB3,
FeatureType,
max(quarter_id) quarter_id,
max(acct_date) closed_count_date
from data
group by
claim_number,
claimant,
feature,
LOB2,
LOB3,
FeatureType;


/*-------------------------------------Main select with attributes on monthly level ----------------*/
truncate table reporting.vmERIS_Claims;
insert into reporting.vmERIS_Claims
with
/*Calendar Quterly summaries*/
data as (
select
datediff(qtr, isnull(cl.dateofloss,f.loss_date), m.mon_enddate)+1 DevQ_tmp,
m.mon_year,
m.mon_quarter,
cast(m.mon_year as varchar)+'0'+cast(m.mon_quarter as varchar) quarter_id,
isnull(cl.dateofloss,f.loss_date) loss_date,
f.reported_date,
tmp_dc.Carrier,
tmp_dc.Company,
tmp_dc.Policy_number,
tmp_dc.PolicyRef policy_uniqueid,
lpad(isnull(clr.clrsk_number,1),3,'0') RiskCd,
tmp_dc.poleff_date,
tmp_dc.polexp_date,
pe.RenewalTermCd,
case
when tmp_dc.source_system='WINS' or p.pol_policynumbersuffix='~' then 'New'
when p.pol_policynumbersuffix='00' then 'Renewal'
when cast(isnull(p.pol_policynumbersuffix,'0') as int)<2 then 'New'
else 'Renewal'
end policyneworrenewal,
tmp_dc.policy_state PolicyState,
tmp_dc.producer_status,
f.claim_number,
f.claimant,
case when tmp_dc.catastrophe_id is null then 'No' else 'Yes' end Cat_Indicator,
tmp_dc.LOB LOB,
case
when f.aslob='010' then 'SP'
when f.aslob='021' then 'SP'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'SP'
when f.aslob='120' then 'SP'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'SP'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'AC'
end LOB2,
case
when f.aslob='010' then 'DF'
when f.aslob='021' then 'DF'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'OTH'
when f.aslob='120' then 'OTH'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'DF'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'APD'
end LOB3,
case
when upper(substring(tmp_dc.Policy_number,3,1))='A' then 'AU'
when upper(substring(tmp_dc.Policy_number,3,1))='B' then 'BO'
when upper(substring(tmp_dc.Policy_number,3,1))='E' then 'EQ'
when upper(substring(tmp_dc.Policy_number,3,1))='F' then 'DF'
when upper(substring(tmp_dc.Policy_number,3,1))='H' then 'HO'
when upper(substring(tmp_dc.Policy_number,3,1))='M' then 'MH'
when upper(substring(tmp_dc.Policy_number,3,1))='Q' then 'EQ'
when upper(substring(tmp_dc.Policy_number,3,1))='R' then 'AU'
when upper(substring(tmp_dc.Policy_number,3,1))='U' then 'PU'
end Product,
pe.PolicyFormCode,
case
when tmp_dc.Company in ('0019') then 'Select'
when pe.ProgramInd='Non-Civil Servant' then 'NC'
when pe.ProgramInd='Civil Servant' then 'CS'
when pe.ProgramInd='Affinity Group' then 'AG'
when pe.ProgramInd='Educator' then 'ED'
when pe.ProgramInd='Firefighter' then 'FF'
when pe.ProgramInd='Law Enforcement' then 'LE'
else tmp_dc.LOB
end ProgramInd,
case
when f.aslob='010' then 'PROP'
when f.aslob='021' then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040' then 'LIAB'
when f.aslob='090' then 'PROP'
when f.aslob='120' then 'PROP'
when f.aslob='160' then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'
when f.aslob='191' then 'LIAB'
when f.aslob='192' then 'LIAB'
when f.aslob='211' then 'PROP'
when f.aslob='220' then 'PROP'
end FeatureType,
case
when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map
when substring(tmp_dc.Policy_number,3,1) in ('F','H') then
case
when pe.AltSubTypeCd='DF1' then '03'
when pe.AltSubTypeCd='DF3' then '03'
when pe.AltSubTypeCd='DF6' then '06'
when pe.AltSubTypeCd='FL1-Basic' then '03'
when pe.AltSubTypeCd='FL1-Vacant' then '03'
when pe.AltSubTypeCd='FL2-Broad' then '03'
when pe.AltSubTypeCd='FL3-Special' then '03'
when pe.AltSubTypeCd='Form3' then '03'
when pe.AltSubTypeCd='HO3' then '03'
when pe.AltSubTypeCd='HO4' then '04'
when pe.AltSubTypeCd='HO6' then '06'
when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3'
when pe.AltSubTypeCd='PA' then 'OTH'
end
else 'OTH'
end Feature,
sum(aoo_paid + dcc_paid) Paid_Expense ,
sum(dcc_paid) Paid_DCC_Expense ,
sum(aoo_paid + aoo_reserve + dcc_paid + dcc_reserve) Incurred_Expense ,
sum(dcc_paid + dcc_reserve) Incurred_dcc_Expense,
sum(salvage_received + subro_received) Salvage_and_subrogation,
sum(loss_paid) Paid_Loss ,
sum(loss_paid + loss_reserve) Incurred_Loss ,
sum(loss_reserve + aoo_reserve + dcc_reserve) Reserve,
sum(loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received) Paid,
sum(loss_paid + loss_reserve + aoo_paid + dcc_paid) Incurred,
sum(loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received) Incurred_net_Salvage_Subrogation,
sum(loss_paid + loss_reserve + aoo_paid + aoo_reserve + dcc_paid + dcc_reserve) total_incurred_loss,
sum(loss_paid + aoo_paid + dcc_paid) Loss_and_ALAE_for_Paid_count,
case
when Reserve=0 then 'Closed'
else 'Open' end Claim_Status ,
tmp_dc.source_system ,
pe.AltSubTypeCd
from public.vmfact_claim_blended f
join fsbi_dw_spinn.dim_month m
on f.month_id=m.month_id
join tmp_dc
on tmp_dc.claim_number=f.claim_number
and tmp_dc.claimant=f.claimant
and tmp_dc.feature=f.feature
left outer join covx
on f.feature=covx.feature
and f.feature_type=covx.feature_type
and f.aslob=covx.aslob
and f.rag=covx.rag
left outer join fsbi_dw_spinn.dim_policyextension pe
on tmp_dc.PolicyRef=pe.policy_uniqueid
and tmp_dc.source_system='SPINN'
left outer join fsbi_dw_spinn.dim_policy p
on tmp_dc.PolicyRef=p.pol_uniqueid
and tmp_dc.source_system='SPINN'
left outer join fsbi_dw_spinn.dim_claimrisk clr
on tmp_dc.claim_number=clr.claimnumber
and tmp_dc.source_system='SPINN'
left outer join (select distinct clm_claimnumber, dateofloss from fsbi_dw_spinn.dim_claim) cl
on tmp_dc.claim_number=cl.clm_claimnumber
and tmp_dc.source_system='SPINN'
left outer join tmp_only_liab_170 l
on f.claim_number=l.claim_number
and f.claimant=l.claimant
left outer join tmp_only_liab_040 l040
on f.claim_number=l040.claim_number
and f.claimant=l040.claimant
where m.mon_year>=DATE_PART(year,Getdate())-12
group by
datediff(qtr, isnull(cl.dateofloss,f.loss_date), m.mon_enddate)+1,
m.mon_year,
m.mon_quarter,
cast(m.mon_year as varchar)+'0'+cast(m.mon_quarter as varchar),
isnull(cl.dateofloss,f.loss_date),
f.reported_date,
tmp_dc.Carrier,
tmp_dc.Company,
tmp_dc.Policy_number,
tmp_dc.PolicyRef,
lpad(isnull(clr.clrsk_number,1),3,'0'),
tmp_dc.poleff_date,
tmp_dc.polexp_date,
pe.RenewalTermCd,
case
when tmp_dc.source_system='WINS' or p.pol_policynumbersuffix='~' then 'New'
when p.pol_policynumbersuffix='00' then 'Renewal'
when cast(isnull(p.pol_policynumbersuffix,'0') as int)<2 then 'New'
else 'Renewal'
end,
tmp_dc.policy_state,
tmp_dc.producer_status,
f.claim_number,
f.claimant,
case when tmp_dc.catastrophe_id is null then 'No' else 'Yes' end,
tmp_dc.LOB,
case
when f.aslob='010' then 'SP'
when f.aslob='021' then 'SP'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'SP'
when f.aslob='120' then 'SP'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'SP'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'AC'
end,
case
when f.aslob='010' then 'DF'
when f.aslob='021' then 'DF'
when f.aslob='040' then 'HO'
when f.aslob='090' then 'OTH'
when f.aslob='120' then 'OTH'
when f.aslob='160' then 'HO'
when f.aslob='170' then 'DF'
when f.aslob='191' then 'AL'
when f.aslob='192' then 'AL'
when f.aslob='211' then 'APD'
when f.aslob='220' then 'APD'
end,
case
when upper(substring(tmp_dc.Policy_number,3,1))='A' then 'AU'
when upper(substring(tmp_dc.Policy_number,3,1))='B' then 'BO'
when upper(substring(tmp_dc.Policy_number,3,1))='E' then 'EQ'
when upper(substring(tmp_dc.Policy_number,3,1))='F' then 'DF'
when upper(substring(tmp_dc.Policy_number,3,1))='H' then 'HO'
when upper(substring(tmp_dc.Policy_number,3,1))='M' then 'MH'
when upper(substring(tmp_dc.Policy_number,3,1))='Q' then 'EQ'
when upper(substring(tmp_dc.Policy_number,3,1))='R' then 'AU'
when upper(substring(tmp_dc.Policy_number,3,1))='U' then 'PU'
end,
pe.AltSubTypeCd,
pe.policyformcode,
case
when tmp_dc.Company in ('0019') then 'Select'
when pe.ProgramInd='Non-Civil Servant' then 'NC'
when pe.ProgramInd='Civil Servant' then 'CS'
when pe.ProgramInd='Affinity Group' then 'AG'
when pe.ProgramInd='Educator' then 'ED'
when pe.ProgramInd='Firefighter' then 'FF'
when pe.ProgramInd='Law Enforcement' then 'LE'
else tmp_dc.LOB
end ,
case
when f.aslob='010' then 'PROP'
when f.aslob='021' then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1)) in ('H','M') and f.aslob='040' and l040.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1)) not in ('H','M') and f.aslob='040' then 'LIAB'
when f.aslob='090' then 'PROP'
when f.aslob='120' then 'PROP'
when f.aslob='160' then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is not null then 'LIAB'
when upper(substring(tmp_dc.Policy_number,3,1))='F' and f.aslob='170' and l.claim_number is null then 'PROP'
when upper(substring(tmp_dc.Policy_number,3,1))<>'F' and f.aslob='170' then 'LIAB'
when f.aslob='191' then 'LIAB'
when f.aslob='192' then 'LIAB'
when f.aslob='211' then 'PROP'
when f.aslob='220' then 'PROP'
end ,
case
when substring(tmp_dc.Policy_number,3,1)='A' then covx.feature_map
when substring(tmp_dc.Policy_number,3,1) in ('F','H') then
case
when pe.AltSubTypeCd='DF1' then '03'
when pe.AltSubTypeCd='DF3' then '03'
when pe.AltSubTypeCd='DF6' then '06'
when pe.AltSubTypeCd='FL1-Basic' then '03'
when pe.AltSubTypeCd='FL1-Vacant' then '03'
when pe.AltSubTypeCd='FL2-Broad' then '03'
when pe.AltSubTypeCd='FL3-Special' then '03'
when pe.AltSubTypeCd='Form3' then '03'
when pe.AltSubTypeCd='HO3' then '03'
when pe.AltSubTypeCd='HO4' then '04'
when pe.AltSubTypeCd='HO6' then '06'
when pe.AltSubTypeCd='HO3-Homeguard' then 'HG3'
when pe.AltSubTypeCd='PA' then 'OTH'
end
else 'OTH'
end,
tmp_dc.source_system,
pe.AltSubTypeCd
)
/*DevQ with limit to 120month/40 Qtr*/
,data1 as (
select
case
when DevQ_tmp>=40 then 40
else DevQ_tmp
end DevQ,
d.*,
/*--Reported_Count is calculated at this level because later we loss quarter_id--*/
/*--last_closed_count_flg is calculated at this level because later we loss quarter_id--*/
/*--for final calculations based on last_closed_count_flg we need ITD which are calculated later*/
case when first_reported_count.quarter_id=d.quarter_id then 1 else 0 end Reported_Count,
case when last_closed_count.quarter_id=d.quarter_id then 'Y' else 'N' end last_closed_count_flg
from data d
/*-------------------------------*/
left outer join tmp_reported_count first_reported_count
on
d.claim_number = first_reported_count.claim_number and
d.claimant = first_reported_count.claimant and
d.feature = first_reported_count.feature and
d.LOB2 = first_reported_count.LOB2 and
d.LOB3 = first_reported_count.LOB3 and
d.FeatureType = first_reported_count.FeatureType
/*-------------------------------*/
left outer join tmp_closed_count last_closed_count
on
d.claim_number = last_closed_count.claim_number and
d.claimant = last_closed_count.claimant and
d.feature = last_closed_count.feature and
d.LOB2 = last_closed_count.LOB2 and
d.LOB3 = last_closed_count.LOB3 and
d.FeatureType = last_closed_count.FeatureType
/*-------------------------------*/
)
/*DevQ summaries*/
,data2 as (
select
3*DevQ DevQ,
mon_year Reported_Year,
mon_quarter Reported_Qtr,
loss_date,
reported_date,
Carrier,
Company,
Policy_number,
policy_uniqueid,
RiskCd,
poleff_date,
polexp_date,
RenewalTermCd,
policyneworrenewal,
PolicyState,
producer_status,
d.claim_number,
d.claimant,
Cat_Indicator,
LOB,
LOB2,
LOB3,
Product,
PolicyFormCode,
ProgramInd,
FeatureType,
Feature,
Claim_Status,
source_system,
/*---------------------------------------------*/
/*---------------------------------------------*/
sum(Paid_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Paid_Expense,
sum(Paid_DCC_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Paid_DCC_Expense,
sum(Paid_Loss) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Paid_Loss,
sum(Incurred) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Incurred,
sum(Incurred_net_Salvage_Subrogation) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Incurred_net_Salvage_Subrogation,
sum(total_incurred_loss) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Total_Incurred_Loss,
sum(Reserve) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Reserve,
sum(Loss_and_ALAE_for_Paid_count) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Loss_and_ALAE_for_Paid_count,
sum(Salvage_and_subrogation) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr rows unbounded preceding) as ITD_Salvage_and_subrogation,
/*added 03/01/2022*/
itd_paid_loss+ itd_paid_expense- itd_salvage_and_subrogation ITD_PAID ,
/*---------------------------------------------*/
/*This analytical aggregation may not needed and prev aggregation can be used as is or we need it for modified DevQ (40?)*/
/*---------------------------------------------*/
sum(Paid_DCC_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Paid_DCC_Expense,
sum(Paid_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Paid_Expense,
sum(Incurred_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Incurred_Expense,
sum(Incurred_dcc_Expense) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Incurred_dcc_Expense,
sum(Salvage_and_Subrogation) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Paid_Salvage_and_Subrogation,
sum(Paid_Loss) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Paid_Loss,
sum(Incurred_Loss) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Incurred_Loss,
sum(Paid) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Paid,
sum(Incurred) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Incurred,
sum(Incurred_net_Salvage_Subrogation) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Incurred_net_Salvage_Subrogation,
sum(Total_Incurred_Loss) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType,Reported_Year, Reported_Qtr rows unbounded preceding) as QTD_Total_Incurred_Loss,
/*---------------------------------------------*/
case when ITD_Incurred_net_Salvage_Subrogation>0 then greatest(0,ITD_Incurred_net_Salvage_Subrogation - 250000) else 0 end X_ITD_Incurred_net_Salvage_Subrogation_250k,
case when ITD_Incurred_net_Salvage_Subrogation>0 then greatest(0,ITD_Incurred_net_Salvage_Subrogation - 500000) else 0 end X_ITD_Incurred_net_Salvage_Subrogation_500k,
/*---------------------------------------------*/
Reported_Count,
case when last_closed_count_flg='Y' then 1 else 0 end Closed_Count,
case when last_closed_count_flg='Y' and ITD_Paid_Loss + ITD_Paid_Expense<=0 then 1 else 0 end Closed_NoPay,
case when last_closed_count_flg='Y' then ITD_Paid_Loss else 0 end Paid_On_Closed_Loss,
case when last_closed_count_flg='Y' then ITD_Paid_Expense else 0 end Paid_On_Closed_Expense,
case when last_closed_count_flg='Y' then ITD_Paid_DCC_Expense else 0 end Paid_On_Closed_DCC_Expense ,
case when last_closed_count_flg='Y' then ITD_Salvage_and_subrogation else 0 end Paid_On_Closed_Salvage_Subrogation ,
AltSubTypeCd
from data1 d
)
/*One more level for analytical functions*/
,data3 as (
select
DevQ,
Reported_Year,
Reported_Qtr,
loss_date,
reported_date,
Carrier,
Company,
Policy_number,
policy_uniqueid,
RiskCd,
poleff_date,
polexp_date,
RenewalTermCd,
policyneworrenewal,
PolicyState,
producer_status,
claim_number,
claimant,
Cat_Indicator,
LOB,
LOB2,
LOB3,
Product,
PolicyFormCode,
ProgramInd,
FeatureType,
Feature,
Claim_Status,
source_system,
/*---------------------------------------------*/
ITD_Paid_Expense,
ITD_Paid_DCC_Expense,
ITD_Paid_Loss,
ITD_Incurred,
ITD_Incurred_net_Salvage_Subrogation,
isnull(lag(ITD_Incurred_net_Salvage_Subrogation) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr),0) prev_ITD_Incurred_net_Salvage_Subrogation,
ITD_Total_Incurred_Loss,
ITD_Reserve,
ITD_Loss_and_ALAE_for_Paid_count,
ITD_Salvage_and_subrogation,
ITD_PAID ,
isnull(lag(ITD_PAID) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType order by Reported_Year, Reported_Qtr),0) prev_ITD_PAID,
/*---------------------------------------------*/
QTD_Paid_DCC_Expense,
QTD_Paid_Expense,
QTD_Incurred_Expense,
QTD_Incurred_dcc_Expense,
QTD_Paid_Salvage_and_Subrogation,
QTD_Paid_Loss,
QTD_Incurred_Loss,
QTD_Paid,
QTD_Incurred,
QTD_Incurred_net_Salvage_Subrogation,
QTD_Total_Incurred_Loss,
/*---------------------------------------------*/
/*---------------------------------------------*/
least(25000,ITD_PAID) - least(25000,prev_ITD_PAID) QTD_Paid_25k,
least(50000,ITD_PAID) - least(50000,prev_ITD_PAID) QTD_Paid_50k,
least(100000,ITD_PAID) - least(100000,prev_ITD_PAID) QTD_Paid_100k,
least(250000,ITD_PAID) - least(250000,prev_ITD_PAID) QTD_Paid_250k,
least(500000,ITD_PAID) - least(500000,prev_ITD_PAID) QTD_Paid_500k,
least(1000000,ITD_PAID) - least(1000000,prev_ITD_PAID) QTD_Paid_1M,
/*---------------------------------------------*/
least(25000,ITD_Incurred_net_Salvage_Subrogation) - least(25000,prev_ITD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation_25k,
least(50000,ITD_Incurred_net_Salvage_Subrogation) - least(50000,prev_ITD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation_50k,
least(100000,ITD_Incurred_net_Salvage_Subrogation) - least(100000,prev_ITD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation_100k,
least(250000,ITD_Incurred_net_Salvage_Subrogation) - least(250000,prev_ITD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation_250k,
least(500000,ITD_Incurred_net_Salvage_Subrogation) - least(500000,prev_ITD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation_500k,
least(1000000,ITD_Incurred_net_Salvage_Subrogation) - least(1000000,prev_ITD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation_1M,
/*---------------------------------------------*/
X_ITD_Incurred_net_Salvage_Subrogation_250k,
X_ITD_Incurred_net_Salvage_Subrogation_500k,
/*---------------------------------------------*/
Reported_Count,
sum(Reported_Count) over(partition by d.claim_number,d.claimant, feature, LOB2, LOB3, FeatureType ORDER BY reported_year, reported_qtr rows unbounded preceding) isReported,
case when isReported=1 then Closed_Count else 0 end Closed_Count,
case when isReported=1 then Closed_NoPay else 0 end Closed_NoPay,
Paid_On_Closed_Loss,
Paid_On_Closed_Expense,
Paid_On_Closed_DCC_Expense ,
Paid_On_Closed_Salvage_Subrogation ,
case
when min(case when ITD_Loss_and_ALAE_for_Paid_count>0 then concat(reported_year, reported_qtr) end) over(partition by claim_number, claimant, feature, LOB2, LOB3, FeatureType)=concat(reported_year, reported_qtr)
then 1
else 0
end Paid_Count ,
AltSubTypeCd
from data2 d
)
/*final*/
select
DevQ,
Reported_Year,
Reported_Qtr,
loss_date,
reported_date,
Carrier,
Company,
Policy_number,
policy_uniqueid,
RiskCd,
poleff_date,
polexp_date,
RenewalTermCd,
policyneworrenewal,
PolicyState,
producer_status,
claim_number,
claimant,
Cat_Indicator,
LOB,
LOB2,
LOB3,
Product,
PolicyFormCode,
ProgramInd,
FeatureType,
Feature,
Claim_Status,
source_system,
/*---------------------------------------------*/
ITD_Paid_Expense,
ITD_Paid_DCC_Expense,
ITD_Paid_Loss,
ITD_Incurred,
ITD_Incurred_net_Salvage_Subrogation,
ITD_Total_Incurred_Loss,
ITD_Reserve,
ITD_Loss_and_ALAE_for_Paid_count,
ITD_Salvage_and_subrogation,
/*---------------------------------------------*/
QTD_Paid_DCC_Expense,
QTD_Paid_Expense,
QTD_Incurred_Expense,
QTD_Incurred_dcc_Expense,
QTD_Paid_Salvage_and_Subrogation,
QTD_Paid_Loss,
QTD_Incurred_Loss,
QTD_Paid,
QTD_Incurred,
QTD_Incurred_net_Salvage_Subrogation,
QTD_Total_Incurred_Loss,
/*---------------------------------------------*/
/*---------------------------------------------*/
QTD_Paid_25k,
QTD_Paid_50k,
QTD_Paid_100k,
QTD_Paid_250k,
QTD_Paid_500k,
QTD_Paid_1M,
/*---------------------------------------------*/
QTD_Incurred_net_Salvage_Subrogation_25k,
QTD_Incurred_net_Salvage_Subrogation_50k,
QTD_Incurred_net_Salvage_Subrogation_100k,
QTD_Incurred_net_Salvage_Subrogation_250k,
QTD_Incurred_net_Salvage_Subrogation_500k,
QTD_Incurred_net_Salvage_Subrogation_1M,
/*---------------------------------------------*/
X_ITD_Incurred_net_Salvage_Subrogation_250k,
X_ITD_Incurred_net_Salvage_Subrogation_500k,
/*---------------------------------------------*/
Reported_Count,
Closed_Count,
Closed_NoPay,
Paid_On_Closed_Loss,
Paid_On_Closed_Expense,
Paid_On_Closed_DCC_Expense ,
Paid_On_Closed_Salvage_Subrogation ,
/*2022-03-31 If a claim has closed_count or closed_nopay = 1 and reported_count = 0 then set closed_count or closed_nopay to 0 as well.*/
case when sum(Closed_NoPay) over(partition by claim_number, claimant, feature, LOB2, LOB3, FeatureType)=0 then Paid_Count else 0 end Paid_Count,
pLoadDate LoadDate,
ITD_PAID ,
AltSubTypeCd
from data3 d
order by DevQ,claim_number,claimant,feature;

END;



$$
;
