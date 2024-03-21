drop view if exists fsbi_dw_spinn.vauto_modeldata_allcov;		
create or replace view  fsbi_dw_spinn.vauto_modeldata_allcov as 		
select  		
p.pol_policynumber policynumber,		
m.policy_uniqueid,		
m.vin,		
m.vehicle_uniqueid,		
cr.cvrsk_number riskcd ,		
m.risktype risktypecd,		
d.LicenseNumber driver,		
cr.cvrsk_number2  drivernumber,		
m.driver_uniqueid DriverParentId,		
cast(date_part(year, m.startdate) as int) cal_year,		
m.startdate,		
case when m.enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  m.enddate end   enddate,		
m.startdatetm,		
m.enddatetm,		
DateDiff(d, m.startdate, case when m.enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  m.enddate end)/365.25  ecy,		
m.coveragecd coverage,		
m.limit1,		
m.limit2,		
m.deductible,		
m.wp,		
case when pe.renewaltermcd='1 Year' then 1 else 2 end * m.wp*(DateDiff(d, m.startdate, case when m.enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  m.enddate end)/365.25) ep,		
m.coll_deductible,		
m.comp_deductible,		
m.bi_limit1,		
m.bi_limit2,		
m.umbi_limit1,		
m.umbi_limit2,		
m.pd_limit1,		
m.pd_limit2,		
m.cntveh ,		
m.cntdrv,		
m.CntNonDrv,		
m.cntexcludeddrv ,		
m.minDriverAge,		
case when m.cntveh>(m.cntdrv-m.cntNondrv-m.cntexcludeddrv) then 'Yes' else 'No' end Extra_Vehicles,		
/*---------------------------POLICY ATTRIBUTES-------------------------------------*/		
vdc.comp_number companycd	,	
vdc.comp_name1 carriercd	,	
pe.programind	,	
pe.previouscarriercd ,		
case when p.pol_policynumbersuffix='01' then 'New' else 'Renewal' end  policyneworrenewal	,	
pe.renewaltermcd	,	
p.pol_effectivedate  effectivedate	,	
p.pol_expirationdate expirationdate	,	
case when pe.inceptiondt<='1900-01-01' then  null else pe.inceptiondt end 	inceptiondt,	
case when pe.persistencydiscountdt<='1900-01-01' then  null else pe.persistencydiscountdt end	persistencydiscountdt,	
pr.prdr_number producercode	,	
pr.prdr_name1 producername	,	
pr.prdr_address1 produceraddress	,	
pr.prdr_city producercity 	,	
pr.prdr_state producerstate	,	
pr.prdr_zipcode producerpostalcode	,	
pr.producer_status,		
pr.territory	,	
di.MultiPolicyDiscount MultiPolicyDiscountInd	,	
di.MultiPolicyHomeDiscount MultiPolicyDiscountInd_Value	,	
di.HomeRelatedPolicyNumber 	,	
di.UmbrellaRelatedPolicyNumber 	,	
di.MultiCarDiscountInd 	,	
di.CSEEmployeeDiscountInd	,	
pe.installmentfee	,	
pe.nsffee	,	
pe.latefee	,	
di.LiabilityReductionInd	,	
di.FullPayDiscountInd	,	
di.TwoPayDiscountInd	,	
di.EFTDiscount	,	
/*---------------------------------------------------------------------------------*/		
case when pe.persistencydiscountdt>'1900-01-01' then  datepart(y,p.pol_effectivedate) -datepart(y,pe.persistencydiscountdt)  else 0 end  Persistency,		
datepart(y,p.pol_effectivedate) PolicyYear	,	
/*---------------------------VEHICLE ATTRIBUTES-------------------------------*/		
m.VehicleInceptionDate,  		
v.StateProvCd	State,	
v.County	,	
v.PostalCode	,	
v.City	,	
v.Addr1	,	
v.Addr2	,	
v.GaragAddrFlg 	,	
v.GaragPostalCode 	,	
v.GaragPostalCodeFlg	,	
v.VehBodyTypeCd 	,	
v.performancecd	,	
v.modelyr	,	
v.VehUseCd	,	
v.estimatedannualdistance	,	
v.estimatedworkdistance	,	
v.odometerreading	,	
v.weekspermonthdriven	,	
v.daysperweekdriven	,	
v.manufacturer	,	
v.neworusedind	,	
v.AntiTheftCd	,	
v.Restraintcd	,	
v.TowingAndLaborInd	,	
v.RentalReimbursementInd	,	
v.MedicalPartsAccessibility	,	
v.Mileage	,	
v.TitleHistoryIssue,		
/*CARFAX*/		
v.CaliforniaRecentMileage, 		
v.RecentAverageMileage, 		
v.AverageMileage, 		
v.ModeledAnnualMileage,		
v.HistCarfax201902_Last_Owner_Average_Miles as Last_Owner_Average_Miles,		
v.HistCarfax201902_Last_Owner_Recent_Annual_Mileage as  Last_Owner_Recent_Annual_Mileage,		
v.HistCarfax201902_Last_Owner_Government_Recent_Annual_Mileage  as Last_Owner_Government_Recent_Annual_Mileage,		
v.HistCarfax201902_Estimated_Current_Mileage as Estimated_Current_Mileage,		
v.HistCarfax201902_Annual_Mileage_Estimate  as Annual_Mileage_Estimate,		
case when v.Salvage_FirstDt>'1900-01-01' or v.junk_firstdt>'1900-01-01' or v.rebuiltreconstructed_firstdt>'1900-01-01' or v.othertitlebrand_firstdt>'1900-01-01' or v.manufacturerbuybacklemon_firstdt>'1900-01-01' then 'Yes'  else 'No' end Salvage,		
case 		
 when v.Mileage='Estimated' then 'Estimated'		
 when v.Mileage='Recommended' and v.CarfaxSource like 'DataReport%'  then 		
  case		
   when v.EstimatedAnnualDistance = v.CaliforniaRecentMileage then 'CaliforniaRecentMileage Carfax DataReport'		
   when v.EstimatedAnnualDistance = v.RecentAverageMileage then 'RecentAverageMileage Carfax DataReport'		
   when v.EstimatedAnnualDistance = v.AverageMileage then 'AverageMileage Carfax DataReport'		
   when v.EstimatedAnnualDistance = v.ModeledAnnualMileage then 'ModeledAnnualMileage Carfax DataReport'		
   else 'Not Match Carfax DataReport'		
  end		
   when v.Mileage='Recommended' and v.CarfaxSource like 'Extend%'  then 		
  case		
   when v.EstimatedAnnualDistance = v.CaliforniaRecentMileage then 'CaliforniaRecentMileage Prev Term Carfax DataReport'		
   when v.EstimatedAnnualDistance = v.RecentAverageMileage then 'RecentAverageMileage  Prev Term Carfax DataReport'		
   when v.EstimatedAnnualDistance = v.AverageMileage then 'AverageMileage  Prev Term Carfax DataReport'		
   when v.EstimatedAnnualDistance = v.ModeledAnnualMileage then 'ModeledAnnualMileage  Prev Term Carfax DataReport'		
   else 'Not Match Prev Term Carfax DataReport'		
  end		
   else 'N/A'		
