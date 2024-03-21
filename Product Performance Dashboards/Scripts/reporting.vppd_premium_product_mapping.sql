drop view if exists reporting.vppd_premium_product_mapping;																		
create view reporting.vppd_premium_product_mapping as																		
with config_data as (																		
select distinct																		
p.prdt_lob,																		
covx.covx_asl as aslob,																		
covx.act_rag  as rag,																		
left(covx.coveragetype,1) as coverage_type,																		
covx.covx_code as standard_coverage,																		
c.cov_code coverage,																		
isnull(covx.act_map,'~') as coverage_map																		
from public.dim_coverageextension covx																		
join fsbi_dw_spinn.dim_coverage c																		
on covx.coverage_id=c.coverage_id																		
join fsbi_dw_spinn.fact_policytransaction f																		
on f.coverage_id=c.coverage_id																		
join fsbi_dw_spinn.dim_product p																		
on f.product_id=p.product_id																		
where upper(c.cov_code) not like '%FEE%' 																		
)																		
,product_data as 																		
(																		
select distinct																		
prdt_lob,																		
'PersonalAuto' product,																		
'AL' subproduct,																		
 coverage_type,																		
 coverage_map,																		
 standard_coverage,																		
 coverage,																		
 rag																		
from config_data																		
where 																		
coverage_type='L' and 																		
rag='AL'																		
union all																		
select distinct																		
prdt_lob,																		
'PersonalAuto' product,																		
'ALBI' subproduct,																		
 coverage_type,																		
 coverage_map,																		
 standard_coverage,																		
 coverage,																		
 rag																		
from config_data																		
where 																		
coverage_map in ('BI')																		
union all																		
select distinct																		
prdt_lob,																		
'PersonalAuto' product,																		
'ALOTHER' subproduct,																		
 coverage_type,																		
 coverage_map,																		
 standard_coverage,																		
 coverage,																		
 rag																		
from config_data																		
where 																		
coverage_type='L' and 																		
coverage_map<>'BI' and																		
rag='AL'																		
union all																		
select distinct																		
prdt_lob,																		
'PersonalAuto' product,																		
'APD' subproduct,																		
 coverage_type,																		
 coverage_map,																		
 standard_coverage,																		
 coverage,																		
 rag																		
from config_data																		
where																		
coverage_type='P' and 																		
rag='APD'																		
/*---------Dwelling Liability--------------*/																		
union all																		
select distinct																		
prdt_lob,																		
'Dwelling' product,																		
'DL' subproduct,																		
 coverage_type,																		
 coverage_map,																		
 standard_coverage,																		
 coverage,																		
 rag																		
from config_data																		
where rag='SP' and prdt_lob='Dwelling'																		
/*---------Homeowners Liability--------------*/																		
union all																		
select distinct																		
prdt_lob,																		
'Homeowners' product,																		
'HL' subproduct,																		
 coverage_type,																		
 coverage_map,																		
 standard_coverage,																		
 coverage,																		
 rag																		
from config_data																		
where rag in ('HO','SP') and prdt_lob='Homeowners'																		
/*--All Other Lines--*/																		
union all																		
select distinct																		
prdt_lob,																		
case																		
 when rag in ('AL','APD') then 'PersonalAuto'																		
 when rag in ('HO','SP') and prdt_lob='Homeowners' then 'Homeowners'																		
 when rag in ('SP') and prdt_lob='Dwelling' then 'Dwelling' 																		
 when rag in ('CM') then 'Commercial'																		
end Product,																		
'All' subproduct,																		
 coverage_type,																		
 coverage_map,																		
 standard_coverage,																		
 coverage,																		
 rag																		
from config_data																		
)																		
select distinct *																		
from																		
(																		
select *																		
from product_data																		
union all																		
select distinct																		
prdt_lob,																		
'All Products' product,																		
'All' subproduct,																		
 coverage_type,																		
 coverage_map,																		
 standard_coverage,																		
 coverage,																		
 rag																		
from product_data																		
where subproduct='All'																		
) ;																		
																		
comment on view reporting.vppd_premium_product_mapping is 'Product performance Dashboard product configuration related to earned premium, exposures and PIF. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';																		
grant select  on reporting.vppd_premium_product_mapping to report_user;																		
