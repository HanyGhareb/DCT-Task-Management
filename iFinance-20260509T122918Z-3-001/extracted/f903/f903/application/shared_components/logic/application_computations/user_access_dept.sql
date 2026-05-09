prompt --application/shared_components/logic/application_computations/user_access_dept
begin
--   Manifest
--     APPLICATION COMPUTATION: USER_ACCESS_DEPT
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(70531487662730484)
,p_computation_sequence=>10
,p_computation_item=>'USER_ACCESS_DEPT'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>'select btf_workflow.USER_ACCESS_dept(:APP_USER) from dual;'
,p_computation_error_message=>'No Access to any Department'
);
wwv_flow_api.component_end;
end;
/
