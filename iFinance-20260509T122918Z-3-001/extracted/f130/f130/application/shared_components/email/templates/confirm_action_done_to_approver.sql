prompt --application/shared_components/email/templates/confirm_action_done_to_approver
begin
--   Manifest
--     REPORT LAYOUT: Confirm Action Done to Approver
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
 p_id=>wwv_flow_api.id(53472912833441680)
,p_name=>'Confirm Action Done to Approver'
,p_static_id=>'CONFIRM_ACTION_DONE_TO_APPROVER'
,p_subject=>'FYI- You have  #ACTION# Payment Recommendation #PAYMENT_NUMBER#,IPC: #IPC_NUMBER# for #CONTRACTING_PARTY#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear #APPROVER_TITLE# #APPROVER_NAME#, <br /><br />You have #ACTION# the below payment recommendation:</p>',
'<table style="height: 356px; width: 120%; border-collapse: collapse;" border="0">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 99.9999%; height: 18px; background-color: #8dc0f3;" colspan="5"><strong><em>FYI- Payment </em></strong></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 99.9999%; height: 18px; background-color: #8dc0f3;" colspan="5"><strong><em>Certificate Approval</em></strong></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px;">&nbsp;</td>',
'<td style="width: 28.251%; height: 18px;">&nbsp;</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px;">&nbsp;</td>',
'<td style="width: 40.9877%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Project:</em></td>',
'<td style="width: 28.251%; height: 18px; font-size: 10px;">#PROJECT#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Payment No:</em></td>',
'<td style="width: 40.9877%; height: 18px; font-size: 10px;">#PAYMENT_NUMBER#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Contract Description:</em></td>',
'<td style="width: 28.251%; height: 18px; font-size: 10px;">#CONTRACT_DESCRIPTION#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Contract Ref:</em></td>',
'<td style="width: 40.9877%; height: 18px; font-size: 10px;">#CONTRACT_REFERENCE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Contracting Party:</em></td>',
'<td style="width: 28.251%; height: 18px; font-size: 10px;">#CONTRACTING_PARTY#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Purchase Order:</em></td>',
'<td style="width: 40.9877%; height: 18px; font-size: 10px;">#PURCHASE_ORDER#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Initial Contract Amount:</em></td>',
'<td style="width: 28.251%; height: 18px; font-size: 10px;">#INITIAL_CONTRACT_AMOUNT#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Agreement Duration:</em></td>',
'<td style="width: 40.9877%; height: 18px; font-size: 10px;">#AGREEMENT_DURATION#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Approved Variations:</em></td>',
'<td style="width: 28.251%; height: 18px; font-size: 10px;">#APPROVED_VARIATIONS#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Completion Date:</em></td>',
'<td style="width: 40.9877%; height: 18px; font-size: 10px;">#COMPLETION_DATE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Revised Contract Amount:</em></td>',
'<td style="width: 28.251%; height: 18px; font-size: 10px;">#REVISED_CONTRACT_AMOUNT#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Cumulative Certified to Date:</em></td>',
'<td style="width: 40.9877%; height: 18px; font-size: 10px;">#CUMULATIVE_CERTIFIED_TO_DATE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Payment Type:</em></td>',
'<td style="width: 28.251%; height: 18px; font-size: 10px;">#PAYMENT_TYPE#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Previously Certified:</em></td>',
'<td style="width: 40.9877%; height: 18px; font-size: 10px;">#PREVIOUSLY_CERTIFIED#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Payment Period:</em></td>',
'<td style="width: 28.251%; height: 18px; font-size: 10px;">#PAYMENT_METHOD#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3; font-size: 10px;"><em>Net Payable Amount (excluding VAT):</em></td>',
'<td style="width: 40.9877%; height: 18px; font-size: 10px;">#NET_PAYABLE_AMOUNT_EXCLUDING_VAT#</td>',
'</tr>',
'<tr>',
'<td style="width: 12.3868%; background-color: #8dc0f3; font-size: 10px;">Valuation Date<em><br /></em></td>',
'<td style="width: 28.251%; font-size: 10px;">#VALUATION_DATE#</td>',
'<td style="width: 0.823043%;">&nbsp;</td>',
'<td style="width: 17.5514%; background-color: #8dc0f3; font-size: 10px;"><em>&nbsp;</em></td>',
'<td style="width: 40.9877%; font-size: 10px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 81px;">',
'<td style="width: 12.3868%; height: 81px; background-color: #8dc0f3; font-size: 10px;"><em>Scope of Work:</em></td>',
'<td style="width: 87.6131%; height: 81px; font-size: 10px;" colspan="4">#SCOPE_OF_WORK#</td>',
'</tr>',
'<tr style="height: 18px; text-align: left;">',
'<td style="width: 12.3868%; height: 41px; background-color: #8dc0f3; font-size: 10px;"><em>Remarks:</em></td>',
'<td style="width: 87.6131%; height: 41px; font-size: 10px;" colspan="4">#REMARK#</td>',
'</tr>',
'</tbody>',
'</table>',
'<p>&nbsp;</p>',
'<p>&nbsp;</p>',
'<table style="border-collapse: collapse; width: 74.1475%; height: 47px;" border="1">',
'<tbody>',
'<tr style="height: 47px;">',
'<td style="width: 28.1992%; border-style: hidden; height: 47px;">&nbsp;</td>',
'<td style="padding: 16px 24px; border-radius: 4px; min-width: 200px; width: 5.22167%; height: 47px;" align="center" bgcolor="#120E78"><a style="font-size: 16px; line-height: 14px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inl'
||'ine-block; padding: 16px 24px;" href="#APPLICATION_LINK#" target="_blank" rel="nofollow">i-Finance</a></td>',
'</tr>',
'</tbody>',
'</table>',
'<p>&nbsp;</p>'))
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
,p_comment=>'CWIP0002'
);
wwv_flow_api.component_end;
end;
/
