-- Daily index-usage history and conservative 30-day unused-candidate view.
-- Monitoring only: this script never alters, hides, or drops an index.
set define off
set serveroutput on
whenever sqlerror exit sql.sqlcode rollback

create or replace view admin.dct_prod_index_usage_v as
select i.owner index_owner,i.table_owner,i.table_name,i.index_name,
       i.uniqueness,i.status,
       case when c.index_name is not null then 'Y' else 'N' end constraint_backed,
       nvl(u.total_access_count,0) total_access_count,
       nvl(u.total_exec_count,0) total_exec_count,
       u.last_used
  from dba_indexes i
  left join dba_index_usage u
    on u.owner=i.owner and u.name=i.index_name
  left join (
    select distinct index_owner,index_name
      from dba_constraints
     where index_name is not null
  ) c on c.index_owner=i.owner and c.index_name=i.index_name
 where i.table_owner='PROD';

create or replace procedure admin.grant_dct_index_usage_tmp authid definer as
begin
  execute immediate 'grant select on admin.dct_prod_index_usage_v to prod';
end;
/
begin admin.grant_dct_index_usage_tmp; end;
/
drop procedure admin.grant_dct_index_usage_tmp;

declare
  l_count number;
begin
  select count(*) into l_count from dba_tables
   where owner='PROD' and table_name='DCT_INDEX_USAGE_SNAPSHOT';
  if l_count=0 then
    execute immediate q'[
      create table prod.dct_index_usage_snapshot (
        snapshot_date      date not null,
        index_owner        varchar2(128) not null,
        table_name         varchar2(128) not null,
        index_name         varchar2(128) not null,
        uniqueness         varchar2(9) not null,
        status             varchar2(8),
        constraint_backed  varchar2(1) not null,
        total_access_count number default 0 not null,
        total_exec_count   number default 0 not null,
        last_used          date,
        created_at         timestamp with time zone default systimestamp not null,
        constraint pk_dct_index_usage_snapshot primary key
          (snapshot_date,index_owner,index_name),
        constraint ck_dct_idxuse_constraint check (constraint_backed in ('Y','N'))
      )]';
  end if;
end;
/

create or replace package prod.dct_index_usage_pkg authid definer as
  procedure capture;
end dct_index_usage_pkg;
/

create or replace package body prod.dct_index_usage_pkg as
  procedure capture is
    l_day date:=trunc(cast(systimestamp at time zone 'Asia/Dubai' as date));
  begin
    delete from prod.dct_index_usage_snapshot where snapshot_date=l_day;
    insert into prod.dct_index_usage_snapshot
      (snapshot_date,index_owner,table_name,index_name,uniqueness,status,
       constraint_backed,total_access_count,total_exec_count,last_used)
    select l_day,index_owner,table_name,index_name,uniqueness,status,
           constraint_backed,total_access_count,total_exec_count,last_used
      from admin.dct_prod_index_usage_v;
    delete from prod.dct_index_usage_snapshot where snapshot_date<l_day-180;
    commit;
  end capture;
end dct_index_usage_pkg;
/

create or replace view prod.dct_index_unused_candidate_v as
select index_owner,table_name,index_name,
       min(snapshot_date) observation_start,
       max(snapshot_date) observation_end,
       count(distinct snapshot_date) observed_days,
       max(total_access_count)-min(total_access_count) access_growth,
       max(last_used) last_used
  from prod.dct_index_usage_snapshot
 where uniqueness='NONUNIQUE'
   and constraint_backed='N'
   and status='VALID'
   and snapshot_date>=trunc(sysdate)-30
 group by index_owner,table_name,index_name
having count(distinct snapshot_date)>=30
   and max(total_access_count)=min(total_access_count);

declare
  l_exists number;
  l_start timestamp with time zone;
begin
  l_start:=to_timestamp_tz(
    to_char(systimestamp at time zone 'Asia/Dubai'+interval '1' day,'YYYY-MM-DD')||
    ' 03:00:00 Asia/Dubai','YYYY-MM-DD HH24:MI:SS TZR');
  select count(*) into l_exists from dba_scheduler_jobs
   where owner='PROD' and job_name='DCT_INDEX_USAGE_JOB';
  if l_exists=0 then
    dbms_scheduler.create_job(
      job_name=>'PROD.DCT_INDEX_USAGE_JOB',job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_INDEX_USAGE_PKG.CAPTURE',start_date=>l_start,
      repeat_interval=>'FREQ=DAILY;BYHOUR=3;BYMINUTE=0;BYSECOND=0',
      enabled=>false,auto_drop=>false,
      comments=>'Daily index usage snapshot; monitoring only, no index changes');
  else
    dbms_scheduler.disable('PROD.DCT_INDEX_USAGE_JOB',force=>true);
    dbms_scheduler.set_attribute('PROD.DCT_INDEX_USAGE_JOB','job_action','PROD.DCT_INDEX_USAGE_PKG.CAPTURE');
    dbms_scheduler.set_attribute('PROD.DCT_INDEX_USAGE_JOB','start_date',l_start);
    dbms_scheduler.set_attribute('PROD.DCT_INDEX_USAGE_JOB','repeat_interval',
                                 'FREQ=DAILY;BYHOUR=3;BYMINUTE=0;BYSECOND=0');
  end if;
  dbms_scheduler.enable('PROD.DCT_INDEX_USAGE_JOB');
end;
/

begin prod.dct_index_usage_pkg.capture; end;
/

select snapshot_date,count(*) indexes_captured,
       sum(case when total_access_count>0 then 1 else 0 end) indexes_used
  from prod.dct_index_usage_snapshot
 group by snapshot_date order by snapshot_date desc fetch first 3 rows only;
select count(*) candidates_after_30_days from prod.dct_index_unused_candidate_v;
select owner,job_name,enabled,state,next_run_date from dba_scheduler_jobs
 where owner='PROD' and job_name='DCT_INDEX_USAGE_JOB';
select object_name,object_type,status from dba_objects
 where owner='PROD' and object_name in
 ('DCT_INDEX_USAGE_SNAPSHOT','DCT_INDEX_USAGE_PKG','DCT_INDEX_UNUSED_CANDIDATE_V')
 order by object_name,object_type;

exit
