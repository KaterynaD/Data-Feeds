create or replace view reporting.vmeris_policies_quarterly_snapshots as 
select 
data.*
from external_data_pricing.vmeris_policies_ia data
join reporting.veris_quarterly_latest_snapshots f
on data.quarter_id=f.quarter_id
and data.snapshot_id=f.snapshot_id
and f.tablename='vmeris_policies_ia'
with no schema binding;

comment on view reporting.vmeris_policies_quarterly_snapshots is 'The view can be used instead of the original table to get data only from the latest snapshot per quarter. Only quarter ID is needed to get the data.';
