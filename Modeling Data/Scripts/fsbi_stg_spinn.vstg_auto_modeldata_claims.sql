drop view if exists fsbi_stg_spinn.vstg_auto_modeldata_claims;
create view fsbi_stg_spinn.vstg_auto_modeldata_claims as
with Cov as (
select 
c.coverage_id,
cov_code,
cx.act_modeldata_auto  CoverageCd
from fsbi_dw_spinn.dim_coverage c
join public.dim_coverageextension cx
on c.coverage_id=cx.coverage_id
where cx.act_modeldata_auto is not null
)
, BI_claimant_data as (
SELECT 
  fc.claimnumber,
  fc.claimant_id,
  sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd) lossinc,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=15000 then 15000 else null end lossinc15,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=25000 then 25000 else null end lossinc25,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=50000 then 50000 else null end lossinc50,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=100000 then 100000 else null end lossinc100
FROM fsbi_dw_spinn.fact_claim fc
join cov
on fc.coverage_id=cov.coverage_id
where month_id=cast(to_char(GetDate(),'yyyymm') as int)
and cov.Coveragecd='BI'
group by 
fc.claimnumber,
fc.claimant_id
)
, UMBI_claimant_data as (
SELECT 
  fc.claimnumber,
  fc.claimant_id,
  sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd) lossinc,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=15000 then 15000 else null end lossinc15,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=25000 then 25000 else null end lossinc25,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=50000 then 50000 else null end lossinc50,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=100000 then 100000 else null end lossinc100
FROM fsbi_dw_spinn.fact_claim fc
join cov
on fc.coverage_id=cov.coverage_id
where month_id=cast(to_char(GetDate(),'yyyymm') as int)
and cov.Coveragecd='UMBI'
group by 
fc.claimnumber,
fc.claimant_id
)
, UIMBI_claimant_data as (
SELECT 
  fc.claimnumber,
  fc.claimant_id,
  sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd) lossinc,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=15000 then 15000 else null end lossinc15,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=25000 then 25000 else null end lossinc25,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=50000 then 50000 else null end lossinc50,
  case when sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>=100000 then 100000 else null end lossinc100
FROM fsbi_dw_spinn.fact_claim fc
join cov
on fc.coverage_id=cov.coverage_id
where month_id=cast(to_char(GetDate(),'yyyymm') as int)
and cov.Coveragecd='UIMBI'
group by 
fc.claimnumber,
fc.claimant_id
)
, BI_claim_data as (
SELECT 
  claimnumber,
  sum(lossinc) lossinc,
  case when sum(isnull(lossinc15,lossinc))>=30000 then 30000 else sum(isnull(lossinc15,lossinc)) end lossinc1530,
  case when sum(isnull(lossinc25,lossinc))>=50000 then 50000 else sum(isnull(lossinc25,lossinc)) end lossinc2550,
  case when sum(isnull(lossinc50,lossinc))>=100000 then 100000 else sum(isnull(lossinc50,lossinc)) end lossinc50100 ,
  case when sum(isnull(lossinc100,lossinc))>=300000 then 300000 else sum(isnull(lossinc100,lossinc)) end lossinc100300
FROM BI_claimant_data
group by 
claimnumber
)
, UMBI_claim_data as (
SELECT 
  claimnumber,
  sum(lossinc) lossinc,
  case when sum(isnull(lossinc15,lossinc))>=30000 then 30000 else sum(isnull(lossinc15,lossinc)) end lossinc1530,
  case when sum(isnull(lossinc25,lossinc))>=50000 then 50000 else sum(isnull(lossinc25,lossinc)) end lossinc2550,
  case when sum(isnull(lossinc50,lossinc))>=100000 then 100000 else sum(isnull(lossinc50,lossinc)) end lossinc50100 ,
  case when sum(isnull(lossinc100,lossinc))>=300000 then 300000 else sum(isnull(lossinc100,lossinc)) end lossinc100300
FROM UMBI_claimant_data
group by 
claimnumber
)
, UIMBI_claim_data as (
SELECT 
  claimnumber,
  sum(lossinc) lossinc,
  case when sum(isnull(lossinc15,lossinc))>=30000 then 30000 else sum(isnull(lossinc15,lossinc)) end lossinc1530,
  case when sum(isnull(lossinc25,lossinc))>=50000 then 50000 else sum(isnull(lossinc25,lossinc)) end lossinc2550,
  case when sum(isnull(lossinc50,lossinc))>=100000 then 100000 else sum(isnull(lossinc50,lossinc)) end lossinc50100 ,
  case when sum(isnull(lossinc100,lossinc))>=300000 then 300000 else sum(isnull(lossinc100,lossinc)) end lossinc100300
FROM UIMBI_claimant_data
group by 
claimnumber
)
, raw_data as (
SELECT 
  fc.claimnumber,
  fc.primaryrisk_id claimrisk_id,
  cr.clrsk_lossdate lossdate,
  cr.policy_id,
  cr.policy_uniqueid,
  p.pol_effectivedate effectivedate,
  p.pol_expirationdate expirationdate,
  p.pol_policynumber policynumber,
  case when ce.clm_catcode='~' then 'N' else 'Y' end CatFlg,
  ce.losscausecd,
  ce.AtFaultcd,
  cov.Coveragecd,
  sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd) lossinc,
  sum(fc.ualc_exp_pd_amt_itd + fc.ualc_exp_rsrv_chng_amt_itd) dcce
