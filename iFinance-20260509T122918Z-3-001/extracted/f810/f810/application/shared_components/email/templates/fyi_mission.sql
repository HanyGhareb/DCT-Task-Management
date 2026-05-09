prompt --application/shared_components/email/templates/fyi_mission
begin
--   Manifest
--     REPORT LAYOUT: FYI Mission
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
 p_id=>wwv_flow_api.id(109325478687130929)
,p_name=>'FYI Mission'
,p_static_id=>'FYI_MISSION'
,p_subject=>'FYI - #REQUEST_TYPE# for #EMP_NAME#, Amount: #AMOUNT#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p style="display: none;"><code>iFinanceCode</code></p>',
'<p>Dear <span style="color: #008000;"><strong>#APPROVER_TITLE# <em>#APPROVER_NAME#,</em></strong></span></p>',
'<p>your kind attention are required for #REQUEST_TYPE# Request <em><strong>#REQUEST_NO#</strong></em> to&nbsp; <em><strong>#EMP_NAME#</strong></em></p>',
'<table style="height: 123px; width: 100%; border-collapse: collapse; border-style: none;">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Request No</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #REQUEST_NO#</td>',
'</tr>',
'<tr style="height: 66px;">',
'<td style="width: 31.7784%; height: 15px;"><strong>Request Type</strong></td>',
'<td style="width: 68.2216%; height: 15px;">: #REQUEST_TYPE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Country/City</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #COUNTRY#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>DATE</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #REQUEST_DATE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Amount</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #AMOUNT# AED</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Justification</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #JUSTIFICATION#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Cost Center</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #COST_CENTER#</td>',
'</tr>',
'</tbody>',
'</table>',
'<p>&nbsp;</p>',
'<p>please check attached for the full details.</p>',
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
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Missions and Training Management</h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #f5f5f5; text-align: left; color: black;">',
'<h4>Best Regards</h4>',
'<h5><em>MIS Team</em>,</h5>',
'APDT008',
'</div>'))
,p_text_template=>'APDT008'
);
wwv_flow_api.component_end;
end;
/
