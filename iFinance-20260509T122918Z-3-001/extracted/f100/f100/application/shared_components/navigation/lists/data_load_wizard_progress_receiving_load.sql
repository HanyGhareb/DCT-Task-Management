prompt --application/shared_components/navigation/lists/data_load_wizard_progress_receiving_load
begin
--   Manifest
--     LIST: Data Load Wizard Progress - Receiving Load
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
 p_id=>wwv_flow_api.id(100407832845617899)
,p_name=>'Data Load Wizard Progress - Receiving Load'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100408281039617899)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Receiving Data Load Source'
,p_list_item_link_target=>'f?p=&APP_ID.:50:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100408634476617900)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Receiving  Data / Table Mapping'
,p_list_item_link_target=>'f?p=&APP_ID.:51:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100409014028617900)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Receiving  Data Validation'
,p_list_item_link_target=>'f?p=&APP_ID.:52:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(100409419722617900)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Receiving  Data Load Results'
,p_list_item_link_target=>'f?p=&APP_ID.:53:&APP_SESSION.::&DEBUG.:::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
