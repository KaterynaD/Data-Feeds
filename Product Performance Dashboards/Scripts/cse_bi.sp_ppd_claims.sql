CREATE OR REPLACE PROCEDURE cse_bi.sp_ppd_claims(pLoadDate datetime) 					
AS $$					
BEGIN					
/*incremental load is too complex. full takes 1 min*/					
truncate table reporting.ppd_claims;					
insert into reporting.ppd_claims					
with 					
data_feature as (					
select					
month_id,					
policy_state,					
carrier,					
company,					
policyneworrenewal,					
product,					
cat_flg,					
perilgroup,					
claim_number,					
claimant,					
rag,					
feature_type,					
feature_map,					
total_incurred_loss feat_total_incurred_loss,					
sum(total_incurred_loss) over(partition by claim_number,rag,feature_type,feature_map,claimant order by month_id rows unbounded preceding) as feat_cumulative_total_incurred_loss,					
total_reserve feat_total_reserve,					
sum(total_reserve)       over(partition by claim_number,rag,feature_type,feature_map,claimant order by month_id rows unbounded preceding) as feat_cumulative_total_reserve,					
case when feat_cumulative_total_incurred_loss >= 0.5 then 1 else 0 end as feat_reported_count,					
case when feat_cumulative_total_incurred_loss >= 0.5 and feat_cumulative_total_reserve < 0.5 then 1 else 0 end as feat_closed_count,					
greatest(feat_reported_count - feat_closed_count,0) as feat_open_count,					
case when feat_cumulative_total_incurred_loss > 100000 then 1 else 0 end as feat_reported_count_100k,					
loss_incurred feat_loss_incurred,					
sum(loss_incurred) over(partition by claim_number,rag,feature_type,feature_map,claimant order by month_id rows unbounded preceding) as feat_cumulative_loss_incurred,					
alae_incurred feat_alae_incurred,					
sum(alae_incurred) over(partition by claim_number,rag,feature_type,feature_map,claimant order by month_id rows unbounded preceding) as feat_cumulative_alae_incurred,					
salsub_received feat_salsub_received,					
sum(salsub_received) over(partition by claim_number,rag,feature_type,feature_map,claimant order by month_id rows unbounded preceding) as feat_cumulative_salsub_received					
from reporting.ppd_claim_summaries					
)					
,data_claim1 as (					
select					
month_id,					
policy_state,					
carrier,					
company,					
policyneworrenewal,					
product,					
cat_flg,					
perilgroup,					
claim_number,					
rag,					
feature_type,					
sum(total_incurred_loss)total_incurred_loss,					
sum(total_reserve) total_reserve,					
sum(loss_incurred) loss_incurred,					
sum(alae_incurred) alae_incurred,					
sum(alae_paid) alae_paid,					
sum(salsub_incurred) salsub_incurred,					
sum(salsub_received) salsub_received					
from reporting.ppd_claim_summaries					
group by 					
month_id,					
policy_state,					
carrier,					
company,					
policyneworrenewal,					
product,					
cat_flg,					
perilgroup,					
claim_number,					
rag,					
feature_type					
)					
,data_claim as (					
select					
month_id,					
policy_state,					
carrier,					
company,					
policyneworrenewal,					
product,					
cat_flg,					
perilgroup,					
claim_number,					
rag,					
feature_type,					
total_incurred_loss clm_total_incurred_loss,					
sum(total_incurred_loss) over(partition by claim_number,rag,feature_type order by month_id rows unbounded preceding) as clm_cumulative_total_incurred_loss,					
loss_incurred clm_loss_incurred,					
sum(loss_incurred) over(partition by claim_number,rag,feature_type order by month_id rows unbounded preceding) as clm_cumulative_loss_incurred,					
alae_incurred clm_alae_incurred,					
sum(alae_incurred) over(partition by claim_number,rag,feature_type order by month_id rows unbounded preceding) as clm_cumulative_alae_incurred,					
salsub_received clm_salsub_received,					
sum(salsub_received) over(partition by claim_number,rag,feature_type order by month_id rows unbounded preceding) as clm_cumulative_salsub_received					
from data_claim1					
)					
select 					
dc.month_id,					
dc.policy_state,					
dc.carrier,					
dc.company,					
dc.policyneworrenewal,					
dc.product,					
dc.cat_flg,					
dc.perilgroup,					
dc.claim_number,					
df.claimant,					
df.rag,					
df.feature_type,					
df.feature_map,					
/*===============Claim level==============*/					
/*-----------------------------*/					
dc.clm_total_incurred_loss,					
dc.clm_cumulative_total_incurred_loss,					
/*-----------------------------*/					
dc.clm_loss_incurred,					
dc.clm_cumulative_loss_incurred,					
/*-----------------------------*/					
dc.clm_alae_incurred,					
dc.clm_cumulative_alae_incurred,					
/*-----------------------------*/					
dc.clm_salsub_received,					
dc.clm_cumulative_salsub_received,					
/*-----------------------------*/					
/*===============Feature Map level==============*/					
/*-----------------------------*/					
df.feat_total_incurred_loss ,					
df.feat_cumulative_total_incurred_loss ,					
/*-------------needed to test counts only------*/					
df.feat_total_reserve,					
df.feat_cumulative_total_reserve,					
/*-----------------------------*/					
df.feat_reported_count ,					
df.feat_closed_count ,					
df.feat_open_count ,					
df.feat_reported_count_100k ,					
/*-----------------------------*/					
df.feat_loss_incurred ,					
df.feat_cumulative_loss_incurred,					
/*-----------------------------*/					
df.feat_alae_incurred ,					
df.feat_cumulative_alae_incurred,					
/*-----------------------------*/					
df.feat_salsub_received,					
df.feat_cumulative_salsub_received ,					
/*---------Capped----------*/					
/*---------100k----------*/					
least(clm_cumulative_total_incurred_loss, 100000) clm_capped_cumulative_total_incurred_100k,					
case when cast(clm_cumulative_total_incurred_loss as float)=0 then 0 else cast(feat_cumulative_total_incurred_loss as float)/cast(clm_cumulative_total_incurred_loss as float) end ratio,					
case 					
 when clm_cumulative_total_incurred_loss>100000 then					
  ratio*clm_capped_cumulative_total_incurred_100k					
 else					
  feat_cumulative_total_incurred_loss					
