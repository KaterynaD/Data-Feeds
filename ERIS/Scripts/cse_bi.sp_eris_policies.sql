CREATE OR REPLACE PROCEDURE cse_bi.sp_eris_policies(pLoadDate datetime) 
AS $$
BEGIN
/*full load takes 3 min*/
/*dim_policy_extension is a combination of dim_policy with dim_policyextension
with additional calculated fields (LOB) 
plus rate changes coefficients which are applied based on effective date and coverages
There are more lines per policy then just one in dim_policy
It depends on ERIS coverages*/
/*Because there is no regular aggregation function for multiplicateion 
- EXP(SUM(of lograthim LN)) is used*/
create temporary table dim_policy_extended as 
select 
p.policy_id,
p.pol_policynumber,
p.pol_uniqueid,
p.pol_policynumbersuffix,
p.pol_effectivedate,
p.pol_expirationdate,
p.pol_masterstate,
case 
when upper(substring(p.pol_policynumber,3,1))='A' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='B' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='E' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='F' then 'DF'
when upper(substring(p.pol_policynumber,3,1))='H' then 'HO'
when upper(substring(p.pol_policynumber,3,1))='M' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='Q' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='R' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='U' then 'OTH'
end LOB,
isnull(r.coverage,'All') coverage,
isnull(EXP(SUM(LN(cast((1+r.renewal_change/100) as float)))),1) renewal_change,
isnull(EXP(SUM(LN(cast((1+r.nb_change/100) as float)))),1) nb_change
from fsbi_dw_spinn.dim_policy p
join fsbi_dw_spinn.dim_policyextension pe 
on p.policy_id=pe.policy_id
join fsbi_dw_spinn.vdim_company co
on p.company_id=co.company_id
left outer join external_data_pricing.eris_ratechange r
on  r.startdt>pol_effectivedate
and r.carriercd=co.comp_name1
and r.AltSubTypeCd=pe.AltSubTypeCd
and r.statecd=p.pol_masterstate
where  upper(substring(p.pol_policynumber,3,1)) in ('A',
'B',
'E',
'F',
'H',
'M',
'Q',
'R',
'U' )
group by
p.policy_id,
p.pol_policynumber,
p.pol_uniqueid,
p.pol_policynumbersuffix,
p.pol_effectivedate,
p.pol_expirationdate,
p.pol_masterstate,
case 
when upper(substring(p.pol_policynumber,3,1))='A' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='B' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='E' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='F' then 'DF'
when upper(substring(p.pol_policynumber,3,1))='H' then 'HO'
when upper(substring(p.pol_policynumber,3,1))='M' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='Q' then 'OTH'
when upper(substring(p.pol_policynumber,3,1))='R' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='U' then 'OTH'
end,
isnull(r.coverage,'All');



/*main part*/
truncate table reporting.vmERIS_Policies;
insert into reporting.vmERIS_Policies 
select
m.mon_year report_year,
m.mon_quarter report_quarter,
p.pol_policynumber Policynumber,
p.policy_id,
p.pol_uniqueid policy_uniqueid,
lpad(cr.cvrsk_number,3,'0') RiskCd,
p.pol_policynumbersuffix PolicyVersion,
p.pol_effectivedate effectivedate,
p.pol_expirationdate expirationdate,
pe.RenewalTermCd,
f.policyneworrenewal,
p.pol_masterstate PolicyState,
co.comp_number CompanyNumber,
co.comp_name1 Company,
p.LOB,
c.cov_asl ASL,
case
when c.cov_asl='010' then 'SP'
when c.cov_asl='021' then 'SP'
when c.cov_asl='040' then 'HO'
when c.cov_asl='090' then 'SP'
when c.cov_asl='120' then 'SP'
when c.cov_asl='160' then 'HO'
when c.cov_asl='170' then 'SP'
when c.cov_asl='191' then 'AL'
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
when c.cov_asl='220' then 'AC'
end LOB2,
case
when c.cov_asl='010' then 'DF'
when c.cov_asl='021' then 'DF'
when c.cov_asl='040' then 'HO'
when c.cov_asl='090' then 'OTH'
when c.cov_asl='120' then 'OTH'
when c.cov_asl='160' then 'HO'
when c.cov_asl='170' then 'DF'
when c.cov_asl='191' then 'AL'
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
when c.cov_asl='220' then 'APD'
end LOB3,
case
when upper(substring(p.pol_policynumber,3,1))='A' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='B' then 'BO'
when upper(substring(p.pol_policynumber,3,1))='E' then 'EQ'
when upper(substring(p.pol_policynumber,3,1))='F' then 'DF'
when upper(substring(p.pol_policynumber,3,1))='H' then 'HO'
when upper(substring(p.pol_policynumber,3,1))='M' then 'MH'
when upper(substring(p.pol_policynumber,3,1))='Q' then 'EQ'
when upper(substring(p.pol_policynumber,3,1))='R' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='U' then 'PU'
end Product,
pe.PolicyFormCode,
case 
when co.comp_number in ('0019') then 'Select'
when pe.ProgramInd='Non-Civil Servant' then 'NC'
when pe.ProgramInd='Civil Servant' then 'CS'
when pe.ProgramInd='Affinity Group' then 'AG'
when pe.ProgramInd='Educator' then 'ED'
when pe.ProgramInd='Firefighter' then 'FF'
when pe.ProgramInd='Law Enforcement' then 'LE'
else p.LOB
end ProgramInd,
pr.producer_status,
case
when c.cov_asl='010' then 'PROP'
when c.cov_asl='021' then 'PROP'
when c.cov_asl='040' then 'PROP'
when c.cov_asl='090' then 'PROP'
when c.cov_asl='120' then 'PROP'
when c.cov_asl='160' then 'LIAB'
when c.cov_asl='170' then 'LIAB'
when c.cov_asl='191' then 'LIAB'
when c.cov_asl='192' then 'LIAB'
when c.cov_asl='211' then 'PROP'
when c.cov_asl='220' then 'PROP'
end CoverageType,
case when ce.codetype='Fee' then 'Fee' 
else 
 case
  when substring(p.pol_policynumber,3,1)='A' then isnull(ce.Act_ERIS,'OTH')
  when substring(p.pol_policynumber,3,1) in ('F','H') then
   case
    when pe.AltSubTypeCd='DF1' then '03'
    when pe.AltSubTypeCd='DF3' then '03'
    when pe.AltSubTypeCd='DF6' then '06'
    when pe.AltSubTypeCd='FL1-Basic' then '03'
    when pe.AltSubTypeCd='FL1-Vacant' then '03'
    when pe.AltSubTypeCd='FL2-Broad' then '03'
    when pe.AltSubTypeCd='FL3-Special' then '03'
    when pe.AltSubTypeCd='Form3' then '03'
    when pe.AltSubTypeCd like 'HO3%' then '03'
    when pe.AltSubTypeCd='HO4' then '04'
    when pe.AltSubTypeCd='HO6' then '06'
    when pe.AltSubTypeCd='PA' then 'OTH'
   end
  else 'OTH'
 end
