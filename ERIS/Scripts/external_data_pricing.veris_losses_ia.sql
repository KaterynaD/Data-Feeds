drop table if exists external_data_pricing.veris_losses_ia;						
create external table external_data_pricing.veris_losses_ia(						
	devq BIGINT,					
	loss_qtr DOUBLE PRECISION,					
	loss_year DOUBLE PRECISION,					
	reported_qtr INTEGER,					
	reported_year INTEGER,					
	cat_indicator VARCHAR(3),					
	carrier VARCHAR(100),					
	company VARCHAR(50),					
	lob VARCHAR(3),					
	lob2 VARCHAR(3),					
	lob3 VARCHAR(3),					
	product VARCHAR(2),					
	policystate VARCHAR(2),					
	programind VARCHAR(6),					
	featuretype VARCHAR(4),					
	feature VARCHAR(5),					
	renewaltermcd VARCHAR(255),					
	policyneworrenewal VARCHAR(7),					
	claim_status VARCHAR(6),					
	producer_status VARCHAR(10),					
	source_system VARCHAR(5),					
	qtd_paid_dcc_expense NUMERIC(38, 2),					
	qtd_paid_expense NUMERIC(38, 2),					
	qtd_incurred_expense NUMERIC(38, 2),					
	qtd_incurred_dcc_expense NUMERIC(38, 2),					
	qtd_paid_salvage_and_subrogation NUMERIC(38, 2),					
	qtd_paid_loss NUMERIC(38, 2),					
	qtd_incurred_loss NUMERIC(38, 2),					
	qtd_paid NUMERIC(38, 2),					
	qtd_incurred NUMERIC(38, 2),					
	qtd_incurred_net_salvage_subrogation NUMERIC(38, 2),					
	qtd_total_incurred_los NUMERIC(38, 2),					
	paid_on_closed_salvage_subrogation NUMERIC(38, 2),					
	qtd_paid_25k NUMERIC(38, 2),					
	qtd_paid_50k NUMERIC(38, 2),					
	qtd_paid_100k NUMERIC(38, 2),					
	qtd_paid_250k NUMERIC(38, 2),					
	qtd_paid_500k NUMERIC(38, 2),					
	qtd_paid_1m NUMERIC(38, 2),					
	qtd_incurred_net_salvage_subrogation_25k NUMERIC(38, 2),					
	qtd_incurred_net_salvage_subrogation_50k NUMERIC(38, 2),					
	qtd_incurred_net_salvage_subrogation_100k NUMERIC(38, 2),					
	qtd_incurred_net_salvage_subrogation_250k NUMERIC(38, 2),					
	qtd_incurred_net_salvage_subrogation_500k NUMERIC(38, 2),					
	qtd_incurred_net_salvage_subrogation_1m NUMERIC(38, 2),					
	reported_count BIGINT,					
	closed_count BIGINT,					
	closed_nopay BIGINT,					
	paid_on_closed_loss NUMERIC(38, 2),					
	paid_on_closed_expense NUMERIC(38, 2),					
	paid_on_closed_dcc_expense NUMERIC(38, 2),					
	paid_count BIGINT,					
	PolicyFormCode VARCHAR(20),					
	AltSubTypeCd VARCHAR(20)					
)						
partitioned by (quarter_id VARCHAR(7), snapshot_id VARCHAR(8))						
stored as PARQUET						
location  's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/'						
TABLE PROPERTIES ( 'write.parallel'='off' );						
						
						
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2021q02', snapshot_id='20220705') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2021q02/snapshot_id=20220705/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2021q03', snapshot_id='20220215') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2021q03/snapshot_id=20220215/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2021q04', snapshot_id='20220215') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2021q04/snapshot_id=20220215/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2021q02', snapshot_id='20220215') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2021q02/snapshot_id=20220215/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2021q04', snapshot_id='20220309') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2021q04/snapshot_id=20220309/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2022q01', snapshot_id='20220401') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2022q01/snapshot_id=20220401/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2022q02', snapshot_id='20220705') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2022q02/snapshot_id=20220705/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2022q03', snapshot_id='20221003') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2022q03/snapshot_id=20221003/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2022q04', snapshot_id='20230110') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2022q04/snapshot_id=20230110/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2022q01', snapshot_id='20220504') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2022q01/snapshot_id=20220504/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2022q02', snapshot_id='20220725') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2022q02/snapshot_id=20220725/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2022q03', snapshot_id='20221114') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2022q03/snapshot_id=20221114/';					
alter table external_data_pricing.veris_losses_ia	add if not exists partition( quarter_id='2023q01', snapshot_id='20230104') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_LOSSES/quarter_id=2023q01/snapshot_id=20230104/';					
