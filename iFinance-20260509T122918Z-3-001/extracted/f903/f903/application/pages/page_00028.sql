prompt --application/pages/page_00028
begin
--   Manifest
--     PAGE: 00028
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
 p_id=>28
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'End User - Requests List'
,p_step_title=>'End User - Requests List'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200422134041'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76255776575347007)
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
 p_id=>wwv_flow_api.id(76256370669347007)
,p_name=>'End User - Requests List'
,p_template=>wwv_flow_api.id(65543737550255752)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'  rownum user_avatar,',
'  ''u-color-''|| ( ora_hash(user_id,45) + 1 ) user_color,',
'  ''Reqquest access for project# '' ||',
'   entity_name  user_name,',
'  updated_on event_date,',
'  ''Project Access''event_type,',
'  comments  event_title,',
'  null event_desc,',
'  case request_status ',
'    when ''Approved'' then ''fa fa-clock-o''',
'    when ''Rejected'' then ''fa fa-check-circle-o''',
'    when ''on-hold'' then ''fa fa-exclamation-circle''',
'    when ''Draft'' then ''fa fa-exclamation-triangle''',
'  end event_icon,',
'  case request_status ',
'    when ''Approved'' then ''is-new''',
'    when ''Rejected'' then ''is-removed''',
'    when ''on-hold'' then ''is-updated''',
'    when ''Draft'' then ''is-updated''',
'  end event_status,',
'   null  event_link',
'from btf_data_access_requests',
'--where entity_name in (SELECT  btf_data_access.entity_name d',
'--                                                            FROM   btf_data_access',
'--                                                            WHERE btf_data_access.entity_type = ''PROJECT''',
'--                                                            and btf_data_access.user_id = :APP_USER)'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65556509573255757)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76155888903095327)
,p_query_column_id=>1
,p_column_alias=>'USER_AVATAR'
,p_column_display_sequence=>1
,p_column_heading=>'User Avatar'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76155911002095328)
,p_query_column_id=>2
,p_column_alias=>'USER_COLOR'
,p_column_display_sequence=>2
,p_column_heading=>'User Color'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76156075856095329)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76156109296095330)
,p_query_column_id=>4
,p_column_alias=>'EVENT_DATE'
,p_column_display_sequence=>4
,p_column_heading=>'Event Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76156217554095331)
,p_query_column_id=>5
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Event Type'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76156366982095332)
,p_query_column_id=>6
,p_column_alias=>'EVENT_TITLE'
,p_column_display_sequence=>6
,p_column_heading=>'Event Title'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76156463239095333)
,p_query_column_id=>7
,p_column_alias=>'EVENT_DESC'
,p_column_display_sequence=>7
,p_column_heading=>'Event Desc'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76156537177095334)
,p_query_column_id=>8
,p_column_alias=>'EVENT_ICON'
,p_column_display_sequence=>8
,p_column_heading=>'Event Icon'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76156690162095335)
,p_query_column_id=>9
,p_column_alias=>'EVENT_STATUS'
,p_column_display_sequence=>9
,p_column_heading=>'Event Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76156772791095336)
,p_query_column_id=>10
,p_column_alias=>'EVENT_LINK'
,p_column_display_sequence=>10
,p_column_heading=>'Event Link'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.component_end;
end;
/
