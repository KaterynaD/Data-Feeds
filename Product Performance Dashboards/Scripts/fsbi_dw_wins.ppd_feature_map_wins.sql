CREATE TABLE fsbi_dw_wins.ppd_feature_map_wins						
(						
	aslob VARCHAR(5) ENCODE lzo,					
	rag VARCHAR(5) ENCODE lzo,					
	feature_type VARCHAR(1) ENCODE lzo,					
	feature VARCHAR(10) ENCODE lzo,					
	feature_map VARCHAR(15) ENCODE lzo					
)						
DISTSTYLE EVEN;						
						
COMMENT ON TABLE fsbi_dw_wins.ppd_feature_map_wins IS 'WINS features mapping for Product performance dashboards. Used instead of public.dim_coverageextension because of WINS features complications';						
