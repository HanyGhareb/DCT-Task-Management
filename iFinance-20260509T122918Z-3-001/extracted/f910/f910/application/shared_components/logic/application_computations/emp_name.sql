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
,p_default_id_offset=>40620729557075005
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(2107947722974147)
,p_computation_sequence=>10
,p_computation_item=>'EMP_NAME'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT first_name || '' '' || last_name  ',
'FROM dct_employees_list2',
'where employee_num = substr(:APP_USER,4)'))
,p_computation_error_message=>'NO Employee defined for this application user.'
);
wwv_flow_api.component_end;
end;
/
