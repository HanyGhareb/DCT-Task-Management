prompt --application/shared_components/logic/application_computations/ed_num
begin
--   Manifest
--     APPLICATION COMPUTATION: ED_NUM
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
 p_id=>wwv_flow_api.id(8965630875885205)
,p_computation_sequence=>10
,p_computation_item=>'ED_NUM'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT executive_director_num',
'from employees_v',
'where employee_num = :EMP_NUM'))
,p_computation_error_message=>'No Exec-Director for logged in user'
);
wwv_flow_api.component_end;
end;
/
