drop view if exists fsbi_stg_spinn.vstg_auto_modeldata_producers;	
create view fsbi_stg_spinn.vstg_auto_modeldata_producers as	
select  distinct 	
  cast(H.PolicyRef as varchar) as policy_uniqueID,	
  H.SystemId,	
  coalesce(BOR_p.ProviderNumber,renewal_p.ProviderNumber,pr.ProviderNumber,'Unknown') producer_uniqueid	
from   fsbi_stg_spinn.vtmp_PolicyHistory H	
join aurora_prodcse_dw.basicpolicy bp on 	
	H.SystemId = bp.SystemId
    and H.CMMContainer = bp.CMMContainer	
left outer join aurora_prodcse_dw.Provider pr	
on bp.ProviderRef=pr.SystemId	
and pr.cmmContainer='Provider'	
left outer join aurora_prodcse_dw.Provider renewal_p	
on bp.RenewalProviderRef=renewal_p.SystemId	
and renewal_p.cmmContainer='Provider'	
left outer join aurora_prodcse_dw.Provider BOR_p	
on bp.BORProviderRef=BOR_p.SystemId	
and BOR_p.cmmContainer='Provider';	
	
	
 COMMENT ON VIEW fsbi_stg_spinn.vstg_auto_modeldata_producers IS 'Info of changes in producers per policy mid-term changes to load Auto modeldata staging';	