end feat_capped_cumulative_total_incurred_100k,					
case 					
 when clm_cumulative_total_incurred_loss>100000 then					
  case when cast(clm_cumulative_total_incurred_loss as float)=0 then 0 else feat_capped_cumulative_total_incurred_100k*(cast(clm_cumulative_loss_incurred as float)/cast(clm_cumulative_total_incurred_loss as float)) end					
 else					
  feat_cumulative_loss_incurred					
end feat_capped_cumulative_loss_incurred_100k,					
case 					
 when clm_cumulative_total_incurred_loss>100000 then					
  case when cast(clm_cumulative_total_incurred_loss as float)=0 then 0 else feat_capped_cumulative_total_incurred_100k*(cast(clm_cumulative_alae_incurred as float)/cast(clm_cumulative_total_incurred_loss as float)) end					
 else					
  feat_cumulative_alae_incurred					
end feat_capped_cumulative_alae_incurred_100k,					
case 					
 when clm_cumulative_total_incurred_loss>100000 then					
  case when cast(clm_cumulative_total_incurred_loss as float)=0 then 0 else feat_capped_cumulative_total_incurred_100k*(cast(clm_cumulative_salsub_received as float)/cast(clm_cumulative_total_incurred_loss as float)) end					
 else					
  feat_cumulative_salsub_received					
end feat_capped_cumulative_salsub_received_100k					
/*-----------------------------*/					
,pLoadDate LoadDate					
/*-----------------------------*/					
from data_claim dc					
join data_feature df					
on dc.claim_number=df.claim_number					
and dc.rag = df.rag					
and dc.feature_type=df.feature_type					
and dc.month_id=df.month_id					
and dc.policy_state=df.policy_state					
and dc.carrier=df.carrier					
and dc.company=df.company					
and dc.policyneworrenewal=df.policyneworrenewal					
order by dc.claim_number, dc.month_id;					
					
					
					
END;					
$$ LANGUAGE plpgsql;					
