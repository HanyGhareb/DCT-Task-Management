prompt --application/shared_components/logic/application_items/person_id
begin
--   Manifest
--     APPLICATION ITEM: PERSON_ID
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(11885161188974043)
,p_name=>'PERSON_ID'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/
