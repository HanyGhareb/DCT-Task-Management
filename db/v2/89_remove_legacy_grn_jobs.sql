-- Remove disabled legacy GRN extract jobs whose target table ATD_GRN was retired.
-- The active GRN Temporary Job targeting ATD_GRN_ALL_V2 is explicitly preserved.
set define off
set serveroutput on
whenever sqlerror exit sql.sqlcode rollback

declare
  l_bad number;
  l_deleted number;
  procedure drop_scheduler_job(p_name varchar2) is
    l_count number;
  begin
    select count(*) into l_count from dba_scheduler_jobs
     where owner='PROD' and job_name=upper(p_name);
    if l_count>0 then
      dbms_scheduler.drop_job('PROD.'||upper(p_name),force=>true);
      dbms_output.put_line('Dropped scheduler job PROD.'||upper(p_name));
    end if;
  end;
begin
  select count(*) into l_bad
    from prod.atd_otbi_jobs
   where job_name in ('GRN Full','GRN Updates 10Min','GRN Hourly')
     and (enabled<>'N' or upper(stage_table)<>'PROD.ATD_GRN');
  if l_bad>0 then
    raise_application_error(-20089,'Legacy GRN job state changed; refusing removal');
  end if;

  drop_scheduler_job('ATD_OTBI_GRN_FULL');
  drop_scheduler_job('ATD_OTBI_GRN_UPDATES_10MIN');
  drop_scheduler_job('ATD_OTBI_GRN_HOURLY');

  delete from prod.atd_otbi_jobs
   where job_name in ('GRN Full','GRN Updates 10Min','GRN Hourly')
     and enabled='N'
     and upper(stage_table)='PROD.ATD_GRN';
  l_deleted:=sql%rowcount;
  commit;
  dbms_output.put_line('Deleted disabled legacy GRN configurations: '||l_deleted);
end;
/

select job_name,stage_table,final_table,enabled
  from prod.atd_otbi_jobs
 where upper(job_name) like 'GRN%'
 order by job_name;

select owner,job_name,enabled,state
  from dba_scheduler_jobs
 where owner='PROD' and job_name like 'ATD_OTBI_GRN%'
 order by job_name;

exit
