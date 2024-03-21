CREATE OR REPLACE PROCEDURE cse_bi.sp_extend_blended_claims_monthly(pLoadDate datetime) 		
AS $$		
DECLARE 		
months RECORD;		
BEGIN		
FOR months IN 		
 select distinct 		
 month_id , 		
 cast(to_char(add_months(cast(cast(month_id as varchar) + '01' as date),-1),'YYYYMM') as int) prev_month_id		
 from fsbi_stg_spinn.fact_claim		
 order by month_id		
LOOP		
 drop table if exists tmp_data;		
 create temporary table tmp_data as 		
select		
         cast(to_char(acct_date,'yyyymm') as int) month_id		
       , claim_number		
       , catastrophe_id		
       , claimant		
       , feature		
       , feature_desc		
       , feature_type		
       , aslob		
       , rag		
       , schedp_part		
	   /*-----------------------*/	
       , sum(loss_paid) loss_paid		
       , sum(loss_reserve) loss_reserve		
       , sum(aoo_paid) aoo_paid		
       , sum(aoo_reserve) aoo_reserve		
       , sum(dcc_paid) dcc_paid		
       , sum(dcc_reserve) dcc_reserve		
       , sum(salvage_received) salvage_received		
       , sum(salvage_reserve) salvage_reserve		
       , sum(subro_received) subro_received		
       , sum(subro_reserve) subro_reserve		
	   /*-----------------------*/	   
       , product_code		
       , product		
       , subproduct		
       , carrier		
       , carrier_group		
       , company		
       , policy_state		
       , policy_number		
       , policyref		
       , poleff_date		
       , polexp_date	   	
       , producer_code		
       , loss_date		
       , loss_year		
       , reported_date		
       , loss_cause		
       , source_system		
from public.vmfact_claimtransaction_blended f		
where cast(to_char(acct_date,'yyyymm') as int)=months.month_id		
group by		
         cast(to_char(acct_date,'yyyymm') as int)		
       , claim_number		
       , catastrophe_id		
       , claimant		
       , feature		
       , feature_desc		
       , feature_type		
       , aslob		
       , rag		
       , schedp_part	   	
       , product_code		
       , product		
       , subproduct		
       , carrier		
       , carrier_group		
       , company		
       , policy_state		
       , policy_number		
       , policyref		
       , poleff_date		
       , polexp_date	   	
       , producer_code		
       , loss_date		
       , loss_year		
       , reported_date		
       , loss_cause		
       , changetype		
       , source_system;		
	   	
delete from public.vmfact_claim_blended		
where month_id=months.month_id;	   	
		