end matchCarfax,		
v.carfaxsource ,		
v.classCD	,	
v.ratingvalue	,  	
v.cmpratingvalue	,  	
v.colratingvalue	,  	
v.liabilityratingvalue	,  	
v.medpayratingvalue	,  	
v.racmpratingvalue	,  	
v.racolratingvalue	,  	
v.rabiratingsymbol	,  	
v.rapdratingsymbol	,  	
v.ramedpayratingsymbol	,  	
v.GarageTerritory	,  	
v.daylightrunninglightsind	,  	
v.CostNewAmt	,	
v.StatedAmt	,	
v.StatedAmtInd	,	
v.FullGlassCovInd 	,	
CASE WHEN ISNULL(v.RACOLRatingValue, '~') <> '~'                		
    THEN                 		
     CASE LEFT(v.RACOLRatingValue, 1)                		
      WHEN 'A' THEN 10586                		
      WHEN 'B' THEN 13200                		
      WHEN 'C' THEN 14189                		
      WHEN 'D' THEN 16910                		
      WHEN 'E' THEN 18166                		
      WHEN 'F' THEN 19244                		
      WHEN 'G' THEN 20886                		
      WHEN 'H' THEN 22921                		
      WHEN 'J' THEN 26561                		
      WHEN 'K' THEN 31190                		
      WHEN 'L' THEN 33907                		
      WHEN 'M' THEN 38111                		
      WHEN 'N' THEN 51608                		
      WHEN 'P' THEN 87479                		
     END                		
   ELSE v.CostNewAmt                		
  END  AS vehicle_value,		
