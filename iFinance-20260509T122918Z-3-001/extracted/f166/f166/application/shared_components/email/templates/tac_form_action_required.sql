prompt --application/shared_components/email/templates/tac_form_action_required
begin
--   Manifest
--     REPORT LAYOUT: TAC Form Action Required
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(69823617007832989)
,p_name=>'TAC Form Action Required'
,p_static_id=>'TAC_FORM_ACTION_REQUIRED'
,p_subject=>'Action Required- #PURPOSE# Request, Amount: #ESTIMATED_BUDGET# for #REQUESTOR_NAME#.'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <strong><span style="color: #003366;">#APPROVER_TITLE# #APPROVER_NAME#</span></strong>, <br /><br /><br /></p>',
'<table style="height: 426px; width: 120%; border-collapse: collapse;" border="0">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 45.3857%; height: 18px; background-color: #00008b;" colspan="3"><span style="color: #ffffff;"><strong><em>Action Required - #PURPOSE# Approval</em></strong></span></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 45.3857%; height: 18px; background-color: #00008b;" colspan="3"><span style="color: #ffffff;"><em>Request No: <strong>#FORM_NUMBER# , Dated: #FORM_DATE#</strong></em></span></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px;">&nbsp;</td>',
'<td style="width: 34.1599%; height: 18px;">&nbsp;</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px; font-size: 10px;"><strong><em>Requestor:</em></strong></td>',
'<td style="width: 34.1599%; height: 18px; font-size: 10px;">#REQUESTOR_NAME#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px; font-size: 10px;"><strong><em>Sector:</em></strong></td>',
'<td style="width: 34.1599%; height: 18px; font-size: 10px;">#SECTOR#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; height: 18px; font-size: 10px;"><strong><em>Project:</em></strong></td>',
'<td style="width: 34.1599%; height: 18px; font-size: 10px;">#PROJECT_TITLE#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 19px;">',
'<td style="width: 10.5372%; font-size: 10px; height: 19px;"><strong><em>Project Duration:</em></strong></td>',
'<td style="width: 34.1599%; font-size: 10px; height: 19px;">#PROJECT_DURATION#</td>',
'<td style="width: 0.688705%; height: 19px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 22px;">',
'<td style="width: 10.5372%; font-size: 10px; height: 22px;"><strong><em>Estimated Budget:</em></strong></td>',
'<td style="width: 34.1599%; font-size: 10px; height: 22px;">#ESTIMATED_BUDGET#</td>',
'<td style="width: 0.688705%; height: 22px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 24px;">',
'<td style="width: 10.5372%; font-size: 10px; height: 24px;"><strong><em>Tender No:</em></strong></td>',
'<td style="width: 34.1599%; font-size: 10px; height: 24px;">#TENDER_NO#</td>',
'<td style="width: 0.688705%; height: 24px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 10.5372%; font-size: 10px; height: 18px;"><strong><em>Prepared by:</em></strong></td>',
'<td style="width: 34.1599%; font-size: 10px; height: 18px;">#PREPARED_BY#</td>',
'<td style="width: 0.688705%; height: 18px;">&nbsp;</td>',
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
'<th style="width: 45.3857%; background-color: #00008b; font-size: 10px; height: 12px; text-align: center;" colspan="3"><strong><span style="color: #ffffff;"><em>Notes</em></span></strong></th>',
'</tr>',
'<tr style="height: 81px;">',
'<th style="width: 45.3857%; height: 81px; font-size: 10px; text-align: left;" colspan="3" scope="row">#NOTES#</th>',
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
'    <h3>Service: #PURPOSE#</h3>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #F5F5F5; text-align: left; color:black"> ',
'<h4>Best Regards</h4>',
'<h5><i>MIS Team</i>,</h5>',
'</div>'))
,p_comment=>'This template to send Email for Action required for TAC_FORM requests'
);
wwv_flow_api.component_end;
end;
/
