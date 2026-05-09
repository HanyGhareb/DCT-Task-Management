prompt --application/shared_components/email/templates/reminder_manager_check
begin
--   Manifest
--     REPORT LAYOUT: Reminder Manager Check
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(53590919489212511)
,p_name=>'Reminder Manager Check'
,p_static_id=>'REMINDER_MANAGER_CHECK'
,p_subject=>'Reminder -  Action Required: Release Cheque #CHECK_NUM# Amount #AMOUNT#.'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <span style="color: #ff0000;"><strong>#APPROVER_TITLE# #APPROVER_EMP_NAME#,</strong></span></p>',
'<p>&nbsp;</p>',
'<p><strong><em>Kindly note that the below manager check is still not released till date, kindly note that those checks need to be released immediately to avoid cancellation of the check. </em></strong></p>',
'<p><strong><em>In case of check cancelation, the allocated budget will be forfeited and a new allocation for your 2023 department budget need to be assigned if the payment will be issued again. </em></strong></p>',
'<p><strong><em>Appreciate taking the required action, releasing/cancellation before <span style="color: #ff0000;">#DUE_DATE#</span></em></strong></p>',
'<p><strong><em>Thank you for your attention and support.</em></strong></p>',
'<table style="height: 226px; width: 100%; border-collapse: collapse;" border="1">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Vendor</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#SUPPLIER_NAME#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Deliverable</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#DESCRIPTIONS#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Business Owner</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#FULL_NAME_EN#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Check No</strong></td>',
'<td style="width: 69.7849%; height: 18px;"><span style="color: #000000;"><strong>#CHECK_NUM#&nbsp;</strong></span></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Amount</strong></td>',
'<td style="width: 69.7849%; height: 18px;"><span style="color: #000000;"><strong>#AMOUNT# #CURRENCY#</strong></span></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 30.2151%; height: 18px;"><strong>Comment</strong></td>',
'<td style="width: 69.7849%; height: 18px;">#APPROVER_COMMENT#</td>',
'</tr>',
'</tbody>',
'</table>',
'',
'<table style="border-collapse: collapse; width: 100%; height: 50px;" border="1">',
'<tbody>',
'<tr style="height: 50px;">',
'<td style="padding: 16px 24px; border-radius: 4px; min-width: 200px; width: 45.2652%; height: 50px;" align="center" bgcolor="#120E78"><a style="font-size: 16px; line-height: 14px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inl'
||'ine-block; padding: 16px 24px;" href="#APPLICATION_LINK#" target="_blank" rel="nofollow"> Access iFinance </a></td>',
'</tr>',
'</tbody>',
'</table>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Manager Cheques </h2>',
'</div>       '))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #F5F5F5; text-align: left; color:black"> ',
'<h4>Best Regards</h4>',
'<h5><i>MIS Team</i>,</h5>',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
