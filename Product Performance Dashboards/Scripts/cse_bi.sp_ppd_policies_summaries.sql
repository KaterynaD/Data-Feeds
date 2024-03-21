CREATE OR REPLACE PROCEDURE cse_bi.sp_ppd_policies_summaries(ploaddate timestamp)	
	LANGUAGE plpgsql
AS $$	
	
DECLARE 	
months RECORD;	
BEGIN	
FOR months IN 	
 select distinct 	
 month_id 	
 from fsbi_stg_spinn.fact_policy	
 order by month_id	
LOOP	
delete from reporting.ppd_policies_summaries	
where month_id=months.month_id;	
	
insert into reporting.ppd_policies_summaries	
with 	
/*-----EXPOSURES------*/	
/*----1.Not Auto PD---*/	
data_other as (	
select	
p.prdt_lob as product,	
f.month_id,	
po.pol_masterstate policy_state,	
co.comp_name1 carrier,	
co.comp_number  company,	
f.policyneworrenewal,	
sum(case	
 when c.cov_code in ('F.30005B','F.31580A') then round(ee_rm/12,3) /*Umbrella*/	
 when pe.AltSubTypeCd='PB' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*Boatowners - boats - CovA and Trailers covC*/	
 when pe.AltSubTypeCd='EQ' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*In Earthquake policies if there are both CovA and CovC, then CovC do not have exposures*/	
 when pe.AltSubTypeCd = 'DF3' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode<>'WF-DWELL') then round(ee_rm/12,3) 	
 when pe.AltSubTypeCd = 'HO3-Homeguard' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode='EXWF-DWELL') then round(ee_rm/12,3)	
 when pe.AltSubTypeCd in ('DF6','DF1', 'FL1-Basic', 'FL1-Vacant', 'FL2-Broad', 'FL3-Special', 'Form3', 'HO3') and (c.cov_subline in ('410','402') and ce.covx_code='CovA') then round(ee_rm/12,3)	
 when pe.AltSubTypeCd in ('HO4', 'HO6') and ce.covx_code='CovC' then round(ee_rm/12,3)	
 when ce.covx_code = 'BI' then round(ee_rm/12,3)	
else 0	
end) EE	
from fsbi_dw_spinn.fact_policycoverage f	
join fsbi_dw_spinn.dim_coverage c	
on f.coverage_id=c.coverage_id	
join public.dim_coverageextension ce	
on c.coverage_id=ce.coverage_id	
join fsbi_dw_spinn.dim_product p	
on p.product_id=f.product_id	
join fsbi_dw_spinn.dim_policyextension pe	
on f.policy_id=pe.policy_id	
join fsbi_dw_spinn.dim_policy po	
on po.policy_id=f.policy_id	
join fsbi_dw_spinn.vdim_company co	
on f.company_id=co.company_id	
where f.month_id>=201201	
and ce.covx_code not in ( 'COLL', 'COMP')	
and f.month_id=months.month_id	
group by 	
p.prdt_lob,	
f.month_id,	
po.pol_masterstate,	
co.comp_name1,	
co.comp_number,	
f.policyneworrenewal	
having  sum(case	
 when c.cov_code in ('F.30005B','F.31580A') then round(ee_rm/12,3) /*Umbrella*/	
 when pe.AltSubTypeCd='PB' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*Boatowners - boats - CovA and Trailers covC*/	
 when pe.AltSubTypeCd='EQ' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*In Earthquake policies if there are both CovA and CovC, then CovC do not have exposures*/	
 when pe.AltSubTypeCd = 'DF3' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode<>'WF-DWELL') then round(ee_rm/12,3) 	
 when pe.AltSubTypeCd = 'HO3-Homeguard' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode='EXWF-DWELL') then round(ee_rm/12,3)	
 when pe.AltSubTypeCd in ('DF6','DF1', 'FL1-Basic', 'FL1-Vacant', 'FL2-Broad', 'FL3-Special', 'Form3', 'HO3') and (c.cov_subline in ('410','402') and ce.covx_code='CovA') then round(ee_rm/12,3)	
 when pe.AltSubTypeCd in ('HO4', 'HO6') and ce.covx_code='CovC' then round(ee_rm/12,3)	
 when ce.covx_code = 'BI' then round(ee_rm/12,3)	
