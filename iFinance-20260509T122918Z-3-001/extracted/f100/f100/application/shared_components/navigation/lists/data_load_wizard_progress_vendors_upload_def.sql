prompt --application/shared_components/navigation/lists/data_load_wizard_progress_vendors_upload_def
begin
--   Manifest
--     LIST: Data Load Wizard Progress - Vendors Upload Def
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(93497822214374710)
,p_name=>'Data Load Wizard Progress - Vendors Upload Def'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(93498236108374711)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Vendors Data Load Source'
,p_list_item_link_target=>'f?p=&APP_ID.:39:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(93498620659374715)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Vendors Data / Table Mapping'
,p_list_item_link_target=>'f?p=&APP_ID.:40:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(93499099413374715)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Vendors  Data Validation'
,p_list_item_link_target=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(93499420532374715)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Vendors Data Load Results'
,p_list_item_link_target=>'f?p=&APP_ID.:42:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
