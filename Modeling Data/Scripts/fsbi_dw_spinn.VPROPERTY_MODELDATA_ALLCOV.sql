drop view if exists fsbi_dw_spinn.VPROPERTY_MODELDATA_ALLCOV;		
create or replace view fsbi_dw_spinn.VPROPERTY_MODELDATA_ALLCOV as 		
SELECT  modeldata_id		
       , systemidstart		
       , systemidend		
       , cast(date_part(year, startdate) as int) cal_year		
       , startdate		
       , case when enddate > dateadd(month, -3, current_date) then dateadd(month, -3, current_date) else  enddate end   enddate		
       , startdatetm		
       , enddatetm		
       , DateDiff(d, startdate, case when enddate > dateadd(month, -3, current_date) then dateadd(month, -3, current_date) else  enddate end)/365.25  ehy		
       , case when pe.renewaltermcd='1 Year' then 1 else 2 end * CovA_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -3, current_date) then dateadd(month, -3, current_date) else  enddate end)/365.25) CovA_ep		
       , case when pe.renewaltermcd='1 Year' then 1 else 2 end * CovB_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -3, current_date) then dateadd(month, -3, current_date) else  enddate end)/365.25) CovB_ep		
       , case when pe.renewaltermcd='1 Year' then 1 else 2 end * CovC_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -3, current_date) then dateadd(month, -3, current_date) else  enddate end)/365.25) CovC_ep		
       , case when pe.renewaltermcd='1 Year' then 1 else 2 end * CovD_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -3, current_date) then dateadd(month, -3, current_date) else  enddate end)/365.25) CovD_ep		
       , case when pe.renewaltermcd='1 Year' then 1 else 2 end * CovE_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -3, current_date) then dateadd(month, -3, current_date) else  enddate end)/365.25) CovE_ep		
       , case when pe.renewaltermcd='1 Year' then 1 else 2 end * CovF_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -3, current_date) then dateadd(month, -3, current_date) else  enddate end)/365.25) CovF_ep		
/*------------------------------------------POLICY DATA---------------------------------*/	   	
       , pol_policynumber PolicyNumber		
       , f.policy_uniqueid 		
       , pe.InceptionDt		
       , p.POL_POLICYNUMBERSUFFIX PolicyTerm		
       , case when  p.POL_POLICYNUMBERSUFFIX='01' then 'New' else 'Renewal' end PolicyType		
       , p.pol_effectivedate effectivedate		
       , p.pol_expirationdate expirationdate		
       , p.POL_MASTERSTATE PolicyState		   
       , pe.PolicyFormCode PolicyForm		
       , pe.PersistencyDiscountDt		
       , case when pe.persistencydiscountdt>'1900-01-01' then cast( datediff(month,pe.persistencydiscountdt, p.pol_effectivedate)/12 as int)else 0 end  Persistency		
       , co.comp_number CompanyCd		
       , co.comp_name1 CarrierCd		
       , pe.installmentfee		
       , pe.nsffee		
       , pe.latefee		
       , pc.ProgramInd		
       , b.employeecreditind CSEEmployeeDiscountInd		
       , pc.liabilitylimitolt 		
       , pc.liabilitylimitcpl		
	   , upper(replace(pc.personalinjuryind,'~','No')) personalinjuryind	
/*---------------------------------------END POLICY DATA---------------------------------*/	 	
/*-------------------------------------- Agency  DATA   --------------------------------*/		
       , a.prdr_number producercode		
       , a.prdr_name1 producername		
       , a.prdr_address1 produceraddress		
       , a.prdr_city producercity 		
       , a.prdr_state producerstate		
       , a.prdr_zipcode producerpostalcode		
       , a.producer_status		
       , a.territory		
/*-------------------------------------- END Agency  DATA   --------------------------------*/		   
       , risk_uniqueid		
       , risknumber		
       , risktype		
       , b.StateProvCd State		
       , b.County		
       , b.PostalCode		
       , b.City		
       , b.Addr1		
       , b.Addr2		
