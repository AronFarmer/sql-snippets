insert into radio1_sandbox.af_daily_performance
with date_selection as (select (select max(day) from radio1_sandbox.af_daily_performance where table_split = 'OverallDaily') as start_date, getdate() as end_date)
select
'OverallDaily' as table_split,
ace.day as date,
       adl.quarter,
   case when age_range in ('0-5','6-10','11-15') then 'Under 16'
      when age_range in ('16-19','20-24') then '16 - 24'
       when age_range in ('25-29','30-34') then '25 - 34'
        when age_range in ('35-39','40-44') then '35 - 44'
         when age_range in ('45-49','50-54') then '45 - 54'
          when age_range in ('55-59','60-64') then '55 - 65'
           when age_range in ('65+') then 'Over 65'
            else 'Unknown' end as age_band,
       frequency_band,
   'null' as content_type,
       'null' as broadcast_type,
       'null' as network_type,
       'null' as master_brandname,
       'null' as title,
       'null' as episodetitle,
       count(distinct hashed_id) as accounts,
       sum(stream_playing_time)/3600 as time_spent_hours,
       sum(stream_starts_min_3_secs) as plays

from radio1_sandbox.audio_content_enriched ace
inner join radio1_sandbox.af_date_lookup adl on adl.day = ace.day
where ace.day > (select start_date from date_selection) and ace.day < (select end_date from date_selection)
and app_name = 'sounds'
group by 1,2,3,4,5,6,7,8,9,10,11;
insert into radio1_sandbox.af_daily_performance
with date_selection as (select (select max(day) from radio1_sandbox.af_daily_performance where table_split = 'BroadcastDaily') as start_date, getdate() as end_date)
select
'BroadcastDaily' as table_split,
ace.day as date,
       adl.quarter,
   case when age_range in ('0-5','6-10','11-15') then 'Under 16'
      when age_range in ('16-19','20-24') then '16 - 24'
       when age_range in ('25-29','30-34') then '25 - 34'
        when age_range in ('35-39','40-44') then '35 - 44'
         when age_range in ('45-49','50-54') then '45 - 54'
          when age_range in ('55-59','60-64') then '55 - 65'
           when age_range in ('65+') then 'Over 65'
            else 'Unknown' end as age_band,
       frequency_band,
   'null' as content_type,
       bbc_st_lod as broadcast_type,
       'null' as network_type,
       'null' as master_brandname,
       'null' as title,
       'null' as episodetitle,
       count(distinct hashed_id) as accounts,
       sum(stream_playing_time)/3600 as time_spent_hours,
       sum(stream_starts_min_3_secs) as plays

from radio1_sandbox.audio_content_enriched ace
inner join radio1_sandbox.af_date_lookup adl on adl.day = ace.day
where ace.day > (select start_date from date_selection) and ace.day < (select end_date from date_selection)
and app_name = 'sounds'
group by 1,2,3,4,5,6,7,8,9,10,11;
insert into radio1_sandbox.af_daily_performance
with date_selection as (select (select max(day) from radio1_sandbox.af_daily_performance where table_split = 'NetworkDaily') as start_date, getdate() as end_date)
select
'NetworkDaily' as table_split,
ace.day as date,
       adl.quarter,
   case when age_range in ('0-5','6-10','11-15') then 'Under 16'
      when age_range in ('16-19','20-24') then '16 - 24'
       when age_range in ('25-29','30-34') then '25 - 34'
        when age_range in ('35-39','40-44') then '35 - 44'
         when age_range in ('45-49','50-54') then '45 - 54'
          when age_range in ('55-59','60-64') then '55 - 65'
           when age_range in ('65+') then 'Over 65'
            else 'Unknown' end as age_band,
       frequency_band,
       'null' as content_type,
       'null' as broadcast_type,
       case when am.network_types = 'Music' then 'Music' else 'Speech' end as network_type,
       'null' as master_brandname,
       'null' as title,
       'null' as episodetitle,
       count(distinct hashed_id) as accounts,
       sum(stream_playing_time)/3600 as time_spent_hours,
       sum(stream_starts_min_3_secs) as plays

from radio1_sandbox.audio_content_enriched ace
inner join radio1_sandbox.af_date_lookup adl on adl.day = ace.day
left join radio1_sandbox.af_masterbrands am on am.master_brand_name = ace.master_brand_name
where ace.day > (select start_date from date_selection) and ace.day < (select end_date from date_selection)
and app_name = 'sounds'
group by 1,2,3,4,5,6,7,8,9,10,11;
insert into radio1_sandbox.af_daily_performance
with date_selection as (select (select max(day) from radio1_sandbox.af_daily_performance where table_split = 'MasterbrandDaily') as start_date, getdate() as end_date)
select
'MasterbrandDaily' as table_split,
ace.day as date,
       adl.quarter,
   case when age_range in ('0-5','6-10','11-15') then 'Under 16'
      when age_range in ('16-19','20-24') then '16 - 24'
       when age_range in ('25-29','30-34') then '25 - 34'
        when age_range in ('35-39','40-44') then '35 - 44'
         when age_range in ('45-49','50-54') then '45 - 54'
          when age_range in ('55-59','60-64') then '55 - 65'
           when age_range in ('65+') then 'Over 65'
            else 'Unknown' end as age_band,
       frequency_band,
       'null' as content_type,
       bbc_st_lod as broadcast_type,
       case when am.network_types = 'Music' then 'Music' else 'Speech' end as network_type,
       ace.master_brand_name as master_brandname,
       'null' as title,
       'null' as episodetitle,
       count(distinct hashed_id) as accounts,
       sum(stream_playing_time)/3600 as time_spent_hours,
       sum(stream_starts_min_3_secs) as plays

