prompt --application/pages/page_00088
begin
--   Manifest
--     PAGE: 00088
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>88
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Delegation Management'
,p_alias=>'DELEGATION-MANAGEMENT'
,p_step_title=>'Delegation Management'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230925063140'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(112466952428793791)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127813188296449776)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(127749711524449850)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(127867332295449731)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(112466353272793790)
,p_plug_name=>'DP Items Delegation Management'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
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
'        , p.DP_ITEM_CODE',
'        ,(select x.full_name_en ',
'         from employees_v x',
'         where x.person_id = p.END_USER_ID) Requestor',
'         ',
'        , case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'         , ''<span aria-hidden="true" class="fa fa-mail-forward fa-2x fam-information fam-is-success"></span>'' Action',
'         , ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'from dp_items_approval_history h , dp_items p , employees_v e',
'where h.REQUEST_ID = p.ITEM_ID',
'and h.status = ''Pending''',
'and h.person_id = e.person_id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Delegation Management'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(112466276013793790)
,p_name=>'Delegation Management'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_select_columns=>'N'
,p_show_rows_per_page=>'N'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>191056153238531792
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112465916881793785)
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
 p_id=>wwv_flow_api.id(112461833836793781)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Item Code'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112465493940793783)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>21
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112465115298793783)
,p_db_column_name=>'STEP_NO'
,p_display_order=>31
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112464707889793782)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>41
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112464246713793782)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>51
,p_column_identifier=>'E'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112463909514793782)
,p_db_column_name=>'PENDING_SINCE'
,p_display_order=>61
,p_column_identifier=>'F'
,p_column_label=>'Pending Since'
,p_column_type=>'DATE'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112463449627793782)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>71
,p_column_identifier=>'G'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112463122468793782)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>81
,p_column_identifier=>'H'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112462654825793781)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>91
,p_column_identifier=>'I'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112462274340793781)
,p_db_column_name=>'EMAIL'
,p_display_order=>101
,p_column_identifier=>'J'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112461462777793781)
,p_db_column_name=>'REQUESTOR'
,p_display_order=>111
,p_column_identifier=>'L'
,p_column_label=>'Requestor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112461065379793780)
,p_db_column_name=>'PHOTO'
,p_display_order=>121
,p_column_identifier=>'M'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112460665417793780)
,p_db_column_name=>'ACTION'
,p_display_order=>131
,p_column_identifier=>'N'
,p_column_label=>'Delegate'
,p_column_link=>'f?p=&APP_ID.:86:&SESSION.::&DEBUG.:86:P86_EMPLOYEE_NAME,P86_PERSON_ID,P86_REQUEST_ID,P86_TYPE,P86_HISTORY_ID,P86_ACTION_FOR:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,D,#ID#,DP'
,p_column_linktext=>'#ACTION#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112460292904793780)
,p_db_column_name=>'REMINDER'
,p_display_order=>141
,p_column_identifier=>'O'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:86:&SESSION.::&DEBUG.:86:P86_EMPLOYEE_NAME,P86_PERSON_ID,P86_REQUEST_ID,P86_TYPE,P86_HISTORY_ID,P86_ACTION_FOR:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,R,#ID#,DP'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(112451149741454399)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1910713'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:DP_ITEM_CODE:FULL_NAME_EN:EMPLOYEE_NUM:RECEVIED_DATE:PENDING_SINCE:EMAIL:REQUESTOR:ACTION:REMINDER:'
,p_sort_column_1=>'PENDING_SINCE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(111984010503112737)
,p_plug_name=>'SD Delegation Management'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
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
'        , p.SCOPE_CODE',
'        ,(select x.full_name_en ',
'         from employees_v x',
'         where x.person_id = (select d.END_USER_ID',
'                                from dp_items d',
'                                where d.ITEM_ID = DP_ITEM_ID)) Requestor',
'         ',
'        , case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'         , ''<span aria-hidden="true" class="fa fa-mail-forward fa-2x fam-information fam-is-success"></span>'' Action',
'         , ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'from dp_scoping_approval_history h , dp_scoping_a p , employees_v e',
'where h.REQUEST_ID = p.SCOPE_ID',
'and h.status = ''Pending''',
'and h.person_id = e.person_id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(111983798430112735)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_select_columns=>'N'
,p_show_rows_per_page=>'N'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>191538630822212847
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111983648522112734)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111983576366112733)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111775143887647869)
,p_db_column_name=>'SCOPE_CODE'
,p_display_order=>30
,p_column_identifier=>'O'
,p_column_label=>'Scope Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111983486982112732)
,p_db_column_name=>'STEP_NO'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111776408747647881)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111776312215647880)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111776137627647879)
,p_db_column_name=>'PENDING_SINCE'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Pending Since'
,p_column_type=>'DATE'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111776066506647878)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111775942844647877)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111775879217647876)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111775811717647875)
,p_db_column_name=>'EMAIL'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111775602069647873)
,p_db_column_name=>'REQUESTOR'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Requestor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111775482542647872)
,p_db_column_name=>'PHOTO'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111775399423647871)
,p_db_column_name=>'ACTION'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Delegate'
,p_column_link=>'f?p=&APP_ID.:86:&SESSION.::&DEBUG.:86:P86_EMPLOYEE_NAME,P86_PERSON_ID,P86_REQUEST_ID,P86_TYPE,P86_HISTORY_ID,P86_ACTION_FOR:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,D,#ID#,SD'
,p_column_linktext=>'#ACTION#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111775272707647870)
,p_db_column_name=>'REMINDER'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:86:&SESSION.::&DEBUG.:86:P86_EMPLOYEE_NAME,P86_PERSON_ID,P86_REQUEST_ID,P86_TYPE,P86_HISTORY_ID,P86_ACTION_FOR:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,R,#ID#,SD'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(111763718350608493)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1917588'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:SCOPE_CODE:FULL_NAME_EN:EMPLOYEE_NUM:RECEVIED_DATE:PENDING_SINCE:EMAIL:REQUESTOR:ACTION:REMINDER:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(111984052642112738)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(112466353272793790)
,p_button_name=>'Config_DP'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Configure'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   :IS_IFINANCE_ADMIN = ''Y'' ',
'or :IS_DP_ADMIN = ''Y''	'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-gear'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(111983921365112736)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(111984010503112737)
,p_button_name=>'Config_SD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Configure'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   :IS_IFINANCE_ADMIN = ''Y'' ',
'or :IS_DP_ADMIN = ''Y''	'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-gear'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(111775015771647867)
,p_branch_name=>'Go to DP Workflow Config - 87'
,p_branch_action=>'f?p=&APP_ID.:87:&SESSION.::&DEBUG.:87:P87_APPROVAL_TYPE_ID:121&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(111984052642112738)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(111774860436647866)
,p_branch_name=>'Go to Scoping Workflow Config - 87'
,p_branch_action=>'f?p=&APP_ID.:87:&SESSION.::&DEBUG.:87:P87_APPROVAL_TYPE_ID:161&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(111983921365112736)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(114257530375497841)
,p_name=>'Refresh after close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(112466353272793790)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(114257444424497840)
,p_event_id=>wwv_flow_api.id(114257530375497841)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(112466353272793790)
);
wwv_flow_api.component_end;
end;
/
