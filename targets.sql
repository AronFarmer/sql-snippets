select table_split, min(day) as min_date, max(day) as max_date, count(*) as rows from radio1_sandbox.af_daily_performance
where day < date_add('day',-91,getdate())
group by 1;



delete from radio1_sandbox.af_daily_performance
where table_split in ('TLEODaily','TLEOOnlyDaily') and day < date_add('day',-100,getdate());


select count(*) from radio1_sandbox.af_daily_performance
