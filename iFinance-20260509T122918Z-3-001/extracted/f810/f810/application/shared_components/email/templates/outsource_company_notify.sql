prompt --application/shared_components/email/templates/outsource_company_notify
begin
--   Manifest
--     REPORT LAYOUT: outsource company notify
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
 p_id=>wwv_flow_api.id(92644860238715135)
,p_name=>'outsource company notify'
,p_static_id=>'OUTSOURCE_COMPANY_NOTIFY'
,p_subject=>'Duty Travel Invoice Required'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear Team<span style="color: #008000;"><strong><em>,</em></strong></span></p>',
'<p>Please procced with the payment and invoice us as per below.</p>',
'<p>your kind attention is required for below <strong><span style="color: #008000;">#REQUEST_TYPE#</span></strong> Request <span style="color: #008000;"><strong>#REQUEST_NO#</strong></span> from<span style="color: #008000;"><strong> #REQUESTOR#.</stro'
||'ng></span></p>',
'<p><span style="color: #ff0000;">#COMMENT#</span></p>',
'<table style="height: 244px; width: 100%; border-collapse: collapse; border-style: none;">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 29.0511%; height: 18px;"><strong>Name</strong></td>',
'<td style="width: 70.9489%; height: 18px;">: #EMP_NAME# - #EMPLOYEE_NUMBER#</td>',
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
'<td style="width: 70.9489%; height: 18px;">: <strong><span style="color: #ff0000;">#AMOUNT# AED</span></strong></td>',
'</tr>',
'</tbody>',
'</table>',
'<p>please check attached for the full details.</p>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Duty Hub</h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #f5f5f5; text-align: left; color: black;">',
'<h4>Best Regards</h4>',
'<h5><em>MIS Team</em>,</h5>',
'APDT008'))
);
wwv_flow_api.component_end;
end;
/