m.liabilityonly_flg liabilityonlyflg,		
m.componly_flg componlyflg,		
  /*----------------------------------DRIVER ATTRIBUTES------------------------------*/		
m.DriverInceptionDate,    		
d.LicenseNumber,		
case when d.BirthDt<='1900-01-01' then  null else d.BirthDt end BirthDt,		
d.gendercd,		
d.maritalstatuscd,		
d.acci_pointschargedterm,		
d.viol_pointschargedterm,		
d.susp_pointschargedterm,		
d.other_pointschargedterm,		
d.driverstatuscd,		
d.drivertypecd,		
case when d.licensedt<='1900-01-01' then  null else d.licensedt end licensedt,		
d.LicensedStateProvCd,		
d.NewToStateInd,		
d.ScholasticDiscountInd,		
d.gooddriverind,		
d.maturedriverind,		
d.occupationclasscd,		
d.mvrstatusdt,		
d.MVRStatus,		
d.newteenexpirationdt,		
d.DriverTrainingInd,		
d.VIOL_PointsCharged_Adj,		
d.ACCI_PointsCharged_Adj,		
d.MissedViolationPoints,		
d.Acci5yr,		
d.Acci7yr,		
d.PointsCharged,		
  /*---------------------------------------------------------------------------------*/		
case when d.BirthDt<='1900-01-01' then  null else DateDiff(month, d.birthdt,p.pol_EffectiveDate)/12 end   DriverAge,		
case when d.licensedt<='1900-01-01' then  null else DateDiff(month, d.licensedt,p.pol_EffectiveDate)/12 end DriverLicenseAge,		
case when d.LicenseNumber='~' then 'Yes' else 'No' end excess_veh_ind,		
  /*----------------------------------INSURED ATTRIBUTES------------------------------*/		
i.InsuranceScore,		
i.OverriddenInsuranceScore,		
i.InsuranceScoreValue,		
i.ratepageeffectivedt,		
i.insscoretiervalueband,		
i.applieddt,		
i.financialstabilitytier,		
 --		
m.excludeddrv_flg  excludeddrvflg,		
 --		
 /*-----------------------------------CLAIMS----------------------------------------*/		
