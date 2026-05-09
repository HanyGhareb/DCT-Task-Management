prompt --application/shared_components/logic/application_computations/is_ifinance_admin
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_IFINANCE_ADMIN
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
 p_id=>wwv_flow_api.id(128404929435422011)
,p_computation_sequence=>20
,p_computation_item=>'IS_IFINANCE_ADMIN'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT decode(count(*) , 0 , ''N'' , ''Y'')',
'FROM',
'    dct_data_access_assignment',
'WHERE',
'        entity_type_id = ''ROLE''',
'    AND entity_id = 24',
'    and PERSON_ID = :PERSON_ID',
'    AND status = ''A''',
'    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10);'))
);
wwv_flow_api.component_end;
end;
/
