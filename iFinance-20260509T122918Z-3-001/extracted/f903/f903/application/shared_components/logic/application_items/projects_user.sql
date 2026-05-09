prompt --application/shared_components/logic/application_items/projects_user
begin
--   Manifest
--     APPLICATION ITEM: PROJECTS_USER
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(77158815628018651)
,p_name=>'PROJECTS_USER'
,p_protection_level=>'I'
,p_item_comment=>'count of projects assigned to app user'
);
wwv_flow_api.component_end;
end;
/
