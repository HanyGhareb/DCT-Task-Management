prompt --application/shared_components/email/templates/single_source_action_required
begin
--   Manifest
--     REPORT LAYOUT: Single Source Action Required
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(66893297396357304)
,p_name=>'Single Source Action Required'
,p_static_id=>'SINGLE_SOURCE_ACTION_REQUIRED'
,p_subject=>'Action Required- Single Source Req #REQUEST_NUMBER#,Amount: #ESTIMATED_BUDGET# for #REQUESTOR#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <strong><span style="color: #003366;">#APPROVER_TITLE# #APPROVER_NAME#</span></strong>, <br /><br /><br /></p>',
'<table style="height: 556px; width: 120%; border-collapse: collapse;" border="0">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 45.3857%; height: 18px; background-color: #00008b;" colspan="3"><span style="color: #ffffff;"><strong><em>Action Required - Single Source Approval</em></strong></span></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 45.3857%; height: 18px; background-color: #00008b;" colspan="3"><span style="color: #ffffff;"><em>Request No: <strong>#REQUEST_NUMBER#</strong></em></span></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px;">&nbsp;</td>',
'<td style="width: 34.1599%; height: 18px;">&nbsp;</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px; font-size: 10px;"><em>Requestor:</em></td>',
'<td style="width: 34.1599%; height: 18px; font-size: 10px;">#REQUESTOR#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px; font-size: 10px;"><em>Project Name:</em></td>',
'<td style="width: 34.1599%; height: 18px; font-size: 10px;">#PROJECT_NAME#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px; font-size: 10px;"><em>Vendor:</em></td>',
'<td style="width: 34.1599%; height: 18px; font-size: 10px;">#VENDOR_NAME#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr>',
'<td style="width: 10.5372%; font-size: 10px;"><em>Estimated Budget:</em></td>',
'<td style="width: 34.1599%; font-size: 10px;">#ESTIMATED_BUDGET#</td>',
'<td style="width: 0.688705%;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 45.3857%; background-color: #00008b; font-size: 10px; height: 18px; text-align: center;" colspan="3"><strong><span style="color: #ffffff;"><em>Budget</em></span><span style="color: #ffffff;"><em> Details</em></span></strong></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px; font-size: 10px;"><em>Project Number:</em></td>',
'<td style="width: 34.1599%; height: 18px; font-size: 10px;">#PROJECT_NUMBER#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px; font-size: 10px;"><em>Task:</em></td>',
'<td style="width: 34.1599%; height: 18px; font-size: 10px;">#TASK#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px; font-size: 10px;"><em>Expenditure Type:</em></td>',
'<td style="width: 34.1599%; height: 18px; font-size: 10px;">#EXPENDITUR_TYPE#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr>',
'<td style="width: 10.5372%; font-size: 10px;"><em>Cost Center:</em></td>',
'<td style="width: 34.1599%; font-size: 10px;">&nbsp;#COST_CENTER#</td>',
'<td style="width: 0.688705%;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 45.3857%; height: 18px; background-color: #00008b; font-size: 10px; text-align: center;" colspan="3"><em><strong><span style="color: #ffffff;">Excemption types</span></strong></em></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="height: 18px; font-size: 10px; width: 45.3857%;" colspan="3">#EXCEMPTION_TYPES#</td>',
'</tr>',
'<tr style="height: 12px;">',
'<td style="font-size: 10px; height: 12px; width: 45.3857%;" colspan="3">&nbsp;</td>',
'</tr>',
'<tr style="height: 12px;">',
'<td style="font-size: 10px; height: 12px; width: 45.3857%;" colspan="3">&nbsp;</td>',
'</tr>',
'<tr style="height: 12px;">',
'<td style="font-size: 10px; width: 45.3857%; height: 12px; background-color: #00008b; text-align: center;" colspan="3"><span style="color: #ffffff;"><em><strong>Scope of Work</strong></em></span></td>',
'</tr>',
'<tr style="height: 100px;">',
'<th style="width: 45.3857%; font-size: 10px; height: 100px; text-align: left;" colspan="3"><em><br /></em><em> #SCOPE_OF_WORK#</em></th>',
'</tr>',
'<tr style="height: 12px;">',
'<th style="width: 45.3857%; background-color: #00008b; font-size: 10px; height: 12px; text-align: center;" colspan="3"><strong><span style="color: #ffffff;"><em>Justification:</em></span></strong></th>',
'</tr>',
'<tr style="height: 81px;">',
'<th style="width: 45.3857%; height: 81px; font-size: 10px; text-align: left;" colspan="3" scope="row">#JUSTIFICATION#</th>',
'</tr>',
'<tr style="height: 12px;">',
'<th style="width: 45.3857%; background-color: #00008b; font-size: 10px; height: 12px; text-align: center;" colspan="3"><strong><span style="color: #ffffff;"><em>Corrective Plan:</em></span></strong></th>',
'</tr>',
'<tr style="height: 81px;">',
'<th style="width: 45.3857%; height: 81px; font-size: 10px; text-align: left;" colspan="3" scope="row">#CORRECTIVE_PLAN#</th>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px;">Comment:</td>',
'<td style="width: 34.1599%; height: 18px;">#COMMENTS#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'</tbody>',
'</table>',
'<p><span style="color: #008000;"><strong><a style="color: #008000;" title="Approve using OTP without login" href="#DIRECT_APPROVE_LINK#" target="_blank">Approve Using OTP</a></strong></span></p>',
'<p><strong><a title="Approve through i-finance system, you need to login" href="#APPLICATION_LINK#" target="_blank">Approve through i-finance system</a></strong></p>',
'<p><strong><span style="color: #ff0000;"><a style="color: #ff0000;" title="Reject using OTP without login." href="#DIRECT_REJECT_LINK#" target="_blank">Reject through email</a></span></strong></p>',
'<p>&nbsp;</p>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #120E78; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Supply Chain Services</h2>',
'    <h2>Single Source</h2>',
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