insert into public.vmfact_claim_blended		
with data as (		
select		
         md.month_id		
       , md.claim_number		
       , md.catastrophe_id		
       , md.claimant		
       , md.feature		
       , md.feature_desc		
       , md.feature_type		
       , md.aslob		
       , md.rag		
       , md.schedp_part		
/*---------------------------------------------------*/		
       , md.loss_paid		
       , md.loss_reserve		
       , md.aoo_paid		
       , md.aoo_reserve		
       , md.dcc_paid		
       , md.dcc_reserve		
       , md.salvage_received		
       , md.salvage_reserve		
       , md.subro_received		
       , md.subro_reserve		
/*---------------------------------------------------*/	   	
       , md.product_code		
       , md.product		
       , md.subproduct		
       , md.carrier		
       , md.carrier_group		
       , md.company		
       , md.policy_state		
       , md.policy_number		
       , md.policyref		
       , md.poleff_date		
       , md.polexp_date	   	
       , md.producer_code		
       , md.loss_date		
       , md.loss_year		
       , md.reported_date		
       , md.loss_cause		
       , md.source_system	   	
,pLoadDate LoadDate		
from tmp_data md		
union all		
select		
         months.month_id month_id		
       , coalesce(mdc.claim_number,md.claim_number) 	claim_number	
       , coalesce(mdc.catastrophe_id,md.catastrophe_id) catastrophe_id		
       , coalesce(mdc.claimant,md.claimant) claimant		
       , coalesce(mdc.feature,md.feature) feature		
       , coalesce(mdc.feature_desc,md.feature_desc) feature_desc		
       , coalesce(mdc.feature_type,md.feature_type) feature_type		
       , coalesce(mdc.aslob,md.aslob) aslob		
       , coalesce(mdc.rag,md.rag) rag		
       , coalesce(mdc.schedp_part,md.schedp_part) schedp_part		
/*---------------------------------------------------*/		
       , 0 loss_paid		
       , 0 loss_reserve		
       , 0 aoo_paid		
       , 0 aoo_reserve		
       , 0 dcc_paid		
       , 0 dcc_reserve		
       , 0 salvage_received		
       , 0 salvage_reserve		
       , 0 subro_received		
       , 0 subro_reserve		
/*---------------------------------------------------*/	   	
       , coalesce(mdc.product_code,md.product_code) product_code		
       , coalesce(mdc.product,md.product) product		
       , coalesce(mdc.subproduct,md.subproduct)subproduct		
       , coalesce(mdc.carrier,md.carrier) carrier		
       , coalesce(mdc.carrier_group,md.carrier_group) carrier_group		
       , coalesce(mdc.company,md.company) company		
       , coalesce(mdc.policy_state,md.policy_state) policy_state		
       , coalesce(mdc.policy_number,md.policy_number) policy_number		
       , coalesce(mdc.policyref,md.policyref) policyref		
       , coalesce(mdc.poleff_date,md.poleff_date) poleff_date		
       , coalesce(mdc.polexp_date,md.polexp_date) polexp_date		
       , coalesce(mdc.producer_code,md.producer_code) producer_code		
       , coalesce(mdc.loss_date,md.loss_date) loss_date		
       , coalesce(mdc.loss_year,md.loss_year) loss_year		
       , coalesce(mdc.reported_date,md.reported_date) reported_date		
       , coalesce(mdc.loss_cause,md.loss_cause)	loss_cause	
       , coalesce(mdc.source_system,md.source_system)	source_system   	
,pLoadDate LoadDate		
from public.vmfact_claim_blended	 md	
left outer join tmp_data mdc		
on md.claim_number=mdc.claim_number		
and md.claimant=mdc.claimant		
and md.feature=mdc.feature		
where md.month_id=months.prev_month_id		
)		
select		
         month_id		
       , claim_number		
       , catastrophe_id		
       , claimant		
       , feature		
       , feature_desc		
       , feature_type		
       , aslob		
       , rag		
       , schedp_part		
	   /*-----------------------*/	
       , sum(loss_paid) loss_paid		
       , sum(loss_reserve) loss_reserve		
       , sum(aoo_paid) aoo_paid		
       , sum(aoo_reserve) aoo_reserve		
       , sum(dcc_paid) dcc_paid		
       , sum(dcc_reserve) dcc_reserve		
       , sum(salvage_received) salvage_received		
       , sum(salvage_reserve) salvage_reserve		
       , sum(subro_received) subro_received		
       , sum(subro_reserve) subro_reserve		
	   /*-----------------------*/	   
       , product_code		
       , product		
       , subproduct		
       , carrier		
       , carrier_group		
       , company		
       , policy_state		
       , policy_number		
       , policyref		
       , poleff_date		
       , polexp_date		   
       , producer_code		
       , loss_date		
       , loss_year		
       , reported_date		
       , loss_cause		
       , source_system		
	   ,LoadDate	
from data		
group by		
         month_id		
       , claim_number		
       , catastrophe_id		
       , claimant		
       , feature		
       , feature_desc		
       , feature_type		
       , aslob		
       , rag		
       , schedp_part	   	
       , product_code		
       , product		
       , subproduct		
       , carrier		
       , carrier_group		
       , company		
       , policy_state		
       , policy_number		
       , policyref		
       , poleff_date		
       , polexp_date		   
       , producer_code		
       , loss_date		
       , loss_year		
       , reported_date		
       , loss_cause		
       , source_system		
	   , LoadDate;	
END LOOP;		
END;		
$$ LANGUAGE plpgsql;		
