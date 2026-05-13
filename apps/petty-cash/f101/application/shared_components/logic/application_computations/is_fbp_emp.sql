prompt --application/shared_components/logic/application_computations/is_fbp_emp
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_FBP_EMP
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(27173799144084643)
,p_computation_sequence=>30
,p_computation_item=>'IS_FBP_EMP'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'',
'begin',
'select count(*) ',
'into l_count',
'from cost_centers_fbp',
'where bp_type = ''FBP''',
'and status = ''A''',
'and sysdate between nvl(START_DATE, sysdate -10) and nvl(END_DATE , sysdate + 10)',
'and person_id = :PERSON_ID;',
'',
'if l_count > 0 then return ''Y'' ;',
'else',
'  return ''N'';',
'end if;',
'end;'))
);
wwv_flow_api.component_end;
end;
/
