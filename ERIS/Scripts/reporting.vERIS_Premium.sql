drop view if exists reporting.vERIS_Premium;	
create view reporting.vERIS_Premium as 	
select	
report_year,	
report_quarter,	
RenewalTermCd,	
policyneworrenewal,	
PolicyState,	
CompanyNumber,	
Company,	
LOB,	
ASL,	
LOB2,	
LOB3,	
Product,	
PolicyFormCode,	
ProgramInd,	
producer_status,	
CoverageType,	
Coverage,	
FeeInd,	
sum(WP) WP,	
sum(EP) EP,	
sum(CLEP) CLEP,	
sum(EE) EE,	
AltSubTypeCd	
from reporting.vmERIS_policies	
group by	
report_year,	
report_quarter,	
RenewalTermCd,	
policyneworrenewal,	
PolicyState,	
CompanyNumber,	
Company,	
LOB,	
ASL,	
LOB2,	
LOB3,	
Product,	
PolicyFormCode,	
ProgramInd,	
producer_status,	
CoverageType,	
Coverage,	
FeeInd,	
AltSubTypeCd;	
	
comment on view reporting.vERIS_Premium is 'ERIS Premiums aggregated level. Business Owner: Pierre-Antoine Espagnet <pespagnet@cseinsurance.com>';	
	
comment on column reporting.vERIS_Premium.report_year	 is 'Based on policy transaction accounting date';
comment on column reporting.vERIS_Premium.report_quarter	 is 'Based on policy transaction accounting date';
comment on column reporting.vERIS_Premium.lob	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vERIS_Premium.lob2	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vERIS_Premium.lob3	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vERIS_Premium.product	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vERIS_Premium.programind	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vERIS_Premium.coveragetype	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vERIS_Premium.coverage	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vERIS_Premium.wp	 is 'Sum of Written Premium';
comment on column reporting.vERIS_Premium.ep	 is 'Sum of Earned Premium';
comment on column reporting.vERIS_Premium.clep	 is 'Sum of Current Level Earned Premium: Earned premium adjusted using all rate changes starting after policy term effecyive date, based on company,  state, policyformcode,  new or renewal policy. ';
comment on column reporting.vERIS_Premium.AltSubTypeCd is 'The same as PolicyFormCd almost in all cases except HO3-Homegurad as on 2022/06';	
