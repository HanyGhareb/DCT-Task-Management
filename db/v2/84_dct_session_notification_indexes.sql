-- Ensure high-value indexes exist on PROD tables. Index ownership may differ
-- from table ownership when the deployment account creates the index.
set define off
set serveroutput on
whenever sqlerror exit sql.sqlcode rollback

declare
  procedure create_if_missing(
    p_index_name varchar2,
    p_ddl        varchar2
  ) is
    l_count number;
  begin
    select count(*)
      into l_count
      from all_indexes
     where table_owner = 'PROD'
       and index_name = upper(p_index_name);

    if l_count = 0 then
      execute immediate p_ddl;
      dbms_output.put_line('Created PROD.' || upper(p_index_name));
    else
      dbms_output.put_line('Equivalent index already exists: ' || upper(p_index_name));
    end if;
  end;
begin
  create_if_missing(
    'IX_DCT_SESS_USER',
    'create index prod.ix_dct_sess_user on prod.dct_sessions(user_id, is_active)'
  );
  create_if_missing(
    'IX_DCT_NOTIF_USER',
    'create index prod.ix_dct_notif_user on prod.dct_notifications(recipient_user_id, is_read)'
  );
end;
/

begin
  for x in (
    select owner, index_name
      from all_indexes
     where table_owner = 'PROD'
       and index_name in ('IX_DCT_SESS_USER', 'IX_DCT_NOTIF_USER')
  ) loop
    dbms_stats.gather_index_stats(x.owner, x.index_name);
  end loop;
end;
/

select i.table_name,
       i.index_name,
       i.status,
       listagg(c.column_name, ', ') within group (order by c.column_position) as columns_list
  from all_indexes i
  join all_ind_columns c
    on c.index_owner = i.owner
   and c.index_name = i.index_name
   and c.table_owner = i.table_owner
   and c.table_name = i.table_name
 where i.table_owner = 'PROD'
   and i.index_name in ('IX_DCT_SESS_USER', 'IX_DCT_NOTIF_USER')
 group by i.table_name, i.index_name, i.status
 order by i.table_name;

exit
