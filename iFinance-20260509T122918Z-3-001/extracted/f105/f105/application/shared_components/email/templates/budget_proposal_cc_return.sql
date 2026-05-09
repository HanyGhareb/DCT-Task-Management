prompt --application/shared_components/email/templates/budget_proposal_cc_return
begin
--   Manifest
--     REPORT LAYOUT: Budget Proposal CC Return
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(41233471508921021)
,p_name=>'Budget Proposal CC Return'
,p_static_id=>'BUDGET_PROPOSAL_CC_RETURN'
,p_subject=>'#SUBJECT#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <strong><span style="color: #000000;"><em>#APPROVER_TITLE# #APPROVER_NAME#,</em></span></strong></p>',
'<p>Kindly not that <span style="color: #000000;"><em><strong>#Plan_name# </strong></em>for<em><strong> #COST_CENTER_NAME# (#COST_CENTER#)</strong></em></span></p>',
'<p>returned by <strong><span style="color: #008000;">#SENDER_NAME#&nbsp;</span></strong></p>',
'<p>Comment:<span style="color: #ff0000;"> #COMMENT#</span></p>',
'<p>&nbsp;</p>',
'<table style="border-collapse: collapse; width: 100%; height: 71px;" border="1">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 20.9498%; height: 18px;">&nbsp;</td>',
'<td style="width: 34.5983%; height: 18px; text-align: center; background-color: #ff7f50;"><strong>Opex</strong></td>',
'<td style="width: 44.4518%; height: 18px; text-align: center; background-color: #ff7f50;"><strong>Capex</strong></td>',
'</tr>',
'<tr style="height: 25px;">',
'<td style="width: 20.9498%; height: 25px; background-color: #ff7f50;"><strong>Ceiling</strong></td>',
'<td style="width: 34.5983%; height: 25px; text-align: right;">#CEILING_CH2# <strong>AED</strong></td>',
'<td style="width: 44.4518%; height: 25px; text-align: right;">#CEILING_CH3# <strong>AED</strong></td>',
'</tr>',
'<tr style="height: 28px;">',
'<td style="width: 20.9498%; height: 28px; background-color: #ff7f50;"><strong>Allocated</strong></td>',
'<td style="width: 34.5983%; height: 28px; text-align: right;">#ALLOCATE_CH2# <strong>AED</strong></td>',
'<td style="width: 44.4518%; height: 28px; text-align: right;">#ALLOCATE_CH3# <strong>AED</strong></td>',
'</tr>',
'</tbody>',
'</table>',
'<p>&nbsp;</p>',
'<p><em>#CC_INSTRUCTIONS#</em></p>',
'<p><em>#COMMENTS#</em></p>',
'<p>&nbsp;</p>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #FF7F50; padding: 8px; text-align: center; color:#000005"> ',
'<h1><em>i-finance </em></h1>',
'<h2>Fund Management Module</h2>',
'<p><strong>Budget Proposal Plan</strong></p>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #f5f5f5; text-align: left; color: black;">',
'<h4>Best Regards</h4>',
'<h5><em>MIS Team</em>,</h5>',
'BP003'))
);
wwv_flow_api.component_end;
end;
/
