prompt --application/shared_components/email/templates/hotel_outstanding
begin
--   Manifest
--     REPORT LAYOUT: Hotel Outstanding
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(156931411181357662)
,p_name=>'Hotel Outstanding'
,p_static_id=>'HOTEL_OUTSTANDING'
,p_subject=>'DCT Outstanding Invoices - Collection Notification'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Date: #DATE#</p>',
'<p><strong>Customer: #CUSTOMER_NAME#</strong></p>',
'<p>Dear Sir/Madam,</p>',
'<p>Greetings from Department of Culture and Tourism- Abu Dhabi.</p>',
'<p>We are writing to remind you of the outstanding amount <strong>#AMOUNT#</strong> <strong>AED</strong> as per below, which are past due according to our records. We kindly request that you take the necessary steps to settle these invoices at your e'
||'arliest convenience.</p>',
'<table style="height: 77px; width: 100%; border-collapse: collapse;" border="1">',
'<tbody>',
'<tr style="height: 29px;">',
'<td style="width: 55.0736%; height: 29px;"><strong>Delay Penalty</strong></td>',
'<td style="width: 79.2164%; height: 29px;">#DELAY# <strong>AED</strong></td>',
'</tr>',
'<tr style="height: 24px;">',
'<td style="width: 55.0736%; height: 24px;"><strong>Tourism Fees</strong></td>',
'<td style="width: 79.2164%; height: 24px;">#TF# <strong>AED</strong></td>',
'</tr>',
'<tr style="height: 24px;">',
'<td style="width: 55.0736%; height: 24px;"><strong>Total</strong></td>',
'<td style="width: 79.2164%; height: 24px;">#TOTAL# <strong>AED</strong></td>',
'</tr>',
'</tbody>',
'</table>',
'<p><span style="color: #ff0000;"><code><em>#COMMENTS#</em></code></span></p>',
'<p>If you have any unresolved problems concerning your account or require any further details, please do not hesitate to contact us immediately at <a href="mailto:Receivables@dctabudhabi.ae">Receivables@dctabudhabi.ae</a></p>',
'<p>If payment has not already been sent, please send it immediately to our bank account electronically, referencing the invoice details as instructed below:</p>',
'<p>Bank Account No: <strong>10179268020005</strong></p>',
'<p>IBAN: <strong>AE110030010179268020005</strong></p>',
'<p>SWIFT: <strong>ADCBAEAA</strong></p>',
'<p>Bank Name: <strong>Abu Dhabi Commercial Bank</strong></p>',
'<p>If payment has already been sent, please share the details immediately by email and disregard this reminder.</p>',
'<p>We thank you in advance for giving this matter your urgent attention.</p>',
'<p>&nbsp;</p>',
'<p>Yours sincerely,</p>',
'<p>Accounts Receivable Department</p>',
'<p>DCT Finance</p>',
'<p>&nbsp;</p>',
'<p>Note: This is a computer-generated document. No signature is required.</p>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #FF7F50; padding: 8px; text-align: center; color:#000005"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Accounts Receivable </h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #f5f5f5; text-align: left; color: black;">',
'<h4>Best Regards</h4>',
'<h5><em>MIS Team</em>,</h5>',
'ARTD0004',
'</div>'))
,p_comment=>'ARTD0004'
);
wwv_flow_api.component_end;
end;
/