cov_claim_count_le500 	 claim_count_le500	,
cov_claim_count_1000 	 claim_count_1000	,
cov_claim_count_1500 	 claim_count_1500	,
cov_claim_count_2000 	 claim_count_2000	,
cov_claim_count_2500 	 claim_count_2500	,
cov_claim_count_5k 	 claim_count_5k	,
cov_claim_count_10k 	 claim_count_10k	,
cov_claim_count_25k 	 claim_count_25k	,
cov_claim_count_50k 	 claim_count_50k	,
cov_claim_count_100k 	 claim_count_100k	,
cov_claim_count_250k 	 claim_count_250k	,
cov_claim_count_500k 	 claim_count_500k	,
cov_claim_count_750k 	 claim_count_750k	,
cov_claim_count_1m 	 claim_count_1m	,
cov_claim_count 	 claim_count	,
nc_cov_inc_loss_le500 	 nc_inc_loss_le500	,
nc_cov_inc_loss_1000 	 nc_inc_loss_1000	,
nc_cov_inc_loss_1500 	 nc_inc_loss_1500	,
nc_cov_inc_loss_2000 	 nc_inc_loss_2000	,
nc_cov_inc_loss_2500 	 nc_inc_loss_2500	,
nc_cov_inc_loss_5k 	 nc_inc_loss_5k	,
nc_cov_inc_loss_10k 	 nc_inc_loss_10k	,
nc_cov_inc_loss_25k 	 nc_inc_loss_25k	,
nc_cov_inc_loss_50k 	 nc_inc_loss_50k	,
nc_cov_inc_loss_100k 	 nc_inc_loss_100k	,
nc_cov_inc_loss_250k 	 nc_inc_loss_250k	,
nc_cov_inc_loss_500k 	 nc_inc_loss_500k	,
nc_cov_inc_loss_750k 	 nc_inc_loss_750k	,
nc_cov_inc_loss_1m 	 nc_inc_loss_1m	,
nc_cov_inc_loss 	 nc_inc_loss	,
cat_cov_inc_loss_le500 	 cat_inc_loss_le500	,
cat_cov_inc_loss_1000 	 cat_inc_loss_1000	,
cat_cov_inc_loss_1500 	 cat_inc_loss_1500	,
cat_cov_inc_loss_2000 	 cat_inc_loss_2000	,
cat_cov_inc_loss_2500 	 cat_inc_loss_2500	,
cat_cov_inc_loss_5k 	 cat_inc_loss_5k	,
cat_cov_inc_loss_10k 	 cat_inc_loss_10k	,
cat_cov_inc_loss_25k 	 cat_inc_loss_25k	,
cat_cov_inc_loss_50k 	 cat_inc_loss_50k	,
cat_cov_inc_loss_100k 	 cat_inc_loss_100k	,
cat_cov_inc_loss_250k 	 cat_inc_loss_250k	,
cat_cov_inc_loss_500k 	 cat_inc_loss_500k	,
cat_cov_inc_loss_750k 	 cat_inc_loss_750k	,
cat_cov_inc_loss_1m 	 cat_inc_loss_1m	,
cat_cov_inc_loss 	 cat_inc_loss	,
nc_cov_inc_loss_dcce_le500 	 nc_inc_loss_dcce_le500	,
nc_cov_inc_loss_dcce_1000 	 nc_inc_loss_dcce_1000	,
nc_cov_inc_loss_dcce_1500 	 nc_inc_loss_dcce_1500	,
nc_cov_inc_loss_dcce_2000 	 nc_inc_loss_dcce_2000	,
nc_cov_inc_loss_dcce_2500 	 nc_inc_loss_dcce_2500	,
nc_cov_inc_loss_dcce_5k 	 nc_inc_loss_dcce_5k	,
nc_cov_inc_loss_dcce_10k 	 nc_inc_loss_dcce_10k	,
nc_cov_inc_loss_dcce_25k 	 nc_inc_loss_dcce_25k	,
nc_cov_inc_loss_dcce_50k 	 nc_inc_loss_dcce_50k	,
nc_cov_inc_loss_dcce_100k 	 nc_inc_loss_dcce_100k	,
nc_cov_inc_loss_dcce_250k 	 nc_inc_loss_dcce_250k	,
nc_cov_inc_loss_dcce_500k 	 nc_inc_loss_dcce_500k	,
nc_cov_inc_loss_dcce_750k 	 nc_inc_loss_dcce_750k	,
nc_cov_inc_loss_dcce_1m 	 nc_inc_loss_dcce_1m	,
nc_cov_inc_loss_dcce 	 nc_inc_loss_dcce	,
cat_cov_inc_loss_dcce_le500 	 cat_inc_loss_dcce_le500	,
cat_cov_inc_loss_dcce_1000 	 cat_inc_loss_dcce_1000	,
cat_cov_inc_loss_dcce_1500 	 cat_inc_loss_dcce_1500	,
cat_cov_inc_loss_dcce_2000 	 cat_inc_loss_dcce_2000	,
cat_cov_inc_loss_dcce_2500 	 cat_inc_loss_dcce_2500	,
cat_cov_inc_loss_dcce_5k 	 cat_inc_loss_dcce_5k	,
cat_cov_inc_loss_dcce_10k 	 cat_inc_loss_dcce_10k	,
cat_cov_inc_loss_dcce_25k 	 cat_inc_loss_dcce_25k	,
cat_cov_inc_loss_dcce_50k 	 cat_inc_loss_dcce_50k	,
cat_cov_inc_loss_dcce_100k 	 cat_inc_loss_dcce_100k	,
cat_cov_inc_loss_dcce_250k 	 cat_inc_loss_dcce_250k	,
cat_cov_inc_loss_dcce_500k 	 cat_inc_loss_dcce_500k	,
cat_cov_inc_loss_dcce_750k 	 cat_inc_loss_dcce_750k	,
cat_cov_inc_loss_dcce_1m 	 cat_inc_loss_dcce_1m	,
cat_cov_inc_loss_dcce 	 cat_inc_loss_dcce	,
BIlossinc1530,		
UMBIlossinc1530,		
UIMBIlossinc1530,		
  /*-----------------------------------QUALITY FLAGS----------------------------------------------*/		
