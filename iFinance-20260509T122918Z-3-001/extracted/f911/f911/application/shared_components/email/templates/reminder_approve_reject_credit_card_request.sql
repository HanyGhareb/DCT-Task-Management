prompt --application/shared_components/email/templates/reminder_approve_reject_credit_card_request
begin
--   Manifest
--     REPORT LAYOUT: Reminder Approve Reject Credit Card Request
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(76112637854028276)
,p_name=>'Reminder Approve Reject Credit Card Request'
,p_static_id=>'REMINDER_APPROVE_REJECT_CREDIT_CARD_REQUEST'
,p_subject=>'Reminder Action Required: Credit Card request for #EMP_NAME# , Amount #AMOUNT# AED'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h1 style="background-color: red; color: white; text-align: center;">Reminder</h1>',
'<p>Hello <strong><span style="color: #0e6654;"><em>#APPROVER_TITL# #APPROVER_EMP_NAME#,</em></span></strong> <br /><br />your kind attention is required for Credit card Request for employee: <span style="color: #0e6654;"><em><strong>#EMP_TITLE# #EMP_'
||'NAME#</strong></em></span> for <span style="color: #0e6654;"><em><strong>#AMOUNT#</strong></em></span> AED. <br /><br /><span style="color: red; font-size: 14px;"> Purpose: </span> <span style="color: #0e6654;"><em> #PURPOSE#</em></span> <br /><span '
||'style="color: red; font-size: 14px;"> Comment: </span> <span style="color: #0e6654;"><em> #COMMENT#</em></span> <br /><br /></p>',
'<table border="0" align="center">',
'<tbody>',
'<tr>',
'<td style="padding: 16px 24px; border-radius: 4px; min-width: 200px;" align="center" bgcolor="#0e6654"><a style="font-size: 16px; line-height: 16px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inline-block; padding: 16px 24px;"'
||' href="#APPLICATION_LINK#" target="_blank" rel="nofollow"> Approve / Reject </a></td>',
'</tr>',
'</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Credit Card Management </h2>',
'</div>    '))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #F5F5F5; text-align: left; color:black"> ',
'<h4>Best Regards</h4>',
'<h5><i>MIS Team</i>,</h5>',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
