drop table if exists external_data_pricing.veris_premium_ia;												
create external table external_data_pricing.veris_premium_ia(												
	report_year INTEGER,											
	report_quarter INTEGER,											
	renewaltermcd VARCHAR(255),											
	policyneworrenewal VARCHAR(10),											
	policystate VARCHAR(50),											
	companynumber VARCHAR(50),											
	company VARCHAR(100),											
	lob VARCHAR(3),											
	asl VARCHAR(5),											
	lob2 VARCHAR(3),											
	lob3 VARCHAR(3),											
	product VARCHAR(2),											
	policyformcode VARCHAR(255),											
	programind VARCHAR(6),											
	producer_status VARCHAR(10),											
	coveragetype VARCHAR(4),											
	coverage VARCHAR(5),											
	feeind VARCHAR(1) ,											
	wp NUMERIC(38, 2),											
	ep NUMERIC(38, 2),											
	clep DOUBLE PRECISION,											
	ee NUMERIC(38, 3)		,									
	AltSubTypeCd VARCHAR(20)											
)												
partitioned by (quarter_id VARCHAR(7), snapshot_id VARCHAR(8))												
stored as PARQUET												
location  's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/'												
TABLE PROPERTIES ( 'write.parallel'='off' );												
												
												
												
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2021q02', snapshot_id='20220217') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2021q02/snapshot_id=20220217/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2021q03', snapshot_id='20220217') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2021q03/snapshot_id=20220217/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2021q04', snapshot_id='20220216') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2021q04/snapshot_id=20220216/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2021q04', snapshot_id='20220217') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2021q04/snapshot_id=20220217/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2022q01', snapshot_id='20220401') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2022q01/snapshot_id=20220401/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2022q02', snapshot_id='20220705') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2022q02/snapshot_id=20220705/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2022q03', snapshot_id='20221003') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2022q03/snapshot_id=20221003/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2022q04', snapshot_id='20230130') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2022q04/snapshot_id=20230130/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2022q02', snapshot_id='20220725') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2022q02/snapshot_id=20220725/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2022q03', snapshot_id='20221114') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2022q03/snapshot_id=20221114/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2022q04', snapshot_id='20230227') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2022q04/snapshot_id=20230227/';											
alter table external_data_pricing.veris_premium_ia	add if not exists partition( quarter_id='2023q01', snapshot_id='20230401') location 's3://cse-bi/RedshiftSpectrum/IA Pricing/VERIS_PREMIUM/quarter_id=2023q01/snapshot_id=20230401/';											
												
