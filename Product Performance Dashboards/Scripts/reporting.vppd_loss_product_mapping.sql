drop view if exists reporting.vppd_loss_product_mapping;
create view reporting.vppd_loss_product_mapping as
with config_data as (
select distinct
covx.covx_asl as aslob,
covx.act_rag  as rag,
left(covx.coveragetype,1) as feature_type,
covx.covx_code as standard_feature,
c.cov_code feature,
isnull(covx.act_map,'~') as feature_map
from public.dim_coverageextension covx
join fsbi_dw_spinn.dim_coverage c
on covx.coverage_id=c.coverage_id
union 
select distinct 
aslob,
rag,
left(feature_type,1) as feature_type,
feature standard_feature,
feature,
'~' feature_map
from public.vmfact_claimtransaction_blended
where feature='~'
union 
select distinct
aslob,
rag,
feature_type,
feature standard_feature,
feature,
feature_map
from fsbi_dw_wins.PPD_FEATURE_MAP_WINS
)
select distinct
 'PersonalAuto' Product,
 'APD' SubProduct,
 feature_type,
 feature_map,
 standard_feature,
 feature,
 rag
from config_data
where feature_type='P' and 
rag='APD'
union all
select distinct
 'PersonalAuto' Product,
 'ALOTHER' SubProduct,
 feature_type,
 feature_map,
 standard_feature,
 feature,
 rag
from config_data
where feature_type='L' and 
feature_map<>'BI' and
rag='AL'
union all
select distinct
 'PersonalAuto' Product,
 'AL' SubProduct,
 feature_type,
 feature_map,
 standard_feature,
 feature,
 rag
from config_data
where feature_type='L' and 
rag='AL'
union all
select distinct
 'PersonalAuto' Product,
 'ALBI' SubProduct,
 feature_type,
 feature_map,
 standard_feature,
 feature,
 rag
from config_data
where feature_map in ('BI')
union all
select distinct
 'Homeowners' Product,
 'HL' SubProduct,
 feature_type,
 feature_map,
 standard_feature,
 feature,
 rag
from config_data
where feature_type='L'
and rag='HO'
union all
select distinct
 'Dwelling' Product,
 'DL' SubProduct,
 feature_type,
 feature_map,
 standard_feature,
 feature,
 rag
from config_data
where feature_type='L'
and rag='SP'
union all
select distinct
 'All Products' Product,
 'All' SubProduct,
 feature_type,
 feature_map,
 standard_feature,
 feature,
 rag
from config_data
where rag is not null
union all
select distinct
 case
 when rag in ('AL','APD') then 'PersonalAuto'
 when rag in ('HO') then 'Homeowners'
 when rag in ('SP') then 'Dwelling' 
 when rag in ('CM') then 'Commercial'
 end Product,
'All' SubProduct,
 feature_type,
 feature_map,
 standard_feature,
 feature,
 rag
from config_data
where rag is not null;

grant select  on reporting.vppd_loss_product_mapping to report_user;

comment on view reporting.vppd_loss_product_mapping is 'Product performance Dashboard product configuration related to losses. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';