from radio1_sandbox.audio_content_enriched ace
inner join radio1_sandbox.af_date_lookup adl on adl.day = ace.day    
left join radio1_sandbox.af_masterbrands am on am.master_brand_name = ace.master_brand_name
where ace.day > (select start_date from date_selection) and ace.day < (select end_date from date_selection)
and app_name = 'sounds'
group by 1,2,3,4,5,6,7,8,9,10,11;
insert into radio1_sandbox.af_daily_performance
with date_selection as (select (select max(day) from radio1_sandbox.af_daily_performance where table_split = 'TLEODaily') as start_date, getdate() as end_date)
select
'TLEODaily' as table_split,
ace.day as date,
       adl.quarter,
   case when age_range in ('0-5','6-10','11-15') then 'Under 16'
      when age_range in ('16-19','20-24') then '16 - 24'
       when age_range in ('25-29','30-34') then '25 - 34'
        when age_range in ('35-39','40-44') then '35 - 44'
         when age_range in ('45-49','50-54') then '45 - 54'
          when age_range in ('55-59','60-64') then '55 - 65'
           when age_range in ('65+') then 'Over 65'
            else 'Unknown' end as age_band,
       frequency_band,
       case when ace.sounds_mixes_bool = true then 'Sounds Mixes'
    when ace.rail_podcasts_bool = true then 'Rail Podcasts'
       when ace.all_podcasts_bool = true then 'Network Podcasts'
    else 'Network Content' end as content_type,
       bbc_st_lod as broadcast_type,
       case when am.network_types = 'Music' then 'Music' else 'Speech' end as network_type,
       ace.master_brand_name as master_brandname,
       tleo as title,
       'null' as episodetitle,
       count(distinct hashed_id) as accounts,
       sum(stream_playing_time)/3600 as time_spent_hours,
       sum(stream_starts_min_3_secs) as plays

from radio1_sandbox.audio_content_enriched ace
inner join radio1_sandbox.af_date_lookup adl on adl.day = ace.day    
left join radio1_sandbox.af_masterbrands am on am.master_brand_name = ace.master_brand_name
where ace.day > (select start_date from date_selection) and ace.day < (select end_date from date_selection)
and app_name = 'sounds'
group by 1,2,3,4,5,6,7,8,9,10,11;
insert into radio1_sandbox.af_daily_performance
with date_selection as (select (select max(day) from radio1_sandbox.af_daily_performance where table_split = 'TLEOOnlyDaily') as start_date, getdate() as end_date)
select
'TLEOOnlyDaily' as table_split,
ace.day as date,
       adl.quarter,
   case when age_range in ('0-5','6-10','11-15') then 'Under 16'
      when age_range in ('16-19','20-24') then '16 - 24'
       when age_range in ('25-29','30-34') then '25 - 34'
        when age_range in ('35-39','40-44') then '35 - 44'
         when age_range in ('45-49','50-54') then '45 - 54'
          when age_range in ('55-59','60-64') then '55 - 65'
           when age_range in ('65+') then 'Over 65'
            else 'Unknown' end as age_band,
       frequency_band,
       case when ace.sounds_mixes_bool = true then 'Sounds Mixes'
    when ace.rail_podcasts_bool = true then 'Rail Podcasts'
       when ace.all_podcasts_bool = true then 'Network Podcasts'
    else 'Network Content' end as content_type,
       'both' as broadcast_type,
       case when am.network_types = 'Music' then 'Music' else 'Speech' end as network_type,
       ace.master_brand_name as master_brandname,
       tleo as title,
       'null' as episodetitle,
       count(distinct hashed_id) as accounts,
       sum(stream_playing_time)/3600 as time_spent_hours,
       sum(stream_starts_min_3_secs) as plays

from radio1_sandbox.audio_content_enriched ace
inner join radio1_sandbox.af_date_lookup adl on adl.day = ace.day    
left join radio1_sandbox.af_masterbrands am on am.master_brand_name = ace.master_brand_name
where ace.day > (select start_date from date_selection) and ace.day < (select end_date from date_selection)
and app_name = 'sounds'
group by 1,2,3,4,5,6,7,8,9,10,11;
insert into radio1_sandbox.af_daily_performance
with date_selection as (select (select max(day) from radio1_sandbox.af_daily_performance where table_split = 'MasterbrandOnlyDaily') as start_date, getdate() as end_date)
select
'MasterbrandOnlyDaily' as table_split,
ace.day as date,
       adl.quarter,
   case when age_range in ('0-5','6-10','11-15') then 'Under 16'
      when age_range in ('16-19','20-24') then '16 - 24'
       when age_range in ('25-29','30-34') then '25 - 34'
        when age_range in ('35-39','40-44') then '35 - 44'
         when age_range in ('45-49','50-54') then '45 - 54'
          when age_range in ('55-59','60-64') then '55 - 65'
           when age_range in ('65+') then 'Over 65'
            else 'Unknown' end as age_band,
       frequency_band,
       'null' as content_type,
       'both' as broadcast_type,
       'null' as network_type,
       master_brand_name as master_brandname,
       'null' as title,
       'null' as episodetitle,
       count(distinct hashed_id) as accounts,
       sum(stream_playing_time)/3600 as time_spent_hours,
       sum(stream_starts_min_3_secs) as plays

from radio1_sandbox.audio_content_enriched ace
inner join radio1_sandbox.af_date_lookup adl on adl.day = ace.day
where ace.day > (select start_date from date_selection) and ace.day < (select end_date from date_selection)
and app_name = 'sounds'
group by 1,2,3,4,5,6,7,8,9,10,11;




