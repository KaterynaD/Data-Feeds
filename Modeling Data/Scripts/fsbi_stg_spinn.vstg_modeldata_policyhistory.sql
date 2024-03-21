drop view if exists fsbi_stg_spinn.vstg_modeldata_policyhistory;	
create view fsbi_stg_spinn.vstg_modeldata_policyhistory as	
/*Mid-Term changes*/	
select 	
  cast(ph.SystemId as varchar) 	SystemId
, cast(ph.PolicyRef as varchar)	PolicyRef
, ph.TransactionNumber	
, ph.TransactionCd	
, ph.BookDt	
, ph.TransactionEffectiveDt	
, ph.ReplacedByTransactionNumber	
, ph.ReplacementOfTransactionNumber	
, ph.UnAppliedByTransactionNumber	
,'Application' cmmContainer	
from fsbi_stg_spinn.vstg_policyhistory ph	
union all	
/*Final policy state*/	
select   	
p.pol_uniqueid SystemId ,	
p.pol_uniqueid Policy_Uniqueid,  	
10000 transactionNumber,	
'Final' TransactionCd,	
case when Policy_SPINN_Status='Cancelled' then pe.CancelDt else  p.POL_EXPIRATIONDATE end BookDt,	
case when Policy_SPINN_Status='Cancelled' then pe.CancelDt else  p.POL_EXPIRATIONDATE end TransactionEffectiveDt,	
null ReplacedByTransactionNumber,	
null ReplacementOfTransactionNumber,	
null UnAppliedByTransactionNumber	,
'Policy' cmmContainer	
from  fsbi_dw_spinn.dim_policy p	
join fsbi_dw_spinn.dim_policyextension pe	
on p.policy_id=pe.policy_id 	
where p.pol_uniqueid<>'Unknown'	
and p.pol_policynumbersuffix<>'00'	
and p.pol_uniqueid<>'Unknown';	
	
COMMENT ON VIEW fsbi_stg_spinn.vstg_modeldata_policyhistory IS 'It`s a staging view based on vstg_policyhistory and fsbi_dw_spinn.dim-policy and dim_policyextension to combiney a policy term mid-term changes and final(latest ) policy term state . It`s used in Modeling data ETL.';	
COMMENT ON COLUMN fsbi_stg_spinn.vstg_modeldata_policyhistory.SystemId IS 'Approved Application SystemId which indicates mid-term policy term changes (cmmContainer=Application) or PolicyRef when cmmContainer=Policy. The data can be sorted by SystemId to get the proper order of changes in the policy term.';	
COMMENT ON COLUMN fsbi_stg_spinn.vstg_modeldata_policyhistory.PolicyRef IS 'Policy Term unique identifier. It`s based on SystemId with cmmContainer=Policy. the same as policy_uniqueid or pol_uniqueid in DW tables';	
COMMENT ON COLUMN fsbi_stg_spinn.vstg_modeldata_policyhistory.TransactionNumber is 'Transaction number associatated with the mid-term change';	
COMMENT ON COLUMN fsbi_stg_spinn.vstg_modeldata_policyhistory.TransactionCd is 'Type of transaction  associatated with the mid-term change - New Business, Renewal, Cancelation etc or Final in the final policy state.';	
COMMENT ON COLUMN fsbi_stg_spinn.vstg_modeldata_policyhistory.BookDt is 'The date when a mid-term change transaction was booked';	
COMMENT ON COLUMN fsbi_stg_spinn.vstg_modeldata_policyhistory.TransactionEffectiveDt is 'The date when a mid-term change is effective';	
COMMENT ON COLUMN fsbi_stg_spinn.vstg_modeldata_policyhistory.cmmContainer is 'Application in mid-term changes and Policy in Final policy state';	
