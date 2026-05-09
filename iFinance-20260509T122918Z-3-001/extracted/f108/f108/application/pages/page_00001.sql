prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'MPR'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#xID_APPROVAL_control_panel{',
'     display:none;',
'}',
'',
'#ID_APPROVAL_USER_control_panel{',
'     display:none;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240129090604'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24200305486422358)
,p_plug_name=>'Manual PR Not available'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--info'
,p_plug_template=>wwv_flow_api.id(19163493885383326)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><strong style="color: red;"> Creation of new Manual PRs are on-hold as budgets are being uploaded on Oracle, you will be able to create PRs on Oracle soon,</strong> For any help, please contact: <a href="mailto:CSekhar@dctabudhabi.ae">Chandra Sekh'
||'ar</a>, <a href="mailto:SMohamed@dctabudhabi.ae">Sherin Mohamed</a></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(19121487847324134)
,p_plug_name=>'All Manuel PRs'
,p_region_name=>'ID_APPROVAL'
,p_icon_css_classes=>'fa-list-alt'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent4:t-Region--noBorder:t-Region--scrollBody:margin-top-none:margin-bottom-md:margin-left-none:margin-right-none'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  mpr.ID,',
'       mpr.CREATOR_PERSON_ID,',
'       mpr.REQUESTOR_PERSON_ID,',
'       mpr.REQUESTOR_ORG_ID,',
'       mpr.REQUEST_NUMBER,',
'       mpr.REQUESTED_AMOUNT,',
'       mpr.CURRENCY,',
'       mpr.REQUEST_TYPE,',
'       mpr.mpr_categpry,',
'       PROJECT_NUMBER,',
'       mpr.TASK_NUMBER,',
'       mpr.EXPENDITURE_TYPE,',
'       mpr.INITIAL_AMOUNT,',
'       mpr.DCT_PROJECT_NAME,',
'       mpr.DCT_PROJECT_DESCRIPTION,',
'       mpr.SUBMISSION_DATE,',
'       mpr.PR_NUMBER,',
'       mpr.DELIVERABLE_DATE,',
'       mpr.RECOMMENDED_VENDOR_NUM,',
'       mpr.RECOMMENDED_VENDOR_SITE_CODE,',
'       mpr.PROCUREMENT_METHOD,',
'       mpr.STATUS,',
'       mpr.fisical_year,',
'       x.emp    Pending_with,',
'       x.received_date received_date,',
'       x.received_date received_date_ON,',
'       mpr.NOTES,',
'       mpr.CREATED_BY,',
'       mpr.CREATED_ON,',
'       mpr.UPDATED_BY,',
'       mpr.UPDATED_ON,',
'       org.sector,',
'       org.department_name,',
'       mpr.FUND_AVAILABLE_YN,',
'       mpr.COST_CENTER,',
'       mpr.DT_REQUIRED,',
'       y.LAST_APPROVED_BY,',
'       y.APPROVED_ON  last_APPROVED_ON',
'       , ''<span aria-hidden="true" class="fa fa-copy fa-2x"></span>'' Copy',
'  from MPR mpr, organizations_details_v org,',
'    (select h.mpr_id , max(h.RECEVIED_DATE)  received_date,',
'    LISTAGG( e.first_name || '' '' || e.last_name , ''; '') WITHIN GROUP (ORDER BY hire_date) emp',
'from mpr_approval_history h, dct_employees_list2 e, mpr m',
'where h.person_id = e.person_id',
'and m.id = h.mpr_id',
'and h.status = ''Pending''',
'and m.status = ''In-Progress''',
'group by h.mpr_id) x,',
'(select h2.mpr_id mpr_id, e2.full_name_en  last_approved_by, h2.action_date Approved_on',
'from mpr_approval_history h2 , employees_v e2',
'where  1=1 ',
'--and h2.mpr_id = mpr.id',
'and h2.person_id = e2.person_id',
'and h2.status = ''Approved''',
'and h2.step_no = (select max(x2.step_no) from mpr_approval_history x2 where x2.mpr_id = h2.mpr_id)) y',
'  where mpr.requestor_org_id = org.org_id',
'  and mpr.id = x.mpr_id (+)',
'  and mpr.id = y.mpr_id (+)',
'  order by mpr.UPDATED_ON desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from DCT_DATA_ACCESS_ASSIGNMENT',
'where entity_id in (36,32, 30,31,46)    -- (36 MPR Admin, 32 Budget Planning, 30 Sourcing Manager, 31 Supply Management Unit Heads , 46 View All MPR)',
'and person_id = :PERSON_ID',
'and status = ''A''',
'and sysdate between start_date and nvl(end_date , sysdate+ 100)',
'union all',
'select 1',
'from cost_centers_fbp c',
'where c.bp_type = ''FBP''',
'and c.status = ''A''',
'and sysdate BETWEEN c.start_date and nvl(c.end_date,sysdate+1)',
'and c.person_id = :PERSON_ID;'))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'All Manuel PRs'
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
,p_plug_comment=>'only MPR Admin Role'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(19121585203324135)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Manual PR available'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID,P2_PRINT_ID:#ID#,#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>19121585203324135
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19121684042324136)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19121752886324137)
,p_db_column_name=>'CREATOR_PERSON_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Creator'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(19496453621420111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19121820042324138)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Requestor'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(19496453621420111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19121959160324139)
,p_db_column_name=>'REQUESTOR_ORG_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Organization'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(19497296651432225)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19122016621324140)
,p_db_column_name=>'REQUEST_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'MPR#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19122182564324141)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19122259116324142)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(19499875202477399)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19122322695324143)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19122456035324144)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19122532142324145)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19122618604324146)
,p_db_column_name=>'INITIAL_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Initial Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19122734683324147)
,p_db_column_name=>'DCT_PROJECT_NAME'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'DCT Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19122887093324148)
,p_db_column_name=>'DCT_PROJECT_DESCRIPTION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'DCT Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19122949565324249)
,p_db_column_name=>'SUBMISSION_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Submission Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19123028168324250)
,p_db_column_name=>'PR_NUMBER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'PR Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19292206183442301)
,p_db_column_name=>'DELIVERABLE_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Deliverable Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19292350455442302)
,p_db_column_name=>'RECOMMENDED_VENDOR_NUM'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Recommended Vendor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19292490464442303)
,p_db_column_name=>'RECOMMENDED_VENDOR_SITE_CODE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Recommended Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19292531752442304)
,p_db_column_name=>'PROCUREMENT_METHOD'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Procurement Method'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19292601945442305)
,p_db_column_name=>'STATUS'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19292704016442306)
,p_db_column_name=>'NOTES'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19292850999442307)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19292973855442308)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19293065080442309)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19293100722442310)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19293306841442312)
,p_db_column_name=>'SECTOR'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19293467981442313)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20287971711339514)
,p_db_column_name=>'CURRENCY'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20288090319339515)
,p_db_column_name=>'FUND_AVAILABLE_YN'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Fund Available ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20345897479846076)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20288167213339516)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20288271741339517)
,p_db_column_name=>'DT_REQUIRED'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'DT Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20345897479846076)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25748307544248418)
,p_db_column_name=>'MPR_CATEGPRY'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25823128127405788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25748435155248419)
,p_db_column_name=>'PENDING_WITH'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25748538617248420)
,p_db_column_name=>'RECEIVED_DATE'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Pending Since'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25749434309248429)
,p_db_column_name=>'RECEIVED_DATE_ON'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Received  On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23232871747343563)
,p_db_column_name=>'LAST_APPROVED_BY'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Last Approved By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23232738281343562)
,p_db_column_name=>'LAST_APPROVED_ON'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Last Approved ON'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1124818785945146)
,p_db_column_name=>'FISICAL_YEAR'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Fisical Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11973476458745558)
,p_db_column_name=>'COPY'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Copy'
,p_column_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:34:P34_ID,P34_REQUEST_NUMBER:#ID#,#REQUEST_NUMBER#'
,p_column_linktext=>'#COPY#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(19305217789446148)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'193053'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:MPR_CATEGPRY:REQUESTOR_PERSON_ID:SECTOR:COST_CENTER:REQUESTOR_ORG_ID:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:DELIVERABLE_DATE:REQUESTED_AMOUNT:STATUS:'
,p_sort_column_1=>'UPDATED_ON'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'DESC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(199577089787343141)
,p_report_id=>wwv_flow_api.id(19305217789446148)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(199576728381343141)
,p_report_id=>wwv_flow_api.id(19305217789446148)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(199576373264343140)
,p_report_id=>wwv_flow_api.id(19305217789446148)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(331062752666121584)
,p_application_user=>'TCA9051'
,p_name=>'MPR By Sectors'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:REQUESTOR_PERSON_ID:COST_CENTER:REQUESTOR_ORG_ID:PROJECT_NUMBER:REQUESTED_AMOUNT:CURRENCY:STATUS:SECTOR:'
,p_break_on=>'SECTOR:0:0:0:0:0'
,p_break_enabled_on=>'SECTOR:0:0:0:0:0'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(331062608210121584)
,p_report_id=>wwv_flow_api.id(331062752666121584)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(331062486524121584)
,p_report_id=>wwv_flow_api.id(331062752666121584)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(331062413963121584)
,p_report_id=>wwv_flow_api.id(331062752666121584)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(329477637606739060)
,p_application_user=>'TCA9051'
,p_name=>'Latest'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:REQUESTOR_PERSON_ID:COST_CENTER:REQUESTOR_ORG_ID:PROJECT_NUMBER:REQUESTED_AMOUNT:CURRENCY:STATUS:'
,p_sort_column_1=>'UPDATED_ON'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(329477507560739061)
,p_report_id=>wwv_flow_api.id(329477637606739060)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(329477434074739061)
,p_report_id=>wwv_flow_api.id(329477637606739060)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(329477361401739061)
,p_report_id=>wwv_flow_api.id(329477637606739060)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(329303938552899153)
,p_application_user=>'TCA9051'
,p_name=>'Finance PR'
,p_description=>'All MPR for Finance department '
,p_report_seq=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:REQUESTOR_PERSON_ID:COST_CENTER:REQUESTOR_ORG_ID:PROJECT_NUMBER:REQUESTED_AMOUNT:CURRENCY:STATUS:'
,p_sort_column_1=>'UPDATED_ON'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(329303720480899153)
,p_report_id=>wwv_flow_api.id(329303938552899153)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(329303595303899153)
,p_report_id=>wwv_flow_api.id(329303938552899153)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(329303495183899153)
,p_report_id=>wwv_flow_api.id(329303938552899153)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(329303806086899153)
,p_report_id=>wwv_flow_api.id(329303938552899153)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COST_CENTER'
,p_operator=>'='
,p_expr=>'4510210'
,p_condition_sql=>'"COST_CENTER" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''4510210''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(329091601800881088)
,p_application_user=>'TCA9036'
,p_name=>'Emad'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:REQUESTOR_PERSON_ID:COST_CENTER:PROJECT_NUMBER:REQUESTED_AMOUNT:CURRENCY:STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(329091565161881089)
,p_report_id=>wwv_flow_api.id(329091601800881088)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(329091475059881089)
,p_report_id=>wwv_flow_api.id(329091601800881088)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(329091310836881089)
,p_report_id=>wwv_flow_api.id(329091601800881088)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(328634323507374754)
,p_application_user=>'TCA9051'
,p_name=>'Pending With'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:REQUESTOR_PERSON_ID:COST_CENTER:REQUESTOR_ORG_ID:PROJECT_NUMBER:REQUESTED_AMOUNT:CURRENCY:PENDING_WITH:RECEIVED_DATE:STATUS:'
,p_sort_column_1=>'REQUEST_NUMBER'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'UPDATED_ON'
,p_sort_direction_2=>'DESC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(328629040654419376)
,p_report_id=>wwv_flow_api.id(328634323507374754)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(328628930191419376)
,p_report_id=>wwv_flow_api.id(328634323507374754)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(328628833985419376)
,p_report_id=>wwv_flow_api.id(328634323507374754)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(328250279266785081)
,p_application_user=>'TCA627'
,p_name=>'MPR with Fund Available'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:REQUESTOR_PERSON_ID:COST_CENTER:REQUESTOR_ORG_ID:PROJECT_NUMBER:FUND_AVAILABLE_YN:REQUESTED_AMOUNT:CURRENCY:PENDING_WITH:STATUS:'
,p_sort_column_1=>'REQUEST_NUMBER'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'UPDATED_ON'
,p_sort_direction_2=>'DESC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(328250129039785082)
,p_report_id=>wwv_flow_api.id(328250279266785081)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(328250007414785082)
,p_report_id=>wwv_flow_api.id(328250279266785081)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(328249946397785082)
,p_report_id=>wwv_flow_api.id(328250279266785081)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(324504846174209925)
,p_application_user=>'TCA9051'
,p_name=>'Status Summary By Category'
,p_report_seq=>10
,p_report_type=>'PIVOT'
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:REQUESTOR_PERSON_ID:COST_CENTER:REQUESTOR_ORG_ID:PROJECT_NUMBER:REQUESTED_AMOUNT:CURRENCY:PENDING_WITH:STATUS:'
,p_sort_column_1=>'REQUEST_NUMBER'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'UPDATED_ON'
,p_sort_direction_2=>'DESC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(324504758082209925)
,p_report_id=>wwv_flow_api.id(324504846174209925)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(324504613750209925)
,p_report_id=>wwv_flow_api.id(324504846174209925)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(324504508399209925)
,p_report_id=>wwv_flow_api.id(324504846174209925)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_pivot(
 p_id=>wwv_flow_api.id(324504420906209925)
,p_report_id=>wwv_flow_api.id(324504846174209925)
,p_pivot_columns=>'MPR_CATEGPRY'
,p_row_columns=>'STATUS'
);
wwv_flow_api.create_worksheet_pivot_agg(
 p_id=>wwv_flow_api.id(324504379078209926)
,p_pivot_id=>wwv_flow_api.id(324504420906209925)
,p_display_seq=>1
,p_function_name=>'COUNT'
,p_column_name=>'REQUEST_NUMBER'
,p_db_column_name=>'PFC1'
,p_column_label=>'Count'
,p_format_mask=>'999G999G999G999G990'
,p_display_sum=>'Y'
);
wwv_flow_api.create_worksheet_pivot_agg(
 p_id=>wwv_flow_api.id(324504224036209926)
,p_pivot_id=>wwv_flow_api.id(324504420906209925)
,p_display_seq=>2
,p_function_name=>'SUM'
,p_column_name=>'REQUESTED_AMOUNT'
,p_db_column_name=>'PFC2'
,p_column_label=>'Total Amount'
,p_format_mask=>'999G999G999G999G990'
,p_display_sum=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(202446752740975103)
,p_application_user=>'TCA282'
,p_name=>'PRs'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:MPR_CATEGPRY:REQUESTOR_PERSON_ID:COST_CENTER:REQUESTOR_ORG_ID:PROJECT_NUMBER:REQUESTED_AMOUNT:PENDING_WITH:STATUS:COPY:'
,p_sort_column_1=>'REQUESTOR_PERSON_ID'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'UPDATED_ON'
,p_sort_direction_2=>'DESC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'DESC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(202446654921975102)
,p_report_id=>wwv_flow_api.id(202446752740975103)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(202446512775975102)
,p_report_id=>wwv_flow_api.id(202446752740975103)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(202446438724975102)
,p_report_id=>wwv_flow_api.id(202446752740975103)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(199578296600369379)
,p_application_user=>'TCA9051'
,p_name=>'2023 MPR For Hospitality'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:MPR_CATEGPRY:REQUESTOR_PERSON_ID:SECTOR:COST_CENTER:REQUESTOR_ORG_ID:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:DELIVERABLE_DATE:REQUESTED_AMOUNT:STATUS:'
,p_sort_column_1=>'UPDATED_ON'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'DESC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(199578177304369378)
,p_report_id=>wwv_flow_api.id(199578296600369379)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(199578064549369378)
,p_report_id=>wwv_flow_api.id(199578296600369379)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(199577964980369378)
,p_report_id=>wwv_flow_api.id(199578296600369379)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(199578210766369379)
,p_report_id=>wwv_flow_api.id(199578296600369379)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'DELIVERABLE_DATE'
,p_operator=>'>='
,p_expr=>'20230101000000'
,p_condition_sql=>'"DELIVERABLE_DATE" >= to_date(#APXWS_EXPR#,''YYYYMMDDHH24MISS'')'
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_DATE#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(118964651181382920)
,p_application_user=>'TCA9051'
,p_name=>'4510150 Report'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:MPR_CATEGPRY:REQUESTOR_PERSON_ID:SECTOR:COST_CENTER:REQUESTOR_ORG_ID:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:DELIVERABLE_DATE:REQUESTED_AMOUNT:STATUS:FUND_AVAILABLE_YN:FISICAL_YEAR:CREATED_ON:'
,p_sort_column_1=>'UPDATED_ON'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'DESC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(118964317387382920)
,p_report_id=>wwv_flow_api.id(118964651181382920)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3EB52F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(118964222389382920)
,p_report_id=>wwv_flow_api.id(118964651181382920)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(118964184374382920)
,p_report_id=>wwv_flow_api.id(118964651181382920)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FC4F3F'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(118964502909382920)
,p_report_id=>wwv_flow_api.id(118964651181382920)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COST_CENTER'
,p_operator=>'='
,p_expr=>'4510150'
,p_condition_sql=>'"COST_CENTER" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''4510150''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(118964426502382920)
,p_report_id=>wwv_flow_api.id(118964651181382920)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>'"STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(19289975973383473)
,p_plug_name=>'MPR'
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
 p_id=>wwv_flow_api.id(21965100301318839)
,p_plug_name=>'Notifications History'
,p_icon_css_classes=>'fa-history'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent4:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id,',
'    m.id    mpr_id,',
'    m.request_number,',
'    decode(m.request_type,''S'',''Non-Tendering'',''T'',''Tendering'') request_type,',
'    case m.mpr_categpry ',
'           When  61 Then (select value from DCT_LOOKUP_VALUES where lookup_id = 12 and  value_id = 61) ',
'           When  62 Then (select value from DCT_LOOKUP_VALUES where lookup_id = 12 and  value_id = 62) ',
'           When  63 Then (select value from DCT_LOOKUP_VALUES where lookup_id = 12 and  value_id = 63) ',
'    End       PR_Category,',
'    m.requested_amount,',
'    h.action_required,',
'    h.recevied_date,',
'    h.status,',
'    h.action_date,',
'    h.comments,',
'   decode(h.approval_type,''MPR_APPROVAL'',''Manual PR'',h.role_desc) Type',
'FROM',
'    mpr_approval_history h , mpr m',
'where h.person_id = :PERSON_ID',
'and h.mpr_id = m.id',
'and h.status not in (''Submitted'' , ''Pending'' , ''Future'' , ''Bateen'')',
'and h.ACTION_REQUIRED not in (''Stopped'');'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1',
'FROM',
'    mpr_approval_history h ',
'where h.person_id = :PERSON_ID;'))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Notifications History'
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
 p_id=>wwv_flow_api.id(21965290996318840)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>21965290996318840
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21965420529318842)
,p_db_column_name=>'REQUEST_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Number'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID,P2_PRINT_ID:#MPR_ID#,#MPR_ID#'
,p_column_linktext=>'#REQUEST_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21965532959318843)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21965650552318844)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21965721078318845)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21965841490318846)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21965967907318847)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21966065980318848)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21966166312318849)
,p_db_column_name=>'COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22341325246366301)
,p_db_column_name=>'TYPE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22341468301366302)
,p_db_column_name=>'PR_CATEGORY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'MPR Category'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22341651263366304)
,p_db_column_name=>'ID'
,p_display_order=>130
,p_column_identifier=>'N'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22341739963366305)
,p_db_column_name=>'MPR_ID'
,p_display_order=>140
,p_column_identifier=>'O'
,p_column_label=>'Mpr Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(22350189649367173)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'223502'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:REQUESTED_AMOUNT:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE'
,p_sort_column_1=>'ACTION_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(202113159270492928)
,p_application_user=>'TCA982'
,p_name=>'Manual Pr list '
,p_description=>'manual list '
,p_report_seq=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:REQUESTED_AMOUNT:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE'
,p_sort_column_1=>'ACTION_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22583613942288916)
,p_plug_name=>'My Manual PR'
,p_region_name=>'ID_APPROVAL_USER'
,p_icon_css_classes=>'fa-file-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent4:t-Region--noBorder:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select mpr.ID,',
'       mpr.CREATOR_PERSON_ID,',
'       mpr.REQUESTOR_PERSON_ID,',
'       mpr.REQUESTOR_ORG_ID,',
'       mpr.REQUEST_NUMBER,',
'       mpr.REQUESTED_AMOUNT,',
'       mpr.CURRENCY,',
'       mpr.REQUEST_TYPE,',
'       PROJECT_NUMBER,',
'       mpr.TASK_NUMBER,',
'       mpr.EXPENDITURE_TYPE,',
'       mpr.INITIAL_AMOUNT,',
'       mpr.DCT_PROJECT_NAME,',
'       mpr.DCT_PROJECT_DESCRIPTION,',
'       mpr.SUBMISSION_DATE,',
'       mpr.PR_NUMBER,',
'       mpr.DELIVERABLE_DATE,',
'       mpr.RECOMMENDED_VENDOR_NUM,',
'       mpr.RECOMMENDED_VENDOR_SITE_CODE,',
'       mpr.PROCUREMENT_METHOD,',
'       mpr.STATUS,',
'       mpr.NOTES,',
'       mpr.CREATED_BY,',
'       mpr.CREATED_ON,',
'       mpr.UPDATED_BY,',
'       mpr.UPDATED_ON,',
'       org.sector,',
'       org.department_name,',
'       mpr.FUND_AVAILABLE_YN,',
'       mpr.COST_CENTER,',
'       mpr.DT_REQUIRED',
'         , ''<span aria-hidden="true" class="fa fa-copy fa-2x"></span>'' Copy',
'  from MPR mpr, organizations_details_v org',
'  where',
'  mpr.requestor_org_id = org.org_id',
'  and',
'  (mpr.REQUESTOR_PERSON_ID = :PERSON_ID or mpr.CREATOR_PERSON_ID = :PERSON_ID)',
'  order by mpr.UPDATED_ON desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'My Manual PR'
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
 p_id=>wwv_flow_api.id(22583735806288917)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'you don''t have any Manual PR.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID,P2_PRINT_ID:#ID#,#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>22583735806288917
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22583896836288918)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22583903362288919)
,p_db_column_name=>'CREATOR_PERSON_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Creator Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22584009059288920)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Requestor Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22584146294288921)
,p_db_column_name=>'REQUESTOR_ORG_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Requestor Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22584211543288922)
,p_db_column_name=>'REQUEST_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'MPR#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22584376275288923)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22584460729288924)
,p_db_column_name=>'CURRENCY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22584585947288925)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(19499875202477399)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22584637616288926)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22584702807288927)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22584803324288928)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22584902735288929)
,p_db_column_name=>'INITIAL_AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Initial Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22585058963288930)
,p_db_column_name=>'DCT_PROJECT_NAME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'DCT Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22585146019288931)
,p_db_column_name=>'DCT_PROJECT_DESCRIPTION'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'DCT Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22585228384288932)
,p_db_column_name=>'SUBMISSION_DATE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Submission Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22585371983288933)
,p_db_column_name=>'PR_NUMBER'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'PR Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22585499155288934)
,p_db_column_name=>'DELIVERABLE_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Deliverable Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22585596138288935)
,p_db_column_name=>'RECOMMENDED_VENDOR_NUM'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Recommended Vendor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22585620513288936)
,p_db_column_name=>'RECOMMENDED_VENDOR_SITE_CODE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Recommended Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22585730775288937)
,p_db_column_name=>'PROCUREMENT_METHOD'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Procurement Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22585872799288938)
,p_db_column_name=>'STATUS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22585949273288939)
,p_db_column_name=>'NOTES'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22586058094288940)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22586186212288941)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22586284698288942)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22586357615288943)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22586635481288946)
,p_db_column_name=>'FUND_AVAILABLE_YN'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Fund Available Yn'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22586778585288947)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22586826471288948)
,p_db_column_name=>'DT_REQUIRED'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Dt Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40172548861102855)
,p_db_column_name=>'COPY'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Copy'
,p_column_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.::P34_ID,P34_REQUEST_NUMBER:#ID#,#REQUEST_NUMBER#'
,p_column_linktext=>'#COPY#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136604589300420522)
,p_db_column_name=>'SECTOR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136604487808420521)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(22745114616866555)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'227452'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NUMBER:REQUEST_TYPE:REQUESTED_AMOUNT:CURRENCY:INITIAL_AMOUNT:DCT_PROJECT_NAME:DELIVERABLE_DATE:STATUS::COPY:SECTOR:DEPARTMENT_NAME'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(41079982705046170)
,p_report_id=>wwv_flow_api.id(22745114616866555)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_NUMBER'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("REQUEST_NUMBER" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#F44336'
,p_row_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(41080461588046170)
,p_report_id=>wwv_flow_api.id(22745114616866555)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(41080810797046170)
,p_report_id=>wwv_flow_api.id(22745114616866555)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#DDE629'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23736530473981320)
,p_plug_name=>'BP Manuel PRs'
,p_icon_css_classes=>'fa-list-alt'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent4:t-Region--noBorder:t-Region--scrollBody:margin-top-none:margin-bottom-md:margin-left-none:margin-right-none'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select mpr.ID,',
'       mpr.CREATOR_PERSON_ID,',
'       mpr.REQUESTOR_PERSON_ID,',
'       mpr.REQUESTOR_ORG_ID,',
'       mpr.REQUEST_NUMBER,',
'       mpr.REQUESTED_AMOUNT,',
'       mpr.CURRENCY,',
'       mpr.REQUEST_TYPE,',
'       PROJECT_NUMBER,',
'       mpr.TASK_NUMBER,',
'       mpr.EXPENDITURE_TYPE,',
'       mpr.INITIAL_AMOUNT,',
'       mpr.DCT_PROJECT_NAME,',
'       mpr.DCT_PROJECT_DESCRIPTION,',
'       mpr.SUBMISSION_DATE,',
'       mpr.PR_NUMBER,',
'       mpr.DELIVERABLE_DATE,',
'       mpr.RECOMMENDED_VENDOR_NUM,',
'       mpr.RECOMMENDED_VENDOR_SITE_CODE,',
'       mpr.PROCUREMENT_METHOD,',
'       mpr.STATUS,',
'       mpr.NOTES,',
'       mpr.CREATED_BY,',
'       mpr.CREATED_ON,',
'       mpr.UPDATED_BY,',
'       mpr.UPDATED_ON,',
'       org.sector,',
'       org.department_name,',
'       mpr.FUND_AVAILABLE_YN,',
'       mpr.COST_CENTER,',
'       (select distinct cost_center_description',
'        from dct_gl_code_combinations_all',
'        where cost_center_code = mpr.COST_CENTER) Cost_Center_name,',
'       mpr.DT_REQUIRED',
'  from MPR mpr, organizations_details_v org',
'  where mpr.requestor_org_id = org.org_id',
'  and mpr.cost_center in (select cost_center',
'from cost_centers_fbp',
'where person_id = :PERSON_ID',
'and status = ''A'')',
'  order by mpr.UPDATED_ON desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from cost_centers_fbp',
'where status = ''A''',
'and person_id = :PERSON_ID;'))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'BP Manuel PRs'
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
,p_plug_comment=>'only MPR Admin Role'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(23736645943981321)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Manual PR available'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID,P2_PRINT_ID:#ID#,#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>23736645943981321
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23736749818981322)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23736829906981323)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23736978236981324)
,p_db_column_name=>'CURRENCY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23737094543981325)
,p_db_column_name=>'FUND_AVAILABLE_YN'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Fund Available ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20345897479846076)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23737186828981326)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23737285620981327)
,p_db_column_name=>'DT_REQUIRED'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'DT Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20345897479846076)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23737397056981328)
,p_db_column_name=>'CREATOR_PERSON_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Creator'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(19496453621420111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23737478666981329)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Requestor'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(19496453621420111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23737579423981330)
,p_db_column_name=>'REQUESTOR_ORG_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Organization'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(19497296651432225)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23737641199981331)
,p_db_column_name=>'REQUEST_NUMBER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'MPR#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23737754507981332)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23737806857981333)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(19499875202477399)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23737925323981334)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23738068145981335)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23738115715981336)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23738207038981337)
,p_db_column_name=>'INITIAL_AMOUNT'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Initial Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23738310701981338)
,p_db_column_name=>'DCT_PROJECT_NAME'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'DCT Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23738485248981339)
,p_db_column_name=>'DCT_PROJECT_DESCRIPTION'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'DCT Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23738541207981340)
,p_db_column_name=>'SUBMISSION_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Submission Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23738640418981341)
,p_db_column_name=>'PR_NUMBER'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'PR Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23738783579981342)
,p_db_column_name=>'DELIVERABLE_DATE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Deliverable Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23738899056981343)
,p_db_column_name=>'RECOMMENDED_VENDOR_NUM'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Recommended Vendor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23738976829981344)
,p_db_column_name=>'RECOMMENDED_VENDOR_SITE_CODE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Recommended Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23739015287981345)
,p_db_column_name=>'PROCUREMENT_METHOD'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Procurement Method'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23739195513981346)
,p_db_column_name=>'STATUS'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23739296562981347)
,p_db_column_name=>'NOTES'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23739304559981348)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23739495637981349)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23739507435981350)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23742143392932501)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23742257184932502)
,p_db_column_name=>'SECTOR'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23742322447932503)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(23758255182917357)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'237583'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NUMBER:REQUESTOR_PERSON_ID:REQUESTED_AMOUNT:CURRENCY:COST_CENTER:DELIVERABLE_DATE:STATUS::COST_CENTER_NAME'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(23760686341858215)
,p_report_id=>wwv_flow_api.id(23758255182917357)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#DDE629'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(19293220228442311)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(19289975973383473)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2::'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-file-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24200502738422360)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(19289975973383473)
,p_button_name=>'New_NOT_AVAILABLE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-file-plus'
,p_button_comment=>'Disable Pending Pages on 9-Aug-2021'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(22393977672545478)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(19289975973383473)
,p_button_name=>'Send_Email'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Email'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'EMP_NUM'
,p_button_condition2=>'9051:9050:1384'
,p_button_condition_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(22393849575545477)
,p_name=>'Send Email'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(22393977672545478)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(22393817833545476)
,p_event_id=>wwv_flow_api.id(22393849575545477)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to send notification mail to all in-progress Manual PRs, are you sure ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(22393651582545475)
,p_event_id=>wwv_flow_api.id(22393849575545477)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
' ',
' for emp in (select e.full_name_en , e.email , m.request_number',
'                from mpr     m , employees_v e',
'                where m.requestor_person_id = e.person_id',
'                and m.status = ''In-Progress'')',
'',
'loop',
'   ',
'  ',
'        apex_mail.send (',
'        p_from               => ''ifinance@dctabudhabi.ae'' ,   ',
'        p_to                 => emp.email,',
'        p_template_static_id => ''RESUBMIT_MPR'',',
'        p_placeholders       => ''{'' ||',
'        ''    "REQUESTED_PERSON_NAME":''  || apex_json.stringify(emp.full_name_en) ||    ',
'        ''   , "REQUEST_NUMBER":''        || apex_json.stringify(emp.request_number) ||',
'        ''}'' );',
'        ',
'     end loop;',
' ',
'     apex_mail.push_queue;',
'exception',
'     when others then',
'        ',
'     raise; ',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(22393586524545474)
,p_event_id=>wwv_flow_api.id(22393849575545477)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Email Send Successfully'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11972379026745547)
,p_name=>'refresh after copy'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(19121487847324134)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11972222407745546)
,p_event_id=>wwv_flow_api.id(11972379026745547)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(19121487847324134)
);
wwv_flow_api.component_end;
end;
/
