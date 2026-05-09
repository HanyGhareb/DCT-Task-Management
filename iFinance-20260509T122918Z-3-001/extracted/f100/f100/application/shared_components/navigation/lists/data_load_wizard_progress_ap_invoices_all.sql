prompt --application/shared_components/navigation/lists/data_load_wizard_progress_ap_invoices_all
begin
--   Manifest
--     LIST: Data Load Wizard Progress - AP Invoices ALL
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
 p_id=>wwv_flow_api.id(100738827658231639)
,p_name=>'Data Load Wizard Progress - AP Invoices ALL'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100739215273231640)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'AP Invoices All Data Load Source'
,p_list_item_link_target=>'f?p=&APP_ID.:56:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100739653035231640)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'AP Invoices All  Data / Table Mapping'
,p_list_item_link_target=>'f?p=&APP_ID.:57:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100740065485231641)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'AP Invoices All  Data Validation'
,p_list_item_link_target=>'f?p=&APP_ID.:58:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100740427017231641)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'AP Invoices All  Data Load Results'
,p_list_item_link_target=>'f?p=&APP_ID.:59:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
