prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>30
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Delegation Management'
,p_alias=>'DELEGATION-MANAGEMENT'
,p_step_title=>'Delegation Management'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230731041246'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(104399341100195025)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(44716056336446683)
,p_plug_name=>'Budget Transfer Delegation Management'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(104398821259195027)
,p_plug_name=>'Delegation Management'
,p_parent_plug_id=>wwv_flow_api.id(44716056336446683)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  h.id',
'        ,h.REQUEST_ID',
'        ,h.step_no',
'         ,h.person_id',
'        ,h.recevied_date',
'        ,h.recevied_date    Pending_since',
'        ,H.APPROVAL_TYPE_ID',
'        ,e.full_name_en',
'        ,e.employee_num',
'        ,e.email',
'        ',
'        , p.request_no',
'        ,(select x.full_name_en ',
'         from employees_v x',
'         where x.person_id = p.SUBMITTED_BY) Requestor',
'         ',
'        ,nvl(p.FROM_AMOUNT, p.TO_AMOUNT) Amount',
'        , case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'         , ''<span aria-hidden="true" class="fa fa-mail-forward fa-2x fam-information fam-is-success"></span>'' Action',
'         , ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'from btf_end_users_req_approval_history h , btf_end_users_header_v p , employees_v e',
'where h.REQUEST_ID = p.REQUEST_ID',
'and h.status = ''Pending''',
'and h.person_id = e.person_id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Delegation Management'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(104398703514195027)
,p_name=>'Delegation Management'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>108885328874989605
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104398251898195030)
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
 p_id=>wwv_flow_api.id(104397897331195031)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104397459531195031)
,p_db_column_name=>'STEP_NO'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104397067084195032)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104396649782195032)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104396284391195032)
,p_db_column_name=>'PENDING_SINCE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Pending Since'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104395902060195032)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104395472009195032)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104395108116195033)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104394637306195033)
,p_db_column_name=>'EMAIL'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104394300657195033)
,p_db_column_name=>'REQUESTOR'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Requestor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104393920617195033)
,p_db_column_name=>'AMOUNT'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104393447212195033)
,p_db_column_name=>'PHOTO'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104393056238195034)
,p_db_column_name=>'ACTION'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Delegate'
,p_column_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.:31:P31_EMPLOYEE_NAME,P31_PERSON_ID,P31_REQUEST_ID,P31_TYPE,P31_HISTORY_ID:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,D,#ID#'
,p_column_linktext=>'#ACTION#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104392645504195034)
,p_db_column_name=>'REMINDER'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.::P31_EMPLOYEE_NAME,P31_PERSON_ID,P31_REQUEST_ID,P31_TYPE,P31_HISTORY_ID:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,R,#ID#'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87069304782549118)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>25
,p_column_identifier=>'P'
,p_column_label=>'Request No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(104380693636292466)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1089034'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:REQUEST_NO:FULL_NAME_EN:EMPLOYEE_NUM:RECEVIED_DATE:PENDING_SINCE:REQUESTOR:AMOUNT:ACTION:REMINDER:'
,p_sort_column_1=>'PENDING_SINCE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(44715966103446682)
,p_plug_name=>'Budget Proposal Delegation Management'
,p_region_template_options=>'#DEFAULT#:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(43472670753345631)
,p_plug_name=>'Budget Proposal Delegation Report'
,p_parent_plug_id=>wwv_flow_api.id(44715966103446682)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  h.id',
'        ,h.REQUEST_ID',
'        ,h.step_no',
'         ,h.person_id',
'        ,h.recevied_date',
'        ,h.recevied_date    Pending_since',
'--        ,H.APPROVAL_TYPE_ID',
'        ,e.full_name_en',
'        ,e.employee_num',
'        ,e.email',
'        ',
'        ,(select x.full_name_en ',
'         from employees_v x',
'         where x.person_id = p.SUBMITTED_BY) Requestor',
'        , p.cost_center',
'        , user_details.get_cost_center_name(p.cost_center) cost_center_Name',
'        , case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'         , ''<span aria-hidden="true" class="fa fa-mail-forward fa-2x fam-information fam-is-success"></span>'' Action',
'         , ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'from budget_proposal_cost_centers_plans_approval_history h , budget_proposal_cost_centers_plans p , employees_v e',
'where h.REQUEST_ID = p.ID',
'and h.status = ''Pending''',
'and h.person_id = e.person_id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Proposal Delegation Report'
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
 p_id=>wwv_flow_api.id(43472587950345630)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>169811444438839002
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43472453794345629)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43472362161345628)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43472276961345627)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43472207289345626)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43472110661345625)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43471959487345624)
,p_db_column_name=>'PENDING_SINCE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Pending Since'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43471914976345623)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43471763196345622)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43471655630345621)
,p_db_column_name=>'EMAIL'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43471591069345620)
,p_db_column_name=>'REQUESTOR'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Requestor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43471518678345619)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43471362462345618)
,p_db_column_name=>'PHOTO'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43471307149345617)
,p_db_column_name=>'ACTION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Action'
,p_column_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.:31:P31_EMPLOYEE_NAME,P31_PERSON_ID,P31_REQUEST_ID,P31_TYPE,P31_HISTORY_ID:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,DBP,#ID#'
,p_column_linktext=>'#ACTION#'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43471153082345616)
,p_db_column_name=>'REMINDER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.:31:P31_EMPLOYEE_NAME,P31_PERSON_ID,P31_REQUEST_ID,P31_TYPE,P31_HISTORY_ID:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,RBP,#ID#'
,p_column_linktext=>'#REMINDER#'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43471099948345615)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(43461702111338957)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1698224'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:FULL_NAME_EN:COST_CENTER:COST_CENTER_NAME:EMPLOYEE_NUM:RECEVIED_DATE:PENDING_SINCE:EMAIL:REQUESTOR:ACTION:REMINDER:'
,p_sort_column_1=>'PENDING_SINCE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(97673836797767283)
,p_name=>'Refresh after close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(104398821259195027)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(97673741534767282)
,p_event_id=>wwv_flow_api.id(97673836797767283)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(104398821259195027)
);
wwv_flow_api.component_end;
end;
/
