prompt --application/shared_components/logic/application_computations/user_roles
begin
--   Manifest
--     APPLICATION COMPUTATION: USER_ROLES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>910
,p_default_id_offset=>82649548957193263
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(5632210528096886)
,p_computation_sequence=>10
,p_computation_item=>'USER_ROLES'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY_COLON'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select entity_id  -- , (select r.role_name from roles r where r.role_id = entity_id) xx                   ',
'from dct_data_access_assignment ',
'where entity_type_id = ''ROLE''',
'and status = ''A''',
'and SYSDATE between start_date and NVL(end_date,sysdate + 1)and user_id = :APP_USER;'))
);
wwv_flow_api.component_end;
end;
/
