DROP TABLE IF EXISTS reporting.ppd_claims;
CREATE TABLE reporting.ppd_claims	
(	
	month_id INTEGER DISTKEY,
	policy_state VARCHAR(75) ENCODE lzo,
	carrier VARCHAR(100) ENCODE lzo,
	company VARCHAR(50) ENCODE lzo,
	policyneworrenewal VARCHAR(7) ENCODE lzo,
	product VARCHAR(100) ENCODE lzo,
	cat_flg VARCHAR(3) ENCODE lzo,
	perilgroup VARCHAR(9) ENCODE lzo,
	claim_number VARCHAR(50),
	claimant VARCHAR(50) ENCODE lzo,
	rag VARCHAR(5) ENCODE lzo,
	feature_type VARCHAR(100) ENCODE lzo,
	feature_map VARCHAR(20) ENCODE lzo,
	clm_total_incurred_loss NUMERIC(38, 2) ENCODE az64,
	clm_cumulative_total_incurred_loss NUMERIC(38, 2) ENCODE az64,
	clm_loss_incurred NUMERIC(38, 2) ENCODE az64,
	clm_cumulative_loss_incurred NUMERIC(38, 2) ENCODE az64,
	clm_alae_incurred NUMERIC(38, 2) ENCODE az64,
	clm_cumulative_alae_incurred NUMERIC(38, 2) ENCODE az64,
	clm_salsub_received NUMERIC(38, 2) ENCODE az64,
	clm_cumulative_salsub_received NUMERIC(38, 2) ENCODE az64,
	feat_total_incurred_loss NUMERIC(38, 2) ENCODE az64,
	feat_cumulative_total_incurred_loss NUMERIC(38, 2) ENCODE az64,
	feat_total_reserve NUMERIC(38, 2) ENCODE az64,
	feat_cumulative_total_reserve NUMERIC(38, 2) ENCODE az64,
	feat_reported_count INTEGER ENCODE az64,
	feat_closed_count INTEGER ENCODE az64,
	feat_open_count INTEGER ENCODE az64,
	feat_reported_count_100k INTEGER ENCODE az64,
	feat_loss_incurred NUMERIC(38, 2) ENCODE az64,
	feat_cumulative_loss_incurred NUMERIC(38, 2) ENCODE az64,
	feat_alae_incurred NUMERIC(38, 2) ENCODE az64,
	feat_cumulative_alae_incurred NUMERIC(38, 2) ENCODE az64,
	feat_salsub_received NUMERIC(38, 2) ENCODE az64,
	feat_cumulative_salsub_received NUMERIC(38, 2) ENCODE az64,
	clm_capped_cumulative_total_incurred_100k NUMERIC(38, 2) ENCODE az64,
	ratio DOUBLE PRECISION,
	feat_capped_cumulative_total_incurred_100k DOUBLE PRECISION,
	feat_capped_cumulative_loss_incurred_100k DOUBLE PRECISION,
	feat_capped_cumulative_alae_incurred_100k DOUBLE PRECISION,
	feat_capped_cumulative_salsub_received_100k DOUBLE PRECISION,
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
	
comment on table reporting.ppd_claims is 'Product performance Dashboard Claims calculations. Business Owner: Suraj Setlur <ssetlur@cseinsurance.com>';	
	
	
grant select  on reporting.ppd_claims to report_user;	
