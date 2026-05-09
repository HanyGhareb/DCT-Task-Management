prompt --application/shared_components/navigation/lists/petty_cash_admin_quick_list
begin
--   Manifest
--     LIST: Petty Cash Admin Quick List
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(2371670453091682)
,p_name=>'Petty Cash Admin Quick List'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2371899802091680)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'<b>Petty Cash Requests</b>'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-number-1-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2376887383017953)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'<b>&nbsp; &nbsp; Pending Petty Cash Requests</b>'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_APPROVAL_STATUS:In-Progress:'
,p_list_item_icon=>'fa-caret-square-o-right'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2377108439013535)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'<b>&nbsp; &nbsp; Approved Petty Cash requests</b>'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_APPROVAL_STATUS:Approved:'
,p_list_item_icon=>'fa-caret-square-o-right'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2372203437091680)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'<b>Reimbursement Requests</b>'
,p_list_item_link_target=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::P7_EXPENSE_REPORT_TYPE:Reimbursement:'
,p_list_item_icon=>'fa-number-2-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2372665820091680)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'<b>Clearing Requests</b>'
,p_list_item_link_target=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::P7_EXPENSE_REPORT_TYPE:Clearing:'
,p_list_item_icon=>'fa-number-3-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2570319113292934)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'<b>Track Petty Cash</b>'
,p_list_item_link_target=>'f?p=&APP_ID.:57:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-number-4-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2570673770282845)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'<b>Track Expense Reports</b>'
,p_list_item_link_target=>'f?p=&APP_ID.:58:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-number-5-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(32206775857855756)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'<b>Delegation</b>'
,p_list_item_link_target=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.:47:::'
,p_list_item_icon=>'fa-mail-forward'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(145778234296932395)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'Reminders'
,p_list_item_link_target=>'f?p=&APP_ID.:64:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-envelope-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
