drop view if exists reporting.vERIS_losses;		
create or replace view reporting.vERIS_losses as 		
select		
DevQ,		
date_part(qtr,loss_date) Loss_Qtr,		
date_part(year,loss_date) Loss_Year,		
Reported_Qtr,		
Reported_Year,  		
cat_indicator, 		
carrier,		
company,		
LOB ,		
LOB2 ,		
LOB3,		
Product ,		
PolicyState,		
programind,		
featuretype,		
feature,		  
renewaltermcd,		
policyneworrenewal, 		
claim_status,		
producer_status,		
source_system,		
/*---------------------------------------------*/		
sum(QTD_Paid_DCC_Expense) QTD_Paid_DCC_Expense,		
sum(QTD_Paid_Expense) QTD_Paid_Expense,		
sum(QTD_Incurred_Expense) QTD_Incurred_Expense,		
sum(QTD_Incurred_dcc_Expense) QTD_Incurred_dcc_Expense,		
sum(QTD_Paid_Salvage_and_Subrogation) QTD_Paid_Salvage_and_Subrogation,		
sum(QTD_Paid_Loss) QTD_Paid_Loss,		
sum(QTD_Incurred_Loss) QTD_Incurred_Loss,		
sum(QTD_Paid) QTD_Paid,		
sum(QTD_Incurred) QTD_Incurred,		
sum(QTD_Incurred_net_Salvage_Subrogation) QTD_Incurred_net_Salvage_Subrogation,		
sum(QTD_Total_Incurred_Loss) QTD_Total_Incurred_Los,		
/*---------------------------------------------*/		
sum(paid_on_closed_salvage_subrogation) paid_on_closed_salvage_subrogation,		
/*---------------------------------------------*/		
sum(qtd_paid_25k) qtd_paid_25k,		
sum(qtd_paid_50k) qtd_paid_50k,		
sum(qtd_paid_100k) qtd_paid_100k,		
sum(qtd_paid_250k) qtd_paid_250k,		
sum(qtd_paid_500k) qtd_paid_500k,		
sum(qtd_paid_1m) qtd_paid_1m,		
sum(qtd_incurred_net_Salvage_Subrogation_25k)qtd_incurred_net_Salvage_Subrogation_25k ,		
sum(qtd_incurred_net_Salvage_Subrogation_50k) qtd_incurred_net_Salvage_Subrogation_50k,		
sum(qtd_incurred_net_Salvage_Subrogation_100k) qtd_incurred_net_Salvage_Subrogation_100k,		
sum(qtd_incurred_net_Salvage_Subrogation_250k) qtd_incurred_net_Salvage_Subrogation_250k,		
sum(qtd_incurred_net_Salvage_Subrogation_500k) qtd_incurred_net_Salvage_Subrogation_500k,		
sum(qtd_incurred_net_Salvage_Subrogation_1m) qtd_incurred_net_Salvage_Subrogation_1m,		
sum(reported_count) reported_count,		
sum(closed_count) closed_count,		
sum(closed_nopay) closed_nopay,		
sum(paid_on_closed_loss) paid_on_closed_loss,		
sum(paid_on_closed_expense) paid_on_closed_expense,		
sum(paid_on_closed_dcc_expense) paid_on_closed_dcc_expense,		
sum(Paid_Count) Paid_Count,		
PolicyFormCode,		
AltSubTypeCd		
from reporting.vmERIS_Claims		
group by		
devq,		
date_part(qtr,loss_date),		
date_part(year,loss_date),		
Reported_Qtr,		
Reported_Year,  		
cat_indicator, 		
carrier,		
company,		
LOB ,		
LOB2 ,		
LOB3,		
Product ,		
PolicyState,		
programind,		
featuretype,		
feature,		
renewaltermcd,		
policyneworrenewal, 		
claim_status,		
producer_status,		
source_system,		
PolicyFormCode,		
AltSubTypeCd		
having		
sum(QTD_Paid)<>0 or		
sum(QTD_Incurred) <>0 or		
sum(qtd_paid_25k) <>0 or		
sum(qtd_paid_50k) <>0 or		
sum(qtd_paid_100k) <>0 or		
sum(qtd_paid_250k) <>0 or		
sum(qtd_paid_500k) <>0 or		
sum(qtd_paid_1m) <>0 or		
sum(qtd_incurred_net_Salvage_Subrogation_25k)<>0 or		
sum(qtd_incurred_net_Salvage_Subrogation_50k)<>0 or		
sum(qtd_incurred_net_Salvage_Subrogation_100k)<>0 or		
sum(qtd_incurred_net_Salvage_Subrogation_250k)<>0 or		
sum(qtd_incurred_net_Salvage_Subrogation_500k)<>0 or		
sum(qtd_incurred_net_Salvage_Subrogation_1m)<>0 or		
sum(reported_count)<>0 or		
sum(closed_count)<>0 or		
sum(closed_nopay)<>0 or		
sum(paid_on_closed_loss)<>0 or		
sum(paid_on_closed_expense)<>0 or		
sum(paid_on_closed_dcc_expense)<>0 or		
sum(paid_on_closed_salvage_subrogation)<>0		
;		
		
		
comment on view reporting.vERIS_losses is 'Aggregated ERIS Losses, having at least 1 non 0 metric. Business Owner: Pierre-Antoine Espagnet <pespagnet@cseinsurance.com>';		
		
