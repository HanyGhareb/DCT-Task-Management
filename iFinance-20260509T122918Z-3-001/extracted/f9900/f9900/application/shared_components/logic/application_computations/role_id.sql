prompt --application/shared_components/logic/application_computations/role_id
begin
--   Manifest
--     APPLICATION COMPUTATION: ROLE_ID
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
 p_id=>wwv_flow_api.id(39813515546897711)
,p_computation_sequence=>10
,p_computation_item=>'ROLE_ID'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select role_id',
'from cwip_team',
'where status = ''A''',
'and sysdate BETWEEN nvl(start_date ,to_date(''01-01-2020'' , ''dd-mm-yyyy'')) ',
'        AND nvl(end_date ,to_date(''01-01-4020'' , ''dd-mm-yyyy''))',
'and person_id = (select u.user_id',
'                 from dct_ext_users u',
'                 where u.user_name = :APP_USER)',
'and rownum = 1;'))
);
wwv_flow_api.component_end;
end;
/
