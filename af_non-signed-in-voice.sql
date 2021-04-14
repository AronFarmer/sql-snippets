---- Non-Signed In Voice Users ----
insert into radio1_sandbox.af_signed_in_voice
with date_selection as (select date_trunc('week',getdate()-1) as start_date,  date_trunc('week',getdate()) as end_date)

select
        'all accounts' as account_figure,
       count(distinct audience_id) as all_accounts,
       date_trunc('week', to_date(dt,'YYYYMMDD')) as date
from s3_audience.audience_activity
where destination = 'PS_VOICE' and page_producer = 'Sounds'
and to_date(dt,'YYYYMMDD') >= (select start_date from date_selection) and to_date(dt,'YYYYMMDD') < (select end_date from date_selection)
group by date, account_figure
union all
select
        'signed in accounts' as account_figure,
       count(distinct audience_id) as all_accounts,
       date_trunc('week', to_date(dt,'YYYYMMDD')) as date
from s3_audience.audience_activity
where destination = 'PS_VOICE' and page_producer = 'Sounds'
and to_date(dt,'YYYYMMDD') >= (select start_date from date_selection) and to_date(dt,'YYYYMMDD') < (select end_date from date_selection) and is_signed_in is true
group by date, account_figure;