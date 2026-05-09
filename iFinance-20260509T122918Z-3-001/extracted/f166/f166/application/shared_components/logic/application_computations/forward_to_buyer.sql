prompt --application/shared_components/logic/application_computations/forward_to_buyer
begin
--   Manifest
--     APPLICATION COMPUTATION: FORWARD_TO_BUYER
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
 p_id=>wwv_flow_api.id(43826465703781)
,p_computation_sequence=>20
,p_computation_item=>'FORWARD_TO_BUYER'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(distinct person_id)',
'from DCT_DATA_ACCESS_ASSIGNMENT',
'where entity_id = 30    -- 30 for SOURCING_MANAGER Role',
'and status = ''A''',
'and sysdate between start_date and nvl(end_date , sysdate+ 100)',
'and person_id = :PERSON_ID;'))
,p_computation_error_message=>'error while checking FORWARD_TO_BUYER_YN Application Item'
);
wwv_flow_api.component_end;
end;
/
