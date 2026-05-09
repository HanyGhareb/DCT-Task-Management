prompt --application/shared_components/logic/application_computations/is_petty_cash_admin
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_PETTY_CASH_ADMIN
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
 p_id=>wwv_flow_api.id(1503527433566276)
,p_computation_sequence=>20
,p_computation_item=>'IS_PETTY_CASH_ADMIN'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Declare',
'l_count  varchar2(10);',
'begin',
'SELECT count(*)',
'into l_count',
'FROM dct_data_access_assignment ',
'where entity_type_id = ''ROLE'' ',
'and entity_id = 11 ',
'and status = ''A'' ',
'and sysdate BETWEEN start_date and nvl(end_date , sysdate + 10)',
'and person_id = :PERSON_ID;',
'',
'if l_count > 0 Then ',
'                    return ''Y'';',
'           else ',
'               return ''N'';',
'End if;',
'',
'end;'))
,p_computation_error_message=>'Error in IS_PETTY_CASH_ADMIN Application Item'
);
wwv_flow_api.component_end;
end;
/
