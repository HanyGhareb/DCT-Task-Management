-- Remove five confirmed empty legacy/example tables.
-- Safety: refuse to drop a table if it contains any rows.
set define off
set serveroutput on
whenever sqlerror exit sql.sqlcode rollback

declare
  procedure drop_empty_table(p_table_name varchar2) is
    l_exists number;
    l_rows   number;
  begin
    select count(*) into l_exists
      from dba_tables
     where owner='PROD' and table_name=upper(p_table_name);

    if l_exists=0 then
      dbms_output.put_line('Already absent: PROD.'||upper(p_table_name));
      return;
    end if;

    execute immediate 'select count(*) from prod.'||dbms_assert.simple_sql_name(p_table_name)
      into l_rows;
    if l_rows<>0 then
      raise_application_error(-20088,
        'Refusing to drop PROD.'||upper(p_table_name)||': table contains '||l_rows||' row(s)');
    end if;

    execute immediate 'drop table prod.'||dbms_assert.simple_sql_name(p_table_name)||' purge';
    dbms_output.put_line('Dropped empty table PROD.'||upper(p_table_name));
  end;
begin
  drop_empty_table('ATD_STG_EXAMPLE');
  drop_empty_table('ATD_EXAMPLE');
  drop_empty_table('ATD_PROJECTS_F');
  drop_empty_table('ATD_GRN');
  drop_empty_table('ATD_GRN_ALL');
end;
/

select table_name
  from dba_tables
 where owner='PROD'
   and table_name in ('ATD_STG_EXAMPLE','ATD_EXAMPLE','ATD_PROJECTS_F','ATD_GRN','ATD_GRN_ALL')
 order by table_name;

exit
