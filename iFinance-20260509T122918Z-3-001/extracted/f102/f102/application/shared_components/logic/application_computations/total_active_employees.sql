prompt --application/shared_components/logic/application_computations/total_active_employees
begin
--   Manifest
--     APPLICATION COMPUTATION: TOTAL_ACTIVE_EMPLOYEES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(7292593449792119)
,p_computation_sequence=>10
,p_computation_item=>'TOTAL_ACTIVE_EMPLOYEES'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*) total_active_employees',
'from dct_employees_list2',
'where current_flag = ''Y'';'))
,p_computation_error_message=>'Error while compute total Active Employees'
);
wwv_flow_api.component_end;
end;
/
