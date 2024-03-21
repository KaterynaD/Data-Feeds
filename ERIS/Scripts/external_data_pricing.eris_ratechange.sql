drop table if exists external_data_pricing.eris_ratechange;											
create external table external_data_pricing.eris_ratechange(											
ratechange_id integer,											
ratechange_name VARCHAR(10),											
statecd VARCHAR(2),											
linecd VARCHAR(15),											
carriercd VARCHAR(10),											
AltSubTypeCd VARCHAR(20),											
coverage VARCHAR(5),											
startdt DATE,											
nb_change NUMERIC(5, 2),											
renewal_change NUMERIC(5, 2),											
comments VARCHAR(255)											
)											
row format delimited											
fields terminated by ','											
stored as textfile											
location  's3://cse-bi/RedshiftSpectrum/IA Pricing/ERIS_RATECHANGE/' 											
table properties ('skip.header.line.count'='1','invalid_char_handling'='DROP_ROW','data_cleansing_enabled'='true');											
