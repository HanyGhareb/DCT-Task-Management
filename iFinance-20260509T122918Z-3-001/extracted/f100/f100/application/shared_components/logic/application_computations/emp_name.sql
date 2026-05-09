prompt --application/shared_components/logic/application_computations/emp_name
begin
--   Manifest
--     APPLICATION COMPUTATION: EMP_NAME
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
 p_id=>wwv_flow_api.id(2107947722974147)
,p_computation_sequence=>20
,p_computation_item=>'EMP_NAME'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'PLSQL_EXPRESSION'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>'user_details.get_short_name(:PERSON_ID)'
,p_compute_when_type=>'NEVER'
,p_computation_error_message=>'NO Employee defined for this application user.'
);
wwv_flow_api.component_end;
end;
/
