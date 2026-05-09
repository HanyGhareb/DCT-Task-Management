prompt --application/shared_components/logic/application_computations/person_id
begin
--   Manifest
--     APPLICATION COMPUTATION: PERSON_ID
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(36807283392723260)
,p_computation_sequence=>10
,p_computation_item=>'PERSON_ID'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>'select person_id from employees_v where user_name = :APP_USER'
,p_computation_error_message=>'error in PersonID '
);
wwv_flow_api.component_end;
end;
/