end Coverage,
case when ce.codetype='Fee' then 'Y' else 'N' end FeeInd,
'SPINN' Source,
sum(wrtn_prem_amt + fees_amt) WP,
sum(earned_prem_amt) EP,
sum(case
 when f.policyneworrenewal='New' then p.nb_change*earned_prem_amt
 else p.renewal_change*earned_prem_amt
end) CLEP,
sum(
case
 when c.cov_code in ('F.30005B','F.31580A') then round(ee_rm/12,3) /*Umbrella*/
 when pe.AltSubTypeCd='PB' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*Boatowners - boats - CovA and Trailers covC*/
 when pe.AltSubTypeCd='EQ' and ce.covx_code in ('CovA','CovC') then round(ee_rm/12,3) /*In Earthquake policies if there are both CovA and CovC, then CovC do not have exposures*/
 when pe.AltSubTypeCd = 'DF3' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode<>'WF-DWELL') then round(ee_rm/12,3) 
 when pe.AltSubTypeCd = 'HO3-Homeguard' and (c.cov_subline in ('410','402') and ce.covx_code='CovA' and covx_subcode='EXWF-DWELL') then round(ee_rm/12,3)
 when pe.AltSubTypeCd in ('DF6','DF1', 'FL1-Basic', 'FL1-Vacant', 'FL2-Broad', 'FL3-Special', 'Form3', 'HO3') and (c.cov_subline in ('410','402') and ce.covx_code='CovA') then round(ee_rm/12,3)
 when pe.AltSubTypeCd in ('HO4', 'HO6') and ce.covx_code='CovC' then round(ee_rm/12,3)
 when substring(p.pol_policynumber,3,1)='A' and  (ce.covx_code in ('BI', 'COMP', 'COLL','MEDPAY', 'PD','RREIM', 'ROAD', 'UM','UMBI', 'UMPD' ) or isnull(ce.Act_ERIS,'OTH')='OTH') then round(ee_rm/12,3)
