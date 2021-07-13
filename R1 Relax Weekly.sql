;with
AllR1 as (select distinct hashed_id,date_trunc('week',day) as week from radio1_sandbox.audio_content_enriched where app_name = 'sounds' and day >= '2021-04-19'and day < date_trunc('week',getdate()) and live_station_name in ('bbc_radio_one','bbc_1xtra','bbc_radio_one_dance'))
,R1R as (select distinct hashed_id,date_trunc('week',day) as week from radio1_sandbox.audio_content_enriched where app_name = 'sounds' and  day >= '2021-04-19'and day < date_trunc('week',getdate()) and live_station_name in ('bbc_radio_one_relax'))
,AllElse as (select distinct hashed_id, date_trunc('week',day) as week from radio1_sandbox.audio_content_enriched where app_name = 'sounds' and  day >= '2021-04-19'and day < date_trunc('week',getdate()) and live_station_name not in ('bbc_1xtra','bbc_radio_one','bbc_radio_one_dance','bbc_radio_one_relax'))
select
       to_date(date_trunc('week',day),'yyyy-mm-dd') as week,
       case when age_range in ('0-5','6-10','11-15') then 'U16'
           when age_range in ('16-19','20-24','25-29','30-34') then '16-34'
           when age_range in ('35-39','40-44','45-49','50-54','55-59','60-64','65-70','>70') then 'O35' else 'Unknown' end as age_band,
case
when R1R.hashed_id is not null and AllR1.hashed_id is null and AllElse.hashed_id is null then 'R1 Relax Only'
when R1R.hashed_id is not null and AllR1.hashed_id is not null and allelse.hashed_id is null then 'R1 Relax & Listens to R1 only'
when R1R.hashed_id is not null and AllR1.hashed_id is null and AllElse.hashed_id is not null then 'R1 Relax & No R1 & Others'
when R1R.hashed_id is not null and AllR1.hashed_id is not null and AllElse.hashed_id is not null then 'R1 Relax & R1 & Others'
else 'No-R1 Relax' end as distinct_account,
       count(Distinct ace.hashed_id) as accounts,
       sum(stream_starts_min_3_secs) as plays,
       sum(stream_playing_time)/3600.00 as hours

from radio1_sandbox.audio_content_enriched ace
left join allR1 on AllR1.hashed_id = ace.hashed_id and AllR1.week = date_trunc('week',day)
left join R1R on R1R.hashed_id = ace.hashed_id and R1R.week = date_trunc('week',day)
left join AllElse on AllElse.hashed_id = ace.hashed_id and AllElse.week = date_trunc('week',day)
where ace.hashed_id is not null and app_name = 'sounds'
and day >= '2021-04-19'
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
where day >= '2020-10-09'
and day < date_trunc('week',getdate())
and live_station_name = 'bbc_radio_one_relax'
and app_name = 'sounds'
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
where  day >= '2020-10-09'
and day < date_trunc('week',getdate())
and live_station_name = 'bbc_radio_one_relax'
and app_name = 'sounds'
group by age_band, date, table_split;