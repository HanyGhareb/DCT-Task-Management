prompt --application/pages/page_00016
begin
--   Manifest
--     PAGE: 00016
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
 p_id=>16
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'Pending PRs Reminder'
,p_alias=>'PENDING-PRS-REMINDER'
,p_step_title=>'Pending PRs Reminder'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20211220105207'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5100496245850267)
,p_plug_name=>'Note'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4794614814002898)
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
 p_id=>wwv_flow_api.id(4793978622002898)
,p_plug_name=>'Pending PRs Reminder'
,p_region_name=>'USERS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19192662303383345)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'SCM_PENDING_PR'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Pending PRs Reminder'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(4793883200002898)
,p_name=>'Pending PRs Reminder'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>47518438298719692
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4793475279002893)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_allow_hide=>'N'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4793119956002893)
,p_db_column_name=>'PR_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'PR Number'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4792667145002892)
,p_db_column_name=>'REQUESTER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Requester'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4792305269002892)
,p_db_column_name=>'CHARGE_ACCOUNT'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Charge Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4791841642002892)
,p_db_column_name=>'AMOUNT'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Amount'
,p_allow_hide=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4791431392002892)
,p_db_column_name=>'PR_DATE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'PR Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4791047356002892)
,p_db_column_name=>'EMAIL'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Email'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4790713184002892)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4790263140002891)
,p_db_column_name=>'STATUS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Email Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4789891947002891)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(19496453621420111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4789512337002891)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(19496453621420111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4789052970002891)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4788681074002891)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5099256398850255)
,p_db_column_name=>'PO_NUMBER'
,p_display_order=>23
,p_column_identifier=>'N'
,p_column_label=>'Po Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5099215473850254)
,p_db_column_name=>'PO_DATE'
,p_display_order=>33
,p_column_identifier=>'O'
,p_column_label=>'Po Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5099074742850253)
,p_db_column_name=>'PR_STATUS'
,p_display_order=>43
,p_column_identifier=>'P'
,p_column_label=>'PR Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5098974861850252)
,p_db_column_name=>'PO_STATUS'
,p_display_order=>53
,p_column_identifier=>'Q'
,p_column_label=>'PO Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5098823557850251)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>63
,p_column_identifier=>'R'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5098773304850250)
,p_db_column_name=>'PROJECT'
,p_display_order=>73
,p_column_identifier=>'S'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5098636796850249)
,p_db_column_name=>'TASK'
,p_display_order=>83
,p_column_identifier=>'T'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5098556095850248)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>93
,p_column_identifier=>'U'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(4779569911837367)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'475328'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'PR_NUMBER:PR_DATE:REQUESTER:CHARGE_ACCOUNT:AMOUNT:EMAIL:COST_CENTER:STATUS:DESCRIPTION:UPDATED_BY:UPDATED_DATE:ID:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5101452289850277)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(4794614814002898)
,p_button_name=>'Validate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Validate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5100895139850271)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(4794614814002898)
,p_button_name=>'Send_Reminder'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Send Reminder'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5099393949850256)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(4794614814002898)
,p_button_name=>'Upload'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Upload'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:17::'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5098481924850247)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(4794614814002898)
,p_button_name=>'Clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Clear'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5100373827850266)
,p_name=>'P16_NOTE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5100496245850267)
,p_prompt=>'Note'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5101352032850276)
,p_name=>'Validate DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(5101452289850277)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5101294502850275)
,p_event_id=>wwv_flow_api.id(5101352032850276)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Fetch the cost center and requesters mails?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5101197318850274)
,p_event_id=>wwv_flow_api.id(5101352032850276)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update scm_pending_pr pr',
'set pr.cost_center = SUBSTRB(pr.charge_account,5,7)',
', status = ''New''',
', pr.email = (select e.email from employees_v e where e.full_name_en = pr.requester and rownum = 1);',
''))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5101112860850273)
,p_event_id=>wwv_flow_api.id(5101352032850276)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Fetched Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5100933648850272)
,p_event_id=>wwv_flow_api.id(5101352032850276)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(4793978622002898)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5100784331850270)
,p_name=>'Remider DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(5100895139850271)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5100626897850269)
,p_event_id=>wwv_flow_api.id(5100784331850270)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to send reminder email for all requesters in this table?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5100537687850268)
,p_event_id=>wwv_flow_api.id(5100784331850270)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'    l_context          apex_exec.t_context;    ',
'    l_id               pls_integer;',
'    l_emailsidx        pls_integer;',
'    l_namesids         pls_integer;',
'    l_prs               pls_integer;',
'    l_pr_date          pls_integer;',
'    l_Amount           pls_integer;',
'    l_desc             pls_integer;',
'    l_region_id        number;',
'    l_email_id          Number;',
'',
'begin',
'    -- Get the region id for the CUSTOMERS IR region',
'    select region_id',
'      into l_region_id',
'      from apex_application_page_regions',
'     where application_id = :APP_ID',
'       and page_id        = 16',
'       and static_id      = ''USERS'';',
' ',
'    -- Get the query context for the CUSTOMERS IR Region',
'    -- Documentation: https://docs.oracle.com/en/database/oracle/application-express/19.2/aeapi/OPEN_QUERY_CONTEXT-Function.html',
'    l_context := apex_region.open_query_context (',
'                        p_page_id => 16,',
'                        p_region_id => l_region_id );',
'    -- Get the column positions for EMAIL and NAME columns',
'    l_id        := apex_exec.get_column_position( l_context, ''ID'' );',
'    l_emailsidx := apex_exec.get_column_position( l_context, ''EMAIL'' );',
'    l_namesids := apex_exec.get_column_position( l_context, ''REQUESTER'' );',
'    l_pr_date := apex_exec.get_column_position( l_context, ''PR_DATE'' );',
'    l_prs := apex_exec.get_column_position( l_context, ''PR_NUMBER'' );',
'    l_Amount := apex_exec.get_column_position( l_context, ''AMOUNT'' );',
'    l_desc   := apex_exec.get_column_position( l_context, ''DESCRIPTION'' );',
'    ',
'    -- Loop throught the query of the context',
'    while apex_exec.next_row( l_context ) loop  ',
'    ',
'    ',
'        l_email_id :=  apex_mail.send (',
'        p_from               => ''ifinance@dctabudhabi.ae'' ,   ',
'        p_to                 => apex_exec.get_varchar2( l_context, l_emailsidx ),',
'      --  p_cc                 => ''APInquiry@dctabudhabi.ae'',',
'        p_cc                 => ''fbp@dctabudhabi.ae,CSekhar@dctabudhabi.ae,ifinance@dctabudhabi.ae,fprf-section@dctabudhabi.ae'',',
' --       p_cc                 => ''ifinance@dctabudhabi.ae,hghareb@dctabudhabi.ae'',         ',
'        p_template_static_id => ''PENDING_STANDARD_PR_REMINDER'',',
'        p_placeholders       => ''{'' ||',
'        ''    "PR_NUMBER":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_prs )) ||    ',
'        ''   , "REQUESTER":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_namesids )) ||',
'        ''   , "DESC":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_desc )) ||    ',
'        ''   , "PR_DATE":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_pr_date )) ||',
'        ''   , "AMOUNT":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_Amount )) ||',
'        ''   ,"NOTES":''               || apex_json.stringify( :P16_NOTE ) ||    ',
'        ''}'' );',
'        ',
'        ',
'    --***************      ',
'        FOR c1 IN (SELECT FILENAME, FILE_BLOB, FILE_MIMETYPE ',
'                    FROM SCM_PENDING_GRN_DOCUMENTS',
'                    where type = ''PR''',
'                   ) LOOP',
'            ',
'                    APEX_MAIL.ADD_ATTACHMENT(',
'                        p_mail_id    => l_email_id,',
'                        p_attachment => c1.FILE_BLOB,',
'                        p_filename   => c1.FILENAME,',
'                        p_mime_type  => c1.FILE_MIMETYPE);',
'                    END LOOP;',
'             COMMIT;',
'        ',
' --*****************              ',
'        ',
'        update scm_pending_pr pr',
'        set pr.status = ''Sent''',
'        where id = apex_json.stringify( apex_exec.get_number( l_context, l_id ));',
'     end loop;',
' ',
'     apex_exec.close( l_context );',
'     apex_mail.push_queue;',
'exception',
'     when others then',
'         apex_exec.close( l_context );',
'     raise; ',
'end;'))
,p_attribute_02=>'P16_NOTE'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5100145590850264)
,p_event_id=>wwv_flow_api.id(5100784331850270)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(4793978622002898)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5100292318850265)
,p_event_id=>wwv_flow_api.id(5100784331850270)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Sent Successfully'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5098420626850246)
,p_name=>'Clear DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(5098481924850247)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5098286552850245)
,p_event_id=>wwv_flow_api.id(5098420626850246)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Delete all Pending PRs records?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5098205938850244)
,p_event_id=>wwv_flow_api.id(5098420626850246)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'delete from scm_pending_pr;',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5097964259850242)
,p_event_id=>wwv_flow_api.id(5098420626850246)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'All Pending PRs deleted Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5098050368850243)
,p_event_id=>wwv_flow_api.id(5098420626850246)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(4793978622002898)
);
wwv_flow_api.component_end;
end;
/