else 0
end
)  EE,
pLoadDate LoadDate,
pe.AltSubTypeCd
from fsbi_dw_spinn.fact_policycoverage f
join fsbi_dw_spinn.dim_policyextension pe
on f.policy_id=pe.policy_id
join fsbi_dw_spinn.vdim_company co
on f.company_id=co.company_id
join fsbi_dw_spinn.dim_coverage c
on f.coverage_id=c.coverage_id
left outer join public.dim_coverageextension ce
on c.coverage_id=ce.coverage_id
join dim_policy_extended p
on f.policy_id=p.policy_id
and (isnull(ce.Act_ERIS,'OTH')=p.coverage or p.coverage='All')
join fsbi_dw_spinn.vdim_producer pr
on f.producer_id=pr.producer_id
join fsbi_dw_spinn.dim_month m
on f.month_id=m.month_id
join fsbi_dw_spinn.dim_coveredrisk cr
on f.primaryrisk_id=cr.coveredrisk_id
/*Only "meaningfull" coverages from ratin. The results of this join will help to filter out duplicates */
left outer join dim_policy_extended r
on f.policy_id=r.policy_id
and isnull(ce.Act_ERIS,'OTH')=r.coverage
where m.mon_year>cast(to_char(GetDate(),'yyyy') as int) - 12 
/*keep coverages only once*/
and not (p.coverage='All' and isnull(ce.Act_ERIS,'OTH')=isnull(r.coverage,'N/A'))
group by
m.mon_year,
m.mon_quarter,
p.pol_policynumber,
p.policy_id,
p.pol_uniqueid,
lpad(cr.cvrsk_number,3,'0'),
p.pol_policynumbersuffix,
p.pol_effectivedate,
p.pol_expirationdate,
pe.RenewalTermCd,
f.policyneworrenewal,
p.pol_masterstate,
co.comp_number,
co.comp_name1,
p.LOB ,
c.cov_asl,
case
when c.cov_asl='010' then 'SP'
when c.cov_asl='021' then 'SP'
when c.cov_asl='040' then 'HO'
when c.cov_asl='090' then 'SP'
when c.cov_asl='120' then 'SP'
when c.cov_asl='160' then 'HO'
when c.cov_asl='170' then 'SP'
when c.cov_asl='191' then 'AL'
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
when c.cov_asl='220' then 'AC'
end,
case
when c.cov_asl='010' then 'DF'
when c.cov_asl='021' then 'DF'
when c.cov_asl='040' then 'HO'
when c.cov_asl='090' then 'OTH'
when c.cov_asl='120' then 'OTH'
when c.cov_asl='160' then 'HO'
when c.cov_asl='170' then 'DF'
when c.cov_asl='191' then 'AL'
when c.cov_asl='192' then 'AL'
when c.cov_asl='211' then 'APD'
when c.cov_asl='220' then 'APD'
end,
case
when upper(substring(p.pol_policynumber,3,1))='A' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='B' then 'BO'
when upper(substring(p.pol_policynumber,3,1))='E' then 'EQ'
when upper(substring(p.pol_policynumber,3,1))='F' then 'DF'
when upper(substring(p.pol_policynumber,3,1))='H' then 'HO'
when upper(substring(p.pol_policynumber,3,1))='M' then 'MH'
when upper(substring(p.pol_policynumber,3,1))='Q' then 'EQ'
when upper(substring(p.pol_policynumber,3,1))='R' then 'AU'
when upper(substring(p.pol_policynumber,3,1))='U' then 'PU'
end,
pe.PolicyFormCode,
case 
when co.comp_number in ('0019') then 'Select'
when pe.ProgramInd='Non-Civil Servant' then 'NC'
when pe.ProgramInd='Civil Servant' then 'CS'
when pe.ProgramInd='Affinity Group' then 'AG'
when pe.ProgramInd='Educator' then 'ED'
when pe.ProgramInd='Firefighter' then 'FF'
when pe.ProgramInd='Law Enforcement' then 'LE'
else p.LOB
end,
pr.producer_status,
case
when c.cov_asl='010' then 'PROP'
when c.cov_asl='021' then 'PROP'
when c.cov_asl='040' then 'PROP'
when c.cov_asl='090' then 'PROP'
when c.cov_asl='120' then 'PROP'
when c.cov_asl='160' then 'LIAB'
when c.cov_asl='170' then 'LIAB'
when c.cov_asl='191' then 'LIAB'
when c.cov_asl='192' then 'LIAB'
when c.cov_asl='211' then 'PROP'
when c.cov_asl='220' then 'PROP'
end,
case when ce.codetype='Fee' then 'Fee' 
else 
 case
  when substring(p.pol_policynumber,3,1)='A' then isnull(ce.Act_ERIS,'OTH')
  when substring(p.pol_policynumber,3,1) in ('F','H') then
   case
    when pe.AltSubTypeCd='DF1' then '03'
    when pe.AltSubTypeCd='DF3' then '03'
    when pe.AltSubTypeCd='DF6' then '06'
    when pe.AltSubTypeCd='FL1-Basic' then '03'
    when pe.AltSubTypeCd='FL1-Vacant' then '03'
    when pe.AltSubTypeCd='FL2-Broad' then '03'
    when pe.AltSubTypeCd='FL3-Special' then '03'
    when pe.AltSubTypeCd='Form3' then '03'
    when pe.AltSubTypeCd like 'HO3%' then '03'
    when pe.AltSubTypeCd='HO4' then '04'
    when pe.AltSubTypeCd='HO6' then '06'
    when pe.AltSubTypeCd='PA' then 'OTH'
   end
  else 'OTH'
 end
end ,
case when ce.codetype='Fee' then 'Y' else 'N' end,
pe.AltSubTypeCd
having sum(wrtn_prem_amt + fees_amt)<>0 or sum(earned_prem_amt)<>0 or sum(ee_rm)<>0
order by report_year, report_quarter;

END;
$$ LANGUAGE plpgsql;