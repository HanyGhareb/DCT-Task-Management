prompt --application/shared_components/logic/application_computations/current_date
begin
--   Manifest
--     APPLICATION COMPUTATION: CURRENT_DATE
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(11926961846144389)
,p_computation_sequence=>10
,p_computation_item=>'CURRENT_DATE'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>'select to_char(current_date,''DD-MON-YYYY HH12:MI:SS AM'') currentdate from dual;'
,p_computation_error_message=>'Error in Application Item (Current Date)'
);
wwv_flow_api.component_end;
end;
/
