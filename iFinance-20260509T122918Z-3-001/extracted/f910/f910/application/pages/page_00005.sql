prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>40620729557075005
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Menus'
,p_alias=>'MENUS'
,p_step_title=>'Menus'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200909093829'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4992385830341336)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1611180433302287)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(1547752126302241)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(1665264360302322)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4992991695341336)
,p_plug_name=>'Menus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1599843476302282)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select MENU_ID,',
'       ORDER_NO,',
'       CARD_TITLE,',
'       CARD_SUBTITLE,',
'       CARD_TEXT,',
'       CARD_SUBTEXT,',
'       CARD_MODIFIERS,',
'       APP_ID,',
'       PAGE_ID,',
'       (select p.PAGE_NAME',
'         from apex_application_pages p',
'        where p.WORKSPACE = ''PROD'' ',
'        and p.APPLICATION_ID = MENUS.APP_ID ',
'        and p.PAGE_ID = MENUS.PAGE_ID',
'        ) Home_Page,',
'       ''apex_page.get_url(p_application => '' || APP_ID || '' ,PAGE_ID => '' || PAGE_ID || '')''    CARD_LINK,',
'       CARD_COLOR,',
'       CARD_ICON,',
'       CARD_INITIALS,',
'       STATUS,',
'       DESCRIPTION,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY',
'  from MENUS;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Menus'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(4993049703341336)
,p_name=>'Menus'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P6_MENU_ID:#MENU_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>4993049703341336
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4993403434341341)
,p_db_column_name=>'MENU_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Menu Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4993887438341342)
,p_db_column_name=>'CARD_TITLE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Card Title'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4994257381341342)
,p_db_column_name=>'CARD_SUBTITLE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Card Subtitle'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4994633879341342)
,p_db_column_name=>'CARD_TEXT'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Card Text'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4995033977341342)
,p_db_column_name=>'CARD_SUBTEXT'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Card Subtext'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4995424180341343)
,p_db_column_name=>'CARD_MODIFIERS'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Card Modifiers'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4995824398341343)
,p_db_column_name=>'APP_ID'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Module'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(5028441291638957)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4996279294341343)
,p_db_column_name=>'PAGE_ID'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Page'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4996600154341343)
,p_db_column_name=>'CARD_LINK'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Card Link'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4997094021341343)
,p_db_column_name=>'CARD_COLOR'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Card Color'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4997495620341344)
,p_db_column_name=>'CARD_ICON'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Card Icon'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4997803908341344)
,p_db_column_name=>'CARD_INITIALS'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Card Initials'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4998243415341344)
,p_db_column_name=>'STATUS'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(2460154646694716)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4998639555341344)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4999050797341345)
,p_db_column_name=>'CREATED'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4999448445341345)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4999811081341345)
,p_db_column_name=>'UPDATED'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5000231482341345)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4770388509894732)
,p_db_column_name=>'HOME_PAGE'
,p_display_order=>28
,p_column_identifier=>'S'
,p_column_label=>'Home Page'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6575401096184630)
,p_db_column_name=>'ORDER_NO'
,p_display_order=>38
,p_column_identifier=>'T'
,p_column_label=>'Order No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(5000625444342242)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'50007'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CARD_TITLE:ORDER_NO:CARD_SUBTITLE:CARD_TEXT:APP_ID:HOME_PAGE:CARD_LINK:CARD_COLOR:CARD_ICON:CARD_INITIALS:STATUS:DESCRIPTION:UPDATED:'
,p_sort_column_1=>'ORDER_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4770211396894731)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(4992991695341336)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(1663977999302321)
,p_button_image_alt=>'New'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6::'
,p_icon_css_classes=>'fa-calendar-plus-o'
);
wwv_flow_api.component_end;
end;
/
