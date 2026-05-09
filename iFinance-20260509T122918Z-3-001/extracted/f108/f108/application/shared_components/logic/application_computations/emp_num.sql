prompt --application/shared_components/logic/application_computations/emp_num
begin
--   Manifest
--     APPLICATION COMPUTATION: EMP_NUM
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(19333496483562252)
,p_computation_sequence=>10
,p_computation_item=>'EMP_NUM'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT employee_num',
'FROM dct_employees_list2',
'where user_name = :APP_USER'))
,p_computation_error_message=>'error in EMP_NUM for MPR Application'
);
wwv_flow_api.component_end;
end;
/
