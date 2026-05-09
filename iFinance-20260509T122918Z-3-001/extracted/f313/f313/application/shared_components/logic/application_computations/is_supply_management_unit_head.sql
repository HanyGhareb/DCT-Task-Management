prompt --application/shared_components/logic/application_computations/is_supply_management_unit_head
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_SUPPLY_MANAGEMENT_UNIT_HEAD
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(2587444978060510)
,p_computation_sequence=>20
,p_computation_item=>'IS_SUPPLY_MANAGEMENT_UNIT_HEAD'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(distinct person_id)',
'from DCT_DATA_ACCESS_ASSIGNMENT',
'where entity_id = 31    -- 31 for Supply Management Unit Heads Role',
'and status = ''A''',
'and sysdate between start_date and nvl(end_date , sysdate+ 100)',
'and person_id = :PERSON_ID;'))
,p_computation_error_message=>'Error while compute IS_SUPPLY_MANAGEMENT_UNIT_HEAD application Item '
);
wwv_flow_api.component_end;
end;
/