/*------------------------------------------BUILDING DATA---------------------------------*/	   	
       , f.building_uniqueid		
       , YearBuilt 		
       , SqFt 		
       , Stories 		
       , RoofCd 		
       , case when risktype='Homeowners' then NumberOfFamilies else OwnerOccupiedUnits + TenantOccupiedUnits end Units 		
       , OccupancyCd 		
       , AllperilDed 		
       , waterded 		
       , ProtectionClass 		
       , ConstructionCd 		
       , ReportedFireLineAssessment 		
       , FireHazardScore 		
       , ReportedFireHazardScore 		
       , upper(replace(pc.MultiPolicyAutoDiscount,'~','No'))  MultiPolicyInd		
       , pc.MultiPolicyAutoNumber MultiPolicyNumber 		
       , upper(replace(pc.MultiPolicyUmbrellaDiscount,'~','No'))  MultiPolicyIndUmbrella		
       , pc.UmbrellaRelatedPolicyNumber MultiPolicyNumberUmbrella 		
       , upper(replace(earthquakeumbrellaind,'~','No'))  earthquakeumbrellaind		
       , UsageType 		
       , CovADDRR_SecondaryResidence SecondaryResidence		
       , OrdinanceOrLawPct 		
       , FunctionalReplacementCost 		
       , upper(replace(homegardcreditind,'~','No'))  homegardcreditind		
       , upper(replace(sprinklersystem,'~','No'))  sprinklersystem		
       , upper(replace(pc.LandlordInd,'~','No'))  landlordind		
       , upper(replace(cseagent,'~','No'))  cseagent		
       , upper(replace(rentersinsurance,'~','No'))  RentersInsurance		
       , upper(replace(FireAlarmType,'~','No'))  FireAlarmType		
       , upper(replace(BurglaryAlarmType,'~','No'))  BurglaryAlarmType		
       , upper(replace(WaterDetectionDevice,'~','No'))  WaterDetectionDevice		
       , upper(replace(NeighborhoodCrimeWatchInd,'~','No'))  NeighborhoodCrimeWatchInd		
       , upper(replace(PropertyManager,'~','No'))  PropertyManager		
       , upper(replace(SafeguardPlusInd,'~','No'))  SafeguardPlusInd		
       , upper(replace(HODeluxe,'~','No'))  DeluxePackageInd		
       , RatingTier 		
       , WUICLASS		
	   , upper(replace(kitchenfireextinguisherind,'~','No')) kitchenfireextinguisherind	
	   , upper(replace(smokedetector,'~','No')) smokedetector	
	   , upper(replace(gatedcommunityind,'~','No')) gatedcommunityind	
	   , upper(replace(deadboltind,'~','No')) deadboltind	
	   , upper(replace(poolind,'~','No')) poolind	
	   , upper(replace(ReplacementCostDwellingInd,'~','No')) ReplacementCostDwellingInd	
	   , upper(replace(replacementvalueind,'~','No')) replacementvalueind	
	   , upper(replace(serviceline,'~','No')) serviceline	
	   , upper(replace(equipmentbreakdown,'~','No')) equipmentbreakdown	
	   , upper(replace(tenantevictions,'~','No')) tenantevictions	
	   , lossassessment	
	   , numberoffamilies	   
/*------------------------------------------END BUILDING DATA---------------------------------*/		
/*----------------------------------          INSURED DATA      ------------------------------*/		
       , substring(i.fullname,1,CHARINDEX(' ',i.fullname))  InsuredFirstName		
       , substring(i.fullname,CHARINDEX(' ',i.fullname)+1,len(i.fullname)) InsuredLastName		
       , case when i.dob = '1900-01-01' then null else i.dob end InsuredDOB		
       , case when i.dob = '1900-01-01' then null else DateDiff(y,  i.dob,p.pol_EffectiveDate)  end InsuredAge		
	   , i.maritalstatus	
       , i.InsuranceScore		
       , i.OverriddenInsuranceScore		
       , i.InsuranceScoreValue		
       , i.ratepageeffectivedt		
       , i.insscoretiervalueband		
       , i.applieddt		
       , i.financialstabilitytier		
