DROP TABLE IF EXISTS reporting.vmeris_policies	;
CREATE TABLE reporting.vmeris_policies	
(	
report_year INTEGER ENCODE az64,	
report_quarter INTEGER ENCODE az64,	
policynumber VARCHAR(50) ENCODE lzo,	
policy_id INTEGER NOT NULL ENCODE lzo DISTKEY,	
policy_uniqueid VARCHAR(100) ENCODE lzo,	
riskcd VARCHAR(12) ENCODE lzo,	
policyversion VARCHAR(10) ENCODE lzo,	
effectivedate DATE ENCODE az64,	
expirationdate DATE ENCODE az64,	
renewaltermcd VARCHAR(255) ENCODE lzo,	
policyneworrenewal VARCHAR(10) ENCODE lzo,	
policystate VARCHAR(50) ENCODE lzo,	
companynumber VARCHAR(50) ENCODE lzo,	
company VARCHAR(100) ENCODE lzo,	
lob VARCHAR(3) ENCODE lzo,	
asl VARCHAR(5) ENCODE lzo,	
lob2 VARCHAR(3) ENCODE lzo,	
lob3 VARCHAR(3) ENCODE lzo,	
product VARCHAR(2) ENCODE lzo,	
policyformcode VARCHAR(255) ENCODE lzo,	
programind VARCHAR(6) ENCODE lzo,	
producer_status VARCHAR(10) ENCODE lzo,	
coveragetype VARCHAR(4) ENCODE lzo,	
coverage VARCHAR(5) ENCODE lzo,	
feeind VARCHAR(1) ENCODE lzo,	
source VARCHAR(5) ENCODE lzo,	
wp NUMERIC(38, 2) ENCODE az64,	
ep NUMERIC(38, 2) ENCODE az64,	
clep DOUBLE PRECISION,	
ee NUMERIC(38, 3) ENCODE az64,	
loaddate DATE NOT NULL ENCODE runlength,	
AltSubTypeCd VARCHAR(20) ENCODE lzo	
)	
SORTKEY	
(	
report_year,report_quarter	
);	
	
comment on table reporting.vmERIS_Policies is 'ERIS Premiums detail level. Business Owner: Pierre-Antoine Espagnet <pespagnet@cseinsurance.com>';	
	
comment on column reporting.vmeris_policies.report_year	 is 'Based on policy transaction accounting date';
comment on column reporting.vmeris_policies.report_quarter	 is 'Based on policy transaction accounting date';
comment on column reporting.vmeris_policies.lob	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vmeris_policies.lob2	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vmeris_policies.lob3	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vmeris_policies.product	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vmeris_policies.programind	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vmeris_policies.coveragetype	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vmeris_policies.coverage	 is 'See Configuration in ERIS Tables Design document';
comment on column reporting.vmeris_policies.wp	 is 'Written Premium';
comment on column reporting.vmeris_policies.ep	 is 'Earned Premium';
comment on column reporting.vmeris_policies.clep	 is 'Current Level Earned Premium: Earned premium adjusted using all rate changes starting after policy term effecyive date, based on company,  state, policyformcode,  new or renewal policy. ';
comment on column reporting.vmeris_policies.AltSubTypeCd is 'The same as PolicyFormCd almost in all cases except HO3-Homegurad as on 2022/06';	
