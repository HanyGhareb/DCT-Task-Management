prompt --application/shared_components/reports/report_queries/tac_form_query
begin
--   Manifest
--     WEB SERVICE: TAC_Form_Query
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
 p_id=>wwv_flow_api.id(85215774374001231)
,p_name=>'TAC_Form_Query'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    tf.id,',
'    tf.tac_type,',
'    (select value  ',
'    from DCT_LOOKUP_VALUES ',
'    where lookup_id = 13 ',
'    and value_id=  tf.tac_type )  tac_type_name,',
'    tf.form_number,',
'    tf.meeting_number,',
'--    tf.seq_num,',
'    tf.form_date,',
'    tf.purpose,',
'    (select value  ',
'    from DCT_LOOKUP_VALUES ',
'    where lookup_id = (select l.lookup_id ',
'                        from dct_lookups l ',
'                        where l.lookup_code = ''TACFORMPUR'') ',
'    and value_id = tf.purpose) Purpose_name,',
'    tf.requestor_person_id,',
'    (select e.full_name_en',
'    from employees_v e',
'    where e.person_id = tf.requestor_person_id) requestor_name,',
'    tf.prepared_person_id,',
'    (select e.full_name_en',
'    from employees_v e',
'    where e.person_id = tf.prepared_person_id) prepared_name,',
'    tf.requestor_org_id,',
'    user_details.get_emp_department(tf.requestor_person_id) requestor_department,',
'    user_details.get_emp_sector(tf.requestor_person_id) requestor_sector,',
'    user_details.get_cost_center(tf.requestor_person_id) requestor_cost_center,',
'--    tf.department_id,',
'--    tf.sector_id,   ',
'--    tf.cost_center,',
'--    tf.project_duration,',
'--    tf.duration_uom,',
'--    tf.project_duration_text,',
'    nvl((to_char(tf.project_duration) || '' '' ||tf.duration_uom) , tf.duration_uom   ) project_duration,',
'    tf.tender_no,',
'    tf.project_title,',
'    trim(to_char(tf.estimated_amount,''99,999,999,999,999.99'')) || '' '' || tf.currency  ESTIMATED_AMOUNT,',
'--    tf.currency,',
'--    tf.fund_available,',
'    tf.scope_of_work,',
'    tf.recommendation,',
'    tf.approval_status,',
'    tf.notes,',
'    tf.decision,',
'    tf.exemption_others,',
'    tf.tac_committee_id,',
'    tf.meeting_id,',
'    tf.decision_option,',
'    tf.submission_date,',
'    tf.final_approval,',
'    tf.created_by_person_id,',
'    tf.created_on,',
'    tf.updated_by_person_id,',
'    tf.updated_on,',
'    tf.recommended_vendor_num,',
'    tf.recommended_vendor_site_code,',
'    tf.new_vendor_yn,',
'    tf.recommended_vendor_name,',
'    tf.exchange_rate,',
'    tf.exchange_date',
'FROM',
'    tac_form tf',
'where tf.id = nvl(:FORM_ID , :P12_ID)    ;'))
,p_xml_structure=>'APEX'
,p_report_layout_id=>wwv_flow_api.id(85217829884644938)
,p_format=>'PDF'
,p_output_file_name=>'TAC_Form_Query'
,p_content_disposition=>'INLINE'
,p_xml_items=>'P12_ID'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(85239052837408514)
,p_shared_query_id=>wwv_flow_api.id(85215774374001231)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    tf.id,',
'    tf.tac_type,',
'    (select value  ',
'    from DCT_LOOKUP_VALUES ',
'    where lookup_id = 13 ',
'    and value_id=  tf.tac_type )  tac_type_name,',
'    tf.form_number,',
'    tf.meeting_number,',
'--    tf.seq_num,',
'    tf.form_date,',
'    tf.purpose,',
'    (select value  ',
'    from DCT_LOOKUP_VALUES ',
'    where lookup_id = (select l.lookup_id ',
'                        from dct_lookups l ',
'                        where l.lookup_code = ''TACFORMPUR'') ',
'    and value_id = tf.purpose) Purpose_name,',
'    tf.requestor_person_id,',
'    (select e.full_name_en',
'    from employees_v e',
'    where e.person_id = tf.requestor_person_id) requestor_name,',
'    tf.prepared_person_id,',
'    (select e.full_name_en',
'    from employees_v e',
'    where e.person_id = tf.prepared_person_id) prepared_name,',
'    tf.requestor_org_id,',
'    user_details.get_emp_department(tf.requestor_person_id) requestor_department,',
'    user_details.get_emp_sector(tf.requestor_person_id) requestor_sector,',
'    user_details.get_cost_center(tf.requestor_person_id) requestor_cost_center,',
'--    tf.department_id,',
'--    tf.sector_id,   ',
'--    tf.cost_center,',
'--    tf.project_duration,',
'--    tf.duration_uom,',
'--    tf.project_duration_text,',
'    nvl((to_char(tf.project_duration) || '' '' ||tf.duration_uom) , tf.duration_uom   ) project_duration,',
'    tf.tender_no,',
'    tf.project_title,',
'    trim(to_char(tf.estimated_amount,''99,999,999,999,999.99'')) || '' '' || tf.currency  ESTIMATED_AMOUNT,',
'--    tf.currency,',
'--    tf.fund_available,',
'    tf.scope_of_work,',
'    tf.recommendation,',
'    tf.approval_status,',
'    tf.notes,',
'    tf.decision,',
'    tf.exemption_others,',
'    tf.tac_committee_id,',
'    tf.meeting_id,',
'    tf.decision_option,',
'    tf.submission_date,',
'    tf.final_approval,',
'    tf.created_by_person_id,',
'    tf.created_on,',
'    tf.updated_by_person_id,',
'    tf.updated_on,',
'    tf.recommended_vendor_num,',
'    tf.recommended_vendor_site_code,',
'    tf.new_vendor_yn,',
'    tf.recommended_vendor_name,',
'    tf.exchange_rate,',
'    tf.exchange_date',
'FROM',
'    tac_form tf',
'where tf.id = nvl(:FORM_ID , :P12_ID)    ;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(85239310478408514)
,p_shared_query_id=>wwv_flow_api.id(85215774374001231)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'--    id,',
'--    request_id,',
'    step_no,',
'--    person_id,',
'    (SELECT initcap(e.full_name_en)',
'     FROM employees_v e',
'     WHERE e.person_id = h.person_id)    full_name,',
'    NVL((SELECT r.role_name',
'     FROM roles r',
'     WHERE r.role_id = h.role_id),',
'     ROLE_DESC)                             role_name,',
'    action_required,',
'    to_char(recevied_date, ''DD-Mon-YYYY'')       recevied_date,',
'    status,',
'    to_char(action_date, ''DD-Mon-YYYY HH:MI'')         action_date,',
'    comments',
'--    CASE',
'--        WHEN dbms_lob.getlength(( SELECT  s.signature_blob',
'--                                    FROM dct_employees_signatures s',
'--                                    WHERE s.person_id = h.person_id',
'--                                    AND s.status = ''Y''',
'--                                )) > 0 ',
'--            THEN',
'--                (SELECT  s.signature_clob',
'--                  FROM dct_employees_signatures s',
'--                  WHERE  s.person_id = h.person_id',
'--                  AND s.status = ''Y'')',
'--    END                                        AS signature',
'FROM',
'    tac_form_approval_history h',
'WHERE',
'        h.tac_form_id = nvl(:FORM_ID , :P12_ID) ',
'    AND status NOT IN ( ''Bateen'' )',
'order by step_no'))
);
wwv_flow_api.component_end;
end;
/
