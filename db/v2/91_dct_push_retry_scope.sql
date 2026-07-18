-- Fix push retry accounting: an HTTP batch failure must update only the rows
-- selected for that batch, never every PENDING outbox row.
set define off
set serveroutput on
whenever sqlerror exit sql.sqlcode rollback

create or replace package body prod.dct_push_pkg as
  procedure register(p_user_id in number,p_platform in varchar2,
                     p_token in varchar2,p_app_version in varchar2 default null) is
  begin
    update prod.dct_device_tokens
       set user_id=p_user_id,platform=p_platform,app_version=p_app_version,
           is_active='Y',last_seen_at=systimestamp
     where push_token=p_token;
    if sql%rowcount=0 then
      insert into prod.dct_device_tokens(user_id,platform,push_token,app_version)
      values(p_user_id,p_platform,p_token,p_app_version);
    end if;
    commit;
  end register;

  procedure unregister(p_token in varchar2) is
  begin
    update prod.dct_device_tokens set is_active='N' where push_token=p_token;
    commit;
  end unregister;

  procedure send_pending(p_limit in number default 100) is
    type t_id_list is table of number index by pls_integer;
    l_body  clob;
    l_res   clob;
    l_first boolean:=true;
    l_err   varchar2(2000);
    l_ids   t_id_list;
  begin
    l_body:='[';
    for r in (
      select outbox_id,push_token,title,body,data_json
        from prod.dct_push_outbox
       where status='PENDING' and attempts<5
       order by created_at
       fetch first p_limit rows only
    ) loop
      l_ids(l_ids.count+1):=r.outbox_id;
      if not l_first then l_body:=l_body||','; end if;
      l_first:=false;
      l_body:=l_body
        ||'{"to":"'||r.push_token||'"'
        ||',"title":'||apex_json.stringify(r.title)
        ||',"body":'||apex_json.stringify(nvl(r.body,' '))
        ||',"sound":"default","priority":"high"'
        ||',"data":'||nvl(r.data_json,'{}')||'}';
      update prod.dct_push_outbox
         set attempts=attempts+1,status='SENT',sent_at=systimestamp
       where outbox_id=r.outbox_id;
    end loop;
    l_body:=l_body||']';
    if l_body='[]' then return; end if;

    begin
      apex_web_service.g_request_headers.delete;
      apex_web_service.g_request_headers(1).name:='Content-Type';
      apex_web_service.g_request_headers(1).value:='application/json';
      l_res:=apex_web_service.make_rest_request(
        p_url=>'https://exp.host/--/api/v2/push/send',
        p_http_method=>'POST',p_body=>l_body);
      commit;
    exception when others then
      l_err:=substr(sqlerrm,1,2000);
      rollback;
      if l_ids.count>0 then
        forall i in 1..l_ids.count
          update prod.dct_push_outbox
             set attempts=attempts+1,
                 status=case when attempts+1>=5 then 'FAILED' else 'PENDING' end,
                 error_msg=l_err
           where outbox_id=l_ids(i) and status='PENDING';
      end if;
      commit;
    end;
  end send_pending;
end dct_push_pkg;
/

show errors package body prod.dct_push_pkg

select object_name,object_type,status
  from dba_objects
 where owner='PROD' and object_name='DCT_PUSH_PKG'
 order by object_type;

select status,count(*) row_count
  from prod.dct_push_outbox
 group by status order by status;

exit