/*----------------------------------      END     INSURED DATA      ------------------------------*/       		
       , AllCov_WP		
       , AllCov_LossInc		
       , AllCov_LossDCCE		
       , AllCov_LossALAE		
       , CovA_WP		
       , CovB_WP		
       , CovC_WP		
       , CovD_WP		
       , CovE_WP		
       , CovF_WP		
       , cova_deductible		
       , covb_deductible		
       , covc_deductible		
       , covd_deductible		
       , cove_deductible		
       , covf_deductible		
       , cova_limit		
       , covb_limit		
       , covc_limit		
       , b.covclimit CovCIncreasedLimit		
       , covd_limit		
       , cove_limit		
       , covf_limit		
       , OnPremises_Theft_Limit		
       , AwayFromPremises_Theft_Limit		
       , quality_polappinconsistency_flg		
       , quality_riskidduplicates_flg		
       , quality_claimok_flg		
       , quality_claimpolicytermjoin_flg		
       , CovABCDEFLIAB_loss		
       , CovABCDEFLIAB_claim_count		
       , Cat_CovABCDEFLIAB_loss		
       , Cat_CovABCDEFLIAB_claim_count		
       , cova_il_nc_water		
       , cova_il_nc_wh		
       , cova_il_nc_tv		
       , cova_il_nc_fl		
       , cova_il_nc_ao		
       , cova_il_cat_fire		
       , cova_il_cat_ao		
       , covb_il_nc_water		
       , covb_il_nc_wh		
       , covb_il_nc_tv		
       , covb_il_nc_fl		
       , covb_il_nc_ao		
       , covb_il_cat_fire		
       , covb_il_cat_ao		
       , covc_il_nc_water		
       , covc_il_nc_wh		
       , covc_il_nc_tv		
       , covc_il_nc_fl		
       , covc_il_nc_ao		
       , covc_il_cat_fire		
       , covc_il_cat_ao		
       , covd_il_nc_water		
       , covd_il_nc_wh		
       , covd_il_nc_tv		
       , covd_il_nc_fl		
       , covd_il_nc_ao		
       , covd_il_cat_fire		
       , covd_il_cat_ao		
       , cove_il_nc_water		
       , cove_il_nc_wh		
       , cove_il_nc_tv		
       , cove_il_nc_fl		
       , cove_il_nc_ao		
       , cove_il_cat_fire		
       , cove_il_cat_ao		
       , covf_il_nc_water		
       , covf_il_nc_wh		
       , covf_il_nc_tv		
       , covf_il_nc_fl		
       , covf_il_nc_ao		
       , covf_il_cat_fire		
       , covf_il_cat_ao		
       , liab_il_nc_water		
       , liab_il_nc_wh		
       , liab_il_nc_tv		
       , liab_il_nc_fl		
       , liab_il_nc_ao		
       , liab_il_cat_fire		
       , liab_il_cat_ao		
       , cova_il_dcce_nc_water		
       , cova_il_dcce_nc_wh		
       , cova_il_dcce_nc_tv		
       , cova_il_dcce_nc_fl		
       , cova_il_dcce_nc_ao		
       , cova_il_dcce_cat_fire		
       , cova_il_dcce_cat_ao		
       , covb_il_dcce_nc_water		
       , covb_il_dcce_nc_wh		
       , covb_il_dcce_nc_tv		
       , covb_il_dcce_nc_fl		
       , covb_il_dcce_nc_ao		
       , covb_il_dcce_cat_fire		
       , covb_il_dcce_cat_ao		
       , covc_il_dcce_nc_water		
       , covc_il_dcce_nc_wh		
       , covc_il_dcce_nc_tv		
       , covc_il_dcce_nc_fl		
       , covc_il_dcce_nc_ao		
       , covc_il_dcce_cat_fire		
       , covc_il_dcce_cat_ao		
       , covd_il_dcce_nc_water		
       , covd_il_dcce_nc_wh		
       , covd_il_dcce_nc_tv		
       , covd_il_dcce_nc_fl		
       , covd_il_dcce_nc_ao		
       , covd_il_dcce_cat_fire		
       , covd_il_dcce_cat_ao		
       , cove_il_dcce_nc_water		
       , cove_il_dcce_nc_wh		
       , cove_il_dcce_nc_tv		
       , cove_il_dcce_nc_fl		
       , cove_il_dcce_nc_ao		
       , cove_il_dcce_cat_fire		
       , cove_il_dcce_cat_ao		
       , covf_il_dcce_nc_water		
       , covf_il_dcce_nc_wh		
       , covf_il_dcce_nc_tv		
       , covf_il_dcce_nc_fl		
       , covf_il_dcce_nc_ao		
       , covf_il_dcce_cat_fire		
       , covf_il_dcce_cat_ao		
       , liab_il_dcce_nc_water		
       , liab_il_dcce_nc_wh		
       , liab_il_dcce_nc_tv		
       , liab_il_dcce_nc_fl		
       , liab_il_dcce_nc_ao		
       , liab_il_dcce_cat_fire		
       , liab_il_dcce_cat_ao		
       , cova_il_alae_nc_water		
       , cova_il_alae_nc_wh		
       , cova_il_alae_nc_tv		
       , cova_il_alae_nc_fl		
       , cova_il_alae_nc_ao		
       , cova_il_alae_cat_fire		
       , cova_il_alae_cat_ao		
       , covb_il_alae_nc_water		
       , covb_il_alae_nc_wh		
       , covb_il_alae_nc_tv		
       , covb_il_alae_nc_fl		
       , covb_il_alae_nc_ao		
       , covb_il_alae_cat_fire		
       , covb_il_alae_cat_ao		
       , covc_il_alae_nc_water		
       , covc_il_alae_nc_wh		
       , covc_il_alae_nc_tv		
       , covc_il_alae_nc_fl		
       , covc_il_alae_nc_ao		
       , covc_il_alae_cat_fire		
       , covc_il_alae_cat_ao		
       , covd_il_alae_nc_water		
       , covd_il_alae_nc_wh		
       , covd_il_alae_nc_tv		
       , covd_il_alae_nc_fl		
       , covd_il_alae_nc_ao		
       , covd_il_alae_cat_fire		
       , covd_il_alae_cat_ao		
       , cove_il_alae_nc_water		
       , cove_il_alae_nc_wh		
       , cove_il_alae_nc_tv		
       , cove_il_alae_nc_fl		
       , cove_il_alae_nc_ao		
       , cove_il_alae_cat_fire		
       , cove_il_alae_cat_ao		
       , covf_il_alae_nc_water		
       , covf_il_alae_nc_wh		
       , covf_il_alae_nc_tv		
       , covf_il_alae_nc_fl		
       , covf_il_alae_nc_ao		
       , covf_il_alae_cat_fire		
       , covf_il_alae_cat_ao		
       , liab_il_alae_nc_water		
       , liab_il_alae_nc_wh		
       , liab_il_alae_nc_tv		
       , liab_il_alae_nc_fl		
       , liab_il_alae_nc_ao		
       , liab_il_alae_cat_fire		
       , liab_il_alae_cat_ao		
       , cova_ic_nc_water		
       , cova_ic_nc_wh		
       , cova_ic_nc_tv		
       , cova_ic_nc_fl		
       , cova_ic_nc_ao		
       , cova_ic_cat_fire		
       , cova_ic_cat_ao		
       , covb_ic_nc_water		
       , covb_ic_nc_wh		
       , covb_ic_nc_tv		
       , covb_ic_nc_fl		
       , covb_ic_nc_ao		
       , covb_ic_cat_fire		
       , covb_ic_cat_ao		
       , covc_ic_nc_water		
       , covc_ic_nc_wh		
       , covc_ic_nc_tv		
       , covc_ic_nc_fl		
       , covc_ic_nc_ao		
       , covc_ic_cat_fire		
       , covc_ic_cat_ao		
       , covd_ic_nc_water		
       , covd_ic_nc_wh		
       , covd_ic_nc_tv		
       , covd_ic_nc_fl		
       , covd_ic_nc_ao		
       , covd_ic_cat_fire		
       , covd_ic_cat_ao		
       , cove_ic_nc_water		
       , cove_ic_nc_wh		
       , cove_ic_nc_tv		
       , cove_ic_nc_fl		
       , cove_ic_nc_ao		
       , cove_ic_cat_fire		
       , cove_ic_cat_ao		
       , covf_ic_nc_water		
       , covf_ic_nc_wh		
       , covf_ic_nc_tv		
       , covf_ic_nc_fl		
       , covf_ic_nc_ao		
       , covf_ic_cat_fire		
       , covf_ic_cat_ao		
       , liab_ic_nc_water		
       , liab_ic_nc_wh		
       , liab_ic_nc_tv		
       , liab_ic_nc_fl		
       , liab_ic_nc_ao		
       , liab_ic_cat_fire		
       , liab_ic_cat_ao		
       , cova_ic_dcce_nc_water		
       , cova_ic_dcce_nc_wh		
       , cova_ic_dcce_nc_tv		
       , cova_ic_dcce_nc_fl		
       , cova_ic_dcce_nc_ao		
       , cova_ic_dcce_cat_fire		
       , cova_ic_dcce_cat_ao		
       , covb_ic_dcce_nc_water		
       , covb_ic_dcce_nc_wh		
       , covb_ic_dcce_nc_tv		
       , covb_ic_dcce_nc_fl		
       , covb_ic_dcce_nc_ao		
       , covb_ic_dcce_cat_fire		
       , covb_ic_dcce_cat_ao		
       , covc_ic_dcce_nc_water		
       , covc_ic_dcce_nc_wh		
       , covc_ic_dcce_nc_tv		
       , covc_ic_dcce_nc_fl		
       , covc_ic_dcce_nc_ao		
       , covc_ic_dcce_cat_fire		
       , covc_ic_dcce_cat_ao		
       , covd_ic_dcce_nc_water		
       , covd_ic_dcce_nc_wh		
       , covd_ic_dcce_nc_tv		
       , covd_ic_dcce_nc_fl		
       , covd_ic_dcce_nc_ao		
       , covd_ic_dcce_cat_fire		
       , covd_ic_dcce_cat_ao		
       , covf_ic_dcce_nc_water		
       , covf_ic_dcce_nc_wh		
       , covf_ic_dcce_nc_tv		
       , covf_ic_dcce_nc_fl		
       , covf_ic_dcce_nc_ao		
       , covf_ic_dcce_cat_fire		
       , covf_ic_dcce_cat_ao		
       , liab_ic_dcce_nc_water		
       , liab_ic_dcce_nc_wh		
       , liab_ic_dcce_nc_tv		
       , liab_ic_dcce_nc_fl		
       , liab_ic_dcce_nc_ao		
       , liab_ic_dcce_cat_fire		
       , liab_ic_dcce_cat_ao		
       , cova_ic_alae_nc_water		
       , cova_ic_alae_nc_wh		
       , cova_ic_alae_nc_tv		
       , cova_ic_alae_nc_fl		
       , cova_ic_alae_nc_ao		
       , cova_ic_alae_cat_fire		
       , cova_ic_alae_cat_ao		
       , covb_ic_alae_nc_water		
       , covb_ic_alae_nc_wh		
       , covb_ic_alae_nc_tv		
       , covb_ic_alae_nc_fl		
       , covb_ic_alae_nc_ao		
       , covb_ic_alae_cat_fire		
       , covb_ic_alae_cat_ao		
       , covc_ic_alae_nc_water		
       , covc_ic_alae_nc_wh		
       , covc_ic_alae_nc_tv		
       , covc_ic_alae_nc_fl		
       , covc_ic_alae_nc_ao		
       , covc_ic_alae_cat_fire		
       , covc_ic_alae_cat_ao		
       , covd_ic_alae_nc_water		
       , covd_ic_alae_nc_wh		
       , covd_ic_alae_nc_tv		
       , covd_ic_alae_nc_fl		
       , covd_ic_alae_nc_ao		
       , covd_ic_alae_cat_fire		
       , covd_ic_alae_cat_ao		
       , cove_ic_alae_nc_water		
       , cove_ic_alae_nc_wh		
       , cove_ic_alae_nc_tv		
       , cove_ic_alae_nc_fl		
       , cove_ic_alae_nc_ao		
       , cove_ic_alae_cat_fire		
       , cove_ic_alae_cat_ao		
       , covf_ic_alae_nc_water		
       , covf_ic_alae_nc_wh		
       , covf_ic_alae_nc_tv		
       , covf_ic_alae_nc_fl		
       , covf_ic_alae_nc_ao		
       , covf_ic_alae_cat_fire		
       , covf_ic_alae_cat_ao		
       , liab_ic_alae_nc_water		
       , liab_ic_alae_nc_wh		
       , liab_ic_alae_nc_tv		
       , liab_ic_alae_nc_fl		
       , liab_ic_alae_nc_ao		
       , liab_ic_alae_cat_fire		
       , liab_ic_alae_cat_ao		
       , CovA_FL		
       , CovA_SF		
       , CovA_EC		
       , CovC_FL		
       , CovC_SF 		
       , CovC_EC		
       , f.loaddate		
       , AllCov_WP*ehy as  AllCov_EP		
