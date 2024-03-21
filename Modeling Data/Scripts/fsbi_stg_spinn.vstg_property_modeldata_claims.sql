drop view if exists fsbi_stg_spinn.vstg_property_modeldata_claims;	
create view fsbi_stg_spinn.vstg_property_modeldata_claims as	
with raw_data as (	
SELECT 	
  fc.claimnumber,	
  cr.clrsk_lossdate lossdate,	
  fc.primaryrisk_id claimrisk_id,	
  cr.policy_id,	
  cr.policy_uniqueid,	
  p.pol_effectivedate effectivedate,	
  p.pol_expirationdate expirationdate,	
  p.pol_policynumber policynumber,	
  case when ce.clm_catcode='~' then 'No' else 'Yes' end CatFlg,	
  ce.losscausecd,	
  cov.cov_code Coveragecd,	
  cove.act_modeldata_ho_ll_claims CovGroup,	
  /* ------ CovA - CovF losses	--------*/
  sum(case when cove.act_modeldata_ho_ll_claims is not null then  fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd else 0 end) lossinc,	
  sum(case when cove.act_modeldata_ho_ll_claims is not null then  fc.ualc_exp_pd_amt_itd + fc.ualc_exp_rsrv_chng_amt_itd else 0 end) dcce,	
  sum(case when cove.act_modeldata_ho_ll_claims is not null then  fc.alc_exp_pd_amt_itd + fc.alc_exp_rsrv_chng_amt_itd else 0 end) alae,	
  /* ------ All Coverages losses ------*/	
  sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd) all_lossinc,	
  sum(fc.ualc_exp_pd_amt_itd + fc.ualc_exp_rsrv_chng_amt_itd) all_dcce,	
  sum(fc.alc_exp_pd_amt_itd + fc.alc_exp_rsrv_chng_amt_itd) all_alae	
