prompt --application/shared_components/email/templates/duty_hub_invitation
begin
--   Manifest
--     REPORT LAYOUT: Duty Hub Invitation
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(92723824986033378)
,p_name=>'Duty Hub Invitation'
,p_static_id=>'DUTY_HUB_INVITATION'
,p_subject=>'i-Finance: Duty Hub Invitation'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Hello <strong><span style="color: #0e6654;"><em>#TITLE# #EMP_NAME#,</em></span></strong> <br />you are invited to Duty Hub in <span style="color: #0e6654;"><em>i-Finance System</em></span> to manage missions and trainings requests. </p>',
'<p>Here is your i-finance account Details:</p>',
'<table style="font-family: arial, sans-serif; border-collapse: collapse; width: 100%;">',
'<tbody>',
'<tr>',
'<td style="border: 1px solid  #81d0b5; text-align: left; padding: 4px; background-color: #81d0b5; width: 30%; font-size: 14px;">User Name</td>',
'<td style="border: 1px solid #81d0b5; text-align: left; background-color: #81d0b5; padding: 8px;"><span style="color: #0e6654; font-size: 12px;"><em>#USER_NAME#</em></span></td>',
'</tr>',
'<tr>',
'<td style="border: 0px solid #c8f7f1; text-align: left; padding: 4px; background-color: #c8f7f1; width: 20%; font-size: 12px;">Temporary Password</td>',
'<td style="border: 0px solid #c8f7f1; text-align: left; padding: 8px; background-color: #c8f7f1;"><span style="color: #0e6654; font-size: 12px;"><em>#PASSWORD# &nbsp;&nbsp;&nbsp; [you will be asking to change it]</em></span></td>',
'</tr>',
'</tbody>',
'</table>',
'<p><br /><span style="color: #0e6654;"><em>#NOTES!RAW#</em></span></p>',
'<table border="0" align="center">',
'<tbody>',
'<tr>',
'<td style="padding: 16px 24px; border-radius: 4px; min-width: 200px;" align="center" bgcolor="#0e6654"><a style="font-size: 16px; line-height: 16px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inline-block; padding: 16px 24px;"'
||' href="#MY_APPLICATION_LINK#" target="_blank" rel="nofollow"> i-Finance System </a></td>',
'</tr>',
'</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Duty Hub</h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #f5f5f5; text-align: left; color: black;">',
'<h4>Best Regards</h4>',
'<h5><em>MIS Team</em>,</h5>',
'APDT009',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
