prompt --application/shared_components/logic/application_computations/person_type
begin
--   Manifest
--     APPLICATION COMPUTATION: PERSON_TYPE
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(12401507259813248)
,p_computation_sequence=>10
,p_computation_item=>'PERSON_TYPE'
,p_computation_point=>'ON_NEW_INSTANCE'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>'INT'
);
wwv_flow_api.component_end;
end;
/