FROM fsbi_dw_spinn.fact_claim fc
join cov
on fc.coverage_id=cov.coverage_id
join fsbi_dw_spinn.dim_claimextension ce
on fc.claimextension_id=ce.claimextension_id
join fsbi_dw_spinn.dim_claimrisk cr
on cr.claimrisk_id=fc.primaryrisk_id
join fsbi_dw_spinn.dim_policy p 
on p.policy_id=cr.policy_id
where month_id=cast(to_char(GetDate(),'yyyymm') as int)
and cr.clrsk_lossdate<=DATEADD(month, -2, GetDate())
group by 
fc.claimnumber,
fc.primaryrisk_id,
cr.policy_id,
cr.policy_uniqueid,
p.pol_effectivedate,
p.pol_expirationdate,
p.pol_policynumber,
case when ce.clm_catcode='~' then 'N' else 'Y' end,
losscausecd,
AtFaultcd,
cov.Coveragecd,
cr.clrsk_lossdate
having sum(fc.loss_pd_amt_itd + fc.loss_rsrv_chng_amt_itd - fc.subro_recv_chng_amt_itd - fc.salvage_recv_chng_amt_itd)>0 or
sum(fc.ualc_exp_pd_amt_itd + fc.ualc_exp_rsrv_chng_amt_itd)>0
)
select data.* 
,isnull(BI_claim_data.lossinc1530,0) BIlossinc1530
,isnull(BI_claim_data.lossinc2550,0) BIlossinc2550
,isnull(BI_claim_data.lossinc50100,0) BIlossinc50100
,isnull(BI_claim_data.lossinc100300,0) BIlossinc100300
 --
,isnull(UMBI_claim_data.lossinc1530,0) UMBIlossinc1530
,isnull(UMBI_claim_data.lossinc2550,0) UMBIlossinc2550
,isnull(UMBI_claim_data.lossinc50100,0) UMBIlossinc50100
,isnull(UMBI_claim_data.lossinc100300,0) UMBIlossinc100300
 --
,isnull(UIMBI_claim_data.lossinc1530,0) UIMBIlossinc1530
,isnull(UIMBI_claim_data.lossinc2550,0) UIMBIlossinc2550
,isnull(UIMBI_claim_data.lossinc50100,0) UIMBIlossinc50100
,isnull(UIMBI_claim_data.lossinc100300,0) UIMBIlossinc100300
from raw_data as data
left outer join BI_claim_data
on data.claimnumber=BI_claim_data.claimnumber
left outer join UMBI_claim_data
on data.claimnumber=UMBI_claim_data.claimnumber
left outer join UIMBI_claim_data
on data.claimnumber=UIMBI_claim_data.claimnumber;


COMMENT ON VIEW fsbi_stg_spinn.vstg_auto_modeldata_claims IS 'Most recent claims staging data for Auto modeling data based on fsbi_dw_spinn.fact_claim and other dimensions. Some preliminary claims losses capping happens in this view.';
