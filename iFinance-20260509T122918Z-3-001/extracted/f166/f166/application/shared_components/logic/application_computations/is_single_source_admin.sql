prompt --application/shared_components/logic/application_computations/is_single_source_admin
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_SINGLE_SOURCE_ADMIN
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
 p_id=>wwv_flow_api.id(69750365901261103)
,p_computation_sequence=>30
,p_computation_item=>'IS_SINGLE_SOURCE_ADMIN'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
' SELECT decode(count(person_id),0,''N'', ''Y'') ',
' FROM dct_data_access_assignment ',
' where entity_type_id = ''ROLE'' ',
' and entity_id = 67     -- for Single Source Admin role',
' and status = ''A'' ',
' and sysdate BETWEEN start_date and nvl(end_date , sysdate + 10)',
' and person_id = :PERSON_ID'))
,p_computation_error_message=>'Error while generate is_Single_source_admin item'
);
wwv_flow_api.component_end;
end;
/
