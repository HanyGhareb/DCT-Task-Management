prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'External Users Projects Access'
,p_alias=>'EXTERNAL-USERS-PROJECTS-ACCESS'
,p_step_title=>'External Users Projects Access'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210204222909'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6664338564724243)
,p_plug_name=>'overview'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'Below table indicate the projects list available to <b>&P10_FULL_NAME.</b>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10962205122768580)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10254567086597785)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(10191147067597728)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10308621936597827)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10962822585768581)
,p_plug_name=>'External Users Projects Access'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    t.id,',
'    t.project_number,',
'    p.project_code,',
'    nvl(p.project_name, p.dct_project_name) project_name ,',
'    t.task_number,',
'--    contrat_number,',
'    t.person_id,',
'    u.user_name,',
'    u.first_name || '' '' || u.last_name Full_name,',
'    u.email,',
'    t.role_id,',
'    (Select pr.role_name',
'    from project_role pr',
'    where pr.role_id = t.role_id) Role_name,',
'    (Select pr.description',
'    from project_role pr',
'    where pr.role_id = t.role_id) Role_Description,',
'    t.person_type,',
'    t.start_date,',
'    t.end_date,',
'    t.status,',
'    t.notes,',
'    t.created_by,',
'    t.created_on,',
'    t.updated_by,',
'    t.updated_on',
'FROM',
'    cwip_team t , dct_ext_users u , project p ',
'where t.person_id = u.user_id',
'and t.project_number = p.project_number',
'and t.person_id = :P10_PERSON_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P10_PERSON_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'External Users Projects Access'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(10962992656768581)
,p_name=>'External Users Projects Access'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>10962992656768581
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10963397325768584)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10963796779768585)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10964116116768585)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10964591083768585)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10964978837768586)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10965393071768586)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10965713643768586)
,p_db_column_name=>'USER_NAME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10966162289768586)
,p_db_column_name=>'FULL_NAME'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10966557332768587)
,p_db_column_name=>'EMAIL'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10966968937768587)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10967336212768587)
,p_db_column_name=>'ROLE_NAME'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Role Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10967765148768587)
,p_db_column_name=>'ROLE_DESCRIPTION'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Role Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10968100800768588)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10968504511768588)
,p_db_column_name=>'START_DATE'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10968957377768588)
,p_db_column_name=>'END_DATE'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10969318708768588)
,p_db_column_name=>'STATUS'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(10760317215192499)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10969732975768589)
,p_db_column_name=>'NOTES'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10970129934768589)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10970557883768589)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10970959252768590)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10971303411768590)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(10973011793806510)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'109731'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'USER_NAME:FULL_NAME:PROJECT_NUMBER:PROJECT_NAME:ROLE_NAME:START_DATE:END_DATE:STATUS:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(9594106344676443)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(10962822585768581)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Back'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P6_USER_ID:&P10_PERSON_ID.'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(9594382156676445)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(10962822585768581)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Project'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_PERSON_ID:&P10_PERSON_ID.'
,p_icon_css_classes=>'fa-plus-square-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9594027752676442)
,p_name=>'P10_PERSON_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(10962822585768581)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9594241626676444)
,p_name=>'P10_FULL_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(10962822585768581)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
