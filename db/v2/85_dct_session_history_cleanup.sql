-- Nightly cleanup of expired/logged-out session history.
-- Active sessions are never deleted. Additive and rerunnable.
set define off
set serveroutput on
whenever sqlerror exit sql.sqlcode rollback

begin
  merge into prod.dct_system_settings s
  using (
    select 'SESSION_HISTORY_RETENTION_DAYS' setting_key,
           '90' setting_value,
           'Keep inactive or logged-out session history for this many days (minimum 30). Active sessions are never deleted.' description_en
      from dual
  ) x on (s.setting_key=x.setting_key)
  when matched then update set
    s.value_type='NUMBER', s.category='DATA_MAINTENANCE', s.is_system='Y',
    s.description_en=x.description_en
  when not matched then insert
    (setting_key,setting_value,value_type,category,description_en,is_system,created_by)
  values
    (x.setting_key,x.setting_value,'NUMBER','DATA_MAINTENANCE',x.description_en,'Y','SYSTEM');
  commit;
end;
/

declare
  l_count number;
begin
  select count(*) into l_count
    from dba_tables
   where owner='PROD' and table_name='DCT_SESSION_CLEANUP_STATE';
  if l_count=0 then
    execute immediate q'[
      create table prod.dct_session_cleanup_state (
        state_id       number not null,
        last_run_at    timestamp with time zone,
        last_run_by    varchar2(100),
        retention_days number,
        deleted_rows   number default 0 not null,
        status         varchar2(20) not null,
        error_message  varchar2(1000),
        constraint pk_dct_session_cleanup_state primary key (state_id),
        constraint ck_dct_session_cleanup_status check (status in ('SUCCESS','FAILED'))
      )]';
  end if;
end;
/

create or replace package prod.dct_session_cleanup_pkg authid definer as
  procedure run_cleanup(p_run_by varchar2 default 'SCHEDULER');
  procedure run_scheduled;
end dct_session_cleanup_pkg;
/

create or replace package body prod.dct_session_cleanup_pkg as
  procedure save_state(
    p_run_by varchar2,
    p_days   number,
    p_rows   number,
    p_status varchar2,
    p_error  varchar2 default null
  ) is
    pragma autonomous_transaction;
  begin
    merge into prod.dct_session_cleanup_state s
    using (select 1 state_id from dual) x on (s.state_id=x.state_id)
    when matched then update set
      s.last_run_at=systimestamp, s.last_run_by=p_run_by,
      s.retention_days=p_days, s.deleted_rows=p_rows,
      s.status=p_status, s.error_message=substr(p_error,1,1000)
    when not matched then insert
      (state_id,last_run_at,last_run_by,retention_days,deleted_rows,status,error_message)
    values
      (1,systimestamp,p_run_by,p_days,p_rows,p_status,substr(p_error,1,1000));
    commit;
  end;

  procedure run_cleanup(p_run_by varchar2 default 'SCHEDULER') is
    l_days number:=90;
    l_rows number:=0;
  begin
    begin
      select greatest(30,to_number(setting_value default 90 on conversion error))
        into l_days
        from prod.dct_system_settings
       where setting_key='SESSION_HISTORY_RETENTION_DAYS';
    exception when no_data_found then l_days:=90;
    end;

    delete from prod.dct_sessions
     where is_active='N'
       and coalesce(logout_at,last_activity_at,login_at) < systimestamp-numtodsinterval(l_days,'DAY');
    l_rows:=sql%rowcount;
    commit;
    save_state(nvl(p_run_by,'SCHEDULER'),l_days,l_rows,'SUCCESS');
  exception when others then
    rollback;
    save_state(nvl(p_run_by,'SCHEDULER'),l_days,0,'FAILED',sqlerrm);
    raise;
  end run_cleanup;

  procedure run_scheduled is
  begin
    run_cleanup('SCHEDULER');
  end run_scheduled;
end dct_session_cleanup_pkg;
/

declare
  l_exists number;
  l_start timestamp with time zone;
begin
  l_start:=to_timestamp_tz(
    to_char(systimestamp at time zone 'Asia/Dubai'+interval '1' day,'YYYY-MM-DD')||
    ' 01:15:00 Asia/Dubai','YYYY-MM-DD HH24:MI:SS TZR');
  select count(*) into l_exists
    from dba_scheduler_jobs
   where owner='PROD' and job_name='DCT_SESSION_CLEANUP_JOB';
  if l_exists=0 then
    dbms_scheduler.create_job(
      job_name=>'PROD.DCT_SESSION_CLEANUP_JOB',
      job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_SESSION_CLEANUP_PKG.RUN_SCHEDULED',
      start_date=>l_start,
      repeat_interval=>'FREQ=DAILY;BYHOUR=1;BYMINUTE=15;BYSECOND=0',
      enabled=>false, auto_drop=>false,
      comments=>'Delete inactive session history older than the configured retention period');
  else
    dbms_scheduler.disable('PROD.DCT_SESSION_CLEANUP_JOB',force=>true);
    dbms_scheduler.set_attribute('PROD.DCT_SESSION_CLEANUP_JOB','job_action',
                                 'PROD.DCT_SESSION_CLEANUP_PKG.RUN_SCHEDULED');
    dbms_scheduler.set_attribute('PROD.DCT_SESSION_CLEANUP_JOB','start_date',l_start);
    dbms_scheduler.set_attribute('PROD.DCT_SESSION_CLEANUP_JOB','repeat_interval',
                                 'FREQ=DAILY;BYHOUR=1;BYMINUTE=15;BYSECOND=0');
  end if;
  dbms_scheduler.enable('PROD.DCT_SESSION_CLEANUP_JOB');
end;
/

select setting_key,setting_value,category
  from prod.dct_system_settings
 where setting_key='SESSION_HISTORY_RETENTION_DAYS';

select owner,job_name,enabled,state,next_run_date
  from dba_scheduler_jobs
 where owner='PROD' and job_name='DCT_SESSION_CLEANUP_JOB';

select object_name,object_type,status
  from dba_objects
 where owner='PROD'
   and object_name in ('DCT_SESSION_CLEANUP_PKG','DCT_SESSION_CLEANUP_STATE')
 order by object_name,object_type;

exit
