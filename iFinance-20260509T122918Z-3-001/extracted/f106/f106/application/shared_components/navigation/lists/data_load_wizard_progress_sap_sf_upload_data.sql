prompt --application/shared_components/navigation/lists/data_load_wizard_progress_sap_sf_upload_data
begin
--   Manifest
--     LIST: Data Load Wizard Progress - SAP SF Upload Data
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(3200588400379296)
,p_name=>'Data Load Wizard Progress - SAP SF Upload Data'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(3201011645379295)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'SAP Employees Data Load Source'
,p_list_item_link_target=>'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(3201421323379295)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'SAP Employees  Data / Table Mapping'
,p_list_item_link_target=>'f?p=&APP_ID.:31:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(3201820061379295)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'SAP Employees Data Validation'
,p_list_item_link_target=>'f?p=&APP_ID.:32:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(3202183087379294)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'SAP Employees  Data Load Results'
,p_list_item_link_target=>'f?p=&APP_ID.:33:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
