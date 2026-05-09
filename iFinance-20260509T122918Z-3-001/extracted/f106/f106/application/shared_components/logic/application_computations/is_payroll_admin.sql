prompt --application/shared_components/logic/application_computations/is_payroll_admin
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_PAYROLL_ADMIN
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(3398574187135309)
,p_computation_sequence=>20
,p_computation_item=>'IS_PAYROLL_ADMIN'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'          SELECT   decode(nvl(count(person_id),0),0,''N'', ''Y'')',
'--      into l_count',
'        FROM dct_data_access_assignment ',
'        where entity_type_id = ''ROLE''',
'        and PERSON_ID = :PERSON_ID',
'        and entity_id = 98  -- 98	Housing Admin',
'        and status = ''A'' ',
'        and sysdate BETWEEN start_date ',
'            and nvl(end_date , sysdate + 10);'))
,p_computation_error_message=>'error IS_PAYROLL_ADMIn'
);
wwv_flow_api.component_end;
end;
/
