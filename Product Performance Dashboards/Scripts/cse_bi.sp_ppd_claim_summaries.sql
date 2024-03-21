CREATE OR REPLACE PROCEDURE cse_bi.sp_ppd_claim_summaries (pLoadDate datetime) 
AS $$
DECLARE 
months RECORD;
BEGIN

create temporary table tmp_dp as
select distinct 
claim_number,
case 
when claim_number in (
'00449940',
'00449867',
'00449943',
'00449915'
) then 'CommercialFire' 
else   coalesce(p.prdt_lob, f.product )
end product
from public.vmfact_claimtransaction_blended f
left outer join fsbi_dw_spinn.dim_product p
on f.product=p.prdt_name;

create temporary table tmp_da as
select distinct 
claim_number,
max(acct_date) acct_date
from public.vmfact_claimtransaction_blended f
where (source_system='SPINN' or (source_system='WINS' and loss_cause is not null))
group by claim_number;

create temporary table tmp_dc as
select distinct 
f.claim_number,
max(catastrophe_id) catastrophe_id,
max(loss_cause) loss_cause,
max(policy_state) policy_state,
max(company) company,
max(carrier) carrier,
max(policyref) policyref
from public.vmfact_claimtransaction_blended f
join tmp_da
on f.claim_number=tmp_da.claim_number
and f.acct_date=tmp_da.acct_date
where (source_system='SPINN' or (source_system='WINS' and loss_cause is not null))
group by f.claim_number;

create temporary table tmp_fm as 
select distinct
covx.covx_asl as aslob,
covx.act_rag  as rag,
left(covx.coveragetype,1) as feature_type,
covx.covx_code as feature,
isnull(covx.act_map,'~') as feature_map
from public.dim_coverageextension covx
union all
select distinct 
aslob,
rag,
left(feature_type,1) as feature_type,
feature,
'~' feature_map
from public.vmfact_claimtransaction_blended
where feature='~'
union 
select distinct
aslob,
rag,
feature_type,
feature,
feature_map
from fsbi_dw_wins.ppd_feature_map_wins;


FOR months IN 
 select distinct 
 month_id , 
 cast(to_char(add_months(cast(cast(month_id as varchar) + '01' as date),-1),'YYYYMM') as int) prev_month_id
 from fsbi_stg_spinn.fact_claim
 order by month_id
LOOP

delete from reporting.ppd_claim_summaries
where month_id=months.month_id;

insert into reporting.ppd_claim_summaries
select 
f.month_id,
f.claim_number,
f.claimant,
dc.policy_state,
dc.carrier,
dc.company,
case 
 when cast(po.pol_policynumbersuffix as int)<2 then 'New'
 else 'Renewal'
end policyneworrenewal,
case when dc.catastrophe_id is null then 'No' else 'Yes' end Cat_Flg,
case 
 when fm.rag in ('HO','SP') and fm.feature_type='L' then 'Liability'
 when dc.loss_cause in ('Fire','FIRE','Smoke') then 'Fire'
 when dc.loss_cause in ('Water','Water Backup','Water Damage','WATER DAMAGE','Water Discharge') then 'Water'
 when dc.loss_cause in ('Flood','Freezing','Hail','Landslide','Lightning','Weight of Ice Snow Sleet','Wind and Hail','Windstorm','Windstorm and Hail') then 'Weather'
 when dc.loss_cause is null and fm.feature_type='L' then 'Liability'
 when dc.loss_cause is null and fm.feature_type='P'  then 'Other'
 else 'Other'
end as PerilGroup,
dc.loss_cause,
dp.product,
case when fm.aslob in ('051','052') then 'CM' else  fm.rag end rag,
fm.feature_type,
fm.feature_map,
sum(f.loss_paid + f.loss_reserve + f.aoo_paid + f.dcc_paid + f.aoo_reserve + f.dcc_reserve - f.salvage_received  - f.subro_received) total_incurred_loss,
sum(f.loss_paid + f.loss_reserve) loss_incurred,
sum(f.aoo_paid + f.dcc_paid + f.aoo_reserve + f.dcc_reserve) alae_incurred,
sum(f.aoo_paid + f.dcc_paid) alae_paid,
sum(f.salvage_received + f.salvage_reserve + f.subro_received + f.subro_reserve)   salsub_incurred,
sum(f.salvage_received + f.subro_received) salsub_received,
sum(f.loss_reserve + f.aoo_reserve + f.dcc_reserve)  total_reserve
,pLoadDate LoadDate
from public.vmfact_claim_blended  f 
left outer join tmp_dc dc
on dc.claim_number=f.claim_number
left outer join tmp_dp dp
on dp.claim_number=f.claim_number
left outer join tmp_fm fm
on fm.aslob = f.aslob and
fm.rag = f.rag and
fm.feature_type = f.feature_type and 
fm.feature = f.feature 
left outer join fsbi_dw_spinn.dim_policy po
on dc.PolicyRef=po.pol_uniqueid
where loss_date >= '2012-01-01'
and month_id=months.month_id
group by
f.month_id,
f.claim_number,
f.claimant,
dc.policy_state,
dc.carrier,
dc.company,
case 
 when cast(po.pol_policynumbersuffix as int)<2 then 'New'
 else 'Renewal'
end,
case when dc.catastrophe_id is null then 'No' else 'Yes' end,
case 
 when fm.rag in ('HO','SP') and fm.feature_type='L' then 'Liability'
 when dc.loss_cause in ('Fire','FIRE','Smoke') then 'Fire'
 when dc.loss_cause in ('Water','Water Backup','Water Damage','WATER DAMAGE','Water Discharge') then 'Water'
 when dc.loss_cause in ('Flood','Freezing','Hail','Landslide','Lightning','Weight of Ice Snow Sleet','Wind and Hail','Windstorm','Windstorm and Hail') then 'Weather'
 when dc.loss_cause is null and fm.feature_type='L' then 'Liability'
 when dc.loss_cause is null and fm.feature_type='P'  then 'Other'
 else 'Other'
end,
dc.loss_cause,
dp.product,
case when fm.aslob in ('051','052') then 'CM' else  fm.rag end,
fm.feature_type,
fm.feature_map;

/*update catastrophe and perilgroup in all previous month to the latest available*/


update reporting.ppd_claim_summaries
set cat_flg=case when data.catastrophe_id is null then 'No' else 'Yes' end 
,perilgroup=case 
 when s.rag in ('HO','SP') and s.feature_type='L' then 'Liability'
 when data.loss_cause in ('Fire','FIRE','Smoke') then 'Fire'
 when data.loss_cause in ('Water','Water Backup','Water Damage','WATER DAMAGE','Water Discharge') then 'Water'
 when data.loss_cause in ('Flood','Freezing','Hail','Landslide','Lightning','Weight of Ice Snow Sleet','Wind and Hail','Windstorm','Windstorm and Hail') then 'Weather'
 when data.loss_cause is null and s.feature_type='L' then 'Liability'
 when data.loss_cause is null and s.feature_type='P'  then 'Other'
 else 'Other'
end
,policy_state = data.policy_state
,company = data.company
,carrier = data.carrier 
from reporting.ppd_claim_summaries s
join tmp_dc data
on s.claim_number=data.claim_number;



END LOOP;
END;
$$ LANGUAGE plpgsql;