m.quality_replacedvin_flg qualityflgreplacedvin,		
m.quality_replaceddriver_flg qualityflgreplaceddriver,		
  /*-----------------------------------CLAIMS QUALITY FLAGS----------------------------------------*/		
m.quality_claimok_flg qualityclaimokflg,		
m.quality_claimunknownvin_flg qualityclaimunknownvinflg,		
m.quality_claimunknownvinnotlisteddriver_flg qualityclaimunknownvinnotlisteddriverflg,		
m.quality_claimpolicytermjoin_flg qualityclaimpolicytermjoinflg,		
 --		
m.loaddate		
from fsbi_dw_spinn.fact_auto_modeldata m		
join fsbi_dw_spinn.dim_vehicle v		
on m.vehicle_id=v.vehicle_id		
and m.policy_id=v.policy_id		
join fsbi_dw_spinn.dim_policy p		
on m.policy_id=p.policy_id		
join fsbi_dw_spinn.dim_policyextension pe		
on m.policy_id=pe.policy_id		
join fsbi_dw_spinn.dim_driver d		
on m.driver_id=d.driver_id		
join fsbi_dw_spinn.dim_policy_changes di		
on m.policy_changes_id=di.policy_changes_id		
join fsbi_dw_spinn.vdim_producer pr		
on m.producer_id=pr.producer_id		
join fsbi_dw_spinn.dim_coveredrisk cr		
on cr.coveredrisk_id=m.risk_id		
join fsbi_dw_spinn.vdim_company vdc 		
on p.company_id=vdc.company_id		
join fsbi_dw_spinn.dim_insured i 		
on p.policy_id=i.policy_id		
where  m.startdate < dateadd(month, -2, current_date);		
		
grant select,references on fsbi_dw_spinn.vauto_modeldata_allcov to pespagnet,rbertrand;		
		
		
		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.policy_uniqueid IS 'PolicyRef';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.vehicle_uniqueid IS 'SPINN Vehicle Id';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.riskcd IS 'Vehicle Number';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.risktypecd IS 'PrivatePassangerAuto only';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.driver IS 'LicenseNumber';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.driverparentid IS 'SPINN Driver parent Id';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.cal_year IS 'Year of Start Date';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.startdate IS 'Exact Mid-Term Start date or Jan 1 next year if  a mid-term covers more then one year.';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.enddate IS 'Exact Mid-Term End date or Dec 31  if  a mid-term covers more then one year.';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.startdatetm IS 'Exact Mid-Term Start date';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.enddatetm IS 'Exact Mid-Term End Date';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.ecy IS 'DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.coverage IS 'Depend on a view, not applicable forvauto_modeldata,  all coverage groups for _allcov or a specific one for the rest.';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.ep IS 'case when renewaltermcd=''1 Year'' then 1 else 2 end * wp*(DateDiff(d, startdate, case when enddate > dateadd(month, -2, current_date) then dateadd(month, -2, current_date) else  enddate end)/365.25)';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.cntveh IS 'Number of all vehicles in this mid-term change';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.cntdrv IS 'Number of all active drivers in this mid-term change, including non-assigned: count(distinct case when stg.status=`Active` then  stg.driver_uniqueid else null end) ';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.cntnondrv IS 'Number of excluded drivers: count(distinct case when stg.status=`Active` and upper(stg.LicenseNumber) like `%EXCLUDED%`  then stg.driver_uniqueid else null end)';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.cntexcludeddrv IS 'Number of Non drivers: count(distinct case when stg.status=`Active` and upper(stg.LicenseNumber) NOT like `%EXCLUDED%` and stg.DriverTypeCd in (`NonOperator`, `Excluded`, `UnderAged`) then  stg.driver_uniqueid else null end)';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.mindriverage IS 'A minimal driver age per this mid-term change. Non assigned drivers are taken into account';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.extra_vehicles IS 'Number of vehicles without assigned drivers';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.salvage IS 'case when v.Salvage_FirstDt>`1900-01-01` then `Yes` else `No` end Salvage';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.matchcarfax IS 'case 		
 when v.Mileage=''Estimated'' then ''Estimated''		
 when v.Mileage=''Recommended'' and v.CarfaxSource like ''DataReport%''  then 		
  case		
   when v.EstimatedAnnualDistance = v.CaliforniaRecentMileage then ''CaliforniaRecentMileage Carfax DataReport''		
   when v.EstimatedAnnualDistance = v.RecentAverageMileage then ''RecentAverageMileage Carfax DataReport''		
   when v.EstimatedAnnualDistance = v.AverageMileage then ''AverageMileage Carfax DataReport''		
   when v.EstimatedAnnualDistance = v.ModeledAnnualMileage then ''ModeledAnnualMileage Carfax DataReport''		
   else ''Not Match Carfax DataReport''		
  end		
   when v.Mileage=''Recommended'' and v.CarfaxSource like ''Extend%''  then 		
  case		
   when v.EstimatedAnnualDistance = v.CaliforniaRecentMileage then ''CaliforniaRecentMileage Prev Term Carfax DataReport''		
   when v.EstimatedAnnualDistance = v.RecentAverageMileage then ''RecentAverageMileage  Prev Term Carfax DataReport''		
   when v.EstimatedAnnualDistance = v.AverageMileage then ''AverageMileage  Prev Term Carfax DataReport''		
   when v.EstimatedAnnualDistance = v.ModeledAnnualMileage then ''ModeledAnnualMileage  Prev Term Carfax DataReport''		
   else ''Not Match Prev Term Carfax DataReport''		
  end		
   else ''N/A''		
