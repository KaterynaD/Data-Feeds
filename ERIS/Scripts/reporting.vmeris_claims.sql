DROP TABLE IF EXISTS reporting.vmeris_claims;	
CREATE TABLE reporting.vmeris_claims	
(	
    devq bigint,	
    reported_year integer ENCODE az64,	
    reported_qtr integer ENCODE az64,	
    loss_date date ENCODE az64,	
    reported_date date ENCODE az64,	
    carrier character varying(100) ENCODE lzo,	
    company character varying(50) ENCODE lzo,	
    policy_number character varying(50) ENCODE lzo,	
    policy_uniqueid character varying(100) ENCODE lzo,	
    riskcd character varying(12) ENCODE lzo,	
    poleff_date date ENCODE az64,	
    polexp_date date ENCODE az64,	
    renewaltermcd character varying(255) ENCODE lzo,	
    policyneworrenewal character varying(7) ENCODE lzo,	
    policystate character varying(2) ENCODE lzo,	
    producer_status character varying(10) ENCODE lzo,	
    claim_number character varying(50),	
    claimant character varying(50),	
    cat_indicator character varying(3) ENCODE lzo,	
    lob character varying(3) ENCODE lzo,	
    lob2 character varying(3) ENCODE lzo,	
    lob3 character varying(3) ENCODE lzo,	
    product character varying(2) ENCODE lzo,	
    policyformcode character varying(20) ENCODE lzo,	
    programind character varying(6) ENCODE lzo,	
    featuretype character varying(4) ENCODE lzo,	
    feature character varying(5),	
    claim_status character varying(6) ENCODE lzo,	
    source_system character varying(5) ENCODE lzo,	
    itd_paid_expense numeric(38,2) ENCODE az64,	
    itd_paid_dcc_expense numeric(38,2) ENCODE az64,	
    itd_paid_loss numeric(38,2) ENCODE az64,	
    itd_incurred numeric(38,2) ENCODE az64,	
    itd_incurred_net_salvage_subrogation numeric(38,2) ENCODE az64,	
    itd_total_incurred_loss numeric(38,2) ENCODE az64,	
    itd_reserve numeric(38,2) ENCODE az64,	
    itd_loss_and_alae_for_paid_count numeric(38,2) ENCODE az64,	
    itd_salvage_and_subrogation numeric(38,2) ENCODE az64,	
    qtd_paid_dcc_expense numeric(38,2) ENCODE az64,	
    qtd_paid_expense numeric(38,2) ENCODE az64,	
    qtd_incurred_expense numeric(38,2) ENCODE az64,	
    qtd_incurred_dcc_expense numeric(38,2) ENCODE az64,	
    qtd_paid_salvage_and_subrogation numeric(38,2) ENCODE az64,	
    qtd_paid_loss numeric(38,2) ENCODE az64,	
    qtd_incurred_loss numeric(38,2) ENCODE az64,	
    qtd_paid numeric(38,2) ENCODE az64,	
    qtd_incurred numeric(38,2) ENCODE az64,	
    qtd_incurred_net_salvage_subrogation numeric(38,2) ENCODE az64,	
    qtd_total_incurred_loss numeric(38,2) ENCODE az64,	
    qtd_paid_25k numeric(38,2) ENCODE az64,	
    qtd_paid_50k numeric(38,2) ENCODE az64,	
    qtd_paid_100k numeric(38,2) ENCODE az64,	
    qtd_paid_250k numeric(38,2) ENCODE az64,	
    qtd_paid_500k numeric(38,2) ENCODE az64,	
    qtd_paid_1m numeric(38,2) ENCODE az64,	
    qtd_incurred_net_salvage_subrogation_25k numeric(38,2) ENCODE az64,	
    qtd_incurred_net_salvage_subrogation_50k numeric(38,2) ENCODE az64,	
    qtd_incurred_net_salvage_subrogation_100k numeric(38,2) ENCODE az64,	
    qtd_incurred_net_salvage_subrogation_250k numeric(38,2) ENCODE az64,	
    qtd_incurred_net_salvage_subrogation_500k numeric(38,2) ENCODE az64,	
    qtd_incurred_net_salvage_subrogation_1m numeric(38,2) ENCODE az64,	
    x_itd_incurred_net_salvage_subrogation_250k numeric(38,2) ENCODE az64,	
    x_itd_incurred_net_salvage_subrogation_500k numeric(38,2) ENCODE az64,	
    reported_count integer ENCODE az64,	
    closed_count integer ENCODE az64,	
    closed_nopay integer ENCODE az64,	
    paid_on_closed_loss numeric(38,2) ENCODE az64,	
    paid_on_closed_expense numeric(38,2) ENCODE az64,	
    paid_on_closed_dcc_expense numeric(38,2) ENCODE az64,	
    paid_on_closed_salvage_subrogation numeric(38,2) ENCODE az64,	
    paid_count integer ENCODE az64,	
    loaddate timestamp without time zone ENCODE az64,	
    itd_paid numeric(38,2) ENCODE az64,	
    AltSubTypeCd character varying(20) ENCODE lzo	
)	
DISTSTYLE KEY	
DISTKEY(claim_number)	
INTERLEAVED SORTKEY(devq, claim_number, claimant, feature);	
	
	
	
	
	
