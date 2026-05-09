prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>910
,p_default_id_offset=>82649548957193263
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Menus'
,p_alias=>'MENUS'
,p_step_title=>'Menus'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20211001133714'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(35075138094501345)
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
 p_id=>wwv_flow_api.id(35074532229501345)
,p_plug_name=>'Menus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1599843476302282)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
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
'        and p.APPLICATION_ID = MENUS_EXT.APP_ID ',
'        and p.PAGE_ID = MENUS_EXT.PAGE_ID',
'        ) Home_Page,',
'       ''apex_page.get_url(p_application => '' || APP_ID || '' ,PAGE_ID => '' || PAGE_ID || '')''    CARD_LINK,',
'       CARD_COLOR,',
'       CARD_ICON,',
'       CARD_INITIALS,',
'       STATUS,',
'       DESCRIPTION,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_ON,',
'       UPDATED_BY',
'  from MENUS_EXT;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Menus'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(35074474221501345)
,p_name=>'Menus'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_MENU_ID:#ID##MENU_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>47575074735691918
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40065420914842669)
,p_db_column_name=>'CARD_TITLE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Card Title'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40064991929842669)
,p_db_column_name=>'CARD_SUBTITLE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Card Subtitle'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40064635606842669)
,p_db_column_name=>'CARD_TEXT'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Card Text'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40064230554842669)
,p_db_column_name=>'CARD_SUBTEXT'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Card Subtext'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40063763869842669)
,p_db_column_name=>'CARD_MODIFIERS'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Card Modifiers'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40063401795842668)
,p_db_column_name=>'APP_ID'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Module'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(40056481978842660)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40063004827842668)
,p_db_column_name=>'PAGE_ID'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Page'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40062607299842668)
,p_db_column_name=>'CARD_LINK'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Card Link'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40062160712842668)
,p_db_column_name=>'CARD_COLOR'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Card Color'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40061773948842668)
,p_db_column_name=>'CARD_ICON'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Card Icon'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40061393655842668)
,p_db_column_name=>'CARD_INITIALS'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Card Initials'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40060984920842667)
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
 p_id=>wwv_flow_api.id(40060579374842667)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40066199941842670)
,p_db_column_name=>'HOME_PAGE'
,p_display_order=>28
,p_column_identifier=>'S'
,p_column_label=>'Home Page'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40058615702842666)
,p_db_column_name=>'ORDER_NO'
,p_display_order=>38
,p_column_identifier=>'T'
,p_column_label=>'Order No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40079065879089818)
,p_db_column_name=>'ID'
,p_display_order=>48
,p_column_identifier=>'U'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40078962693089817)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>58
,p_column_identifier=>'V'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40078859903089816)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>68
,p_column_identifier=>'W'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40078775747089815)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>78
,p_column_identifier=>'X'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40078735782089814)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>88
,p_column_identifier=>'Y'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(35066898480500439)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'425913'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CARD_TITLE:ORDER_NO:CARD_SUBTITLE:CARD_TEXT:APP_HOME_PAGE:CARD_LINK:CARD_COLOR:CARD_ICON:CARD_INITIALS:STATUS:DESCRIPTION::ID:CREATED_ON:UPDATED_ON'
,p_sort_column_1=>'ORDER_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(40057773841842665)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(35074532229501345)
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