from FSBI_DW_SPINN.FACT_PROPERTY_MODELDATA f		
join FSBI_DW_SPINN.DIM_POLICY p		
on f.policy_id=p.policy_id		
join FSBI_DW_SPINN.DIM_BUILDING b		
on  f.policy_id=b.policy_id		
and f.building_id=b.building_id		
join FSBI_DW_SPINN.VDIM_PRODUCER a		
on f.producer_id=a.producer_id		
join FSBI_DW_SPINN.DIM_POLICYEXTENSION pe		
on f.policy_id=pe.policy_id		
join FSBI_DW_SPINN.DIM_INSURED i		
on f.policy_id=i.policy_id		
join FSBI_DW_SPINN.VDIM_COMPANY co		
on p.company_id=co.company_id		
join FSBI_DW_SPINN.dim_policy_changes pc		
on f.policy_changes_id=pc.policy_changes_id		
and f.policy_id=pc.policy_id		
where  f.startdate < dateadd(month, -3, current_date);		
		
		
grant select,references on all tables in schema fsbi_dw_spinn to group ba;		
grant select,references on fsbi_stg_spinn.grouped_paymenttype to pespagnet,rbertrand;		
grant select,references on fsbi_dw_spinn.vproperty_modeldata_allcov to pespagnet,rbertrand;		
		
		
		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.modeldata_id IS 'Mid-Term change unique identifier. It''s repeated for different coverages in the same mid-term change. ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.systemidstart IS 'Exact mid-term start SystemId from Application';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.systemidend IS 'Exact mid-term end SystemId from Application';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cal_year IS ' 	cast(date_part(year, startdate) as int) 	Year of Start Date';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.startdate IS 'Exact Mid-Term Start date or Jan 1 next year if  a mid-term covers more then one year. ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.enddate IS ' 	case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end	Exact Mid-Term End date or Dec 31  if  a mid-term covers more then one year. ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.startdatetm IS 'Exact Mid-Term Start date';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.enddatetm IS 'Exact Mid-Term End Date';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.ehy IS '  earned home years	DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovA_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovB_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovC_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovD_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovE_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ep IS ' 	case when pe.renewaltermcd=''1 Year'' then 1 else 2 end * CovF_wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.policy_uniqueid IS 'PolicyRef in PolicyStats or SystemId in any other related table';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.units IS ' 	case when risktype=''Homeowners'' then NumberOfFamilies else OwnerOccupiedUnits + TenantOccupiedUnits end';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.multipolicyind IS ' 	upper(replace(pc.MultiPolicyAutoDiscount,''~'',''No''))	It''s based on 2 different fields from Building table: MultiPolicyInd (Safeguard) and AutoHomeInd (ICO products). They are the same discount (if there is an auto policy) but for different products';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.multipolicynumber IS ' 	pc.MultiPolicyAutoNumber	It''s based on 2 different fields from Building table: MultiPolicyNumber (Safeguard) and otherpolicynumber1 (ICO products). They are the same discount (if there is an auto policy) but for different products';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.multipolicyindumbrella IS ' 	upper(replace(pc.MultiPolicyUmbrellaDiscount,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.multipolicynumberumbrella IS ' 	pc.UmbrellaRelatedPolicyNumber';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.earthquakeumbrellaind IS ' 	upper(replace(earthquakeumbrellaind,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.homegardcreditind IS ' 	upper(replace(homegardcreditind,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.sprinklersystem IS ' 	upper(replace(sprinklersystem,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.landlordind IS ' 	upper(replace(pc.landlordind,''~'',''No'')) 	Discount if there is more then 1 Landlord policy per customer';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cseagent IS ' 	upper(replace(cseagent,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.rentersinsurance IS ' 	upper(replace(rentersinsurance,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.firealarmtype IS ' 	upper(replace(FireAlarmType,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.burglaryalarmtype IS ' 	upper(replace(BurglaryAlarmType,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.waterdetectiondevice IS ' 	upper(replace(WaterDetectionDevice,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.neighborhoodcrimewatchind IS ' 	upper(replace(NeighborhoodCrimeWatchInd,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.propertymanager IS ' 	upper(replace(PropertyManager,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.safeguardplusind IS ' 	upper(replace(SafeguardPlusInd,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.deluxepackageind IS ' 	upper(replace(HODeluxe,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.kitchenfireextinguisherind IS ' 	upper(replace(kitchenfireextinguisherind,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.smokedetector IS ' 	 upper(replace(smokedetector,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.gatedcommunityind IS ' 	upper(replace(gatedcommunityind,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.deadboltind IS ' 	upper(replace(deadboltind,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.poolind IS ' 	upper(replace(poolind,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.replacementcostdwellingind IS ' 	upper(replace(ReplacementCostDwellingInd,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.replacementvalueind IS ' 	upper(replace(replacementvalueind,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.serviceline IS ' 	upper(replace(serviceline,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.equipmentbreakdown IS ' 	upper(replace(equipmentbreakdown,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.tenantevictions IS ' 	upper(replace(tenantevictions,''~'',''No''))';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.allcov_wp IS ' 	Total Policy WP 	including discounts but not fees. Total from Coverage List in SPINN UI Dwelling ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.allcov_ep IS ' 	AllCov_WP*ehy	 ';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.allcov_lossinc IS ' 	Total for all coverages Paid and Incurred Losses 	See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.allcov_lossdcce IS ' 	Total for all coverages DCCE	Only DCCE, no IL added See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.allcov_lossalae IS ' 	Total for all coverages ALAE	Only ALAE, no IL added See Coverages in AllCov_Loss Column tab for the list of coverages included';
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covcincreasedlimit IS 'CSE decided to price it in two step: a basic limit + anything above that basic limit so they created two coverage codes (PP and INCC) but what CSE would pay under that coverage is really the sum of both. ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.quality_polappinconsistency_flg IS 'Sometimes the latest known policy state is different from latest application data due to manual updates. I try to use "policy" instead of "aplication" data';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.quality_riskidduplicates_flg IS 'Different risks have the same number in SPINN. SPINN issue. ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.quality_claimok_flg IS 'Claim is joined without an issue';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.quality_claimpolicytermjoin_flg IS 'There is an issue joining a claim to a specific mid-term change because of cancellations. It''s joined to a first mid-term change (record) per policy term.  In many cases there is just one record per policy term in homeowners policies. ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covabcdefliab_loss IS ' 	Total Coverage A thru LIAB groups Paid and Incurred Loss';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covabcdefliab_claim_count IS ' 	Total Coverage A thru LIAB groups Claim Count';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cat_covabcdefliab_loss IS ' 	Catastrophe Total Coverage A thru LIAB groups  Paid and Incurred Loss';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cat_covabcdefliab_claim_count IS ' 	Total Coverage A thru LIAB groups Claim Count';	
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_il_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cova_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covb_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covc_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covd_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.cove_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.covf_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_nc_water IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_nc_wh IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_nc_tv IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_nc_fl IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_nc_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_cat_fire IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.liab_ic_alae_cat_ao IS 'ALAE contains only AOE, not dcce. In fact, the name should be AOE, not ALAE.  ';		
COMMENT ON COLUMN fsbi_dw_spinn.vproperty_modeldata_allcov.loaddate IS 'Data last refresh date';		
