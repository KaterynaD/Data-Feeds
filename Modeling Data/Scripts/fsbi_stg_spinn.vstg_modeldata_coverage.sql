drop view if exists fsbi_stg_spinn.vstg_modeldata_coverage;
create or replace view fsbi_stg_spinn.vstg_modeldata_coverage as
select distinct
cast(H.PolicyRef as varchar) policy_uniqueid
,c.SystemId
,c.ParentId risk_uniqueid
,c.CoverageCd
,isnull(l1.Value,'0') Limit1
,isnull(l2.Value,'0') Limit2
,isnull(d1.Value,'0') Deductible1
,isnull(d2.Value,'0') Deductible2
,isnull(c.FullTermAmt,0) FullTermAmt
from aurora_prodcse_dw.Coverage c
left outer join aurora_prodcse_dw.limit l1
on c.SystemId=l1.SystemId
and c.cmmContainer=l1.cmmContainer
and c.Id=l1.ParentId
and l1.LimitCd='Limit1'
and l1._fivetran_deleted=False
left outer join aurora_prodcse_dw.limit l2
on c.SystemId=l2.SystemId
and c.cmmContainer=l2.cmmContainer
and c.Id=l2.ParentId
and l2.LimitCd='Limit2'
and l2._fivetran_deleted=false
left outer join aurora_prodcse_dw.Deductible d1
on c.SystemId=d1.SystemId
and c.cmmContainer=d1.cmmContainer
and c.Id=d1.ParentId
and d1.DeductibleCd='Deductible1'
and d1._fivetran_deleted=False
left outer join aurora_prodcse_dw.Deductible d2
on c.SystemId=d2.SystemId
and c.cmmContainer=d2.cmmContainer
and c.Id=d2.ParentId
and d1.DeductibleCd='Deductible2'
and d2._fivetran_deleted=False
join fsbi_stg_spinn.vstg_PolicyHistory H
on H.SystemId=c.SystemId
join aurora_prodcse_dw.BasicPolicy bp
on c.SystemId=bp.SystemId
and c.cmmContainer=bp.cmmContainer
where
c.CMMContainer='Application'
and c.Status='Active'
and substring(bp.policynumber,3,1) in ('A','H','F')
and c._fivetran_deleted=False;

COMMENT ON VIEW fsbi_stg_spinn.vstg_modeldata_coverage IS 'Mid-term coverages changes for modeldata. It`s based on aurora_prodcse_dw.coverage, limit, deductible and cse_bi.vstg_PolicyHistory tables and view.';
