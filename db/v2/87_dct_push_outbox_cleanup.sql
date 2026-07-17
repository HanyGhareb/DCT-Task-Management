-- Retention cleanup for completed mobile push outbox rows.
-- PENDING rows are never deleted. Additive and rerunnable.
set define off
set serveroutput on
whenever sqlerror exit sql.sqlcode rollback

begin
  merge into prod.dct_system_settings s
  using (
    select 'PUSH_SENT_RETENTION_DAYS' setting_key,'30' setting_value,
           'Keep successfully sent mobile push messages for this many days (minimum 7).' description_en from dual
    union all
    select 'PUSH_FAILED_RETENTION_DAYS','90',
           'Keep permanently failed mobile push messages for this many days (minimum 30).' from dual
  ) x on (s.setting_key=x.setting_key)
  when matched then update set
    s.value_type='NUMBER',s.category='DATA_MAINTENANCE',s.is_system='Y',s.description_en=x.description_en
  when not matched then insert
    (setting_key,setting_value,value_type,category,description_en,is_system,created_by)
  values (x.setting_key,x.setting_value,'NUMBER','DATA_MAINTENANCE',x.description_en,'Y','SYSTEM');
  commit;
end;
/

declare
  l_count number;
begin
  select count(*) into l_count from dba_tables
   where owner='PROD' and table_name='DCT_PUSH_CLEANUP_STATE';
  if l_count=0 then
    execute immediate q'[
      create table prod.dct_push_cleanup_state (
        state_id       number not null,
        last_run_at    timestamp with time zone,
        sent_days      number,
        failed_days    number,
        sent_deleted   number default 0 not null,
        failed_deleted number default 0 not null,
        status         varchar2(20) not null,
        error_message  varchar2(1000),
        constraint pk_dct_push_cleanup_state primary key (state_id),
        constraint ck_dct_push_cleanup_status check (status in ('SUCCESS','FAILED'))
      )]';
  end if;
end;
/

create or replace procedure prod.dct_push_outbox_cleanup authid definer as
  l_sent_days number:=30;
  l_failed_days number:=90;
  l_sent_rows number:=0;
  l_failed_rows number:=0;
  procedure save_state(p_status varchar2,p_error varchar2 default null) is
    pragma autonomous_transaction;
  begin
    merge into prod.dct_push_cleanup_state s
    using (select 1 state_id from dual) x on (s.state_id=x.state_id)
    when matched then update set
      s.last_run_at=systimestamp,s.sent_days=l_sent_days,s.failed_days=l_failed_days,
      s.sent_deleted=l_sent_rows,s.failed_deleted=l_failed_rows,
      s.status=p_status,s.error_message=substr(p_error,1,1000)
    when not matched then insert
      (state_id,last_run_at,sent_days,failed_days,sent_deleted,failed_deleted,status,error_message)
    values
      (1,systimestamp,l_sent_days,l_failed_days,l_sent_rows,l_failed_rows,p_status,substr(p_error,1,1000));
    commit;
  end;
begin
  begin
    select greatest(7,to_number(setting_value default 30 on conversion error))
      into l_sent_days from prod.dct_system_settings where setting_key='PUSH_SENT_RETENTION_DAYS';
  exception when no_data_found then l_sent_days:=30; end;
  begin
    select greatest(30,to_number(setting_value default 90 on conversion error))
      into l_failed_days from prod.dct_system_settings where setting_key='PUSH_FAILED_RETENTION_DAYS';
  exception when no_data_found then l_failed_days:=90; end;

  delete from prod.dct_push_outbox
   where status='SENT'
     and nvl(sent_at,created_at) < systimestamp-numtodsinterval(l_sent_days,'DAY');
  l_sent_rows:=sql%rowcount;

  delete from prod.dct_push_outbox
   where status='FAILED'
     and created_at < systimestamp-numtodsinterval(l_failed_days,'DAY');
  l_failed_rows:=sql%rowcount;
  commit;
  save_state('SUCCESS');
exception when others then
  rollback;
  l_sent_rows:=0;l_failed_rows:=0;
  save_state('FAILED',sqlerrm);
  raise;
end dct_push_outbox_cleanup;
/

declare
  l_exists number;
  l_start timestamp with time zone;
begin
  l_start:=to_timestamp_tz(
    to_char(systimestamp at time zone 'Asia/Dubai'+interval '1' day,'YYYY-MM-DD')||
    ' 02:00:00 Asia/Dubai','YYYY-MM-DD HH24:MI:SS TZR');
  select count(*) into l_exists from dba_scheduler_jobs
   where owner='PROD' and job_name='DCT_PUSH_CLEANUP_JOB';
  if l_exists=0 then
    dbms_scheduler.create_job(
      job_name=>'PROD.DCT_PUSH_CLEANUP_JOB',job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_PUSH_OUTBOX_CLEANUP',start_date=>l_start,
      repeat_interval=>'FREQ=DAILY;BYHOUR=2;BYMINUTE=0;BYSECOND=0',
      enabled=>false,auto_drop=>false,
      comments=>'Nightly cleanup of completed mobile push outbox rows; PENDING rows are preserved');
  else
    dbms_scheduler.disable('PROD.DCT_PUSH_CLEANUP_JOB',force=>true);
    dbms_scheduler.set_attribute('PROD.DCT_PUSH_CLEANUP_JOB','job_action','PROD.DCT_PUSH_OUTBOX_CLEANUP');
    dbms_scheduler.set_attribute('PROD.DCT_PUSH_CLEANUP_JOB','start_date',l_start);
    dbms_scheduler.set_attribute('PROD.DCT_PUSH_CLEANUP_JOB','repeat_interval',
                                 'FREQ=DAILY;BYHOUR=2;BYMINUTE=0;BYSECOND=0');
  end if;
  dbms_scheduler.enable('PROD.DCT_PUSH_CLEANUP_JOB');
end;
/

begin prod.dct_push_outbox_cleanup; end;
/

select state_id,last_run_at,sent_days,failed_days,sent_deleted,failed_deleted,status
  from prod.dct_push_cleanup_state;
select status,count(*) row_count from prod.dct_push_outbox group by status order by status;
select owner,job_name,enabled,state,next_run_date from dba_scheduler_jobs
 where owner='PROD' and job_name='DCT_PUSH_CLEANUP_JOB';
select object_name,object_type,status from dba_objects
 where owner='PROD' and object_name in ('DCT_PUSH_OUTBOX_CLEANUP','DCT_PUSH_CLEANUP_STATE')
 order by object_name,object_type;

exit
