-- Refresh optimizer statistics for the production application schema.
-- GATHER AUTO limits work to objects whose statistics are missing or stale.
set define off
set serveroutput on
whenever sqlerror exit sql.sqlcode rollback

begin
  dbms_stats.gather_schema_stats(
    ownname          => 'PROD',
    options          => 'GATHER AUTO',
    estimate_percent => dbms_stats.auto_sample_size,
    method_opt       => 'FOR ALL COLUMNS SIZE AUTO',
    degree           => dbms_stats.auto_degree,
    cascade          => true,
    no_invalidate    => dbms_stats.auto_invalidate
  );
  dbms_output.put_line('PROD optimizer statistics refreshed successfully.');
end;
/

select count(*) as invalid_indexes
  from all_indexes
 where owner = 'PROD'
   and status <> 'VALID';

select count(*) as stale_or_missing_index_stats
  from all_indexes
 where owner = 'PROD'
   and (last_analyzed is null or last_analyzed < sysdate - 30);

exit
