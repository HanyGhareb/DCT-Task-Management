prompt --application/shared_components/logic/application_computations/tac_form_count
begin
--   Manifest
--     APPLICATION COMPUTATION: TAC_FORM_COUNT
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
 p_id=>wwv_flow_api.id(1499267169010766)
,p_computation_sequence=>20
,p_computation_item=>'TAC_FORM_COUNT'
,p_computation_point=>'ON_NEW_INSTANCE'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*)',
'from tac_form;'))
,p_computation_error_message=>'Error in Application Item (TAC_FORM_COUNT)'
);
wwv_flow_api.component_end;
end;
/
