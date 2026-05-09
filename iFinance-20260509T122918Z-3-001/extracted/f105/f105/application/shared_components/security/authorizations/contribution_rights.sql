prompt --application/shared_components/security/authorizations/contribution_rights
begin
--   Manifest
--     SECURITY SCHEME: Contribution Rights
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_security_scheme(
 p_id=>wwv_flow_api.id(99846473738410815)
,p_name=>'Contribution Rights'
,p_scheme_type=>'NATIVE_EXISTS'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 --nvl(count(*) , 0)',
'from cost_centers_fbp',
'where status = ''A''',
'and sysdate between nvl(start_date ,sysdate - 10) ',
'            and nvl(end_date , sysdate + 10)',
'and BP_TYPE =  ''FBP''',
'and cost_center = :P101_COST_CENTER',
'and person_id = :PERSON_ID'))
,p_error_message=>'Only your Finance Business Partner can remove record.'
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
wwv_flow_api.component_end;
end;
/
