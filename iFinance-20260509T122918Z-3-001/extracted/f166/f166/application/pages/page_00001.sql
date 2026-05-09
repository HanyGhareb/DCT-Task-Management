prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(24631887413319249)
,p_name=>'Single Source Requests'
,p_alias=>'HOME'
,p_step_title=>'Single Source Requests'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>To find data enter a search term into the search dialog, or click on the column headings to limit the records returned.</p>',
'',
'<p>You can perform numerous functions by clicking the <strong>Actions</strong> button. This includes selecting the columns that are displayed / hidden and their display sequence, plus numerous data and format functions.  You can also define additiona'
||'l views of the data using the chart, group by, and pivot options.</p>',
'',
'<p>If you want to save your customizations select report, or click download to unload the data. Enter you email address and time frame under subscription to be sent the data on a regular basis.<p>',
'',
'<p>For additional information click Help at the bottom of the Actions menu.</p> ',
'',
'<p>Click the <strong>Reset</strong> button to reset the interactive report back to the default settings.</p>'))
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220703093421'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24649943610319183)
,p_plug_name=>'All Single Source Requests'
,p_icon_css_classes=>'fa-files-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUESTOR_PERSON_ID,',
'       REQUESTOR_ORG_ID,',
'       DEPARTMENT_ID,',
'       SECTOR_ID,',
'       COST_CENTER,',
'       REQUEST_NUMBER,',
'       REQUEST_DATE,',
'       PR_NUMBER,',
'       PROJECT_NAME,',
'       REQUESTED_AMOUNT,',
'       SCHEDULE,',
'       NEW_VENDOR_YN,',
'       RECOMMENDED_VENDOR_NUM,',
'       RECOMMENDED_VENDOR_SITE_CODE,',
'       RECOMMENDED_VENDOR_NAME,',
'       QUOTATION_REFERENCE,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       EXEMPTION_TYPE,',
'       SCOPE_OF_WORK,',
'       JUSTIFICATION,',
'       CORRECTIVE_ACTION,',
'       EMPLOYEE_NUMBER,',
'       APPROVAL_STATUS,',
'       NOTES,',
'       NEW_PROJECT_YN,',
'       ATT2,',
'       ATT3,',
'       ATT4,',
'       SEQ_NUM,',
'       ATT6,',
'       ATT7,',
'       ATT8,',
'       ATT9,',
'       ATT10,',
'       ATT11,',
'       ATT12,',
'       SUBMISSION_DATE,',
'       FINAL_APPROVAL,',
'       CREATED_BY_PERSON_ID,',
'       CREATED_ON,',
'       UPDATED_BY_PERSON_ID,',
'       UPDATED_ON,',
'       PR_TYPE,',
'       PR_FUND_AVAILABLE,',
'       CURRENCY,',
'       TAC_COMMITTEE_ID,',
'       PROJECT_DURATION,',
'       DURATION_UOM,',
'       PROJECT_DURATION_TEXT,',
'       RECOMMENDATION,',
'       DECISION,',
'       EXEMPTION_OTHERS,',
'       MEETING_NUMBER,',
'       DECISION_OPTION,DT_APPROVAL_YN',
'  from SCM_SINGL_SOURCE',
' order by UPDATED_ON  desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
' :IS_SINGLE_SOURCE_ADMIN = ''Y'' or ',
':IS_SUPPLY_MANAGEMENT_UNIT_HEAD > 0 or',
':IS_BUYER   > 0 or',
':IS_COMMITTEE_SECRETARY > 0 or',
':IS_SOUCEING_MANAGER > 0',
'or :PERSON_ID in (310555)'))
,p_prn_page_header=>'Single Source Requests'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(24650057929319183)
,p_name=>'Single Source Requests'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No Single Source requests available'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_email_from=>'ifinance@dctabudhabi.ae'
,p_detail_link=>'f?p=&APP_ID.:2:&APP_SESSION.:::2:P2_ID:\#ID#\'
,p_detail_link_text=>'<span class="fa fa-edit" aria-hidden="true"></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>24650057929319183
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24650413385319177)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24650894492319175)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Requestor Person ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24651233105319175)
,p_db_column_name=>'REQUESTOR_ORG_ID'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Requestor Org ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24651603827319174)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Department ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24652062215319174)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Sector ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24652430222319174)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24652807982319174)
,p_db_column_name=>'REQUEST_NUMBER'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Request Number'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P2_ID,P2_SINGLE_SOURCE_ID:\#ID#\,#ID#'
,p_column_linktext=>'#REQUEST_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24653210436319173)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24653614915319173)
,p_db_column_name=>'PR_NUMBER'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Pr Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24654038136319173)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24654478858319172)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24654828234319172)
,p_db_column_name=>'SCHEDULE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Schedule'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24655233356319172)
,p_db_column_name=>'NEW_VENDOR_YN'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'New Vendor ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25249196382855039)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24655686181319172)
,p_db_column_name=>'RECOMMENDED_VENDOR_NUM'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Recommended Vendor'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25245329858855041)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24656059065319171)
,p_db_column_name=>'RECOMMENDED_VENDOR_SITE_CODE'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Recommended Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24656427921319171)
,p_db_column_name=>'RECOMMENDED_VENDOR_NAME'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Vendor Name (Not Registered)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24656834283319171)
,p_db_column_name=>'QUOTATION_REFERENCE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Quotation Reference'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24657283738319170)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24657636711319170)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24658873596319169)
,p_db_column_name=>'SCOPE_OF_WORK'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Scope of Work'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24659206699319169)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24659646031319169)
,p_db_column_name=>'CORRECTIVE_ACTION'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Corrective Action'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24660042045319169)
,p_db_column_name=>'EMPLOYEE_NUMBER'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Employee Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24660492755319168)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25316183551143624)
,p_db_column_name=>'EXEMPTION_TYPE'
,p_display_order=>36
,p_column_identifier=>'AV'
,p_column_label=>'Exemption Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24660860286319168)
,p_db_column_name=>'NOTES'
,p_display_order=>46
,p_column_identifier=>'AA'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24661682617319167)
,p_db_column_name=>'ATT2'
,p_display_order=>56
,p_column_identifier=>'AC'
,p_column_label=>'Att2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24662029912319167)
,p_db_column_name=>'ATT3'
,p_display_order=>66
,p_column_identifier=>'AD'
,p_column_label=>'Att3'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24662438947319167)
,p_db_column_name=>'ATT4'
,p_display_order=>76
,p_column_identifier=>'AE'
,p_column_label=>'Att4'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24663290371319166)
,p_db_column_name=>'ATT6'
,p_display_order=>86
,p_column_identifier=>'AG'
,p_column_label=>'Att6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24663651285319166)
,p_db_column_name=>'ATT7'
,p_display_order=>96
,p_column_identifier=>'AH'
,p_column_label=>'Att7'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24664088915319166)
,p_db_column_name=>'ATT8'
,p_display_order=>106
,p_column_identifier=>'AI'
,p_column_label=>'Att8'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24664444536319165)
,p_db_column_name=>'ATT9'
,p_display_order=>116
,p_column_identifier=>'AJ'
,p_column_label=>'Att9'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24664863483319165)
,p_db_column_name=>'ATT10'
,p_display_order=>126
,p_column_identifier=>'AK'
,p_column_label=>'Att10'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24665220579319165)
,p_db_column_name=>'ATT11'
,p_display_order=>136
,p_column_identifier=>'AL'
,p_column_label=>'Att11'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24665694126319165)
,p_db_column_name=>'ATT12'
,p_display_order=>146
,p_column_identifier=>'AM'
,p_column_label=>'Att12'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24666026830319164)
,p_db_column_name=>'SUBMISSION_DATE'
,p_display_order=>156
,p_column_identifier=>'AN'
,p_column_label=>'Submission Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24666465757319164)
,p_db_column_name=>'FINAL_APPROVAL'
,p_display_order=>166
,p_column_identifier=>'AO'
,p_column_label=>'Final Approval'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24666824261319164)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>176
,p_column_identifier=>'AP'
,p_column_label=>'Created By Person ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24667218871319163)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>186
,p_column_identifier=>'AQ'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24667699475319163)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>196
,p_column_identifier=>'AR'
,p_column_label=>'Updated By Person ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24668094282319163)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>206
,p_column_identifier=>'AS'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24220043315492749)
,p_db_column_name=>'SEQ_NUM'
,p_display_order=>216
,p_column_identifier=>'AT'
,p_column_label=>'Seq Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25314438129143607)
,p_db_column_name=>'NEW_PROJECT_YN'
,p_display_order=>226
,p_column_identifier=>'AU'
,p_column_label=>'New Project ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25249196382855039)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64864386815507671)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>236
,p_column_identifier=>'AW'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64864471535507672)
,p_db_column_name=>'PR_TYPE'
,p_display_order=>246
,p_column_identifier=>'AX'
,p_column_label=>'PR Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64864541125507673)
,p_db_column_name=>'PR_FUND_AVAILABLE'
,p_display_order=>256
,p_column_identifier=>'AY'
,p_column_label=>'PR Fund Available'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25249196382855039)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64864677858507674)
,p_db_column_name=>'CURRENCY'
,p_display_order=>266
,p_column_identifier=>'AZ'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64864766355507675)
,p_db_column_name=>'TAC_COMMITTEE_ID'
,p_display_order=>276
,p_column_identifier=>'BA'
,p_column_label=>'TAC Committee ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64864872405507676)
,p_db_column_name=>'PROJECT_DURATION'
,p_display_order=>286
,p_column_identifier=>'BB'
,p_column_label=>'Project Duration'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64865033839507677)
,p_db_column_name=>'DURATION_UOM'
,p_display_order=>296
,p_column_identifier=>'BC'
,p_column_label=>'Duration UOM'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64865048492507678)
,p_db_column_name=>'PROJECT_DURATION_TEXT'
,p_display_order=>306
,p_column_identifier=>'BD'
,p_column_label=>'Project Duration Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64865235927507679)
,p_db_column_name=>'RECOMMENDATION'
,p_display_order=>316
,p_column_identifier=>'BE'
,p_column_label=>'Recommendation'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64865285013507680)
,p_db_column_name=>'DECISION'
,p_display_order=>326
,p_column_identifier=>'BF'
,p_column_label=>'Decision'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64865401380507681)
,p_db_column_name=>'EXEMPTION_OTHERS'
,p_display_order=>336
,p_column_identifier=>'BG'
,p_column_label=>'Exemption Others'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64865441398507682)
,p_db_column_name=>'MEETING_NUMBER'
,p_display_order=>346
,p_column_identifier=>'BH'
,p_column_label=>'Meeting Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64865566571507683)
,p_db_column_name=>'DECISION_OPTION'
,p_display_order=>356
,p_column_identifier=>'BI'
,p_column_label=>'Decision Option'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(395325957853228)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64865705242507684)
,p_db_column_name=>'DT_APPROVAL_YN'
,p_display_order=>366
,p_column_identifier=>'BJ'
,p_column_label=>'DT Approval ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(25249196382855039)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(24711845860319017)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'247119'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>10
,p_report_columns=>'REQUEST_NUMBER:REQUEST_DATE:REQUESTED_AMOUNT:SCHEDULE:RECOMMENDED_VENDOR_NUM:RECOMMENDED_VENDOR_NAME:PROJECT_NUMBER:TASK_NUMBER:APPROVAL_STATUS:'
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
 p_id=>wwv_flow_api.id(85200384951956921)
