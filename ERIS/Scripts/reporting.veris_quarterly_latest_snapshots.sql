create or replace view reporting.veris_quarterly_latest_snapshots as
select 
tablename,
replace(replace(split_part(values,',',1),'[',''),'"','') quarter_id,
max(replace(replace(split_part(values,',',2),']',''),'"','')) snapshot_id
from reporting.external_partitions
where schemaname='external_data_pricing'
and tablename like '%eris%ia'
group by tablename,
replace(replace(split_part(values,',',1),'[',''),'"','')
order by tablename,
replace(replace(split_part(values,',',1),'[',''),'"','');

comment on view reporting.veris_quarterly_latest_snapshots is 'It`s possible to have more then 1 ERIS table snapshot per month due to tables adjustments. The latest snapshot id per quarter can be found in this view.';
