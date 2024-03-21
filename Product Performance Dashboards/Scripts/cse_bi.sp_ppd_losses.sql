CREATE OR REPLACE PROCEDURE cse_bi.sp_ppd_losses(pLoadDate datetime) 
AS $$
BEGIN
/*incremental load is too complex. full takes less then 1 min*/
truncate table reporting.ppd_losses;
insert into reporting.ppd_losses
with 
/*---First Level of Aggregation at the level of feature---*/
data as (select 
Product,
month_id,
-- policy_state,
case when policy_state='WA' then 'CA' else policy_state end policy_state,
carrier,
company,
policyneworrenewal,
cat_flg,
perilgroup,
rag,
feature_type,
feature_map,
sum(feat_total_incurred_loss) total_incurred,
sum(feat_reported_count) reported_count,
sum(feat_open_count) open_count,
sum(feat_reported_count_100k) reported_count_100k,
sum(feat_capped_cumulative_loss_incurred_100k) + sum(feat_capped_cumulative_alae_incurred_100k) - sum(feat_capped_cumulative_salsub_received_100k)  total_incurred_100k
from 
reporting.ppd_claims
where claim_number<>'00533729' /*excluding legacy claims*/
group by Product,
month_id,
case when policy_state='WA' then 'CA' else policy_state end,
carrier,
company,
policyneworrenewal,
cat_flg,
perilgroup,
rag,
feature_type,
feature_map
)
/*---Second Level - analytical function ---*/
,data2 as (
select
Product,
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
isnull(total_incurred,0) total_incurred,
isnull(total_incurred_100k,0) - isnull(lag(total_incurred_100k) over(partition by policy_state, carrier, policyneworrenewal, company, Product,rag,cat_flg,perilgroup,feature_type,feature_map order by month_id),0) total_incurred_100k,
isnull(reported_count,0) - isnull(lag(reported_count)           over(partition by policy_state, carrier, policyneworrenewal, company, Product,rag,cat_flg,perilgroup,feature_type,feature_map order by month_id),0) reported_count,
isnull(open_count,0) open_count,
isnull(reported_count_100k,0) - isnull(lag(reported_count_100k) over(partition by policy_state, carrier, policyneworrenewal, company, Product,rag,cat_flg,perilgroup,feature_type,feature_map order by month_id),0) reported_count_100k,
isnull(reported_count,0) reported_count_month,
isnull(reported_count_100k,0) reported_count_100k_month,
isnull(total_incurred_100k,0) total_incurred_100k_month
from data
)
, mapping as 
 (select 
  distinct 
  product, 
  subproduct, 
  feature_map, 
  feature_type, 
  rag 
  from reporting.vppd_loss_product_mapping
  ) 
/*--------FINAL for each LOB and some features for Auto------------*/
,product_data as 
(
select
m.Product,
m.SubProduct,
month_id,
policy_state,
carrier,
company,
policyneworrenewal,
cat_flg,
perilgroup,
sum(total_incurred) total_incurred,
sum(total_incurred_100k_month) total_incurred_100k_month,
sum(total_incurred_100k) total_incurred_capped_100k,
sum(reported_count_month) reported_count_month,
sum(reported_count) reported_count,
sum(open_count) open_count,
sum(reported_count_100k) reported_count_100k,
sum(reported_count_100k_month) reported_count_100k_month
from data2
join mapping m
on data2.feature_map=m.feature_map
and data2.feature_type=m.feature_type
and data2.rag=m.rag
group by
m.Product,
m.SubProduct,
month_id,
policy_state,
carrier,
company,
policyneworrenewal,
cat_flg,
perilgroup
)
select *
,pLoadDate LoadDate
from product_data;

END;
$$ LANGUAGE plpgsql;
