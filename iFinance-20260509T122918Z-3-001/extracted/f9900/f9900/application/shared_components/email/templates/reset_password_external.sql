prompt --application/shared_components/email/templates/reset_password_external
begin
--   Manifest
--     REPORT LAYOUT: RESET PASSWORD EXTERNAL
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>910
,p_default_id_offset=>82649548957193263
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(8325078899745579)
,p_name=>'RESET PASSWORD EXTERNAL'
,p_static_id=>'RESET_PASSWORD_EXTERNAL'
,p_subject=>'Reset Password'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<b>Hello #TITLE# #EMP_NAME#,</b><br>',
'<br>',
'<b>you are reset your account in <span style="color: #0e6654;"><i>i-Finance System</i></span> </b><br>',
'you can <a href="#APPLICATION_LINK#">Login From Here</a>.<br><br>',
'',
'<p>Here is your account Details:</p>',
'<b>your user Name         : <span style="color: red;">#USER_NAME#</span> </b><br>',
'<b>your Temporary Password: <span style="color: red;">#PASSWORD#</span> </b><br>',
'',
'',
'<br>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; text-align: center; color:white"> ',
'    <h2><i>i-finance </i></h2>',
'    <h1>Reset Password </h1>',
'',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #F5F5F5; text-align: left; color:black"> ',
'<h4>Best Regards</h4>',
'<h5><i>MIS Team</i>,</h5>',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
