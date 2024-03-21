DROP TABLE IF EXISTS reporting.ppd_claim_summaries;			
CREATE TABLE reporting.ppd_claim_summaries			
(			
	month_id INTEGER ENCODE az64 DISTKEY,		
	claim_number VARCHAR(50) ENCODE lzo,		
	claimant VARCHAR(50) ENCODE lzo,		
	policy_state VARCHAR(75) ENCODE lzo,		
	carrier VARCHAR(100) ENCODE lzo,		
	company VARCHAR(50) ENCODE lzo,		
	policyneworrenewal VARCHAR(7) ENCODE lzo,		
	cat_flg VARCHAR(3) ENCODE lzo,		
	perilgroup VARCHAR(9) ENCODE lzo,		
	loss_cause VARCHAR(255) ENCODE lzo,		
	product VARCHAR(100) ENCODE lzo,		
	rag VARCHAR(5) ENCODE lzo,		
	feature_type VARCHAR(100) ENCODE lzo,		
	feature_map VARCHAR(20) ENCODE lzo,		
	total_incurred_loss NUMERIC(38, 2) ENCODE az64,		
	loss_incurred NUMERIC(38, 2) ENCODE az64,		
	alae_incurred NUMERIC(38, 2) ENCODE az64,		
	alae_paid NUMERIC(38, 2) ENCODE az64,		
	salsub_incurred NUMERIC(38, 2) ENCODE az64,		
	salsub_received NUMERIC(38, 2) ENCODE az64,		
	total_reserve NUMERIC(38, 2) ENCODE az64,		
	loaddate DATE NOT NULL ENCODE runlength		
)			
INTERLEAVED SORTKEY			
(			
	month_id,		
	claim_number,		
	claimant,		
	feature_type,		
	feature_map		
);			
			
comment on table reporting.ppd_claim_summaries is 'Product performance Dashboard Claims base Monthly summaries. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';			
			
			
grant select  on reporting.ppd_claim_summaries to report_user;			
