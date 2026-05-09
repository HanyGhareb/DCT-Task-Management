prompt --application/shared_components/logic/application_computations/user_groups
begin
--   Manifest
--     APPLICATION COMPUTATION: USER_GROUPS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(5633698600183310)
,p_computation_sequence=>10
,p_computation_item=>'USER_GROUPS'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY_COLON'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select group_name as role_group',
'from APEX_WORKSPACE_GROUP_USERS',
'where workspace_name = ''PROD''',
'and user_name =  :APP_USER;'))
);
wwv_flow_api.component_end;
end;
/
