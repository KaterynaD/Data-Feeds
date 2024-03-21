drop view if exists fsbi_stg_spinn.vstg_auto_modeldata_drivers;							
create view fsbi_stg_spinn.vstg_auto_modeldata_drivers as							
select  							
    H.PolicyRef,							
    H.SystemId,							
    dateadd(m, H.TransactionNumber-1, H.TransactionEffectiveDt) 	ChangeDate,      						
    case 							
     when upper(di.ParentId) like '%EXCL%' then 							
		 cast(H.PolicyRef as varchar) + '_' + di.ParentId + '_'+isnull(	parti.Status,'Deleted')+'_'+cast(isnull(di.drivernumber,0) as varchar)+'_'+to_char(isnull(di.licensedt,'1900-01-01'),'yyyy-mm-dd')+'_'+to_char(isnull(birthdt,'1900-01-01'),'yyyy-mm-dd')				
     else							
         cast(H.PolicyRef as varchar)+'_'+di.ParentId+'_'+isnull(di.licensenumber,'Unknown')							
	 end 		Driver_UniqueId,				
	 isnull(	parti.Status,'Deleted') Status,					
	 isnull(	di.LicenseNumber	,	 'Unknown'	)	LicenseNumber	,
	 case when parti.PartyTypeCd = 'NonDriverParty' then isnull(	di.DriverTypeCd	,	 '~'	) else '~' end	DriverTypeCd	,
	 case when persi.BirthDt<'1900-01-01' then '1900-01-01' else isnull(persi.BirthDt,'1900-01-01') end BirthDt 	 					
from  							
  fsbi_stg_spinn.vtmp_PolicyHistory H							
  join aurora_prodcse_dw.DriverInfo di 							
  on  di.SystemId=H.SystemId							
  and di.CMMContainer=H.CMMContainer							
  left outer join aurora_prodcse_dw.PartyInfo parti  							
  on  parti.SystemId=H.SystemId							
  and parti.CMMContainer=H.CMMContainer							
  and di.ParentId = parti.id							
  and parti.PartyTypeCd in ('DriverParty','NonDriverParty'	)  						
  left outer join aurora_prodcse_dw.PersonInfo persi 							
  on persi.SystemId=H.SystemId							
  and persi.CMMContainer=H.CMMContainer							
  and persi.PersonTypeCD='ContactPersonal'							
  and persi.ParentId = di.ParentId	;						
  							
 COMMENT ON VIEW fsbi_stg_spinn.vstg_auto_modeldata_drivers IS 'Drivers unique IDs and basic info info to load Auto modeldata staging';							
 							
