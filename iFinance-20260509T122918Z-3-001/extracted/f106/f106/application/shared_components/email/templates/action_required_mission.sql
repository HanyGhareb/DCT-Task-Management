prompt --application/shared_components/email/templates/action_required_mission
begin
--   Manifest
--     REPORT LAYOUT: Action Required Mission
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(110392414335609012)
,p_name=>'Action Required Mission'
,p_static_id=>'ACTION_REQUIRED_MISSION'
,p_subject=>'#SUBJECT#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <span style="color: #008000;"><strong>#APPROVER_TITLE# <em>#APPROVER_NAME#,</em></strong></span></p>',
'<p>your kind attention is required for below <strong><span style="color: #008000;">#REQUEST_TYPE#</span></strong> Request <span style="color: #008000;"><strong>#REQUEST_NO#</strong></span> from<span style="color: #008000;"><strong> #REQUESTOR#.</stro'
||'ng></span></p>',
'<p>Comment: <span style="color: #ff0000;">#COMMENT#</span></p>',
'<table style="height: 244px; width: 100%; border-collapse: collapse; border-style: none;">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Request No</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #REQUEST_NO#</td>',
'</tr>',
'<tr style="height: 66px;">',
'<td style="width: 29.0511%; height: 10px;"><strong>Request Type</strong></td>',
'<td style="width: 70.9489%; height: 10px;">: #REQUEST_TYPE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Request Date</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #REQUEST_DATE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Employee Number</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #EMPLOYEE_NUMBER#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Grade</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #GARDE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Grade Rate</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #GARDE_RATE# <strong>AED</strong></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Start Date</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #START_DATE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>End Date</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #END_DATE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Mission Days</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #MISSION_DAYS#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Additional Days</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #ADDITIONAL_DAYS#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Eligible PCT</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #ELIGIBLE_PCT# <strong>%</strong></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Amount</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #AMOUNT# AED</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Justification</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #JUSTIFICATION#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Priority</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #PRIORITY#</td>',
'</tr>',
'</tbody>',
'</table>',
'<h3>&nbsp;</h3>',
'<p>please check attached for the full details.</p>',
'<p><span style="color: #000000;">Please click on one of the following choices to automatically generate an E-mail response. Don''t change anything with the generated E-mail. optionally, you can add your comment at the mail end.</span></p>',
'<table style="height: 30px; width: 65.1653%; border-collapse: collapse; border-style: none; float: left;">',
'<tbody>',
'<tr style="height: 25px;">',
'<td style="width: 0.956938%; height: 25px; border-style: none; text-align: left;">#APPROVE_LINK!RAW#</td>',
'<td style="width: 0.956938%; border-style: none; text-align: right;">&nbsp;</td>',
'<td style="width: 20.0876%; height: 25px; border-style: none; text-align: center;">#REJECT_LINK!RAW#</td>',
'<td style="width: 1.17786%; border-style: none; text-align: center;">#DELEGATE_LINK!RAW#</td>',
'<td style="width: 17.9757%; border-style: none; text-align: center;">#RETURN_LINK!RAW#</td>',
'</tr>',
'</tbody>',
'</table>',
'<p>&nbsp;</p>',
'<table border="0" align="center">',
'<tbody>',
'<tr>',
'<td style="padding: 16px 24px; border-radius: 4px; min-width: 200px;" align="center" bgcolor="#0e6654"><a style="font-size: 16px; line-height: 16px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inline-block; padding: 16px 24px;"'
||' href="#APPLICATION_LINK#" target="_blank" rel="nofollow"> Access i-Finance </a></td>',
'</tr>',
'</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color: white;">',
'<h1><em>i-finance </em></h1>',
'<h2>Duty Hub</h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #f5f5f5; text-align: left; color: black;">',
'<h4>Best Regards</h4>',
'<h5><em>MIS Team</em>,</h5>',
'APDT001',
'</div>'))
,p_comment=>'APDT001'
);
wwv_flow_api.component_end;
end;
/
