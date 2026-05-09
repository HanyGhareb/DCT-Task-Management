prompt --application/pages/page_00022
begin
--   Manifest
--     PAGE: 00022
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page(
 p_id=>22
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'Projects Users - Home'
,p_step_title=>'Projects Users - Home'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Scroll Results Only in Side Column */',
'.t-Body-side {',
'    display: flex;',
'    flex-direction: column;',
'    overflow: hidden;',
'}',
'.search-results {',
'    flex: 1;',
'    overflow: auto;',
'}',
'/* Format Search Region */',
'.search-region {',
'    border-bottom: 1px solid rgba(0,0,0,.1);',
'    flex-shrink: 0;',
'}',
'',
'.t-Region-header{',
'background-color:#0e6655;',
'    color:#FFFFFF;',
'}',
'.t-Region-title{',
'    color:#FFFFFF;',
'    font-weighfont-weight: bold;',
'}',
'',
'/* Set Header Panel */',
'.t-Header-branding {',
'    background-color: #0e6655;',
'}',
'',
'',
'/* Set Breadcrumb   */',
'.t-Body-title {',
'',
'    background-color: #EEE;',
'    color:#404040;',
'}',
'',
'/* Add Button - White */',
'.t-Region-header, .t-Region-header .t-Button--link, .t-Region-header .t-Button--noUI {',
'    color:  #FFF;',
'}',
'',
'/* New Plan Button */',
'.a-Button--hot, .t-Button--hot:not(.t-Button--simple), body .ui-button.ui-button--hot, body .ui-state-default.ui-priority-primary {',
'',
'    background-color: #0e6655;',
'    color:#fff;',
'}',
'',
'',
'/*  Table Row Selected */',
'.a-GV-table tr.is-selected .a-GV-cell {',
'    background-color: #CEF6CE;',
'}',
'',
'/* Audit Region */',
'#history    .t-Region-header {',
'     background-color: #f3f0ef;',
'    color:#000;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200503015021'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(75602631166000415)
,p_name=>'<b>Recent Transfer Requests<b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    request_id  ,',
'  substr(priority,0,1) user_avatar,',
'  --''u-color-''|| ( ora_hash(updated_by,45) + 1 ) user_color,',
'  case PRIority ',
'    when ''High'' Then ''u-danger-bg''',
'    when ''Medium'' Then ''u-warning-bg''',
'    when ''Low''    Then ''u-success-bg''',
'    END user_color,',
'  ''REQ# '' || request_no || ''(AED'' || to_char(requested_amount,''999,999,999.99'')||'')''  user_name,',
'  btf_end_users_req.updated_date event_date,',
'  btf_end_users_req.request_status event_type,',
'  ''Project# :'' || btf_end_users_req.project_number || '' - Task:'' || btf_end_users_req.task_number event_title,',
'  ''Justification :'' || btf_end_users_req.justification  event_desc,',
'  case btf_end_users_req.request_status ',
'    when ''Draft'' then ''fa-stop-circle-o''',
'    when ''Accepted'' then ''fa fa-check-circle-o''         ',
'    when ''In-Process'' then ''fa-check-circle-o fa-anim-flash''',
'    when ''Refused'' then ''fa fa-exclamation-circle''',
'    when ''Submitted'' then ''fa fa-exclamation-triangle''',
'  end event_icon,',
'  case btf_end_users_req.request_status ',
'    when ''Draft'' then ''is-disabled''',
'    when ''Accepted'' then ''is-new''',
'    when ''In-Process'' then ''u-color-1-bg''',
'    when ''Refused'' then ''is-removed''',
'    when ''Submitted'' then ''is-updated''',
'  end event_status,',
' -- ''f?p=&APP_ID.:21:&APP_SESSION.::NO::P21_REQUEST_ID:''||request_id event_link',
'  apex_util.prepare_url( ''f?p=''||:APP_ID||'':23:''||:APP_SESSION||''::NO::P23_REQUEST_ID:''|| request_id ) event_link',
'from btf_end_users_req',
'where project_number in (SELECT  btf_data_access.entity_name d',
'                                                            FROM   btf_data_access',
'                                                            WHERE btf_data_access.entity_type = ''PROJECT''',
'                                                            and btf_data_access.user_id = :APP_USER)',
'order by updated_date desc'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65556509573255757)
,p_query_num_rows=>5
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'Y'
,p_csv_output_link_text=>'Download'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75603004356000417)
,p_query_column_id=>1
,p_column_alias=>'REQUEST_ID'
,p_column_display_sequence=>1
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:RP:P23_REQUEST_ID:\#REQUEST_ID#\'
,p_column_linktext=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75603404937000417)
,p_query_column_id=>2
,p_column_alias=>'USER_AVATAR'
,p_column_display_sequence=>2
,p_column_heading=>'User Avatar'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75603880248000417)
,p_query_column_id=>3
,p_column_alias=>'USER_COLOR'
,p_column_display_sequence=>3
,p_column_heading=>'User Color'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75604272113000417)
,p_query_column_id=>4
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>4
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75604674135000417)
,p_query_column_id=>5
,p_column_alias=>'EVENT_DATE'
,p_column_display_sequence=>5
,p_column_heading=>'Event Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75605025658000418)
,p_query_column_id=>6
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>6
,p_column_heading=>'Event Type'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75605433163000418)
,p_query_column_id=>7
,p_column_alias=>'EVENT_TITLE'
,p_column_display_sequence=>7
,p_column_heading=>'Event Title'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75605803712000418)
,p_query_column_id=>8
,p_column_alias=>'EVENT_DESC'
,p_column_display_sequence=>8
,p_column_heading=>'Event Desc'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75606207683000418)
,p_query_column_id=>9
,p_column_alias=>'EVENT_ICON'
,p_column_display_sequence=>9
,p_column_heading=>'Event Icon'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75606610986000418)
,p_query_column_id=>10
,p_column_alias=>'EVENT_STATUS'
,p_column_display_sequence=>10
,p_column_heading=>'Event Status'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75607060293000418)
,p_query_column_id=>11
,p_column_alias=>'EVENT_LINK'
,p_column_display_sequence=>11
,p_column_heading=>'Event Link'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(75608399752000422)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65554277731255756)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(65494572154255667)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(65602363670255785)
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(76392971811025237)
,p_name=>'My Access Requests Status'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    user_id,',
'    (select e.full_name_en ',
'        from dct_employees_list2 e',
'        where e.user_name = btf_data_access_requests.user_id) Employee,',
'    entity_type,',
'    entity_name,',
'    (select distinct p.project_name ',
'        from f_projectbudget p',
'        where p.project_number = entity_name) Project_name,',
'    request_status,',
'    start_date,',
'    end_date,',
'    comments,',
'    created_on,',
'    created_by,',
'    updated_by,',
'    updated_on,',
'    priority,',
'    btf_data_access_requests.action_by,',
'    btf_data_access_requests.action_time,',
'    reviewer_note',
'FROM',
'    btf_data_access_requests',
'where created_by = :APP_USER',
'order by UPDATED_ON desc'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65567986443255766)
,p_query_num_rows=>5
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76393044924025238)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76393165701025239)
,p_query_column_id=>2
,p_column_alias=>'USER_ID'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76393213028025240)
,p_query_column_id=>3
,p_column_alias=>'EMPLOYEE'
,p_column_display_sequence=>3
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76393329826025241)
,p_query_column_id=>4
,p_column_alias=>'ENTITY_TYPE'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76393460419025242)
,p_query_column_id=>5
,p_column_alias=>'ENTITY_NAME'
,p_column_display_sequence=>5
,p_column_heading=>'Project#'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:26:&SESSION.:user:&DEBUG.::P26_ID:#ID#'
,p_column_linktext=>'#ENTITY_NAME#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76393515137025243)
,p_query_column_id=>6
,p_column_alias=>'PROJECT_NAME'
,p_column_display_sequence=>6
,p_column_heading=>'Project Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76393626300025244)
,p_query_column_id=>7
,p_column_alias=>'REQUEST_STATUS'
,p_column_display_sequence=>15
,p_column_heading=>'Request Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76393747156025245)
,p_query_column_id=>8
,p_column_alias=>'START_DATE'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76393807183025246)
,p_query_column_id=>9
,p_column_alias=>'END_DATE'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76393997234025247)
,p_query_column_id=>10
,p_column_alias=>'COMMENTS'
,p_column_display_sequence=>7
,p_column_heading=>'Comment'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76394091235025248)
,p_query_column_id=>11
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76394181389025249)
,p_query_column_id=>12
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76394256439025250)
,p_query_column_id=>13
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76645566604751701)
,p_query_column_id=>14
,p_column_alias=>'UPDATED_ON'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76645628446751702)
,p_query_column_id=>15
,p_column_alias=>'PRIORITY'
,p_column_display_sequence=>14
,p_column_heading=>'Priority'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76645721648751703)
,p_query_column_id=>16
,p_column_alias=>'ACTION_BY'
,p_column_display_sequence=>16
,p_column_heading=>'Action By'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76646419877751710)
,p_query_column_id=>17
,p_column_alias=>'ACTION_TIME'
,p_column_display_sequence=>17
,p_column_heading=>'Action Time'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76646312126751709)
,p_query_column_id=>18
,p_column_alias=>'REVIEWER_NOTE'
,p_column_display_sequence=>18
,p_column_heading=>'Reviewer Note'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(75609509701000423)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(75608399752000422)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Request'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76646195822751707)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(76392971811025237)
,p_button_name=>'New_DATA_ACCESS'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Project Access'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
