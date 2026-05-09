prompt --application/shared_components/logic/application_computations/is_fbp_yn
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_FBP_YN
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(54200919440708029)
,p_computation_sequence=>20
,p_computation_item=>'IS_FBP_YN'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'l_count number;',
'l_res   varchar2(1);',
'begin',
'select COUNT(*) ',
'into l_count',
'from cost_centers_fbp',
'where person_id = :PERSON_ID',
'and bp_type = ''FBP''',
'and status = ''A''',
'and sysdate between nvl(start_date , sysdate - 10) ',
'    and nvl(end_date , sysdate + 10) ;',
'',
'if l_count > 0 then l_res  := ''Y'';',
'else',
'    l_res := ''N'';',
'end if;',
'return l_res;',
'End;'))
,p_computation_error_message=>'IS_FBP_YN issue'
);
wwv_flow_api.component_end;
end;
/
