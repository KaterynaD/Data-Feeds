drop view if exists  fsbi_stg_spinn.vstg_property_modeldata_coverage;
create view fsbi_stg_spinn.vstg_property_modeldata_coverage as
with cov_dict as (select distinct 
c.cov_code,
act_modeldata_ho_ll
from fsbi_dw_spinn.dim_coverage c
join public.dim_coverageextension cx
on c.coverage_id=cx.coverage_id
where cx.act_modeldata_ho_ll is not null)
select 
stg.Policy_Uniqueid,
stg.SystemId,
stg.Risk_Uniqueid,
max(stg.Limit1) Limit1,
max(stg.Limit2) Limit2,
max(stg.Deductible1) Deductible1,
max(stg.Deductible2) Deductible2,
sum(stg.FullTermAmt) FullTermAmt,
c.act_modeldata_ho_ll act_modeldata
from fsbi_stg_spinn.vstg_modeldata_coverage stg
join cov_dict c
on stg.coveragecd=c.COV_CODE
join fsbi_dw_spinn.dim_policy p
on stg.Policy_Uniqueid=p.pol_uniqueid
and substring(p.pol_policynumber,3,1) in ('H','F')
group by 
stg.Policy_Uniqueid,
stg.SystemId,
stg.Risk_Uniqueid,
c.act_modeldata_ho_ll;


COMMENT ON VIEW fsbi_stg_spinn.vstg_property_modeldata_coverage IS 'Staging view specifically for property (Homeowners and Dwelling) modeldata vbased on fsbi_stg_spinn..vstg_modeldata_coverage view, coverage configuration in public.dim_coverageextension and other dimensional tables in fsbi_dw_spinn. The purpose of the view to exclude duplicates if any in mid-term coverage changes. The duplicates may happened due to issues in a daily job shreding XML to database tables. It also standartizes and aggregates  coverages for property modeldata.';
