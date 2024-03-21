CREATE OR REPLACE VIEW reporting.vppd_losses AS 
 SELECT to_date(cast(ppd_losses.month_id as varchar) + '01', 'yyyymmdd') AS reportperiod, 
 ppd_losses.product, 
 ppd_losses.subproduct, 
 ppd_losses.month_id, 
 ppd_losses.policy_state, 
 rtrim(ppd_losses.carrier::text) AS carrier, 
 ppd_losses.company, 
 ppd_losses.policyneworrenewal, 
        CASE
            WHEN ppd_losses.cat_flg::text = 'Yes' THEN 'Cat'
            ELSE 'Non Cat'
        END AS cat_flg, 
ppd_losses.perilgroup, 
ppd_losses.total_incurred, 
ppd_losses.total_incurred_capped_100k, 
ppd_losses.reported_count, 
ppd_losses.open_count, 
ppd_losses.reported_count_100k, 
ppd_losses.reported_count_100k_month, 
ppd_losses.total_incurred_100k_month, 
ppd_losses.reported_count_month
   FROM reporting.ppd_losses;
