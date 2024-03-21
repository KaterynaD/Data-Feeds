DROP TABLE IF EXISTS public.vmfact_claim_blended;	
CREATE TABLE public.vmfact_claim_blended	
(	
	month_id INTEGER ENCODE az64 DISTKEY,
	claim_number VARCHAR(50) ENCODE lzo ,
	catastrophe_id INTEGER ENCODE az64,
	claimant VARCHAR(50) ENCODE lzo,
	feature VARCHAR(75) ENCODE lzo,
	feature_desc VARCHAR(125) ENCODE lzo,
	feature_type VARCHAR(100) ENCODE lzo,
	aslob VARCHAR(5) ENCODE lzo,
	rag VARCHAR(3) ENCODE lzo,
	schedp_part CHAR(2) ENCODE lzo,
	loss_paid NUMERIC(38, 2) ENCODE az64,
	loss_reserve NUMERIC(38, 2) ENCODE az64,
	aoo_paid NUMERIC(38, 2) ENCODE az64,
	aoo_reserve NUMERIC(38, 2) ENCODE az64,
	dcc_paid NUMERIC(38, 2) ENCODE az64,
	dcc_reserve NUMERIC(38, 2) ENCODE az64,
	salvage_received NUMERIC(38, 2) ENCODE az64,
	salvage_reserve NUMERIC(38, 2) ENCODE az64,
	subro_received NUMERIC(38, 2) ENCODE az64,
	subro_reserve NUMERIC(38, 2) ENCODE az64,
	product_code VARCHAR(100) ENCODE lzo,
	product VARCHAR(100) ENCODE lzo,
	subproduct VARCHAR(100) ENCODE lzo,
	carrier VARCHAR(100) ENCODE lzo,
	carrier_group VARCHAR(9) ENCODE lzo,
	company VARCHAR(50) ENCODE lzo,
	policy_state VARCHAR(75) ENCODE lzo,
	policy_number VARCHAR(75) ENCODE lzo,
	policyref INTEGER ENCODE az64,
	poleff_date DATE ENCODE az64,
	polexp_date DATE ENCODE az64,
	producer_code VARCHAR(50) ENCODE lzo,
	loss_date DATE ENCODE az64,
	loss_year INTEGER ENCODE az64,
	reported_date DATE ENCODE az64,
	loss_cause VARCHAR(255) ENCODE lzo,
	source_system VARCHAR(100) ENCODE lzo,
	loaddate DATE NOT NULL ENCODE runlength
)	
INTERLEAVED SORTKEY	
(	
	month_id,
	claim_number,
	source_system
);	
	
comment on table public.vmfact_claim_blended is 'Monthly summaries of public.vmfact_claimtransaction_blended based on month of acct_date';	
	
	
grant select  on public.vmfact_claim_blended to report_user;	
