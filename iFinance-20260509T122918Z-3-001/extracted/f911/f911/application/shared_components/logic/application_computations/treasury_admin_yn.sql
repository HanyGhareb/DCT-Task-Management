prompt --application/shared_components/logic/application_computations/treasury_admin_yn
begin
--   Manifest
--     APPLICATION COMPUTATION: TREASURY_ADMIN_YN
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(34827216196081858)
,p_computation_sequence=>10
,p_computation_item=>'TREASURY_ADMIN_YN'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'begin',
'select count(distinct person_id)',
'into l_count ',
'from DCT_DATA_ACCESS_ASSIGNMENT',
'where entity_id = 52    -- 52 Treasury Reviewer Role',
'and status = ''A''',
'and person_id = :PERSON_ID',
'and sysdate between start_date and nvl(end_date , sysdate+ 100);',
'if l_count > 0 or :PERSON_ID in ( 680461, 585407 , 1542478, 1374852,128179) Then',
'return ''Y'';',
'else ',
'return ''N'';',
'End if;',
'',
'end;',
''))
,p_computation_error_message=>'Error while compute TREASURY_ADMIN_YN Item'
);
wwv_flow_api.component_end;
end;
/
