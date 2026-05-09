prompt --application/shared_components/logic/application_computations/single_source_request_count
begin
--   Manifest
--     APPLICATION COMPUTATION: SINGLE_SOURCE_REQUEST_COUNT
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
 p_id=>wwv_flow_api.id(1499097254017118)
,p_computation_sequence=>20
,p_computation_item=>'SINGLE_SOURCE_REQUEST_COUNT'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'begin',
'',
'if :IS_BUYER > 0',
'   or :IS_COMMITTEE_SECRETARY > 0',
'   or  :IS_SINGLE_SOURCE_ADMIN = ''Y''',
'   or  :IS_SOUCEING_MANAGER     > 0',
'   or  :IS_SUPPLY_MANAGEMENT_UNIT_HEAD > 0',
' then  ',
'    select count(*)',
'    into l_count',
'    from SCM_SINGL_SOURCE;',
'else',
'    select count(*)',
'    into l_count',
'    from SCM_SINGL_SOURCE',
'where REQUESTOR_PERSON_ID = :PERSON_ID;',
'end if;',
'',
'return l_count ;',
'end;'))
,p_computation_error_message=>'error in application item (SINGLE_SOURCE_REQUEST_COUNT) in 120App'
);
wwv_flow_api.component_end;
end;
/
