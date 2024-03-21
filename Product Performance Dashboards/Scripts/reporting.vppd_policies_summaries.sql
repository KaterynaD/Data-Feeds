CREATE OR REPLACE VIEW reporting.vppd_policies_summaries AS 										
 SELECT to_date(cast(ppd_policies_summaries.month_id as varchar) + '01', 'yyyymmdd') AS reportperiod, 										
 ppd_policies_summaries.product, 										
 ppd_policies_summaries.subproduct, 										
 ppd_policies_summaries.month_id, 										
 ppd_policies_summaries.policy_state, 										
 ppd_policies_summaries.carrier, 										
 ppd_policies_summaries.company, 										
 ppd_policies_summaries.policyneworrenewal, 										
 ppd_policies_summaries.ep, 										
 ppd_policies_summaries.ee, 										
 ppd_policies_summaries.pif										
   FROM reporting.ppd_policies_summaries;										