FROM fsbi_dw_spinn.fact_claim fc	
join fsbi_dw_spinn.dim_coverage cov	
on fc.coverage_id=cov.coverage_id	
join public.dim_coverageextension cove	
on fc.coverage_id=cove.coverage_id	
join fsbi_dw_spinn.dim_claimextension ce	
on fc.claimextension_id=ce.claimextension_id	
join fsbi_dw_spinn.dim_claimrisk cr	
on cr.claimrisk_id=fc.primaryrisk_id	
join fsbi_dw_spinn.dim_policy p /*join via dim_claimrisk because can be different policy_uniqueid in fact tables*/	
on p.policy_id=cr.policy_id	
join fsbi_dw_spinn.dim_product pr	
on pr.product_id=fc.product_id	
where month_id=cast(to_char(GetDate(),'yyyymm') as int)	
and pr.prdt_lob in ('Dwelling','Homeowners')	
and cr.clrsk_lossdate<=DATEADD(month, -3, GetDate())	
group by 	
fc.claimnumber,	
cr.clrsk_lossdate,	
fc.primaryrisk_id,	
cr.policy_id,	
cr.policy_uniqueid,	
p.pol_effectivedate,	
p.pol_expirationdate,	
p.pol_policynumber,	
case when ce.clm_catcode='~' then 'No' else 'Yes' end,	
losscausecd,	
cov.cov_code	,
cove.act_modeldata_ho_ll_claims	
)	
,data as (	
select	
claimnumber,	
claimrisk_id,	
lossdate,	
policy_id,	
policy_uniqueid,	
effectivedate,	
expirationdate,	
policynumber,	
CatFlg,	
losscausecd,	
 --	
max(case when 	CoverageCd='CovA-FL' then 1 else 0 end) CovA_FL,
max(case when 	CoverageCd='CovA-SF' then 1 else 0 end) CovA_SF,
max(case when 	CoverageCd='CovA-EC' then 1 else 0 end) CovA_EC ,
max(case when 	CoverageCd='CovC-FL' then 1 else 0 end) CovC_FL,
max(case when 	CoverageCd='CovC-SF' then 1 else 0 end) CovC_SF,
max(case when 	CoverageCd='CovC-EC' then 1 else 0 end) CovC_EC ,
 --	
sum(case when CovGroup='CovA' then lossinc else 0.0 end) CovA_inc_loss,	
sum(case when CovGroup='CovB' then lossinc else 0.0 end) CovB_inc_loss,	
sum(case when CovGroup='CovC' then lossinc else 0.0 end) CovC_inc_loss,	
sum(case when CovGroup='CovD' then lossinc else 0.0 end) CovD_inc_loss,	
sum(case when CovGroup='CovE' then lossinc else 0.0 end) CovE_inc_loss,	
sum(case when CovGroup='CovF' then lossinc else 0.0 end) CovF_inc_loss,	
sum(case when CovGroup='LIAB' then lossinc else 0.0 end) LIAB_inc_loss,	
 --	
sum(case when CovGroup='CovA' then dcce else 0.0 end) CovA_dcce,	
sum(case when CovGroup='CovB' then dcce else 0.0 end) CovB_dcce,	
sum(case when CovGroup='CovC' then dcce else 0.0 end) CovC_dcce,	
sum(case when CovGroup='CovD' then dcce else 0.0 end) CovD_dcce,	
sum(case when CovGroup='CovE' then dcce else 0.0 end) CovE_dcce,	
sum(case when CovGroup='CovF' then dcce else 0.0 end) CovF_dcce,	
sum(case when CovGroup='LIAB' then dcce else 0.0 end) LIAB_dcce,	
 --	
sum(case when CovGroup='CovA' then alae else 0.0 end) CovA_alae,	
sum(case when CovGroup='CovB' then alae else 0.0 end) CovB_alae,	
sum(case when CovGroup='CovC' then alae else 0.0 end) CovC_alae,	
sum(case when CovGroup='CovD' then alae else 0.0 end) CovD_alae,	
sum(case when CovGroup='CovE' then alae else 0.0 end) CovE_alae,	
sum(case when CovGroup='CovF' then alae else 0.0 end) CovF_alae,	
sum(case when CovGroup='LIAB' then alae else 0.0 end) LIAB_alae,	
sum(all_lossinc) all_lossinc,	
sum(all_dcce) all_dcce,	
sum(all_alae) all_alae	
from raw_data	
group by 	
claimnumber,	
claimrisk_id,	
lossdate,	
policy_id,	
policy_uniqueid,	
effectivedate,	
expirationdate,	
policynumber,	
CatFlg,	
losscausecd	
having 	
sum(case when CovGroup='CovA' then lossinc else 0.0 end) >0 or	
sum(case when CovGroup='CovB' then lossinc else 0.0 end)  >0 or	
sum(case when CovGroup='CovC' then lossinc else 0.0 end)  >0 or	
sum(case when CovGroup='CovD' then lossinc else 0.0 end)  >0 or	
sum(case when CovGroup='CovE' then lossinc else 0.0 end)  >0 or	
sum(case when CovGroup='CovF' then lossinc else 0.0 end)  >0 or	
sum(case when CovGroup='LIAB' then lossinc else 0.0 end)  >0 or	
 --	
sum(case when CovGroup='CovA' then dcce else 0.0 end)  >0 or	
sum(case when CovGroup='CovB' then dcce else 0.0 end)  >0 or	
sum(case when CovGroup='CovC' then dcce else 0.0 end)  >0 or	
sum(case when CovGroup='CovD' then dcce else 0.0 end)  >0 or	
sum(case when CovGroup='CovE' then dcce else 0.0 end)  >0 or	
sum(case when CovGroup='CovF' then dcce else 0.0 end)  >0 or	
sum(case when CovGroup='LIAB' then dcce else 0.0 end)  >0 or	
 --	
sum(case when CovGroup='CovA' then alae else 0.0 end)  >0 or	
sum(case when CovGroup='CovB' then alae else 0.0 end)  >0 or	
sum(case when CovGroup='CovC' then alae else 0.0 end)  >0 or	
sum(case when CovGroup='CovD' then alae else 0.0 end)  >0 or	
sum(case when CovGroup='CovE' then alae else 0.0 end)  >0 or	
sum(case when CovGroup='CovF' then alae else 0.0 end)  >0 or	
sum(case when CovGroup='LIAB' then alae else 0.0 end)  >0	
)	
select 	
data.* ,	
case 	
 when CatFlg='No' and losscausecd in ('Flood','Water Backup','Water Damage','Water Discharge') then 'Yes'	
 else 'No'	
end NC_Water ,	
case 	
 when CatFlg='No' and losscausecd in ('Hail','Windstorm') then 'Yes'	
 else 'No'	
end NC_WH ,	
case 	
 when CatFlg='No' and losscausecd in ('Theft','Theft From Unattended Auto','Vandalism Malicious Mischief') then 'Yes'	
 else 'No'	
end NC_TV ,	
case 	
 when CatFlg='No' and losscausecd in ('Fire','Lightning','Smoke') then 'Yes'	
 else 'No'	
end NC_FL ,	
case 	
 when CatFlg='No' and losscausecd NOT in ('Flood','Water Backup','Water Damage','Water Discharge', 'Hail','Windstorm', 'Theft','Theft From Unattended Auto','Vandalism Malicious Mischief','Fire','Lightning','Smoke') then 'Yes'	
 else 'No'	
end NC_AO ,	
case 	
 when CatFlg='Yes' and losscausecd in ('Fire','Lightning','Smoke') then 'Yes'	
 else 'No'	
end CAT_FL ,	
case 	
 when CatFlg='Yes' and losscausecd NOT in ('Fire','Lightning','Smoke') then 'Yes'	
 else 'No'	
end CAT_AO	
from data;	
	
COMMENT ON VIEW fsbi_stg_spinn.vstg_property_modeldata_claims IS 'Claims staging data for Homeowners and Dwelling modeling data based on fsbi_dw_spinn.fact_claim and other claims related dimensions. Claims losses and expenses are categorized by feature groups, loss causes and catastrophies flag,';	
