create or replace view reporting.veris_quarterly_snapshots as
select 
tablename,
replace(replace(split_part(values,',',1),'[',''),'"','') quarter_id,
replace(replace(split_part(values,',',2),']',''),'"','') snapshot_id,
'select * from external_data_pricing.'+tablename+' where quarter_id='''+quarter_id  +''' and snapshot_id='''+snapshot_id  +''' limit 100' sql
from reporting.external_partitions
where schemaname='external_data_pricing'
and tablename like '%eris%ia'
order by tablename,
replace(replace(split_part(values,',',1),'[',''),'"','');


comment on view reporting.veris_quarterly_snapshots is 'IDs of available ERIS tables quarterly snapshots';
