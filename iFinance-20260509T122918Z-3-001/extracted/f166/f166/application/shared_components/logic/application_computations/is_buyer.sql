prompt --application/shared_components/logic/application_computations/is_buyer
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_BUYER
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(1625143509760251)
,p_computation_sequence=>40
,p_computation_item=>'IS_BUYER'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT count(*)',
'FROM dct_data_access_assignment d ',
'where d.person_id = :PERSON_ID',
'and d.entity_type_id = ''ROLE'' ',
'and d.entity_id = 48 ',
'and d.status = ''A'' ',
'and sysdate BETWEEN d.start_date and nvl(d.end_date , sysdate + 10);'))
,p_computation_error_message=>'Error in Buyer'
);
wwv_flow_api.component_end;
end;
/
