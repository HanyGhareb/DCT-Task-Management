prompt --application/shared_components/email/templates/cwip_payment_external_invitation
begin
--   Manifest
--     REPORT LAYOUT: CWIP Payment External Invitation
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(39977594902629592)
,p_name=>'CWIP Payment External Invitation'
,p_static_id=>'CWIP_PAYMENT_EXTERNAL_INVITATION'
,p_subject=>'i-Finance Invitation: CWIP Payment Management (Stakeholders)'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Hello <strong><span style="color: #120e78;"><em>#TITLE# #EMP_NAME#,</em></span></strong></p>',
'<p><br />you are invited to use CWIP Payment Management Module in <span style="color: #120e78;"><em><strong>i-Finance System</strong></em></span> . <br />Here is your i-finance account Details:</p>',
'<table style="font-family: arial, sans-serif; border-collapse: collapse; width: 100%;">',
'<tbody>',
'<tr>',
'<td style="border: 1px solid  #81d0b5; text-align: left; padding: 4px; background-color: #2b94f0; width: 30%; font-size: 14px;">User Name</td>',
'<td style="border: 1px solid #81d0b5; text-align: left; background-color: #2b94f0; padding: 8px;"><span style="color: #0e6654; font-size: 16px;"><em>#USER_NAME#</em></span></td>',
'</tr>',
'<tr>',
'<td style="border: 0px solid #c8f7f1; text-align: left; padding: 4px; background-color: #88c5fb; width: 20%; font-size: 12px;">Temporary Password</td>',
'<td style="border: 0px solid #c8f7f1; text-align: left; padding: 8px; background-color: #88c5fb;"><span style="color: #0e6654; font-size: 14px;"><em>#PASSWORD# &nbsp;&nbsp;&nbsp; [you will be asking to change it]</em></span></td>',
'</tr>',
'</tbody>',
'</table>',
'<p><br /><span style="color: #0e6654;"><em>#NOTES!RAW#</em></span></p>',
'<p><br /><br /></p>',
'<h2>Need Help ?</h2>',
'<ul>',
'<li><a href="https://ifinance.dct.gov.ae:8004/dct/prod/r/files/static/v19/login.pdf">How to access i-Finance system</a></li>',
'<li><a href="https://ifinance.dct.gov.ae:8004/dct/prod/r/files/static/v19/Create%20New%20MPR.pdf#">How to ...</a></li>',
'</ul>',
'<p>&nbsp;</p>',
'<p>&nbsp;</p>',
'<p style="padding-left: 80px;"><span style="text-decoration: underline; color: #0000ff;"><strong><a style="font-size: 18px; color: #0000ff; text-decoration: underline;" href="https://ifinance.dct.gov.ae:8004/dct/f?p=109:1">Go To i-Finance System</a><'
||'/strong></span></p>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #120E78; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>CWIP Payments</h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #F5F5F5; text-align: left; color:black"> ',
'<h4>Best Regards</h4>',
'<h5><i>MIS Team</i>,</h5>',
'</div>'))
,p_comment=>'CWIP0003'
);
wwv_flow_api.component_end;
end;
/
