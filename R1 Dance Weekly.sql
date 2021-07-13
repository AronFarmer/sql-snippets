;with R1D as (select distinct hashed_id,date_trunc('week',day) as week from radio1_sandbox.audio_content_enriched where app_name = 'sounds' and day >= '2020-10-05'and day < date_trunc('week',getdate()) and live_station_name in ('bbc_radio_one_dance'))
,R1 as (select distinct hashed_id,date_trunc('week',day) as week from radio1_sandbox.audio_content_enriched where app_name = 'sounds' and day >= '2020-10-05'and day < date_trunc('week',getdate()) and live_station_name in ('bbc_radio_one'))
,R1X as (select distinct hashed_id, date_trunc('week',day) as week from radio1_sandbox.audio_content_enriched where app_name = 'sounds' and day >= '2020-10-05'and day < date_trunc('week',getdate()) and live_station_name in ('bbc_1xtra'))
,AllElse as (select distinct hashed_id, date_trunc('week',day) as week from radio1_sandbox.audio_content_enriched where app_name = 'sounds' and day >= '2020-10-05'and day < date_trunc('week',getdate()) and live_station_name not in ('bbc_1xtra','bbc_radio_one','bbc_radio_one_dance'))
select
       to_date(date_trunc('week',day),'yyyy-mm-dd') as week,
       case when age_range in ('0-5','6-10','11-15') then 'U16'
           when age_range in ('16-19','20-24','25-29','30-34') then '16-34'
           when age_range in ('35-39','40-44','45-49','50-54','55-59','60-64','65-70','>70') then 'O35' else 'Unknown' end as age_band,
case
when R1D.hashed_id is not null and r1.hashed_id is null and r1x.hashed_id is null and allelse.hashed_id is not null then 'R1D & Others'
when R1D.hashed_id is not null and R1.hashed_id is not null and R1x.hashed_id is not null then 'All Radio 1'
when R1D.hashed_id is null and R1.hashed_id is not null and r1x.hashed_id is null then 'Radio 1 Only'
when R1D.hashed_id is null and R1.hashed_id is null and r1x.hashed_id is not null then 'Radio 1Xtra Only'
when R1D.hashed_id is not null and R1.hashed_id is null and r1x.hashed_id is null then 'Radio 1 Dance Only'
when R1D.hashed_id is not null and R1.hashed_id is not null and r1x.hashed_id is null then 'Radio 1 and Radio 1 Dance'
when R1D.hashed_id is not null and R1.hashed_id is null and r1x.hashed_id is not null then 'R1Xtra and Radio 1 Dance'
when R1D.hashed_id is null and R1.hashed_id is not null and r1x.hashed_id is not null then 'R1Xtra and Radio 1'
else 'No-Radio 1' end as distinct_account,
       count(Distinct ace.hashed_id) as accounts,
       sum(stream_starts_min_3_secs) as plays,
       sum(stream_playing_time)/3600.00 as hours

from radio1_sandbox.audio_content_enriched ace
left join R1D on R1d.hashed_id = ace.hashed_id and r1d.week = date_trunc('week',day)
left join R1 on R1.hashed_id = ace.hashed_id and R1.week = date_trunc('week',day)
left join R1X on R1X.hashed_id = ace.hashed_id and R1X.week = date_trunc('week',day)
left join AllElse on AllElse.hashed_id = ace.hashed_id and AllElse.week = date_trunc('week',day)
where app_name = 'sounds'
  and ace.hashed_id is not null
and day >= '2020-10-05'
and day < date_trunc('week',getdate())
group by age_band, distinct_account, date_trunc('week',day);

select
'weekly' as table_split,
to_date(date_trunc('week',day),'yyyy-mm-dd') as date,
case when age_range in ('11-15','6-10','0-5') then 'Under 16'
when age_range in ('16-19','20-24','25-29','30-34') then '16-34'
when age_range in ('45-49','60-64','35-39','65-70','55-59','>70','40-44','50-54') then 'Over 35'
else 'Unknown' end as age_band,
sum(stream_playing_time)/3600.00 as hours,
sum(stream_starts_min_3_secs) as plays,
count(distinct hashed_id) as accounts
from radio1_sandbox.audio_content_enriched ace
where app_name = 'sounds'
and day >= '2020-10-09'
and day < date_trunc('week',getdate())
and live_station_name = 'bbc_radio_one_dance'
group by age_band, table_split, date
UNION ALL
select
'daily' as table_split,
to_date(day,'yyyy-mm-dd') as date,
case when age_range in ('11-15','6-10','0-5') then 'Under 16'
when age_range in ('16-19','20-24','25-29','30-34') then '16-34'
when age_range in ('45-49','60-64','35-39','65-70','55-59','>70','40-44','50-54') then 'Over 35'
else 'Unknown' end as age_band,
sum(stream_playing_time)/3600.00 as hours,
sum(stream_starts_min_3_secs) as plays,
count(distinct hashed_id) as accounts
from radio1_sandbox.audio_content_enriched ace
where app_name = 'sounds'
and day >= '2020-10-09'
and day < date_trunc('week',getdate())
and live_station_name = 'bbc_radio_one_dance'
group by age_band, date, table_split;

