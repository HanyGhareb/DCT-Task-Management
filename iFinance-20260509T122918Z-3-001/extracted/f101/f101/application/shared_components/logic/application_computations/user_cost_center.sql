prompt --application/shared_components/logic/application_computations/user_cost_center
begin
--   Manifest
--     APPLICATION COMPUTATION: USER_COST_CENTER
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
 p_id=>wwv_flow_api.id(67011807964907176)
,p_computation_sequence=>20
,p_computation_item=>'USER_COST_CENTER'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'PLSQL_EXPRESSION'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>'user_details.get_cost_center(:PERSON_ID)'
,p_computation_error_message=>'Can''t identity User Cost Center'
);
wwv_flow_api.component_end;
end;
/
