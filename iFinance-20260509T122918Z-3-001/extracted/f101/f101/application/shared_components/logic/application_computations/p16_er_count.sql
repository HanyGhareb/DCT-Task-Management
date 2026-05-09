prompt --application/shared_components/logic/application_computations/p16_er_count
begin
--   Manifest
--     APPLICATION COMPUTATION: P16_ER_COUNT
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
 p_id=>wwv_flow_api.id(4810167722993508)
,p_computation_sequence=>20
,p_computation_item=>'P16_ER_COUNT'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT count(expense_report_id) ',
'from expense_reports_all_v',
'where employee_num = :EMP_NUM'))
);
wwv_flow_api.component_end;
end;
/
