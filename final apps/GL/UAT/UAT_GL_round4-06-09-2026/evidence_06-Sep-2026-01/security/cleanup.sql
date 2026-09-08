whenever sqlerror exit failure rollback
set serveroutput on
begin
 delete from prod.dct_sessions where user_id in (select user_id from prod.dct_users where username in ('UAT_FD_20260906062316_ALLOW','UAT_FD_20260906062316_DENY'));
 delete from prod.dct_user_roles where user_id in (select user_id from prod.dct_users where username in ('UAT_FD_20260906062316_ALLOW','UAT_FD_20260906062316_DENY'));
 delete from prod.dct_users where username in ('UAT_FD_20260906062316_ALLOW','UAT_FD_20260906062316_DENY');
 dbms_output.put_line('REMOVED_ACCOUNTS='||sql%rowcount);
 commit;
end;
/
select count(*) remaining_test_accounts from prod.dct_users where username in ('UAT_FD_20260906062316_ALLOW','UAT_FD_20260906062316_DENY');
exit
