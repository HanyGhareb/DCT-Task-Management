prompt --application/shared_components/email/templates/payment_recommendation_final_reject_email
begin
--   Manifest
--     REPORT LAYOUT: Payment Recommendation Final Reject Email
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(39205680205066467)
,p_name=>'Payment Recommendation Final Reject Email'
,p_static_id=>'PAYMENT_RECOMMENDATION_FINAL_REJECT_EMAIL'
,p_subject=>'FYI- Payment Recommendation #PAYMENT_NUMBER# for #CONTRACTING_PARTY# has been Rejected'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Dear #APPROVER_TITLE# #APPROVER_NAME#,',
'<br>',
'<br>',
'below payment recommendation application has been <span style="color: red;"><i><b>Rejected.</b></i></span>',
'<br>',
'Comment: #COMMENT#',
'<br>',
'<br>',
'<table style="height: 356px; width: 120%; border-collapse: collapse;" border="0">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 99.9999%; height: 18px; background-color: #8dc0f3;" colspan="5"><strong><em>Action Required - Payment </em></strong></td>',
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
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Project:</em></td>',
'<td style="width: 28.251%; height: 18px; font-size:10px;">#PROJECT#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Payment No:</em></td>',
'<td style="width: 40.9877%; height: 18px;font-size:10px;">#PAYMENT_NUMBER#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Contract Description:</em></td>',
'<td style="width: 28.251%; height: 18px;font-size:10px;">#CONTRACT_DESCRIPTION#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Contract Ref:</em></td>',
'<td style="width: 40.9877%; height: 18px;font-size:10px;">#CONTRACT_REFERENCE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Contracting Party:</em></td>',
'<td style="width: 28.251%; height: 18px;font-size:10px;">#CONTRACTING_PARTY#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Purchase Order:</em></td>',
'<td style="width: 40.9877%; height: 18px;font-size:10px;">#PURCHASE_ORDER#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Initial Contract Amount:</em></td>',
'<td style="width: 28.251%; height: 18px;font-size:10px;">#INITIAL_CONTRACT_AMOUNT#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Agreement Duration:</em></td>',
'<td style="width: 40.9877%; height: 18px;font-size:10px;">#AGREEMENT_DURATION#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Approved Variations:</em></td>',
'<td style="width: 28.251%; height: 18px;font-size:10px;">#APPROVED_VARIATIONS#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Completion Date:</em></td>',
'<td style="width: 40.9877%; height: 18px;font-size:10px;">#COMPLETION_DATE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Revised Contract Amount:</em></td>',
'<td style="width: 28.251%; height: 18px;font-size:10px;">#REVISED_CONTRACT_AMOUNT#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Cumulative Certified to Date:</em></td>',
'<td style="width: 40.9877%; height: 18px;font-size:10px;">#CUMULATIVE_CERTIFIED_TO_DATE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Payment Type:</em></td>',
'<td style="width: 28.251%; height: 18px;font-size:10px;">#PAYMENT_TYPE#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Previously Certified:</em></td>',
'<td style="width: 40.9877%; height: 18px;font-size:10px;">#PREVIOUSLY_CERTIFIED#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Payment Period:</em></td>',
'<td style="width: 28.251%; height: 18px;font-size:10px;">#PAYMENT_METHOD#</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px; background-color: #8dc0f3;font-size:10px;"><em>Net Payable Amount (excluding VAT):</em></td>',
'<td style="width: 40.9877%; height: 18px;font-size:10px;">#NET_PAYABLE_AMOUNT_EXCLUDING_VAT#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px;">&nbsp;</td>',
'<td style="width: 28.251%; height: 18px;">&nbsp;</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px;">&nbsp;</td>',
'<td style="width: 40.9877%; height: 18px;">&nbsp;</td>',
'</tr>',
'<tr style="height: 81px;">',
'<td style="width: 12.3868%; height: 81px; background-color: #8dc0f3;font-size:10px;"><em>Scope of Work:</em></td>',
'<td style="width: 87.6131%; height: 81px;font-size:10px;" colspan="4">#SCOPE_OF_WORK#</td>',
'</tr>',
'<tr style="height: 18px; text-align: left;">',
'<td style="width: 12.3868%; height: 41px; background-color: #8dc0f3;font-size:10px;"><em>Remarks:</em></td>',
'<td style="width: 87.6131%; height: 41px;font-size:10px;" colspan="4">#REMARK#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 12.3868%; height: 18px;">&nbsp;</td>',
'<td style="width: 28.251%; height: 18px;">&nbsp;</td>',
'<td style="width: 0.823043%; height: 18px;">&nbsp;</td>',
'<td style="width: 17.5514%; height: 18px;">&nbsp;</td>',
'<td style="width: 40.9877%; height: 18px;">&nbsp;</td>',
'</tr>',
'</tbody>',
'</table>',
'',
'<br>',
'<br>',
'<table border="0" align="center">                      ',
'	<tbody><tr>',
'				<td style="padding:16px 24px;border-radius:4px;min-width:200px;" bgcolor="#120E78" align="center">',
'                          <a rel="nofollow" target="_blank" href="#APPLICATION_LINK#" style="font-size:16px;line-height:16px;font-weight:700;color:#FCFBFA;text-decoration:none;display:inline-block;padding:16px 24px;"> Access iFinance </a>            '
||'            ',
'				</td>                      ',
'			</tr>                    ',
'	</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #120E78; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>CWIP Payments</h2>',
'</div>   '))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #F5F5F5; text-align: left; color:black"> ',
'<h4>Best Regards</h4>',
'<h5><i>MIS Team</i>,</h5>',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