COMMENT ON TABLE reporting.vmeris_claims IS 'ERIS Losses detail level. Business Owner: Pierre-Antoine Espagnet <pespagnet@cseinsurance.com>';	
COMMENT ON COLUMN reporting.vmeris_claims.devq IS 'DevQ is based on claims loss dates quarters. DevQ is NOT a quarter number. It''s number of months in quarter. (3*number of development quarters). evQ is always less then or equal 120. It''s forcefully set to 120 for higher numbers.';	
COMMENT ON COLUMN reporting.vmeris_claims.reported_year IS 'Year based on claim transaction date';	
COMMENT ON COLUMN reporting.vmeris_claims.reported_qtr IS 'Quarter based on claim transaction date';	
COMMENT ON COLUMN reporting.vmeris_claims.policyneworrenewal IS 'All WINs claims are related to "New" policyneworrenewal due to a complex way getting proper data';	
COMMENT ON COLUMN reporting.vmeris_claims.lob IS 'See Configuration in ERIS Tables Design document';	
COMMENT ON COLUMN reporting.vmeris_claims.lob2 IS 'See Configuration in ERIS Tables Design document';	
COMMENT ON COLUMN reporting.vmeris_claims.lob3 IS 'See Configuration in ERIS Tables Design document';	
COMMENT ON COLUMN reporting.vmeris_claims.product IS 'See Configuration in ERIS Tables Design document';	
COMMENT ON COLUMN reporting.vmeris_claims.programind IS 'See Configuration in ERIS Tables Design document';	
COMMENT ON COLUMN reporting.vmeris_claims.featuretype IS 'See Configuration in ERIS Tables Design document';	
COMMENT ON COLUMN reporting.vmeris_claims.feature IS 'See Configuration in ERIS Tables Design document';	
COMMENT ON COLUMN reporting.vmeris_claims.claim_status IS 'Closed when Reserve=0 or Open';	
COMMENT ON COLUMN reporting.vmeris_claims.itd_paid_expense IS 'ITD (Inception To date): aoo_paid + dcc_paid';	
COMMENT ON COLUMN reporting.vmeris_claims.itd_paid_dcc_expense IS 'ITD (Inception To date): dcc_paid';	
COMMENT ON COLUMN reporting.vmeris_claims.itd_paid_loss IS 'ITD (Inception To date):loss_paid';	
COMMENT ON COLUMN reporting.vmeris_claims.itd_incurred IS 'ITD (Inception To date):loss_paid + loss_reserve + aoo_paid + dcc_paid';	
COMMENT ON COLUMN reporting.vmeris_claims.itd_incurred_net_salvage_subrogation IS 'ITD (Inception To date):loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received';	
COMMENT ON COLUMN reporting.vmeris_claims.itd_total_incurred_loss IS 'ITD (Inception To date):loss_paid + loss_reserve + aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';	
COMMENT ON COLUMN reporting.vmeris_claims.itd_reserve IS 'ITD (Inception To date):loss_reserve + aoo_reserve + dcc_reserve';	
COMMENT ON COLUMN reporting.vmeris_claims.itd_loss_and_alae_for_paid_count IS 'ITD (Inception To date): loss_paid + aoo_paid + dcc_paid';	
COMMENT ON COLUMN reporting.vmeris_claims.itd_salvage_and_subrogation IS 'ITD (Inception To date: salvage_received + subro_received';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_dcc_expense IS 'QTD (Reported_Year, Reported_Qtr To date): dcc_paid';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_expense IS 'QTD (Reported_Year, Reported_Qtr To date): aoo_paid + dcc_paid';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_expense IS 'QTD (Reported_Year, Reported_Qtr To date): aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_dcc_expense IS 'QTD (Reported_Year, Reported_Qtr To date): dcc_paid + dcc_reserve';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_salvage_and_subrogation IS 'QTD (Reported_Year, Reported_Qtr To date): salvage_received + subro_received';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_loss IS 'QTD (Reported_Year, Reported_Qtr To date): loss_paid';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_loss IS 'QTD (Reported_Year, Reported_Qtr To date): loss_paid + loss_reserve';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_total_incurred_loss IS 'QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_25k IS 'QTD (Reported_Year, Reported_Qtr To date): least(25k, itd_paid) - prev quarter least(25k, itd_paid) ';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_50k IS 'QTD (Reported_Year, Reported_Qtr To date):least(50k, itd_paid) - prev quarter least(50k, itd_paid) ';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_100k IS 'QTD (Reported_Year, Reported_Qtr To date): least(100k, itd_paid) - prev quarter least(100k, itd_paid) ';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_250k IS 'QTD (Reported_Year, Reported_Qtr To date): least(250k, itd_paid) - prev quarter least(250k, itd_paid) ';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_500k IS 'QTD (Reported_Year, Reported_Qtr To date): least(500k, itd_paid) - prev quarter least(500k, itd_paid) ';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_paid_1m IS 'QTD (Reported_Year, Reported_Qtr To date): least(1m, itd_paid) - prev quarter least(1m,itd_paid) ';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_25k IS 'QTD (Reported_Year, Reported_Qtr To date): least(25k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(25k,ITD_Incurred_net_Salvage_Subrogation)';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_50k IS 'QTD (Reported_Year, Reported_Qtr To date): least(50k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(50k,ITD_Incurred_net_Salvage_Subrogation)';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_100k IS 'QTD (Reported_Year, Reported_Qtr To date): least(100k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(100k,ITD_Incurred_net_Salvage_Subrogation)';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_250k IS 'QTD (Reported_Year, Reported_Qtr To date): least(250k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(250k,ITD_Incurred_net_Salvage_Subrogation)';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_500k IS 'QTD (Reported_Year, Reported_Qtr To date): least(500k,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(500k,ITD_Incurred_net_Salvage_Subrogation)';	
COMMENT ON COLUMN reporting.vmeris_claims.qtd_incurred_net_salvage_subrogation_1m IS 'QTD (Reported_Year, Reported_Qtr To date): least(1m,ITD_Incurred_net_Salvage_Subrogation) - prev quarter least(1m,ITD_Incurred_net_Salvage_Subrogation)';	
COMMENT ON COLUMN reporting.vmeris_claims.x_itd_incurred_net_salvage_subrogation_250k IS 'case when ITD_Incurred_net_Salvage_Subrogation>0 then greatest(0,ITD_Incurred_net_Salvage_Subrogation - 250000) else 0 end';	
COMMENT ON COLUMN reporting.vmeris_claims.x_itd_incurred_net_salvage_subrogation_500k IS 'case when ITD_Incurred_net_Salvage_Subrogation>0 then greatest(0,ITD_Incurred_net_Salvage_Subrogation - 500000) else 0 end';	
COMMENT ON COLUMN reporting.vmeris_claims.reported_count IS '1 or 0 Reported Count is based on transactional level.  The script is looking for the first transaction date(*) and quarter when this condition is TRUE in a transaction (no aggragation in metric values): loss_paid>=0.5 or loss_reserve>=0.5 or f.aoo_paid>=0.5 or aoo_reserve>=0.5 or dcc_paid>=0.5 or dcc_reserve>=0.5 or salvage_received>=0.5 or subro_received>=0.5';	
COMMENT ON COLUMN reporting.vmeris_claims.closed_count IS '1 or 0 Closed Count is based on transactional level. The script is looking for the latest transaction date and quarter (from transactional date) when this condition is TRUE:sum(loss_reserve + aoo_reserve + dcc_reserve)<0.5 (The data are aggregated at the claim-claimant-ERIS feature level (see Configuration) and transaction date)';	
COMMENT ON COLUMN reporting.vmeris_claims.closed_nopay IS 'The same as closed count but in the same quorter this condition should be TRUE ITD_Paid_Loss + ITD_Paid_Expense<=0 to have 1 in the metric';	
COMMENT ON COLUMN reporting.vmeris_claims.paid_on_closed_loss IS 'ITD_Paid_Loss If closed_count 1 else 0';	
COMMENT ON COLUMN reporting.vmeris_claims.paid_on_closed_expense IS 'ITD_Paid_Expense If closed_count 1 else 0';	
COMMENT ON COLUMN reporting.vmeris_claims.paid_on_closed_dcc_expense IS 'ITD_Paid_DCC_Expense If closed_count 1 else 0';	
COMMENT ON COLUMN reporting.vmeris_claims.paid_on_closed_salvage_subrogation IS 'ITD_Salvage_and_subrogation If closed_count 1 else 0';	
COMMENT ON COLUMN reporting.vmeris_claims.paid_count IS '1 in DevQ when ITD_Loss_and_ALAE_for_Paid_count>0';	
COMMENT ON COLUMN reporting.vmeris_claims.itd_paid IS 'ITD (Inception To date): itd_paid_loss+ itd_paid_expense- itd_salvage_and_subrogation';	
COMMENT ON COLUMN reporting.vmeris_claims.AltSubTypeCd is 'The same as PolicyFormCd almost in all cases except HO3-Homegurad as on 2022/06';	
