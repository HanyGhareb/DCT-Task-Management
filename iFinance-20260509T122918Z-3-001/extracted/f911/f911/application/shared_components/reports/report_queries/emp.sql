prompt --application/shared_components/reports/report_queries/emp
begin
--   Manifest
--     WEB SERVICE: Emp
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(34469343217713218)
,p_name=>'Emp'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select ''Hiba and Hany'' as EMP_NAME',
'from dual'))
,p_format=>'XML'
,p_output_file_name=>'Emp'
,p_content_disposition=>'ATTACHMENT'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(34469630539710565)
,p_shared_query_id=>wwv_flow_api.id(34469343217713218)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select ''Hiba and Hany'' as EMP_NAME',
'from dual'))
);
wwv_flow_api.component_end;
end;
/
