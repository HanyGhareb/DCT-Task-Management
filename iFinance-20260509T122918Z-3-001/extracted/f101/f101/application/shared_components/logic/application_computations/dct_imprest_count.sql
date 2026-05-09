prompt --application/shared_components/logic/application_computations/dct_imprest_count
begin
--   Manifest
--     APPLICATION COMPUTATION: DCT_IMPREST_COUNT
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
 p_id=>wwv_flow_api.id(333352364957944)
,p_computation_sequence=>10
,p_computation_item=>'DCT_IMPREST_COUNT'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select Count(*)',
'from employee_vendors',
'where vendor_name = ''ABU DHABI TOURISM & CULTURE AUTHORITY - IMPREST''; '))
,p_computation_error_message=>'error while set application Item DCT_IMPREST_COUNT'
);
wwv_flow_api.component_end;
end;
/
