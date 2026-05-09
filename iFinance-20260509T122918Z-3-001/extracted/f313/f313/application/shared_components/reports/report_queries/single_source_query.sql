prompt --application/shared_components/reports/report_queries/single_source_query
begin
--   Manifest
--     WEB SERVICE: Single Source Query
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(65308986032796947)
,p_name=>'Single Source Query'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    sss.REQUEST_NUMBER                                          FORM_NUMBER,',
'    FINAL_APPROVAL                                              EFFECTIVE_DATE,',
'    ',
'    (SELECT e.FULL_NAME_EN',
'     FROM employees_v e',
'     where e.person_id = sss.requestor_person_id)               end_user,',
'     sss.REQUEST_DATE                                           request_date,',
'    (select d.ORG_NAME',
'    from organizations_v d',
'    where d.org_id = sss.department_id)                         department_name,',
'    sss.PR_NUMBER                                               PR_NUMBER,',
'    ',
'    -- project Info',
'    sss.project_name                                            PROJECT_NAME,',
'    trim(to_char(sss.REQUESTED_AMOUNT, ''99,999,999,999.99''))    Budget_estimate,',
'    sss.schedule                                                schedule,',
'    decode(NEW_VENDOR_YN,''Y'', RECOMMENDED_VENDOR_NAME',
'                        ,''N'', v.vendor_name || ',
'                        ''(''||',
'                        v.vendor_number',
'                        ||'') - ''|| v.vendor_site_code)                    Supplier_name,',
'    sss.QUOTATION_REFERENCE                                     QUOTATION_REFERENCE,',
'    ',
'    --3 Budget Details',
'    sss.project_number                                          project_number,',
'    sss.task_number                                             task_number,',
'    sss.expenditure_type                                        expenditure_type,',
'    ',
'    --4 Exemption Types',
'    ',
'    --5 Scope of Work',
'    sss.scope_of_work                                       scope_of_work,',
'    ',
'    --6 Justification',
'    sss.justification                                      justification,',
'    ',
'    --7 Corrective Action',
'    sss.corrective_action                                  corrective_action,',
'    ',
'    --8 Declaration',
'    (select Declaration',
'        from scm_settings',
'        where sysdate between nvl(start_date , sysdate - 10) ',
'            and nvl(end_date , sysdate + 10)',
'            and rownum = 1)                                 Declaration,',
'',
'    id    ',
'    ',
'FROM',
'    scm_singl_source sss, vendors v',
'where sss.recommended_vendor_num = v.vendor_number (+)',
'and sss.recommended_vendor_site_code =  v.vendor_site_code (+)',
'and sss.id = 32;'))
,p_report_layout_id=>wwv_flow_api.id(65602891341786229)
,p_format=>'PDF'
,p_output_file_name=>'Single Source Query'
,p_content_disposition=>'INLINE'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(65622365478880995)
,p_shared_query_id=>wwv_flow_api.id(65308986032796947)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    sss.REQUEST_NUMBER                                          FORM_NUMBER,',
'    FINAL_APPROVAL                                              EFFECTIVE_DATE,',
'    ',
'    (SELECT e.FULL_NAME_EN',
'     FROM employees_v e',
'     where e.person_id = sss.requestor_person_id)               end_user,',
'     to_char(sss.REQUEST_DATE, ''DD-MON-YYYY'')                   request_date,',
'    (select d.ORG_NAME',
'    from organizations_v d',
'    where d.org_id = sss.department_id)                         department_name,',
'    sss.PR_NUMBER                                               PR_NUMBER,',
'    ',
'    -- project Info',
'    sss.project_name                                            PROJECT_NAME,',
'    trim(to_char(sss.REQUESTED_AMOUNT, ''99,999,999,999.99'')) ',
'    || '' AED''                                                  Budget_estimate,',
'    to_char(sss.schedule, ''DD-MON-YYYY'')                        schedule,',
'    decode(NEW_VENDOR_YN,''Y'', RECOMMENDED_VENDOR_NAME',
'                        ,''N'', v.vendor_name || ',
'                        ''(''||',
'                        v.vendor_number',
'                        ||'') - ''|| v.vendor_site_code)                    Supplier_name,',
'    sss.QUOTATION_REFERENCE                                     QUOTATION_REFERENCE,',
'    ',
'    --3 Budget Details',
'    sss.project_number                                          project_number,',
'    sss.task_number                                             task_number,',
'    sss.expenditure_type                                        expenditure_type,',
'    ',
'    --4 Exemption Types',
'    ''Y''                                                 Exemption_types,',
'    --5 Scope of Work',
'    sss.scope_of_work                                       scope_of_work,',
'    ',
'    --6 Justification',
'    sss.justification                                      justification,',
'    ',
'    --7 Corrective Action',
'    sss.corrective_action                                  corrective_action,',
'    ',
'    --8 Declaration',
'    (select Declaration',
'        from scm_settings',
'        where sysdate between nvl(start_date , sysdate - 10) ',
'            and nvl(end_date , sysdate + 10)',
'            and rownum = 1)                                 Declaration,',
'    (select  XMLElement("DECLARATION2", XMLCDATA(Declaration_html))',
'        from scm_settings',
'        where sysdate between nvl(start_date , sysdate - 10) ',
'            and nvl(end_date , sysdate + 10)',
'            and rownum = 1)                                 Declaration2,        ',
'',
'    id    ',
'    ',
'FROM    scm_singl_source sss, vendors v',
'where sss.recommended_vendor_num = v.vendor_number (+)',
'and sss.recommended_vendor_site_code =  v.vendor_site_code (+)',
'and sss.id = :P2_SINGLE_SOURCE_ID;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(65622590704880996)
,p_shared_query_id=>wwv_flow_api.id(65308986032796947)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select et.EXEMPTION_TYPES_NAME, et.EXEMPTION_TYPE,',
'    case when et.id in (select * ',
'                        from apex_string.split(ss.exemption_type , '':''))',
'            Then    ''Y''',
'        else',
'            ''N''',
'    End checked',
'from',
'( select   s.exemption_types_name || '': '' exemption_types_name,',
'        s.exemption_types_desc   as exemption_type',
'        ,s.id as ID',
' from scm_single_source_exemption_types s ',
' where s.status = ''A''',
' and sysdate BETWEEN nvl(s.start_date, sysdate -10) and nvl(s.end_date , sysdate + 10)) et, scm_singl_source ss',
' where ss.id = :P2_SINGLE_SOURCE_ID;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(65622829334880996)
,p_shared_query_id=>wwv_flow_api.id(65308986032796947)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Approval History',
'SELECT',
'--    h.id,',
'--    h.singl_source_id,',
'    h.step_no,',
'--    h.person_id,',
'--    h.role_id,',
'    h.role_desc,',
'    h.action_required,',
'    to_char(h.recevied_date,''DD-MON-YYYY HH:MM:SS AM'') recevied_date,',
'    h.status,',
'    to_char(h.action_date,''DD-MON-YYYY HH:MM:SS AM'')    action_date,',
'    h."COMMENT",',
'--    h.approval_type,',
'--    h.created_by_person_id,',
'--    h.created_on,',
'--    h.updated_by_person_id,',
'--    h.updated_on,',
'   e.full_name_en,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'FROM',
'    scm_singl_source_approval_history h, dct_employees_list2  e',
'  where h.person_id = e.person_id (+)',
'  and h.singl_source_id = :P2_SINGLE_SOURCE_ID',
'order by h.STEP_NO , h.ID;'))
);
wwv_flow_api.component_end;
end;
/