else 0	
end)<>0	
)	
/*--------Auto PD which is COMP or COLL------*/	
,data_coll as (	
select	
f.month_id,	
po.pol_masterstate policy_state,	
co.comp_name1 carrier,	
co.comp_number  company,	
f.policyneworrenewal,	
f.policy_id,	
v.vehidentificationnumber vin,	
v.vehnumber RiskCd,	
sum(round(ee_rm/12,3)) EE	
from fsbi_dw_spinn.fact_policycoverage f	
join fsbi_dw_spinn.dim_coverage c	
on f.coverage_id=c.coverage_id	
join public.dim_coverageextension cx	
on c.coverage_id=cx.coverage_id	
join fsbi_dw_spinn.dim_vehicle v	
on f.vehicle_id=v.vehicle_id	
join fsbi_dw_spinn.dim_policy po	
on po.policy_id=f.policy_id	
join fsbi_dw_spinn.vdim_company co	
on f.company_id=co.company_id	
where cx.covx_code = 'COLL'	
and f.month_id=months.month_id	
group by 	
f.month_id,	
f.policy_id,	
po.pol_masterstate,	
co.comp_name1,	
co.comp_number,	
f.policyneworrenewal,	
v.vehidentificationnumber,	
v.vehnumber	
having  sum(round(ee_rm/12,3))<>0	
)	
,data_comp as (	
select	
f.month_id,	
f.policy_id,	
po.pol_masterstate policy_state,	
co.comp_name1 carrier,	
co.comp_number  company,	
f.policyneworrenewal,	
v.vehidentificationnumber vin,	
v.vehnumber RiskCd,	
sum(round(ee_rm/12,3)) EE	
from fsbi_dw_spinn.fact_policycoverage f	
join fsbi_dw_spinn.dim_coverage c	
on f.coverage_id=c.coverage_id	
join public.dim_coverageextension cx	
on c.coverage_id=cx.coverage_id	
join fsbi_dw_spinn.dim_vehicle v	
on f.vehicle_id=v.vehicle_id	
join fsbi_dw_spinn.dim_policy po	
on po.policy_id=f.policy_id	
join fsbi_dw_spinn.vdim_company co	
on f.company_id=co.company_id	
where  cx.covx_code = 'COMP'	
and f.month_id=months.month_id	
group by 	
f.month_id,	
po.pol_masterstate,	
co.comp_name1,	
co.comp_number,	
f.policyneworrenewal,	
f.policy_id,	
v.vehidentificationnumber,	
v.vehnumber	
having  sum(round(ee_rm/12,3))<>0	
)	
,data_pd as (select	
coalesce(data_comp.month_id, data_coll.month_id) month_id,	
coalesce(data_comp.policy_state, data_coll.policy_state) policy_state,	
coalesce(data_comp.carrier, data_coll.carrier) carrier,	
coalesce(data_comp.company, data_coll.company) company,	
coalesce(data_comp.policyneworrenewal, data_coll.policyneworrenewal) policyneworrenewal,	
sum(case when data_comp.EE is null then isnull(data_coll.EE,0) else isnull(data_comp.EE,0) end) EE	
from data_comp	
full outer join data_coll	
on data_comp.month_id=data_coll.month_id	
and data_comp.policy_id=data_coll.policy_id	
and data_comp.vin=data_coll.vin	
and data_comp.riskcd=data_coll.riskcd	
group by 	
coalesce(data_comp.month_id, data_coll.month_id),	
coalesce(data_comp.policy_state, data_coll.policy_state),	
coalesce(data_comp.carrier, data_coll.carrier),	
coalesce(data_comp.company, data_coll.company),	
coalesce(data_comp.policyneworrenewal, data_coll.policyneworrenewal)	
) 	
/*-------- Earned Premium and PIF-------------*/	
,data as (	
select	
p.prdt_lob as product,	
f.month_id,	
po.pol_masterstate policy_state,	
co.comp_name1 carrier,	
co.comp_number  company,	
f.policyneworrenewal,	
pe.policyformcode,	
left(cx.coveragetype,1) as coverage_type,	
cx.act_rag  as rag,	
cx.covx_code as coverage,	
isnull(cx.act_map,'~') as coverage_map,	
sum(earned_prem_amt)   EP,	
case when s.polst_statuscd = 'INF' and sum(f.term_prem_amt_itd)>0 then po.pol_policynumber else null end PIF	
from fsbi_dw_spinn.fact_policycoverage f	
join fsbi_dw_spinn.dim_coverage c	
on f.coverage_id=c.coverage_id	
join public.dim_coverageextension cx	
on c.coverage_id=cx.coverage_id	
join fsbi_dw_spinn.dim_product p	
on f.product_id = p.product_id	
join fsbi_dw_spinn.vdim_policystatus s	
on f.policystatus_id = s.policystatus_id	
join fsbi_dw_spinn.dim_policy po	
on po.policy_id=f.policy_id	
join fsbi_dw_spinn.dim_policyextension pe	
on f.policy_id=pe.policy_id	
join fsbi_dw_spinn.vdim_company co	
on f.company_id=co.company_id	
where  cx.covx_code not like '%Fee%'	
and f.month_id=months.month_id	
group by p.prdt_lob,	
pe.policyformcode,	
left(cx.coveragetype,1),	
cx.act_rag,	
cx.covx_code,	
cx.act_map,	
f.month_id,	
po.pol_masterstate,	
co.comp_name1,	
co.comp_number,	
f.policyneworrenewal,	
s.polst_statuscd,	
po.pol_policynumber	
having  (sum(earned_prem_amt)<>0 or sum(case when cx.covx_code='BI' then round(ee_rm/12,3) else 0 end)<>0)	
)	
, mapping as 	
 (select 	
  distinct 	
  prdt_lob,	
  isnull(product,'~') product, 	
  subproduct, 	
  coverage_map, 	
  coverage_type, 	
  rag 	
  from reporting.vppd_premium_product_mapping	
  where isnull(product,'~')<>'All Products'	
  ) 	
