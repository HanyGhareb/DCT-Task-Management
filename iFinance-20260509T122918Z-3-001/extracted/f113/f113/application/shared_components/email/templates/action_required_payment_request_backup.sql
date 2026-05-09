prompt --application/shared_components/email/templates/action_required_payment_request_backup
begin
--   Manifest
--     REPORT LAYOUT: Action Required Payment Request Backup
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(2887301402991438)
,p_name=>'Action Required Payment Request Backup'
,p_static_id=>'ACTION_REQUIRED_PAYMENT_REQUEST_BACKUP'
,p_subject=>'#SUBJECT#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p style="display: none;"><code>iFinanceCode</code></p>',
'<p>Dear <span style="color: #008000;"><strong>#APPROVER_TITLE# <em>#APPROVER_NAME#,</em></strong></span></p>',
'<p>your kind attention is required to process below payment request from<span style="color: #008000;"><strong>&nbsp;#REQUESTOR#:</strong></span></p>',
'<table style="height: 198px; width: 100%; border-collapse: collapse; border-style: none;">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Payment Request No</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #PAYMENT_REQUEST_NO#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Vendor Name</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #VENDOR#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Invoice Amount</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #AMOUNT# #CURRENCY#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Invoice No</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #INVOICE_NUMBER#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Invoice Date</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #INVOICE_DATE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Description</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #DESCRIPTION#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Bank Guarantee</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #BANK_GUARANTEE#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Priority</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #PRIORITY#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>IBAN</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #IBAN#</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 31.7784%; height: 18px;"><strong>Bank</strong></td>',
'<td style="width: 68.2216%; height: 18px;">: #BANK_NAME#</td>',
'</tr>',
'</tbody>',
'</table>',
'<p>&nbsp;</p>',
'<p><span style="color: #000000;">Please click on one of the following choices to automatically generate an E-mail response. Don''t change anything with the generated E-mail. optionally, you can add you comment.&nbsp;</span></p>',
'<table style="width: 100.45%; border-collapse: collapse; border-style: none; height: 25px;">',
'<tbody>',
'<tr style="height: 25px;">',
'<td style="width: 14.3856%; height: 25px;">#APPROVE_LINK!RAW#</td>',
'<td style="width: 18.4481%; text-align: center; height: 25px;">#REJECT_LINK!RAW#</td>',
'<td style="width: 21.3643%; text-align: center; height: 25px;">#HOLD_LINK!RAW#</td>',
'<td style="width: 19.9306%; text-align: center; height: 25px;">#DELEGATE_LINK!RAW#</td>',
'<td style="width: 17.8348%; text-align: center; height: 25px;">#RETURN_LINK!RAW#</td>',
'</tr>',
'</tbody>',
'</table>',
'<p>&nbsp;</p>',
'<p>&nbsp;</p>',
'<table style="width: 38.4065%; border-collapse: collapse; border-style: none; height: 25px;">',
'<tbody>',
'<tr style="height: 25px;">',
'<td style="width: 0.956938%; height: 25px; border-style: none;">#APPROVE_LINK!RAW#</td>',
'<td style="width: 0.956938%; border-style: none; text-align: center;">&nbsp;</td>',
'<td style="width: 0.956938%; height: 25px; border-style: none; text-align: center;">#REJECT_LINK!RAW#</td>',
'</tr>',
'</tbody>',
'</table>',
'<p><br /><br /></p>',
'<table border="0" align="center">',
'<tbody>',
'<tr>',
'<td style="padding: 16px 24px; border-radius: 4px; min-width: 200px;" align="center" bgcolor="#0e6654"><a style="font-size: 16px; line-height: 16px; font-weight: bold; color: #fcfbfa; text-decoration: none; display: inline-block; padding: 16px 24px;"'
||' href="#APPLICATION_LINK#" target="_blank" rel="nofollow"> Access i-Finance </a></td>',
'</tr>',
'</tbody>',
'</table>'))
);
wwv_flow_api.component_end;
end;
/
