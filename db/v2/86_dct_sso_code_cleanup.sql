-- Independent cleanup for expired and consumed one-time SSO hand-off codes.
-- Keeps a one-hour grace period; authentication outcomes remain in DCT_AUDIT_LOG.
set define off
set serveroutput on
whenever sqlerror exit sql.sqlcode rollback

declare
  l_count number;
begin
  select count(*) into l_count
    from dba_tables
   where owner='PROD' and table_name='DCT_SSO_CLEANUP_STATE';
  if l_count=0 then
    execute immediate q'[
      create table prod.dct_sso_cleanup_state (
        state_id      number not null,
        last_run_at   timestamp with time zone,
        deleted_rows  number default 0 not null,
        status        varchar2(20) not null,
        error_message varchar2(1000),
        constraint pk_dct_sso_cleanup_state primary key (state_id),
        constraint ck_dct_sso_cleanup_status check (status in ('SUCCESS','FAILED'))
      )]';
  end if;
end;
/

create or replace procedure prod.dct_sso_code_cleanup authid definer as
  l_rows number:=0;
  procedure save_state(p_rows number,p_status varchar2,p_error varchar2 default null) is
    pragma autonomous_transaction;
  begin
    merge into prod.dct_sso_cleanup_state s
    using (select 1 state_id from dual) x on (s.state_id=x.state_id)
    when matched then update set
      s.last_run_at=systimestamp,s.deleted_rows=p_rows,s.status=p_status,
      s.error_message=substr(p_error,1,1000)
    when not matched then insert
      (state_id,last_run_at,deleted_rows,status,error_message)
    values
      (1,systimestamp,p_rows,p_status,substr(p_error,1,1000));
    commit;
  end;
begin
  delete from prod.dct_sso_codes
   where expires_at < sys_extract_utc(systimestamp)-interval '1' hour
      or used_at    < sys_extract_utc(systimestamp)-interval '1' hour;
  l_rows:=sql%rowcount;
  commit;
  save_state(l_rows,'SUCCESS');
exception when others then
  rollback;
  save_state(0,'FAILED',sqlerrm);
  raise;
end dct_sso_code_cleanup;
/

declare
  l_exists number;
begin
  select count(*) into l_exists
    from dba_scheduler_jobs
   where owner='PROD' and job_name='DCT_SSO_CODE_CLEANUP_JOB';
  if l_exists=0 then
    dbms_scheduler.create_job(
      job_name=>'PROD.DCT_SSO_CODE_CLEANUP_JOB',
      job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_SSO_CODE_CLEANUP',
      start_date=>systimestamp,
      repeat_interval=>'FREQ=HOURLY;BYMINUTE=10;BYSECOND=0',
      enabled=>false,auto_drop=>false,
      comments=>'Hourly removal of expired or consumed one-time SSO codes after a one-hour grace period');
  else
    dbms_scheduler.disable('PROD.DCT_SSO_CODE_CLEANUP_JOB',force=>true);
    dbms_scheduler.set_attribute('PROD.DCT_SSO_CODE_CLEANUP_JOB','job_action',
                                 'PROD.DCT_SSO_CODE_CLEANUP');
    dbms_scheduler.set_attribute('PROD.DCT_SSO_CODE_CLEANUP_JOB','repeat_interval',
                                 'FREQ=HOURLY;BYMINUTE=10;BYSECOND=0');
  end if;
  dbms_scheduler.enable('PROD.DCT_SSO_CODE_CLEANUP_JOB');
end;
/

begin
  prod.dct_sso_code_cleanup;
end;
/

select state_id,last_run_at,deleted_rows,status,error_message
  from prod.dct_sso_cleanup_state;

select owner,job_name,enabled,state,next_run_date
  from dba_scheduler_jobs
 where owner='PROD' and job_name='DCT_SSO_CODE_CLEANUP_JOB';

select object_name,object_type,status
  from dba_objects
 where owner='PROD'
   and object_name in ('DCT_SSO_CODE_CLEANUP','DCT_SSO_CLEANUP_STATE')
 order by object_name,object_type;

exit
