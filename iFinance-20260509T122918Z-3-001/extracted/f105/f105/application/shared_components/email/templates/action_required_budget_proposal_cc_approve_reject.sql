prompt --application/shared_components/email/templates/action_required_budget_proposal_cc_approve_reject
begin
--   Manifest
--     REPORT LAYOUT: Action Required Budget Proposal CC Approve Reject
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
 p_id=>wwv_flow_api.id(43499968072600156)
,p_name=>'Action Required Budget Proposal CC Approve Reject'
,p_static_id=>'ACTION_REQUIRED_BUDGET_PROPOSAL_CC_APPROVE_REJECT'
,p_subject=>'#SUBJECT#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <strong><span style="color:#000000"><em>#APPROVER_TITLE# #APPROVER_NAME#,</em></span></strong></p>',
'',
'<p><span style="color:#000000"><em>Greating From Finance Department.</em></span></p>',
'',
'<p>your kind attention is required for&nbsp;<span style="color:#000000"><em><strong>#Plan_name#</strong></em></span></p>',
'',
'<p>Here is the plan summary for your reference:</p>',
'',
'<p><strong>Cost Center Code: </strong><em>#COST_CENTER#</em></p>',
'',
'<p><strong>Cost Center Name: </strong><em>#COST_CENTER_NAME#</em></p>',
'',
'<table border="1" cellspacing="0" style="border-collapse:collapse; height:71px; width:100%">',
'	<tbody>',
'		<tr>',
'			<td style="height:18px; width:20.9498%">&nbsp;</td>',
'			<th style="background-color: rgb(255, 127, 80); height: 18px; text-align: center; width: 34.5983%;"><strong>Opex</strong></th>',
'			<th style="background-color: rgb(255, 127, 80); height: 18px; text-align: center; width: 44.4518%;"><strong>Capex</strong></th>',
'		</tr>',
'		<tr>',
'			<td style="background-color:#ff7f50; height:25px; width:20.9498%"><strong>Ceiling</strong></td>',
'			<td style="height:25px; text-align:right; width:34.5983%">#CEILING_CH2# <strong>AED</strong></td>',
'			<td style="height:25px; text-align:right; width:44.4518%">#CEILING_CH3# <strong>AED</strong></td>',
'		</tr>',
'		<tr>',
'			<td style="background-color:#ff7f50; height:28px; width:20.9498%"><strong>Allocated</strong></td>',
'			<td style="height:28px; text-align:right; width:34.5983%">#ALLOCATE_CH2# <strong>AED</strong></td>',
'			<td style="height:28px; text-align:right; width:44.4518%">#ALLOCATE_CH3# <strong>AED</strong></td>',
'		</tr>',
'	</tbody>',
'</table>',
'',
'<p>&nbsp;</p>',
'',
'<p><em>#CC_INSTRUCTIONS#</em></p>',
'',
'<p><em>#COMMENTS#</em></p>',
'',
'<p>&nbsp;</p>',
'',
'<p><span style="color:#000000">Please click on one of the following choices to automatically generate an E-mail response. Don&#39;t change anything with the generated E-mail. optionally, you can add your comment at the mail end.</span></p>',
'',
'<table cellspacing="0" style="border-collapse:collapse; border-style:none; float:left; height:30px; width:65.1653%">',
'	<tbody>',
'		<tr>',
'			<td style="border-style:none; height:25px; text-align:left; width:0.956938%">#APPROVE_LINK!RAW#</td>',
'			<td style="border-style:none; height:25px; text-align:right; width:0.956938%">&nbsp;</td>',
'			<td style="border-style:none; height:25px; text-align:center; width:20.0876%">#REJECT_LINK!RAW#</td>',
'			<td style="border-style:none; height:25px; text-align:center; width:1.17786%">#DELEGATE_LINK!RAW#</td>',
'			<td style="border-style:none; height:25px; text-align:center; width:17.9757%">#RETURN_LINK!RAW#</td>',
'		</tr>',
'	</tbody>',
'</table>',
'',
'<p>&nbsp;</p>',
'',
'<table align="center" border="0">',
'	<tbody>',
'		<tr>',
'			<td style="border-radius:4px"><a href="#APPLICATION_LINK#" rel="nofollow" style="font-size: 16px; line-height: 16px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inline-block; padding: 16px 24px;" target="_blank">Access i-Fin'
||'ance </a></td>',
'		</tr>',
'	</tbody>',
'</table>',
''))
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
'BP002'))
);
wwv_flow_api.component_end;
end;
/
