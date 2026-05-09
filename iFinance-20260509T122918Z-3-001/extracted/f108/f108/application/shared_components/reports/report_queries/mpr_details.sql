prompt --application/shared_components/reports/report_queries/mpr_details
begin
--   Manifest
--     WEB SERVICE: MPR Details
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(20180171557728585)
,p_name=>'MPR Details'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select m.id',
'      ,m.request_number',
'      ,decode(m.request_type,''S'',''Non-Tendering'',''T'',''Tendering'')               request_type',
'      ,e.full_name_en                                                   Requestor_Name',
'      ,e.department_name                                                Requestor_Department',
'      ,m.requested_amount                                               Requested_amount',
'      ,m.project_number                                                 Project',
'      ,m.task_number                                                    Task',
'      ,m.expenditure_type                                               expenditure_type',
'      ,m.initial_amount                                                 initial_amount',
'      ,m.dct_project_name',
'      ,m.dct_project_description',
'      ,m.submission_date',
'      ,m.pr_number                                                      PR_Number',
'      ,m.deliverable_date',
'      ,v.vendor_name || ''('' || v.vendor_site_code || '')''                  Recommended_vendor_name',
'--      ,m.procurement_method',
'from mpr m , employees_v e , vendors v',
'where m.requestor_person_id = e.person_id',
'and m.recommended_vendor_num = v.vendor_number',
'and m.recommended_vendor_site_code = v.vendor_site_code',
'and m.id = :P2_ID'))
,p_report_layout_id=>wwv_flow_api.id(23365553612334102)
,p_format=>'PDF'
,p_output_file_name=>'MPR Details'
,p_content_disposition=>'INLINE'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(89312033006985576)
,p_shared_query_id=>wwv_flow_api.id(20180171557728585)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select m.id',
'      ,m.request_number',
'      ,m.status                         APPROVAL_STATUS',
'      ,m.cost_center',
'      ,m.fund_available_yn              FUND_AVAILABLE',
'      ,decode(m.request_type,''S'',''Non-Tendering'',''T'',''Tendering'')       request_type',
'      , Case m.mpr_categpry',
'            When 61 Then (select value ',
'                            from DCT_LOOKUP_VALUES',
'                            where lookup_id = 12',
'                            and  value_id = 61)',
'            when 62 Then (select value ',
'                            from DCT_LOOKUP_VALUES',
'                            where lookup_id = 12',
'                            and  value_id = 62)',
'            When 63 Then (select value ',
'                            from DCT_LOOKUP_VALUES',
'                            where lookup_id = 12',
'                            and  value_id = 63)',
'         End                                                            Request_category',
'      ,e.full_name_en                                                   Requestor_Name',
'      ,e.department_name                                                Requestor_Department',
'      ,m.requested_amount                                               Requested_amount',
'      ,m.currency',
'      ,nvl(m.project_number, ''New Project'')                             Project',
'      ,m.task_number                                                    Task',
'      ,m.expenditure_type                                               expenditure_type',
'      ,m.initial_amount                                                 initial_amount',
'      ,m.dct_project_name',
'      ,m.dct_project_description',
'      ,to_char(m.submission_date,''DD-MON-YYYY'')                         submission_date',
'      ,m.pr_number                                                      PR_Number',
'      ,to_char(m.deliverable_date,''DD-MON-YYYY'')                        deliverable_date',
'      ,Case NEW_VENDOR_YN ',
'            When ''Y''    Then RECOMMENDED_VENDOR_NAME',
'            Else v.vendor_name || ''('' || v.vendor_site_code || '')''',
'      End                                                               Recommended_vendor_name',
'--      ,m.procurement_method',
'from mpr m , employees_v e , vendors v',
'where m.requestor_person_id = e.person_id',
'and m.recommended_vendor_num = v.vendor_number (+)',
'and m.recommended_vendor_site_code = v.vendor_site_code (+)',
'and m.id = :P2_PRINT_ID'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(89312230815985576)
,p_shared_query_id=>wwv_flow_api.id(20180171557728585)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  RTRIM(LTRIM(m.PROCUREMENT_METHOD_NAME)) PROCUREMENT_METHOD_NAME',
'from mpr_procurement_methods m , mpr ',
'where mpr.id = :P2_PRINT_ID',
'and m.id in (select t.column_value as ID ',
'                from table(apex_string.split(mpr.PROCUREMENT_METHOD, '':'')) t)'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(89312450730985576)
,p_shared_query_id=>wwv_flow_api.id(20180171557728585)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    likelihood,',
'    likelihood_interpretation   ,',
'    consequence,',
'    consequence_interpretation',
'FROM',
'    mpr_risk_strategy',
'order by seq;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(89312596465985576)
,p_shared_query_id=>wwv_flow_api.id(20180171557728585)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select seq No',
'        ,risk_description',
'        ,likelihood',
'        ,consequence',
'        ,mitigation',
'from mpr_risk_identification_mitigation',
'where mpr_id = :P2_PRINT_ID',
'order by seq'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(89312846391985576)
,p_shared_query_id=>wwv_flow_api.id(20180171557728585)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select h.step_no,',
'      (Select e.full_name_en',
'     from employees_v e',
'     where e.person_id = h.person_id)  person_name,',
'     h.action_required,',
'     h.status,',
'     h.role_desc,',
'      TO_CHAR(h.recevied_date,''DD-MON-YYYY'') recevied_date,',
'    TO_CHAR(action_date,''DD-MON-YYYY'') Action_on',
' --   TO_CHAR(h.recevied_date,''DD-MON-YYYY HH12:MI:SS AM'') recevied_date,',
' --   TO_CHAR(action_date,''DD-MON-YYYY HH12:MI:SS AM'') Action_on',
'FROM mpr_approval_history h',
'where mpr_id = :P2_PRINT_ID',
'and h.status != ''Bateen''',
'order by h.step_no , RECEVIED_DATE  ;'))
);
wwv_flow_api.component_end;
end;
/
