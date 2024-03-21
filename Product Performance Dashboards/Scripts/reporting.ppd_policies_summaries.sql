DROP TABLE IF EXISTS reporting.ppd_policies_summaries;
CREATE TABLE reporting.ppd_policies_summaries	
(	
	product VARCHAR(12) ENCODE lzo,
	subproduct VARCHAR(7) ENCODE lzo,
	month_id INTEGER ENCODE az64 DISTKEY,
	policy_state VARCHAR(50) ENCODE lzo,
	carrier VARCHAR(100) ENCODE lzo,
	company VARCHAR(50) ENCODE lzo,
	policyneworrenewal VARCHAR(10) ENCODE lzo,
	ep NUMERIC(38, 2) ENCODE az64,
	ee NUMERIC(38, 3) ENCODE az64,
	pif BIGINT ENCODE az64,
	loaddate DATE NOT NULL ENCODE runlength
)	
SORTKEY	
(	
	month_id
);	
	
comment on table reporting.ppd_policies_summaries is 'Product performance Dashboard monthly earned premiums, exposures and PIF. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';	
grant select  on reporting.ppd_policies_summaries to report_user;	
