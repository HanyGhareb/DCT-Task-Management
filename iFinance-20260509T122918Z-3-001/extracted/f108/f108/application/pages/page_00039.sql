prompt --application/pages/page_00039
begin
--   Manifest
--     PAGE: 00039
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>39
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'Manual PR Approve / Reject'
,p_alias=>'MANUAL-PR-APPROVE-REJECT'
,p_step_title=>'Manual PR Approve / Reject'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230222043433'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52172887566832270)
,p_plug_name=>'<p6><i>Manual PR Details</i></p6>'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52172527659832267)
,p_plug_name=>'<i><b>End User Detail</i></b>'
,p_icon_css_classes=>'fa-number-1-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52172509832832266)
,p_plug_name=>'<i><b>Budget Details</i></b>'
,p_icon_css_classes=>'fa-number-2-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52170549465832247)
,p_plug_name=>'<i><b>Project Information</i></b>'
,p_icon_css_classes=>'fa-number-3-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52169005843832231)
,p_plug_name=>'<i><b>Procurement Method(s)</b></i> '
,p_region_css_classes=>'sub-region'
,p_icon_css_classes=>'fa-number-4-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52168746043832229)
,p_plug_name=>unistr('<b>End User\2019s list of potential Suppliers/ Bidders for this Project </b>')
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19177535283383337)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(190982769403871427)
,p_plug_name=>'Potential Vendors'
,p_parent_plug_id=>wwv_flow_api.id(52168746043832229)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19192662303383345)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'MPR_POTENTIAL_VENDORS'
,p_query_where=>'MPR_ID = :P39_ID'
,p_query_order_by=>'CREATED_ON'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P39_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Potential Vendors'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_plug_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p style="color:DodgerBlue;">Select your recommended vendors from registered Vendors. OR, Enter the names of vendors you recommend.</p>',
''))
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(190982958250871429)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(190983038506871430)
,p_name=>'MPR_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MPR_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Mpr Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>40
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P39_ID'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(190983109466871431)
,p_name=>'RECOMMENDED_VENDOR_NUM'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RECOMMENDED_VENDOR_NUM'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_POPUP_LOV'
,p_heading=>'Vendor Number'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_stretch=>'A'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'Y'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Potential Vendor'
,p_attribute_10=>'VENDOR_SITE_CODE:siteCode,VENDOR_NAME:vendorName'
,p_is_required=>false
,p_max_length=>50
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(19381804459521497)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(190983301243871432)
,p_name=>'RECOMMENDED_VENDOR_SITE_CODE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RECOMMENDED_VENDOR_SITE_CODE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Vendor Site Code'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_static_id=>'siteCode'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(190983330698871433)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>90
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(190983470022871434)
,p_name=>'Comment'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NOTES'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Comment'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>1020
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(190983512227871435)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Created By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(190983658910871436)
,p_name=>'CREATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Created On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(190983732844871437)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Updated By'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(190983823333871438)
,p_name=>'UPDATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_ON'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Updated On'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(191296189039451392)
,p_name=>'RECOMMENDED_VENDOR_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RECOMMENDED_VENDOR_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Vendor Name'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>255
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_static_id=>'vendorName'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(192106050758628311)
,p_name=>'NEW_VENDOR_YN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NEW_VENDOR_YN'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'New Vendor ?'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_api.id(20345897479846076)
,p_lov_display_extra=>false
,p_lov_display_null=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'N'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(190982850911871428)
,p_internal_uid=>394149766980304201
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_toolbar_buttons=>'ACTIONS_MENU:SAVE'
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>false
,p_define_chart_view=>false
,p_enable_download=>true
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_api.create_ig_report(
 p_id=>wwv_flow_api.id(191283582362282202)
,p_interactive_grid_id=>wwv_flow_api.id(190982850911871428)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(191283638885282202)
,p_report_id=>wwv_flow_api.id(191283582362282202)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191284137321282207)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(190982958250871429)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191284612051282212)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(190983038506871430)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191285188362282214)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(190983109466871431)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>109
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191285627794282216)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(190983301243871432)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>160
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191286115666282217)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(190983330698871433)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191286647816282219)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(190983470022871434)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>154
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191287139152282221)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(190983512227871435)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>98
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191287640174282222)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(190983658910871436)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>137
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191288163024282224)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(190983732844871437)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>87
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191288662855282225)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(190983823333871438)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>129
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(191302128779453206)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(191296189039451392)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>402
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(192160900352353418)
,p_view_id=>wwv_flow_api.id(191283638885282202)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(192106050758628311)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>115
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52168603604832227)
,p_plug_name=>'Hiden'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>110
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(190796027818688180)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19203962458383352)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(19140599913383303)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(19258056279383396)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(190988197803879309)
,p_plug_name=>'Audit Info'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19177535283383337)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P39_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(191821902183949015)
,p_plug_name=>'Documents'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P39_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(191822034908949016)
,p_plug_name=>'MPR Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(191821902183949015)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19192662303383345)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       MPR_ID,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from MPR_DOCUMENTS',
'  where MPR_ID = :P39_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P39_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>'select 1 from mpr_documents where mpr_id = :P39_ID'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'MPR Documents Report'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(191822089690949017)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>394989005759381790
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51958652713596966)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51958224490596966)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51957847834596966)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'File name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51957454736596966)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51957102059596966)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51956663744596965)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'File Blob'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51956260924596965)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51955884872596965)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51955480323596965)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51955037875596965)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51954667048596964)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51954259127596964)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51953872141596964)
,p_db_column_name=>'MPR_ID'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Mpr Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51953480598596964)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51953081302596963)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:MPR_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(191834768289095883)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1512142'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(191832843435950445)
,p_plug_name=>'Approval History'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>100
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select h.ID,',
'       h.MPR_ID,',
'       h.STEP_NO,',
'       h.PERSON_ID,',
'       h.PERSON_TYPE,',
'       nvl(role_desc,h.ROLE_ID) role,',
'       h.ACTION_REQUIRED,',
'       h.RECEVIED_DATE,',
'       h.STATUS,',
'       h.ACTION_DATE,',
'       h.COMMENTS,',
'       h.APPROVAL_TYPE,',
'       h.CREATED_ON,',
'       h.CREATED_BY,',
'       h.UPDATED_BY,',
'       h.UPDATED_ON,',
'       e.full_name_en,',
'       case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                 ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'           end Photo',
'  from MPR_APPROVAL_HISTORY h, dct_employees_list2  e',
'  where h.person_id = e.person_id (+)',
'  and mpr_id = :P39_ID',
'order by h.STEP_NO , h.ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P39_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P39_ID is not null and :P39_STATUS not in  (''Draft'')'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval History'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(191832914527950446)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>394999830596383219
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51952015574595572)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51951572861595572)
,p_db_column_name=>'MPR_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Mpr Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51951124382595572)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51950729011595572)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51950331731595571)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51949998167595571)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51949543476595571)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51949135863595571)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51948815723595571)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51948414850595570)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51947998428595570)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51947543569595570)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51947175512595570)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51946811588595570)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51946343712595569)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51945988438595569)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51945607072595569)
,p_db_column_name=>'PHOTO'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51945183595595569)
,p_db_column_name=>'ROLE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Role'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(192001050132786438)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1512221'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:FULL_NAME_EN:ROLE:ACTION_REQUIRED:STATUS:RECEVIED_DATE:ACTION_DATE:PHOTO:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(51944341726595568)
,p_report_id=>wwv_flow_api.id(192001050132786438)
,p_name=>'Pending'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(52166683989824463)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(190796027818688180)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(51959354416596967)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(191821902183949015)
,p_button_name=>'Add_File'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19255943466383393)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add File'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_MPR_ID,P4_APPROVAL_STATUS,P4_FROM_PAGE:&P39_ID.,&P39_STATUS.,2'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(52166271967824463)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(190796027818688180)
,p_button_name=>'Approve'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_ACTION,P40_ID,P40_MPR_ID:Approve,&P39_HISTORY_ID.,&P39_ID.'
,p_icon_css_classes=>'fa-check-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(52165825176824463)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(190796027818688180)
,p_button_name=>'Reject'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_ACTION,P40_MPR_ID,P40_ID:Reject,&P39_ID.,&P39_HISTORY_ID.'
,p_icon_css_classes=>'fa-times-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(52165475421824463)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(190796027818688180)
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_ACTION,P40_MPR_ID,P40_ID:Delegate,&P39_ID.,&P39_HISTORY_ID.'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(52167019708824464)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(190796027818688180)
,p_button_name=>'Return'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_ACTION,P40_MPR_ID,P40_ID:Return,&P39_ID.,&P39_HISTORY_ID.'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(52056566001824356)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52172764385832269)
,p_name=>'P39_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(52172887566832270)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52172633658832268)
,p_name=>'P39_HISTORY_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(52172887566832270)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52172335722832265)
,p_name=>'P39_CREATOR_PERSON_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(52172527659832267)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Requestor :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52172255543832264)
,p_name=>'P39_DEPARTMENT_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(52172527659832267)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Department :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52172153630832263)
,p_name=>'P39_SECTOR'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(52172527659832267)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Sector  :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52172034740832262)
,p_name=>'P39_REQUEST_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(52172887566832270)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Request Number :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52172001300832261)
,p_name=>'P39_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(52172887566832270)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Status :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52171814593832259)
,p_name=>'P39_REQUEST_TYPE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(52172887566832270)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Tender / Bider ? </span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52171686673832258)
,p_name=>'P39_SUBMISSION_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(52172887566832270)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Submission Date :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52171582264832257)
,p_name=>'P39_DT_REQUIRED'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(52172887566832270)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">DT Required ? </span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_LOV'
,p_lov=>'.'||wwv_flow_api.id(20345897479846076)||'.'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52171425809832256)
,p_name=>'P39_REQUESTED_AMOUNT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(52172527659832267)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Requested Amount :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52171401515832255)
,p_name=>'P39_CURRENCY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(52172527659832267)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Currency :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52171261390832254)
,p_name=>'P39_NEW_PROJECT_YN'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(52172509832832266)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">New Project ?  :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_LOV'
,p_lov=>'.'||wwv_flow_api.id(20345897479846076)||'.'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52171192917832253)
,p_name=>'P39_PROJECT_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(52172509832832266)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Project Number :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52171037666832252)
,p_name=>'P39_TASK_NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(52172509832832266)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Task :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52171015894832251)
,p_name=>'P39_COST_CENTER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(52172509832832266)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Cost Center :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52170893925832250)
,p_name=>'P39_EXPENDITURE_TYPE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(52172509832832266)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Expenditure Type :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52170788852832249)
,p_name=>'P39_FUND_AVAILABLE_YN'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(52172509832832266)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Budget Fund  :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_LOV'
,p_lov=>'.'||wwv_flow_api.id(20345897479846076)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52170653720832248)
,p_name=>'P39_INITIAL_AMOUNT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(52172509832832266)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Initial Budget :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52170469201832246)
,p_name=>'P39_DCT_PROJECT_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(52170549465832247)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">DCT Project :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52170378871832245)
,p_name=>'P39_DCT_PROJECT_DESCRIPTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(52170549465832247)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Project Description :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52170298090832244)
,p_name=>'P39_DELIVERABLE_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(52170549465832247)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Deliverable Date :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52170139881832243)
,p_name=>'P39_NEW_VENDOR_YN'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(52170549465832247)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">New Vendor (Not Registered) ? :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_LOV'
,p_lov=>'.'||wwv_flow_api.id(20345897479846076)||'.'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52170096559832242)
,p_name=>'P39_RECOMMENDED_VENDOR_NUM'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(52170549465832247)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Recommended Vendor :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P39_NEW_VENDOR_YN'
,p_display_when2=>'No'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52169961587832241)
,p_name=>'P39_RECOMMENDED_VENDOR_SITE_CODE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(52170549465832247)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Vendor Site :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P39_NEW_VENDOR_YN'
,p_display_when2=>'No'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52169866599832240)
,p_name=>'P39_RECOMMENDED_VENDOR_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(52170549465832247)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Vendor Name   :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P39_NEW_VENDOR_YN'
,p_display_when2=>'Yes'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52168858767832230)
,p_name=>'P39_PROCUREMENT_METHOD'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(52169005843832231)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Select one or more as applicable :</span>'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select MPR_PROCUREMENT_METHODS.PROCUREMENT_METHOD_NAME as PROCUREMENT_METHOD_NAME,',
'    MPR_PROCUREMENT_METHODS.ID as ID ',
' from MPR_PROCUREMENT_METHODS MPR_PROCUREMENT_METHODS'))
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'2'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52168459481832226)
,p_name=>'P39_MPR_CATEGPRY_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(52168603604832227)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52168394173832225)
,p_name=>'P39_MPR_CATEGPRY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(52168603604832227)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52168268049832224)
,p_name=>'P39_SEQ_NUM'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(52168603604832227)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51962405302602194)
,p_name=>'P39_CREATED_BY'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(190988197803879309)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P39_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51962010983602194)
,p_name=>'P39_CREATED_ON'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(190988197803879309)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P39_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51961582847602193)
,p_name=>'P39_UPDATED_BY'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(190988197803879309)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P39_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51961143341602193)
,p_name=>'P39_UPDATED_ON'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(190988197803879309)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P39_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51941128559553772)
,p_name=>'P39_VENDOR_NAME'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(52170549465832247)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Vendor Name :</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P39_NEW_VENDOR_YN'
,p_display_when2=>'No'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51941034119553771)
,p_name=>'P39_PROJECT_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(52172509832832266)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Project Name:</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51940919719553770)
,p_name=>'P39_REQUESTOR_PERSON_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(52172527659832267)
,p_prompt=>'P39_REQUESTOR_PERSON_NAME'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(52082564974824369)
,p_name=>'Show Tendering sections'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P39_REQUEST_TYPE'
,p_condition_element=>'P39_REQUEST_TYPE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'T'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(52079200329824367)
,p_name=>'Show Section 7 DT'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P39_DT_REQUIRED'
,p_condition_element=>'P39_DT_REQUIRED'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(52077815573824366)
,p_name=>'set Request Amount Hidden'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P39_REQUESTED_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52077282334824366)
,p_event_id=>wwv_flow_api.id(52077815573824366)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_REQUESTED_AMOUNT_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(:P39_REQUESTED_AMOUNT, ''99,999,999,999.99'')'
,p_attribute_07=>'P39_REQUESTED_AMOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(52076878784824365)
,p_name=>'disable projects details for new project'
,p_event_sequence=>100
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P39_NEW_PROJECT'
,p_condition_element=>'P39_NEW_PROJECT'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52076371412824365)
,p_event_id=>wwv_flow_api.id(52076878784824365)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_PROJECT_NUMBER,P39_TASK_NUMBER,P39_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52075849075824365)
,p_event_id=>wwv_flow_api.id(52076878784824365)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_PROJECT_NUMBER,P39_TASK_NUMBER,P39_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52075323164824364)
,p_event_id=>wwv_flow_api.id(52076878784824365)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_COST_CENTER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52074911364824364)
,p_event_id=>wwv_flow_api.id(52076878784824365)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_COST_CENTER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52074389930824364)
,p_event_id=>wwv_flow_api.id(52076878784824365)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_COST_CENTER_LOV'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52073892185824364)
,p_event_id=>wwv_flow_api.id(52076878784824365)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_COST_CENTER_LOV'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52073386903824363)
,p_event_id=>wwv_flow_api.id(52076878784824365)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_COST_CENTER_LOV'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select cost_center_code',
'from organizations_details_v',
'where org_id = :P39_REQUESTOR_ORG_ID'))
,p_attribute_07=>'P39_REQUESTOR_ORG_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52072866921824363)
,p_event_id=>wwv_flow_api.id(52076878784824365)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_INITIAL_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(52072487600824363)
,p_name=>'set Initial Amount'
,p_event_sequence=>110
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P39_REQUESTED_AMOUNT_H'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52071951698824363)
,p_event_id=>wwv_flow_api.id(52072487600824363)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P39_INITIAL_AMOUNT'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>':P39_REQUESTED_AMOUNT_H'
,p_attribute_07=>'P39_REQUESTED_AMOUNT_H'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(52062013270824359)
,p_name=>'Approve DA'
,p_event_sequence=>170
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(52166271967824463)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52061421353824359)
,p_event_id=>wwv_flow_api.id(52062013270824359)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to approve MPR# &P39_REQUEST_NUMBER., Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52060916537824359)
,p_event_id=>wwv_flow_api.id(52062013270824359)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'MPR_WORKFLOW.APPROVE(:P39_ID , :PERSON_ID);',
'END;'))
,p_attribute_02=>'PERSON_ID'
,p_attribute_03=>'P39_DELIVERABLE_DATE'
,p_attribute_04=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52060482914824359)
,p_event_id=>wwv_flow_api.id(52062013270824359)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update mpr',
'set FUND_AVAILABLE_YN = :P39_FUND_AVAILABLE_YN',
'where id = :P39_ID;'))
,p_attribute_02=>'P39_DELIVERABLE_DATE'
,p_attribute_03=>'P39_DELIVERABLE_DATE'
,p_attribute_04=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52059940829824358)
,p_event_id=>wwv_flow_api.id(52062013270824359)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Approved Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52059427250824358)
,p_event_id=>wwv_flow_api.id(52062013270824359)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(52059040562824358)
,p_name=>'Reject DA'
,p_event_sequence=>180
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(52165825176824463)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52058528025824358)
,p_event_id=>wwv_flow_api.id(52059040562824358)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to Reject ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52058102735824358)
,p_event_id=>wwv_flow_api.id(52059040562824358)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'MPR_WORKFLOW.REJECT(:P39_ID , :PERSON_ID);',
'END;'))
,p_attribute_02=>'PERSON_ID'
,p_attribute_03=>'P39_DELIVERABLE_DATE'
,p_attribute_04=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52057517354824357)
,p_event_id=>wwv_flow_api.id(52059040562824358)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Rejected.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(52057071424824357)
,p_event_id=>wwv_flow_api.id(52059040562824358)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(52168714026832228)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'--    creator_person_id,',
'    creator_person_name,',
' --   requestor_person_id,',
'    requestor_person_name,',
'--    requestor_org_id,',
' --   org_name,',
'    department_name,',
'    sector,',
'    request_number,',
'    trim(to_char(requested_amount,''99,999,999,999.99'')) requested_amount,',
'    request_type,',
'    project_number,',
'    project_name,',
'    task_number,',
'    expenditure_type,',
'    trim(to_char(initial_amount,''99,999,999,999.99''))    initial_amount,',
'    dct_project_name,',
'    dct_project_description,',
'--    submission_date,',
'--    pr_number,',
'    to_char(deliverable_date,''DD-Mon-YYYY'') deliverable_date,',
'    vendor_name,',
'    recommended_vendor_num,',
'    recommended_vendor_site_code,',
'    procurement_method,',
'    status,',
' --   notes,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    dt_required,',
'    currency,',
'--    department_id,',
'--    sector_id,',
'    cost_center,',
'--    fbp_person_id,',
'    fund_available_yn,',
'    new_project_yn,',
'    new_vendor_yn,',
'    recommended_vendor_name,',
'    seq_num,',
'    mpr_categpry,',
'    mpr_categpry_name',
'INTO',
'    :P39_id,',
'--    :P39_creator_person_id,',
'    :P39_creator_person_name,',
'--    :P39_requestor_person_id,',
'    :P39_requestor_person_name,',
'--    :P39_requestor_org_id,',
'--    :P39_org_name,',
'    :P39_department_name,',
'    :P39_sector,',
'    :P39_request_number,',
'    :P39_requested_amount,',
'    :P39_request_type,',
'    :P39_project_number,',
'    :P39_project_name,',
'    :P39_task_number,',
'    :P39_expenditure_type,',
'    :P39_initial_amount,',
'    :P39_dct_project_name,',
'    :P39_dct_project_description,',
'--    :P39_submission_date,',
'--    :P39_pr_number,',
'    :P39_deliverable_date,',
'    :P39_vendor_name,',
'    :P39_recommended_vendor_num,',
'    :P39_recommended_vendor_site_code,',
'    :P39_procurement_method,',
'    :P39_status,',
'   -- :P39_notes,',
'    :P39_created_by,',
'    :P39_created_on,',
'    :P39_updated_by,',
'    :P39_updated_on,',
'    :P39_dt_required,',
'    :P39_currency,',
'--    :P39_department_id,',
' --   :P39_sector_id,',
'    :P39_cost_center,',
'--    :P39_fbp_person_id,',
'    :P39_fund_available_yn,',
'    :P39_new_project_yn,',
'    :P39_new_vendor_yn,',
'    :P39_recommended_vendor_name,',
'    :P39_seq_num,',
'    :P39_mpr_categpry,',
'    :P39_mpr_categpry_name',
'FROM',
'    mpr_V',
'where id = :P39_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
