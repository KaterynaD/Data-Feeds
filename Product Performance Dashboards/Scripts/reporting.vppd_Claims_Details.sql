drop view if exists reporting.vppd_Claims_Details;	
create  view reporting.vppd_Claims_Details as 	
with config_product as (	
select  distinct	
Product,	
SubProduct,	
rag,	
feature_type,	
feature_map	
from reporting.vppd_loss_product_mapping	
where upper(feature) not like '%FEE%'	
)	
,data as (	
select	
distinct 	
month_id, 	
policy_state,	
carrier,	
company,	
policyneworrenewal,	
cat_flg, 	
perilgroup, 	
rag, 	
feature_type, 	
feature_map, 	
claim_number,	
claimant,	
feat_total_incurred_loss incurred,	
feat_cumulative_total_reserve cumulative_total_reserve,	
isnull(feat_reported_count,0) feat_reported_count_current_month,	
isnull(lag(feat_reported_count) over(partition by  policy_state, carrier, policyneworrenewal, company, Product,claim_number, claimant, rag,cat_flg,perilgroup,feature_type,feature_map order by month_id),0) feat_reported_count_prev_month,	
feat_reported_count_current_month - feat_reported_count_prev_month isreported,	
feat_open_count isopen,	
feat_reported_count_100k islargeloss,	
feat_capped_cumulative_loss_incurred_100k + feat_capped_cumulative_alae_incurred_100k - feat_capped_cumulative_salsub_received_100k largeloss_incurred	,
feat_loss_incurred loss_incurred,	
feat_alae_incurred alae_incurred,	
feat_loss_incurred + feat_alae_incurred loss_alae_incurred,	
feat_cumulative_loss_incurred cumulative_loss_incurred,	
feat_cumulative_alae_incurred cumulative_alae_incurred,	
feat_cumulative_loss_incurred + feat_cumulative_alae_incurred cumulative_loss_alae_incurred,	
feat_total_reserve  total_reserve	
from reporting.ppd_claims	
)	
,policy as (	
select 	distinct
claim_number claimnumber,	
policy_number policynumber	
from public.vmfact_claimtransaction_blended	
)	
,claim_loss as (select distinct c.clm_claimnumber claim_number,	
max(cle.losscausecd) losscausecd,	
max(replace(cle.sublosscausecd,'No','')) sublosscausecd,	
max(c.dateofloss) dateofloss,	
max(c.datereported) datereported,	
max(cle.description) description	
from fsbi_dw_spinn.dim_claim c	
join fsbi_dw_spinn.dim_claimextension cle	
on c.clm_uniqueid=cle.claim_uniqueid	
group by c.clm_claimnumber	
)	
,AddedToLargeLosses as (	
select	
distinct month_id,  claimant,    feature_map, claim_number	
from reporting.ppd_claims	
where feat_reported_count_100k>0	
except	
select	
distinct cast(to_char(ADD_MONTHS(mon_startdate,1),'YYYYMM') as int) month_id, claimant,  feature_map, claim_number	
from reporting.ppd_claims f	
join fsbi_dw_spinn.dim_month m	
on f.month_id=m.month_id	
where 	feat_reported_count_100k>0
)	
,RemovedFromLargeLosses as (	
select	
distinct cast(to_char(ADD_MONTHS(mon_startdate,1),'YYYYMM') as int) month_id, claimant,  feature_map, claim_number	
from reporting.ppd_claims f	
join fsbi_dw_spinn.dim_month m	
on f.month_id=m.month_id	
where feat_reported_count_100k>0	
except	
select	
distinct month_id,  claimant,    feature_map, claim_number	
from reporting.ppd_claims	
where feat_reported_count_100k>0	
)	
/*Main select*/	
select distinct	
data.month_id, 	
policy_state,	
carrier,	
company,	
policyneworrenewal,	
case	
 when config_product.SubProduct='All' then	
 case	
 when config_product.Product= 'Commercial' then 'Commercial'	
 when config_product.Product='PersonalAuto' then 'Auto'	
 when config_product.Product='Homeowners' then 'Home'	
 when config_product.Product='Dwelling' then 'DF'	
 else config_product.Product	
 end	
else 	
 case	
 when config_product.SubProduct='AL' then 'Auto Liability'	
 when config_product.SubProduct='ALOTHER' then 'Auto Liability Ex BI'	
 when config_product.SubProduct='ALBI' then 'Auto BI'	
 when config_product.SubProduct='APD' then 'Auto PD'	
 when config_product.SubProduct='DL' then 'DF Liability'	
 when config_product.SubProduct='HL' then 'Home Liability'	
end	
end PPD_Product,	
config_product.Product,	
config_product.SubProduct,	
case when cat_flg='Yes' then 'Cat' else 'Non Cat' end cat_flg,	
isnull(perilgroup,'Empty') perilgroup,	
data.claim_number,	
policy.policynumber,	
data.rag, 	
data.feature_type, 	
data.feature_map, 	
data.claimant,	
losscausecd,	
sublosscausecd,	
dateofloss,	
datereported,	
description,	
incurred,	
cumulative_total_reserve,	
feat_reported_count_current_month,	
feat_reported_count_prev_month,	
case	
 when feat_reported_count_current_month=1 and feat_reported_count_prev_month=1 then 'Reported in prior months' 	
 when feat_reported_count_current_month=0 and feat_reported_count_prev_month=0 then 'Reported in prior months' 	
 when feat_reported_count_current_month=1 and feat_reported_count_prev_month=0 then 'Reported in current month' 	
 when feat_reported_count_current_month=0 and feat_reported_count_prev_month=1 then 'Closed No-Pay in current month' 	
end isreported,	
case when isopen>0 then 'Yes' else 'No' end  isopen,	
case when islargeloss>0 then 'Yes' else 'No' end isLargeLoss,	
largeloss_incurred,	
case when a.claim_number is Null then 'No' else 'Yes' end AddedToLargeLosses,	
case when r.claim_number is Null then 'No' else 'Yes' end RemovedFromLargeLosses	,
loss_incurred,	
alae_incurred,	
loss_alae_incurred,	
cumulative_loss_incurred,	
cumulative_alae_incurred,	
cumulative_loss_alae_incurred,	
total_reserve	
from data join 	
config_product	
on data.rag = config_product.rag	
and data.feature_type=config_product.feature_type	
and data.feature_map=config_product.feature_map	
left outer join claim_loss	
on data.claim_number = claim_loss.claim_number	
left outer join policy	
on policy.claimnumber=data.claim_number	
left outer join AddedToLargeLosses a	
on a.month_id=data.month_id	
and a.claimant=data.claimant	
and a.feature_map=data.feature_map	
and a.claim_number=data.claim_number	
left outer join RemovedFromLargeLosses r	
on r.month_id=data.month_id	
and r.claimant=data.claimant	
and r.feature_map=data.feature_map	
and r.claim_number=data.claim_number	
;	
 grant select on reporting.vppd_Claims_Details  to report_user;	
	
	
 comment on view reporting.vppd_Claims_Details is 'Product performance Dashboard claims details view. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';	
	
 grant select on reporting.vppd_Claims_Details to group ba;	
