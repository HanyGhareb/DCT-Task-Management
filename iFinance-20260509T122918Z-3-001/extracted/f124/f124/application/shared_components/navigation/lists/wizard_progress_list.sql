prompt --application/shared_components/navigation/lists/wizard_progress_list
begin
--   Manifest
--     LIST: Wizard Progress List
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(137979330732452596)
,p_name=>'Wizard Progress List'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(137980314717452592)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'APPENDIX A - SCOPE OF WORK'
,p_list_item_link_target=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-clone'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(137983712788452578)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'APPENDIX B-TECHNICAL EVALUATION CRITERIA'
,p_list_item_link_target=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.::P29_SCOPE_ID,P29_TEMPLATE_ID,P29_ITEM_ID:&P28_SCOPE_ID.,&P28_TEMPLATE_ID.,&P28_DP_ITEM_ID.:'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(502661527555590330)
,p_list_item_display_sequence=>25
,p_list_item_link_text=>'APPENDIX E - BIDDER LIST'
,p_list_item_link_target=>'f?p=&APP_ID.:92:&SESSION.::&DEBUG.::::'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(137987929507452576)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'APPENDIX C -COMMERCIAL EVALUATION CRITERIA'
,p_list_item_link_target=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_SCOPE_ID,P30_TEMPLATE_ID,P30_ITEM_ID:&P28_SCOPE_ID.,&P28_TEMPLATE_ID.,&P28_DP_ITEM_ID.:'
,p_list_item_disp_cond_type=>'NEVER'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(137992143324452574)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'APPENDIX D -PRICING SCHEDULE (BOQ)'
,p_list_item_link_target=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.::P31_SCOPE_ID,P31_TEMPLATE_ID,P31_ITEM_ID:&P28_SCOPE_ID.,&P28_TEMPLATE_ID.,&P28_DP_ITEM_ID.:'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(137996304319452539)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Cashflow Details'
,p_list_item_link_target=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.::P32_SCOPE_ID,P32_TEMPLATE_ID,P32_ITEM_ID:&P28_SCOPE_ID.,&P28_TEMPLATE_ID.,&P28_DP_ITEM_ID.:'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
