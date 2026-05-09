prompt --application/shared_components/logic/application_computations/person_id
begin
--   Manifest
--     APPLICATION COMPUTATION: PERSON_ID
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(11885341519980198)
,p_computation_sequence=>10
,p_computation_item=>'PERSON_ID'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select user_id',
'from dct_ext_users',
'where user_name = :APP_USER'))
,p_computation_error_message=>'Error in Application Item (Person ID)'
);
wwv_flow_api.component_end;
end;
/
