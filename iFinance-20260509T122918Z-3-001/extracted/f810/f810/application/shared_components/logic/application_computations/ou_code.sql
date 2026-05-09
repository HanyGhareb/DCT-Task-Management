prompt --application/shared_components/logic/application_computations/ou_code
begin
--   Manifest
--     APPLICATION COMPUTATION: OU_CODE
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(86768982053922902)
,p_computation_sequence=>20
,p_computation_item=>'OU_CODE'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>'TCA'
,p_computation_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Issue in OU_CODE',
'nvl(user_details.get_cost_center_ou(user_details.get_cost_center(:PERSON_ID)), ''TCA'')'))
);
wwv_flow_api.component_end;
end;
/
