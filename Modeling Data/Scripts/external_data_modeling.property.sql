drop  table if exists external_data_modeling.property;			
create external table external_data_modeling.property(			
modeldata_id	INTEGER ,		
systemidstart	INTEGER ,		
systemidend	INTEGER ,		
cal_year	INTEGER ,		
startdate	DATE ,		
enddate	TIMESTAMP ,		
startdatetm	TIMESTAMP ,		
enddatetm	TIMESTAMP ,		
ecy	NUMERIC(25,	4)	,
cova_ep	NUMERIC(38,	6)	,
covb_ep	NUMERIC(38,	6)	,
covc_ep	NUMERIC(38,	6)	,
covd_ep	NUMERIC(38,	6)	,
cove_ep	NUMERIC(38,	6)	,
covf_ep	NUMERIC(38,	6)	,
policynumber	VARCHAR(50) ,		
policy_uniqueid	VARCHAR(100) ,		
inceptiondt	TIMESTAMP ,		
policyterm	VARCHAR(10) ,		
policytype	VARCHAR(7) ,		
effectivedate	DATE ,		
expirationdate	DATE ,		
policystate	VARCHAR(50) ,		
policyform	VARCHAR(255) ,		
persistencydiscountdt	DATE ,		
persistency	INTEGER ,		
companycd	VARCHAR(50) ,		
carriercd	VARCHAR(100) ,		
installmentfee	VARCHAR(255) ,		
nsffee	VARCHAR(255) ,		
latefee	VARCHAR(255) ,		
programind	VARCHAR(255) ,		
cseemployeediscountind	VARCHAR(255) ,		
liabilitylimitolt	VARCHAR(20) ,		
liabilitylimitcpl	VARCHAR(255) ,		
personalinjuryind	VARCHAR(765) ,		
producercode	VARCHAR(50) ,		
producername	VARCHAR(255) ,		
produceraddress	VARCHAR(510) ,		
producercity	VARCHAR(80) ,		
producerstate	VARCHAR(50) ,		
producerpostalcode	VARCHAR(20) ,		
producer_status	VARCHAR(10) ,		
territory	VARCHAR(50) ,		
risk_uniqueid	VARCHAR(100) ,		
risknumber	INTEGER ,		
risktype	VARCHAR(255) ,		
state	VARCHAR(255) ,		
county	VARCHAR(255) ,		
postalcode	VARCHAR(255) ,		
city	VARCHAR(255) ,		
addr1	VARCHAR(255) ,		
addr2	VARCHAR(255) ,		
building_uniqueid	VARCHAR(255) ,		
yearbuilt	INTEGER ,		
sqft	INTEGER ,		
stories	INTEGER ,		
roofcd	VARCHAR(255) ,		
units	INTEGER ,		
occupancycd	VARCHAR(255) ,		
allperilded	VARCHAR(255) ,		
waterded	VARCHAR(16) ,		
protectionclass	VARCHAR(255) ,		
constructioncd	VARCHAR(255) ,		
reportedfirelineassessment	VARCHAR(255) ,		
firehazardscore	VARCHAR(255) ,		
reportedfirehazardscore	VARCHAR(255) ,		
multipolicyind	VARCHAR(765) ,		
multipolicynumber	VARCHAR(255) ,		
multipolicyindumbrella	VARCHAR(765) ,		
multipolicynumberumbrella	VARCHAR(255) ,		
earthquakeumbrellaind	VARCHAR(9) ,		
usagetype	VARCHAR(255) ,		
secondaryresidence	VARCHAR(3) ,		
ordinanceorlawpct	INTEGER ,		
functionalreplacementcost	VARCHAR(4) ,		
homegardcreditind	VARCHAR(765) ,		
sprinklersystem	VARCHAR(765) ,		
landlordind	VARCHAR(765) ,		
cseagent	VARCHAR(9) ,		
rentersinsurance	VARCHAR(9) ,		
firealarmtype	VARCHAR(765) ,		
burglaryalarmtype	VARCHAR(765) ,		
waterdetectiondevice	VARCHAR(9) ,		
neighborhoodcrimewatchind	VARCHAR(765) ,		
propertymanager	VARCHAR(9) ,		
safeguardplusind	VARCHAR(765) ,		
deluxepackageind	VARCHAR(9) ,		
ratingtier	VARCHAR(255) ,		
wuiclass	VARCHAR(30) ,		
kitchenfireextinguisherind	VARCHAR(765) ,		
smokedetector	VARCHAR(765) ,		
gatedcommunityind	VARCHAR(765) ,		
deadboltind	VARCHAR(765) ,		
poolind	VARCHAR(765) ,		
replacementcostdwellingind	VARCHAR(765) ,		
replacementvalueind	VARCHAR(765) ,		
serviceline	VARCHAR(12) ,		
equipmentbreakdown	VARCHAR(765) ,		
tenantevictions	VARCHAR(765) ,		
lossassessment	VARCHAR(16) ,		
numberoffamilies	INTEGER ,		
insuredfirstname	VARCHAR(200) ,		
insuredlastname	VARCHAR(200) ,		
insureddob	TIMESTAMP ,		
insuredage	BIGINT ,		
maritalstatus	VARCHAR(256) ,		
insurancescore	VARCHAR(255) ,		
overriddeninsurancescore	VARCHAR(255) ,		
insurancescorevalue	VARCHAR(5) ,		
ratepageeffectivedt	TIMESTAMP ,		
insscoretiervalueband	VARCHAR(20) ,		
applieddt	DATE ,		
financialstabilitytier	VARCHAR(20) ,		
allcov_wp	NUMERIC(38,	2)	,
allcov_lossinc	NUMERIC(38,	2)	,
allcov_lossdcce	NUMERIC(38,	2)	,
allcov_lossalae	NUMERIC(38,	2)	,
cova_wp	NUMERIC(38,	2)	,
covb_wp	NUMERIC(38,	2)	,
covc_wp	NUMERIC(38,	2)	,
covd_wp	NUMERIC(38,	2)	,
cove_wp	NUMERIC(38,	2)	,
covf_wp	NUMERIC(38,	2)	,
cova_deductible	VARCHAR(255) ,		
covb_deductible	VARCHAR(255) ,		
covc_deductible	VARCHAR(255) ,		
covd_deductible	VARCHAR(255) ,		
cove_deductible	VARCHAR(255) ,		
covf_deductible	VARCHAR(255) ,		
cova_limit	VARCHAR(255) ,		
covb_limit	VARCHAR(255) ,		
covc_limit	VARCHAR(255) ,		
covcincreasedlimit	INTEGER ,		
covd_limit	VARCHAR(255) ,		
cove_limit	VARCHAR(255) ,		
covf_limit	VARCHAR(255) ,		
onpremises_theft_limit	VARCHAR(255) ,		
awayfrompremises_theft_limit	VARCHAR(255) ,		
quality_polappinconsistency_flg	VARCHAR(3) ,		
quality_riskidduplicates_flg	VARCHAR(3) ,		
quality_claimok_flg	INTEGER ,		
quality_claimpolicytermjoin_flg	INTEGER ,		
covabcdefliab_loss	NUMERIC(38,	2)	,
covabcdefliab_claim_count	INTEGER ,		
cat_covabcdefliab_loss	NUMERIC(38,	2)	,
cat_covabcdefliab_claim_count	INTEGER ,		
cova_il_nc_water	NUMERIC(38,	2)	,
cova_il_nc_wh	NUMERIC(38,	2)	,
cova_il_nc_tv	NUMERIC(38,	2)	,
cova_il_nc_fl	NUMERIC(38,	2)	,
cova_il_nc_ao	NUMERIC(38,	2)	,
cova_il_cat_fire	NUMERIC(38,	2)	,
cova_il_cat_ao	NUMERIC(38,	2)	,
covb_il_nc_water	NUMERIC(38,	2)	,
covb_il_nc_wh	NUMERIC(38,	2)	,
covb_il_nc_tv	NUMERIC(38,	2)	,
covb_il_nc_fl	NUMERIC(38,	2)	,
covb_il_nc_ao	NUMERIC(38,	2)	,
covb_il_cat_fire	NUMERIC(38,	2)	,
covb_il_cat_ao	NUMERIC(38,	2)	,
covc_il_nc_water	NUMERIC(38,	2)	,
covc_il_nc_wh	NUMERIC(38,	2)	,
covc_il_nc_tv	NUMERIC(38,	2)	,
covc_il_nc_fl	NUMERIC(38,	2)	,
covc_il_nc_ao	NUMERIC(38,	2)	,
covc_il_cat_fire	NUMERIC(38,	2)	,
covc_il_cat_ao	NUMERIC(38,	2)	,
covd_il_nc_water	NUMERIC(38,	2)	,
covd_il_nc_wh	NUMERIC(38,	2)	,
covd_il_nc_tv	NUMERIC(38,	2)	,
covd_il_nc_fl	NUMERIC(38,	2)	,
covd_il_nc_ao	NUMERIC(38,	2)	,
covd_il_cat_fire	NUMERIC(38,	2)	,
covd_il_cat_ao	NUMERIC(38,	2)	,
cove_il_nc_water	NUMERIC(38,	2)	,
cove_il_nc_wh	NUMERIC(38,	2)	,
cove_il_nc_tv	NUMERIC(38,	2)	,
cove_il_nc_fl	NUMERIC(38,	2)	,
cove_il_nc_ao	NUMERIC(38,	2)	,
cove_il_cat_fire	NUMERIC(38,	2)	,
cove_il_cat_ao	NUMERIC(38,	2)	,
covf_il_nc_water	NUMERIC(38,	2)	,
covf_il_nc_wh	NUMERIC(38,	2)	,
covf_il_nc_tv	NUMERIC(38,	2)	,
covf_il_nc_fl	NUMERIC(38,	2)	,
covf_il_nc_ao	NUMERIC(38,	2)	,
covf_il_cat_fire	NUMERIC(38,	2)	,
covf_il_cat_ao	NUMERIC(38,	2)	,
liab_il_nc_water	NUMERIC(38,	2)	,
liab_il_nc_wh	NUMERIC(38,	2)	,
liab_il_nc_tv	NUMERIC(38,	2)	,
liab_il_nc_fl	NUMERIC(38,	2)	,
liab_il_nc_ao	NUMERIC(38,	2)	,
liab_il_cat_fire	NUMERIC(38,	2)	,
liab_il_cat_ao	NUMERIC(38,	2)	,
cova_il_dcce_nc_water	NUMERIC(38,	2)	,
cova_il_dcce_nc_wh	NUMERIC(38,	2)	,
cova_il_dcce_nc_tv	NUMERIC(38,	2)	,
cova_il_dcce_nc_fl	NUMERIC(38,	2)	,
cova_il_dcce_nc_ao	NUMERIC(38,	2)	,
cova_il_dcce_cat_fire	NUMERIC(38,	2)	,
cova_il_dcce_cat_ao	NUMERIC(38,	2)	,
covb_il_dcce_nc_water	NUMERIC(38,	2)	,
covb_il_dcce_nc_wh	NUMERIC(38,	2)	,
covb_il_dcce_nc_tv	NUMERIC(38,	2)	,
covb_il_dcce_nc_fl	NUMERIC(38,	2)	,
covb_il_dcce_nc_ao	NUMERIC(38,	2)	,
covb_il_dcce_cat_fire	NUMERIC(38,	2)	,
covb_il_dcce_cat_ao	NUMERIC(38,	2)	,
covc_il_dcce_nc_water	NUMERIC(38,	2)	,
covc_il_dcce_nc_wh	NUMERIC(38,	2)	,
covc_il_dcce_nc_tv	NUMERIC(38,	2)	,
covc_il_dcce_nc_fl	NUMERIC(38,	2)	,
covc_il_dcce_nc_ao	NUMERIC(38,	2)	,
covc_il_dcce_cat_fire	NUMERIC(38,	2)	,
covc_il_dcce_cat_ao	NUMERIC(38,	2)	,
covd_il_dcce_nc_water	NUMERIC(38,	2)	,
covd_il_dcce_nc_wh	NUMERIC(38,	2)	,
covd_il_dcce_nc_tv	NUMERIC(38,	2)	,
covd_il_dcce_nc_fl	NUMERIC(38,	2)	,
covd_il_dcce_nc_ao	NUMERIC(38,	2)	,
covd_il_dcce_cat_fire	NUMERIC(38,	2)	,
covd_il_dcce_cat_ao	NUMERIC(38,	2)	,
cove_il_dcce_nc_water	NUMERIC(38,	2)	,
cove_il_dcce_nc_wh	NUMERIC(38,	2)	,
cove_il_dcce_nc_tv	NUMERIC(38,	2)	,
cove_il_dcce_nc_fl	NUMERIC(38,	2)	,
cove_il_dcce_nc_ao	NUMERIC(38,	2)	,
cove_il_dcce_cat_fire	NUMERIC(38,	2)	,
cove_il_dcce_cat_ao	NUMERIC(38,	2)	,
covf_il_dcce_nc_water	NUMERIC(38,	2)	,
covf_il_dcce_nc_wh	NUMERIC(38,	2)	,
covf_il_dcce_nc_tv	NUMERIC(38,	2)	,
covf_il_dcce_nc_fl	NUMERIC(38,	2)	,
covf_il_dcce_nc_ao	NUMERIC(38,	2)	,
covf_il_dcce_cat_fire	NUMERIC(38,	2)	,
covf_il_dcce_cat_ao	NUMERIC(38,	2)	,
liab_il_dcce_nc_water	NUMERIC(38,	2)	,
liab_il_dcce_nc_wh	NUMERIC(38,	2)	,
liab_il_dcce_nc_tv	NUMERIC(38,	2)	,
liab_il_dcce_nc_fl	NUMERIC(38,	2)	,
liab_il_dcce_nc_ao	NUMERIC(38,	2)	,
liab_il_dcce_cat_fire	NUMERIC(38,	2)	,
liab_il_dcce_cat_ao	NUMERIC(38,	2)	,
cova_il_alae_nc_water	NUMERIC(38,	2)	,
cova_il_alae_nc_wh	NUMERIC(38,	2)	,
cova_il_alae_nc_tv	NUMERIC(38,	2)	,
cova_il_alae_nc_fl	NUMERIC(38,	2)	,
cova_il_alae_nc_ao	NUMERIC(38,	2)	,
cova_il_alae_cat_fire	NUMERIC(38,	2)	,
cova_il_alae_cat_ao	NUMERIC(38,	2)	,
covb_il_alae_nc_water	NUMERIC(38,	2)	,
covb_il_alae_nc_wh	NUMERIC(38,	2)	,
covb_il_alae_nc_tv	NUMERIC(38,	2)	,
covb_il_alae_nc_fl	NUMERIC(38,	2)	,
covb_il_alae_nc_ao	NUMERIC(38,	2)	,
covb_il_alae_cat_fire	NUMERIC(38,	2)	,
covb_il_alae_cat_ao	NUMERIC(38,	2)	,
covc_il_alae_nc_water	NUMERIC(38,	2)	,
covc_il_alae_nc_wh	NUMERIC(38,	2)	,
covc_il_alae_nc_tv	NUMERIC(38,	2)	,
covc_il_alae_nc_fl	NUMERIC(38,	2)	,
covc_il_alae_nc_ao	NUMERIC(38,	2)	,
covc_il_alae_cat_fire	NUMERIC(38,	2)	,
covc_il_alae_cat_ao	NUMERIC(38,	2)	,
covd_il_alae_nc_water	NUMERIC(38,	2)	,
covd_il_alae_nc_wh	NUMERIC(38,	2)	,
covd_il_alae_nc_tv	NUMERIC(38,	2)	,
covd_il_alae_nc_fl	NUMERIC(38,	2)	,
covd_il_alae_nc_ao	NUMERIC(38,	2)	,
covd_il_alae_cat_fire	NUMERIC(38,	2)	,
covd_il_alae_cat_ao	NUMERIC(38,	2)	,
cove_il_alae_nc_water	NUMERIC(38,	2)	,
cove_il_alae_nc_wh	NUMERIC(38,	2)	,
cove_il_alae_nc_tv	NUMERIC(38,	2)	,
cove_il_alae_nc_fl	NUMERIC(38,	2)	,
cove_il_alae_nc_ao	NUMERIC(38,	2)	,
cove_il_alae_cat_fire	NUMERIC(38,	2)	,
cove_il_alae_cat_ao	NUMERIC(38,	2)	,
covf_il_alae_nc_water	NUMERIC(38,	2)	,
covf_il_alae_nc_wh	NUMERIC(38,	2)	,
covf_il_alae_nc_tv	NUMERIC(38,	2)	,
covf_il_alae_nc_fl	NUMERIC(38,	2)	,
covf_il_alae_nc_ao	NUMERIC(38,	2)	,
covf_il_alae_cat_fire	NUMERIC(38,	2)	,
covf_il_alae_cat_ao	NUMERIC(38,	2)	,
liab_il_alae_nc_water	NUMERIC(38,	2)	,
liab_il_alae_nc_wh	NUMERIC(38,	2)	,
liab_il_alae_nc_tv	NUMERIC(38,	2)	,
liab_il_alae_nc_fl	NUMERIC(38,	2)	,
liab_il_alae_nc_ao	NUMERIC(38,	2)	,
liab_il_alae_cat_fire	NUMERIC(38,	2)	,
liab_il_alae_cat_ao	NUMERIC(38,	2)	,
cova_ic_nc_water	INTEGER ,		
cova_ic_nc_wh	INTEGER ,		
cova_ic_nc_tv	INTEGER ,		
cova_ic_nc_fl	INTEGER ,		
cova_ic_nc_ao	INTEGER ,		
cova_ic_cat_fire	INTEGER ,		
cova_ic_cat_ao	INTEGER ,		
covb_ic_nc_water	INTEGER ,		
covb_ic_nc_wh	INTEGER ,		
covb_ic_nc_tv	INTEGER ,		
covb_ic_nc_fl	INTEGER ,		
covb_ic_nc_ao	INTEGER ,		
covb_ic_cat_fire	INTEGER ,		
covb_ic_cat_ao	INTEGER ,		
covc_ic_nc_water	INTEGER ,		
covc_ic_nc_wh	INTEGER ,		
covc_ic_nc_tv	INTEGER ,		
covc_ic_nc_fl	INTEGER ,		
covc_ic_nc_ao	INTEGER ,		
covc_ic_cat_fire	INTEGER ,		
covc_ic_cat_ao	INTEGER ,		
covd_ic_nc_water	INTEGER ,		
covd_ic_nc_wh	INTEGER ,		
covd_ic_nc_tv	INTEGER ,		
covd_ic_nc_fl	INTEGER ,		
covd_ic_nc_ao	INTEGER ,		
covd_ic_cat_fire	INTEGER ,		
covd_ic_cat_ao	INTEGER ,		
cove_ic_nc_water	INTEGER ,		
cove_ic_nc_wh	INTEGER ,		
cove_ic_nc_tv	INTEGER ,		
cove_ic_nc_fl	INTEGER ,		
cove_ic_nc_ao	INTEGER ,		
cove_ic_cat_fire	INTEGER ,		
cove_ic_cat_ao	INTEGER ,		
covf_ic_nc_water	INTEGER ,		
covf_ic_nc_wh	INTEGER ,		
covf_ic_nc_tv	INTEGER ,		
covf_ic_nc_fl	INTEGER ,		
covf_ic_nc_ao	INTEGER ,		
covf_ic_cat_fire	INTEGER ,		
covf_ic_cat_ao	INTEGER ,		
liab_ic_nc_water	INTEGER ,		
liab_ic_nc_wh	INTEGER ,		
liab_ic_nc_tv	INTEGER ,		
liab_ic_nc_fl	INTEGER ,		
liab_ic_nc_ao	INTEGER ,		
liab_ic_cat_fire	INTEGER ,		
liab_ic_cat_ao	INTEGER ,		
cova_ic_dcce_nc_water	INTEGER ,		
cova_ic_dcce_nc_wh	INTEGER ,		
cova_ic_dcce_nc_tv	INTEGER ,		
cova_ic_dcce_nc_fl	INTEGER ,		
cova_ic_dcce_nc_ao	INTEGER ,		
cova_ic_dcce_cat_fire	INTEGER ,		
cova_ic_dcce_cat_ao	INTEGER ,		
covb_ic_dcce_nc_water	INTEGER ,		
covb_ic_dcce_nc_wh	INTEGER ,		
covb_ic_dcce_nc_tv	INTEGER ,		
covb_ic_dcce_nc_fl	INTEGER ,		
covb_ic_dcce_nc_ao	INTEGER ,		
covb_ic_dcce_cat_fire	INTEGER ,		
covb_ic_dcce_cat_ao	INTEGER ,		
covc_ic_dcce_nc_water	INTEGER ,		
covc_ic_dcce_nc_wh	INTEGER ,		
covc_ic_dcce_nc_tv	INTEGER ,		
covc_ic_dcce_nc_fl	INTEGER ,		
covc_ic_dcce_nc_ao	INTEGER ,		
covc_ic_dcce_cat_fire	INTEGER ,		
covc_ic_dcce_cat_ao	INTEGER ,		
covd_ic_dcce_nc_water	INTEGER ,		
covd_ic_dcce_nc_wh	INTEGER ,		
covd_ic_dcce_nc_tv	INTEGER ,		
covd_ic_dcce_nc_fl	INTEGER ,		
covd_ic_dcce_nc_ao	INTEGER ,		
covd_ic_dcce_cat_fire	INTEGER ,		
covd_ic_dcce_cat_ao	INTEGER ,		
covf_ic_dcce_nc_water	INTEGER ,		
covf_ic_dcce_nc_wh	INTEGER ,		
covf_ic_dcce_nc_tv	INTEGER ,		
covf_ic_dcce_nc_fl	INTEGER ,		
covf_ic_dcce_nc_ao	INTEGER ,		
covf_ic_dcce_cat_fire	INTEGER ,		
covf_ic_dcce_cat_ao	INTEGER ,		
liab_ic_dcce_nc_water	INTEGER ,		
liab_ic_dcce_nc_wh	INTEGER ,		
liab_ic_dcce_nc_tv	INTEGER ,		
liab_ic_dcce_nc_fl	INTEGER ,		
liab_ic_dcce_nc_ao	INTEGER ,		
liab_ic_dcce_cat_fire	INTEGER ,		
liab_ic_dcce_cat_ao	INTEGER ,		
cova_ic_alae_nc_water	INTEGER ,		
cova_ic_alae_nc_wh	INTEGER ,		
cova_ic_alae_nc_tv	INTEGER ,		
cova_ic_alae_nc_fl	INTEGER ,		
cova_ic_alae_nc_ao	INTEGER ,		
cova_ic_alae_cat_fire	INTEGER ,		
cova_ic_alae_cat_ao	INTEGER ,		
covb_ic_alae_nc_water	INTEGER ,		
covb_ic_alae_nc_wh	INTEGER ,		
covb_ic_alae_nc_tv	INTEGER ,		
covb_ic_alae_nc_fl	INTEGER ,		
covb_ic_alae_nc_ao	INTEGER ,		
covb_ic_alae_cat_fire	INTEGER ,		
covb_ic_alae_cat_ao	INTEGER ,		
covc_ic_alae_nc_water	INTEGER ,		
covc_ic_alae_nc_wh	INTEGER ,		
covc_ic_alae_nc_tv	INTEGER ,		
covc_ic_alae_nc_fl	INTEGER ,		
covc_ic_alae_nc_ao	INTEGER ,		
covc_ic_alae_cat_fire	INTEGER ,		
covc_ic_alae_cat_ao	INTEGER ,		
covd_ic_alae_nc_water	INTEGER ,		
covd_ic_alae_nc_wh	INTEGER ,		
covd_ic_alae_nc_tv	INTEGER ,		
covd_ic_alae_nc_fl	INTEGER ,		
covd_ic_alae_nc_ao	INTEGER ,		
covd_ic_alae_cat_fire	INTEGER ,		
covd_ic_alae_cat_ao	INTEGER ,		
cove_ic_alae_nc_water	INTEGER ,		
cove_ic_alae_nc_wh	INTEGER ,		
cove_ic_alae_nc_tv	INTEGER ,		
cove_ic_alae_nc_fl	INTEGER ,		
cove_ic_alae_nc_ao	INTEGER ,		
cove_ic_alae_cat_fire	INTEGER ,		
cove_ic_alae_cat_ao	INTEGER ,		
covf_ic_alae_nc_water	INTEGER ,		
covf_ic_alae_nc_wh	INTEGER ,		
covf_ic_alae_nc_tv	INTEGER ,		
covf_ic_alae_nc_fl	INTEGER ,		
covf_ic_alae_nc_ao	INTEGER ,		
covf_ic_alae_cat_fire	INTEGER ,		
covf_ic_alae_cat_ao	INTEGER ,		
liab_ic_alae_nc_water	INTEGER ,		
liab_ic_alae_nc_wh	INTEGER ,		
liab_ic_alae_nc_tv	INTEGER ,		
liab_ic_alae_nc_fl	INTEGER ,		
liab_ic_alae_nc_ao	INTEGER ,		
liab_ic_alae_cat_fire	INTEGER ,		
liab_ic_alae_cat_ao	INTEGER ,		
cova_fl	INTEGER ,		
cova_sf	INTEGER ,		
cova_ec	INTEGER ,		
covc_fl	INTEGER ,		
covc_sf	INTEGER ,		
covc_ec	INTEGER ,		
loaddate	TIMESTAMP 		
)			
partitioned by (month_id INTEGER)			
stored as PARQUET			
location  's3://cse-bi/RedshiftSpectrum/Modeling/Property/'			
TABLE PROPERTIES ( 'write.parallel'='on' );			
			
alter table external_data_modeling.property			
add column allcov_ep NUMERIC(38, 6) ;			
			
insert into external_data_modeling.property			
select *, cast(to_char(ADD_MONTHS(GetDate(),-1),'yyyymm') as int) month_id from fsbi_dw_spinn.vproperty_modeldata_allcov			
			
ALTER TABLE external_data_modeling.property DROP PARTITION  (month_id=202203)			

