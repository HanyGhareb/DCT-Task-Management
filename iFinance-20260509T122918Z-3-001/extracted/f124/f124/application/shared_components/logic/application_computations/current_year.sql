prompt --application/shared_components/logic/application_computations/current_year
begin
--   Manifest
--     APPLICATION COMPUTATION: CURRENT_YEAR
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(128403451099447139)
,p_computation_sequence=>10
,p_computation_item=>'CURRENT_YEAR'
,p_computation_point=>'ON_NEW_INSTANCE'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXTRACT(YEAR FROM sysdate)',
'from dual;'))
);
wwv_flow_api.component_end;
end;
/