/*------------------FINAL-------------------*/	
,product_data as 	
(	
select	
isnull(m.product,'~') product,	
isnull(m.subproduct,'~') subproduct,	
data.month_id,	
data.policy_state,	
data.carrier,	
data.company,	
data.policyneworrenewal,	
sum(EP)   EP,	
max(case when isnull(m.product,'~')='~' then 0 when data.rag<>'APD' then data_other.EE else data_pd.EE end) EE,	
count(distinct PIF) PIF	
from data	
left outer join data_other	
on isnull(data.product,'~')=isnull(data_other.product,'~')	
and data.month_id=data_other.month_id	
and data.policyneworrenewal=data_other.policyneworrenewal	
and data.policy_state=data_other.policy_state	
and data.company=data_other.company	
and data.carrier=data_other.carrier	
left outer join data_pd	
on data.month_id=data_pd.month_id	
and data.policyneworrenewal=data_pd.policyneworrenewal	
and data.policy_state=data_pd.policy_state	
and data.company=data_pd.company	
and data.carrier=data_pd.carrier	
join mapping m	
on data.coverage_map=m.coverage_map	
and data.coverage_type=m.coverage_type	
and data.rag=m.rag	
and data.product=m.prdt_lob	
group by	
m.product,	
m.subproduct,	
data.month_id,	
data.policy_state,	
data.carrier,	
data.company,	
data.policyneworrenewal	
)	
select *	
,pLoadDate LoadDate	
from (	
select *	
from product_data	
union all	
select	
'All Products' product,	
'All' subproduct,	
month_id,	
policy_state,	
carrier,	
company,	
policyneworrenewal,	
sum(EP)   EP,	
sum(EE) EE,	
sum(PIF) PIF	
from product_data	
where subproduct='All'	
group by	
month_id,	
policy_state,	
carrier,	
company,	
policyneworrenewal	
) d;	
	
	
	
	
	
END LOOP;	
END;	
	
$$	
;	