comment on column reporting.vERIS_losses.qtd_paid_dcc_expense	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): dcc_paid';
comment on column reporting.vERIS_losses.qtd_paid_expense	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): aoo_paid + dcc_paid';
comment on column reporting.vERIS_losses.qtd_incurred_expense	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): aoo_paid + aoo_reserve + dcc_paid + dcc_reserve';
comment on column reporting.vERIS_losses.qtd_incurred_dcc_expense	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): dcc_paid + dcc_reserve';
comment on column reporting.vERIS_losses.qtd_paid_salvage_and_subrogation	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): salvage_received + subro_received';
comment on column reporting.vERIS_losses.qtd_paid_loss	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): loss_paid';
comment on column reporting.vERIS_losses.qtd_incurred_loss	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): loss_paid + loss_reserve';
comment on column reporting.vERIS_losses.qtd_paid	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date):loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received';
comment on column reporting.vERIS_losses.qtd_incurred	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid';
comment on column reporting.vERIS_losses.qtd_incurred_net_salvage_subrogation	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date):loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received';
comment on column reporting.vERIS_losses.qtd_paid_25k	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(25k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_paid_50k	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(50k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_paid_100k	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(100k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_paid_250k	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(250k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_paid_500k	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(500k, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_paid_1m	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(1m, loss_paid + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_incurred_net_salvage_subrogation_25k	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(25k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_incurred_net_salvage_subrogation_50k	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(50k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_incurred_net_salvage_subrogation_100k	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(100k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_incurred_net_salvage_subrogation_250k	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(250k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_incurred_net_salvage_subrogation_500k	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(500k,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.qtd_incurred_net_salvage_subrogation_1m	 is 'sum of 	QTD (Reported_Year, Reported_Qtr To date): least(1m,loss_paid + loss_reserve + aoo_paid + dcc_paid - salvage_received - subro_received)';
comment on column reporting.vERIS_losses.reported_count	 is 'sum of 	1 or 0 Reported Count is based on transactional level.  The script is looking for the first transaction date(*) and quarter when this condition is TRUE in a transaction (no aggragation in metric values): loss_paid>=0.5 or loss_reserve>=0.5 or f.aoo_paid>=0.5 or aoo_reserve>=0.5 or dcc_paid>=0.5 or dcc_reserve>=0.5 or salvage_received>=0.5 or subro_received>=0.5';
comment on column reporting.vERIS_losses.closed_count	 is 'sum of 	1 or 0 Closed Count is based on transactional level. The script is looking for the latest transaction date and quarter (from transactional date) when this condition is TRUE:sum(loss_reserve + aoo_reserve + dcc_reserve)<0.5 (The data are aggregated at the claim-claimant-ERIS feature level (see Configuration) and transaction date)';
comment on column reporting.vERIS_losses.closed_nopay	 is 'sum of 	The same as closed count but in the same quorter this condition should be TRUE ITD_Paid_Loss + ITD_Paid_Expense<=0 to have 1 in the metric';
comment on column reporting.vERIS_losses.paid_on_closed_loss	 is 'sum of 	ITD_Paid_Loss If closed_count 1 else 0';
comment on column reporting.vERIS_losses.paid_on_closed_expense	 is 'sum of 	ITD_Paid_Expense If closed_count 1 else 0';
comment on column reporting.vERIS_losses.paid_on_closed_dcc_expense	 is 'sum of 	ITD_Paid_DCC_Expense If closed_count 1 else 0';
comment on column reporting.vERIS_losses.paid_on_closed_salvage_subrogation	 is 'sum of 	ITD_Salvage_and_subrogation If closed_count 1 else 0';
comment on column reporting.vERIS_losses.paid_count	 is 'sum of 	1 in DevQ when ITD_Loss_and_ALAE_for_Paid_count>0';
comment on column reporting.vERIS_losses.Claim_Status	 is 'Closed when Reserve=0 or Open';	
		
		
comment on column reporting.vERIS_losses.Loss_Qtr	 is 'Quarter based on claim loss date';	
comment on column reporting.vERIS_losses.Loss_Year	 is 'Year based on claim loss date';	
		
comment on column reporting.vERIS_losses.Reported_Qtr	 is 'Quarter based on claim transaction date';	
comment on column reporting.vERIS_losses.Reported_Year	 is 'Year based on claim transaction date';	
		
comment on column reporting.vERIS_losses.DevQ	 is 'DevQ is based on claims loss dates quarters. DevQ is NOT a quarter number. It''s number of months in quarter. (3*number of development quarters). evQ is always less then or equal 120. It''s forcefully set to 120 for higher numbers.';	
		
		
		
comment on column reporting.vERIS_losses.LOB is 'See Configuration in ERIS Tables Design document';		
comment on column reporting.vERIS_losses.LOB2 is 'See Configuration in ERIS Tables Design document';		
comment on column reporting.vERIS_losses.LOB3 is 'See Configuration in ERIS Tables Design document';		
comment on column reporting.vERIS_losses.Product is 'See Configuration in ERIS Tables Design document';		
comment on column reporting.vERIS_losses.programind is 'See Configuration in ERIS Tables Design document';		
comment on column reporting.vERIS_losses.featuretype is 'See Configuration in ERIS Tables Design document';		
comment on column reporting.vERIS_losses.feature is 'See Configuration in ERIS Tables Design document';		
comment on column reporting.vERIS_losses.policyneworrenewal is 'All WINs claims are related to "New" policyneworrenewal due to a complex way getting proper data';		
comment on column reporting.vERIS_losses.AltSubTypeCd is 'The same as PolicyFormCd almost in all cases except HO3-Homegurad as on 2022/06';		
