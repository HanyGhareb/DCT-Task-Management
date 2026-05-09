prompt --application/shared_components/logic/application_computations/active_service_agreement_count
begin
--   Manifest
--     APPLICATION COMPUTATION: ACTIVE_SERVICE_AGREEMENT_COUNT
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(36807919089700675)
,p_computation_sequence=>10
,p_computation_item=>'ACTIVE_SERVICE_AGREEMENT_COUNT'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*)',
'from service_providers_agreements',
'where status = ''A'''))
,p_computation_error_message=>'Error in ACTIVE_SERVICE_AGREEMENT_COUNT'
);
wwv_flow_api.component_end;
end;
/
