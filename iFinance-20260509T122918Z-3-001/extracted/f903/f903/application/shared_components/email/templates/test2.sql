prompt --application/shared_components/email/templates/test2
begin
--   Manifest
--     REPORT LAYOUT: TEST2
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(66953284726227683)
,p_name=>'TEST2'
,p_static_id=>'TEST2'
,p_subject=>'Test'
,p_html_body=>'Nothing     '
,p_html_header=>'Only Test'
);
wwv_flow_api.component_end;
end;
/