,p_report_id=>wwv_flow_api.id(24711845860319017)
,p_name=>'approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(85200797332956921)
,p_report_id=>wwv_flow_api.id(24711845860319017)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Completed'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Completed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(85201194819956921)
,p_report_id=>wwv_flow_api.id(24711845860319017)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#A96E17'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(85201570479956920)
,p_report_id=>wwv_flow_api.id(24711845860319017)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Stopped'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Stopped''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24669399066319160)
,p_plug_name=>'Single Source Requests'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24556678455319312)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(24493261337319361)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(24610734179319274)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28705965241375912)
,p_plug_name=>'By Status'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
' :IS_SINGLE_SOURCE_ADMIN = ''Y'' or ',
':IS_SUPPLY_MANAGEMENT_UNIT_HEAD > 0 or',
':IS_BUYER   > 0 or',
':IS_COMMITTEE_SECRETARY > 0 or',
':IS_SOUCEING_MANAGER > 0'))
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(28706020108375913)
,p_region_id=>wwv_flow_api.id(28705965241375912)
,p_chart_type=>'donut'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_tooltip_rendered=>'Y'
,p_show_series_name=>false
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
,p_no_data_found_message=>'No Single Source requests available'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(28706195376375914)
,p_chart_id=>wwv_flow_api.id(28706020108375913)
,p_seq=>10
,p_name=>'By Status'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select APPROVAL_STATUS Status, total ,',
'    case APPROVAL_STATUS when ''Completed''    then ''#3BAA2C''',
'                        when ''Stopped''     then ''#F44336''',
'                        when ''In-Progress''  then ''#A96E17''',
'                        when ''Draft''        then ''#FFD6D2''',
'    end Color',
'from',
'(select approval_status , COUNT(*) total',
'from scm_singl_source',
' where APPROVAL_STATUS != ''Draft''',
'GROUP BY approval_status)'))
,p_items_value_column_name=>'TOTAL'
,p_items_label_column_name=>'STATUS'
,p_color=>'&COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LBL_VAL'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20:P20_STATUS:&STATUS.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28706464948375917)
,p_plug_name=>'Top 10 Cost Centers'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
' :IS_SINGLE_SOURCE_ADMIN = ''Y'' or ',
':IS_SUPPLY_MANAGEMENT_UNIT_HEAD > 0 or',
':IS_BUYER   > 0 or',
':IS_COMMITTEE_SECRETARY > 0 or',
':IS_SOUCEING_MANAGER > 0'))
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(28706587550375918)
,p_region_id=>wwv_flow_api.id(28706464948375917)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'value-desc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>false
,p_show_group_name=>false
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_no_data_found_message=>'No Single Source requests available'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(28706614445375919)
,p_chart_id=>wwv_flow_api.id(28706587550375918)
,p_seq=>10
,p_name=>'Cost Centers'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select s.cost_center , COUNT(*)',
'from scm_singl_source s',
'where approval_status != ''Draft''',
'GROUP BY s.cost_center;'))
,p_items_value_column_name=>'COUNT(*)'
,p_items_label_column_name=>'COST_CENTER'
,p_color=>'#34AADC'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(28706853074375921)
,p_chart_id=>wwv_flow_api.id(28706587550375918)
,p_axis=>'y'
,p_is_rendered=>'off'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(28706772667375920)
,p_chart_id=>wwv_flow_api.id(28706587550375918)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66692763499377852)
,p_plug_name=>'My Single Source Requests '
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUESTOR_PERSON_ID,',
'       REQUESTOR_ORG_ID,',
'       DEPARTMENT_ID,',
'       SECTOR_ID,',
'       COST_CENTER,',
'       REQUEST_NUMBER,',
'       REQUEST_DATE,',
'       PR_NUMBER,',
'       PROJECT_NAME,',
'       REQUESTED_AMOUNT,',
'       SCHEDULE,',
'       NEW_VENDOR_YN,',
'       RECOMMENDED_VENDOR_NUM,',
'       RECOMMENDED_VENDOR_SITE_CODE,',
'       RECOMMENDED_VENDOR_NAME,',
'       QUOTATION_REFERENCE,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       EXEMPTION_TYPE,',
'       SCOPE_OF_WORK,',
'       JUSTIFICATION,',
'       CORRECTIVE_ACTION,',
'       EMPLOYEE_NUMBER,',
'       APPROVAL_STATUS,',
'       NOTES,',
'       NEW_PROJECT_YN,',
'       ATT2,',
'       ATT3,',
'       ATT4,',
'       SEQ_NUM,',
'       ATT6,',
'       ATT7,',
'       ATT8,',
'       ATT9,',
'       ATT10,',
'       ATT11,',
'       ATT12,',
'       SUBMISSION_DATE,',
'       FINAL_APPROVAL,',
'       CREATED_BY_PERSON_ID,',
'       CREATED_ON,',
'       UPDATED_BY_PERSON_ID,',
'       UPDATED_ON,',
'       PR_TYPE,',
'       PR_FUND_AVAILABLE,',
'       CURRENCY,',
'       TAC_COMMITTEE_ID,',
'       PROJECT_DURATION,',
'       DURATION_UOM,',
'       PROJECT_DURATION_TEXT,',
'       RECOMMENDATION,',
'       DECISION,',
'       EXEMPTION_OTHERS,',
'       MEETING_NUMBER,',
'       DECISION_OPTION,DT_APPROVAL_YN',
'  from SCM_SINGL_SOURCE',
'  where REQUESTOR_PERSON_ID = :PERSON_ID',
' order by UPDATED_ON  desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Single Source Requests'
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
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(66692988671377854)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'You don''t have any Single Source requests'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_email_from=>'ifinance@dctabudhabi.ae'
,p_detail_link=>'f?p=&APP_ID.:2:&APP_SESSION.:::2:P2_ID:\#ID#\'
,p_detail_link_text=>'<span class="fa fa-edit" aria-hidden="true"></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>95678350334876316
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66693107361377855)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66693174922377856)
,p_db_column_name=>'NOTES'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66693289598377857)
,p_db_column_name=>'ATT2'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Att2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66693404580377858)
,p_db_column_name=>'ATT3'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Att3'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66693453635377859)
,p_db_column_name=>'ATT4'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Att4'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66693559892377860)
,p_db_column_name=>'ATT6'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Att6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66693654546377861)
,p_db_column_name=>'ATT7'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Att7'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66693803534377862)
,p_db_column_name=>'ATT8'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Att8'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66693901612377863)
,p_db_column_name=>'ATT9'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Att9'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694030450377864)
,p_db_column_name=>'ATT10'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Att10'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694113297377865)
,p_db_column_name=>'ATT11'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Att11'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694163857377866)
,p_db_column_name=>'ATT12'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Att12'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694321014377867)
,p_db_column_name=>'SUBMISSION_DATE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Submission Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694398357377868)
,p_db_column_name=>'FINAL_APPROVAL'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Final Approval'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694457439377869)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By Person ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694610445377870)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694667935377871)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated By Person ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694803392377872)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694862592377873)
,p_db_column_name=>'SEQ_NUM'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Seq Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66695011465377874)
,p_db_column_name=>'NEW_PROJECT_YN'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'New Project ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25249196382855039)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66695111878377875)
,p_db_column_name=>'EXEMPTION_TYPE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Exemption Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66695225622377876)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66695320456377877)
,p_db_column_name=>'PR_TYPE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'PR Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66695340074377878)
,p_db_column_name=>'PR_FUND_AVAILABLE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'PR Fund Available'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25249196382855039)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66695513265377879)
,p_db_column_name=>'CURRENCY'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66695588556377880)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Requestor Person ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66695737413377881)
,p_db_column_name=>'TAC_COMMITTEE_ID'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'TAC Committee ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66695798303377882)
,p_db_column_name=>'PROJECT_DURATION'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Project Duration'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66695904704377883)
,p_db_column_name=>'DURATION_UOM'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Duration UOM'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66696026262377884)
,p_db_column_name=>'PROJECT_DURATION_TEXT'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Project Duration Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66696091904377885)
,p_db_column_name=>'RECOMMENDATION'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Recommendation'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66696227844377886)
,p_db_column_name=>'DECISION'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Decision'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66696309214377887)
,p_db_column_name=>'EXEMPTION_OTHERS'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Exemption Others'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66696395979377888)
,p_db_column_name=>'MEETING_NUMBER'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Meeting Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69717426815128739)
,p_db_column_name=>'DECISION_OPTION'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Decision Option'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(395325957853228)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69717469230128740)
,p_db_column_name=>'DT_APPROVAL_YN'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'DT Approval ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(25249196382855039)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69717631155128741)
,p_db_column_name=>'REQUESTOR_ORG_ID'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Requestor Org ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69717642495128742)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Department ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69717819802128743)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Sector ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69717881371128744)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718020577128745)
,p_db_column_name=>'REQUEST_NUMBER'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Request Number'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P2_ID,P2_SINGLE_SOURCE_ID:\#ID#\,#ID#'
,p_column_linktext=>'#REQUEST_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718112433128746)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718182910128747)
,p_db_column_name=>'PR_NUMBER'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Pr Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718259123128748)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718407891128749)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718493587128750)
,p_db_column_name=>'SCHEDULE'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Schedule'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718591452128751)
,p_db_column_name=>'NEW_VENDOR_YN'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'New Vendor ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25249196382855039)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718684727128752)
,p_db_column_name=>'RECOMMENDED_VENDOR_NUM'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Recommended Vendor'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25245329858855041)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718743135128753)
,p_db_column_name=>'RECOMMENDED_VENDOR_SITE_CODE'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Recommended Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718906461128754)
,p_db_column_name=>'RECOMMENDED_VENDOR_NAME'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Vendor Name (Not Registered)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69718938963128755)
,p_db_column_name=>'QUOTATION_REFERENCE'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Quotation Reference'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69719132889128756)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69719202821128757)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69719296724128758)
,p_db_column_name=>'SCOPE_OF_WORK'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Scope of Work'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69719387912128759)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69719462212128760)
,p_db_column_name=>'CORRECTIVE_ACTION'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Corrective Action'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69719594504128761)
,p_db_column_name=>'EMPLOYEE_NUMBER'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'Employee Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(69719716368128762)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(69741746944139300)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'987272'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NUMBER:REQUEST_DATE:REQUESTED_AMOUNT:SCHEDULE:RECOMMENDED_VENDOR_NUM:RECOMMENDED_VENDOR_NAME:PROJECT_NUMBER:TASK_NUMBER:APPROVAL_STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(85278094598587365)
,p_report_id=>wwv_flow_api.id(69741746944139300)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Completed'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Completed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(85278499295587365)
,p_report_id=>wwv_flow_api.id(69741746944139300)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#A96E17'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(85278898501587364)
,p_report_id=>wwv_flow_api.id(69741746944139300)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Stopped'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Stopped''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66692928315377853)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(66692763499377852)
,p_button_name=>'RESET_REPORT_End_User'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_image_alt=>'Reset'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RR::'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24670903551319157)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(24669399066319160)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Single Source Request'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24668489646319162)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(24649943610319183)
,p_button_name=>'RESET_REPORT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RR::'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(24670017960319158)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(24649943610319183)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24670529828319157)
,p_event_id=>wwv_flow_api.id(24670017960319158)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(24649943610319183)
);
wwv_flow_api.component_end;
end;
/