end matchCarfax';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.vehicle_value IS 'Calculated based on RACOLRatingValue';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.liabilityonlyflg IS 'Y if there are only BI, UM, PD, Med coverages exists for this vehicle in the mid-term change';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.componlyflg IS 'Y if there are only COLL and COMP coverages exists for this vehicle in the mid-term change';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.viol_pointscharged_adj IS 'Calculated based on LossHistory and other driver info';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.acci_pointscharged_adj IS 'Calculated based on LossHistory and other driver info';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.missedviolationpoints IS 'Calculated based on LossHistory and other driver info';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.acci5yr IS 'Calculated based on LossHistory and other driver info';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.pointscharged IS 'Calculated based on LossHistory and other driver info';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.driverage IS 'Age based of DIM_DRIVER.BirthDate';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.driverlicenseage IS 'Age based on DIM_DRIVER.DriverLicenseDate';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.excess_veh_ind IS 'Y if there are more vehicles then drivers';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.insurancescorevalue IS 'No historical data populated, Almost empty';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.ratepageeffectivedt IS 'No historical data populated, Almost empty';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.insscoretiervalueband IS 'No historical data populated, Almost empty';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.applieddt IS 'No historical data populated, Almost empty';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.financialstabilitytier IS 'No historical data populated, Almost empty';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.excludeddrvflg IS 'Excluded drivers in SPINN have the same ID. If there is a claim for an excluded driver it is not possible to assign to a proper driver even in SPINN itself. The number of excluded driver also can be afected';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityflgreplacedvin IS 'It`s Y if a vehicle was not set as "Deleted" but rather replaced with an other vehicle';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityflgreplaceddriver IS 'It`s Y if a driver was not set as "Deleted" but rather replaced with an other driver';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityclaimokflg IS 'Y if no issues to assign a claim to a proper mid-term change';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityclaimunknownvinflg IS 'A claim with Unknown VIN in the system';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityclaimunknownvinnotlisteddriverflg IS 'A claim with Unknown VIN and a driver not primary assigned to a vehicle';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.qualityclaimpolicytermjoinflg IS 'A claim is assign to a first record in a policy term due to issues in a related policy ref and/or loss date.';		
COMMENT ON COLUMN fsbi_dw_spinn.vauto_modeldata_allcov.loaddate IS 'When data were loaded';		
