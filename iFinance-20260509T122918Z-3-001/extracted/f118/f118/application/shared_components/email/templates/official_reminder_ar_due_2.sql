prompt --application/shared_components/email/templates/official_reminder_ar_due_2
begin
--   Manifest
--     REPORT LAYOUT: Official Reminder AR DUE 2
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
 p_id=>wwv_flow_api.id(123784954409454643)
,p_name=>'Official Reminder AR DUE 2'
,p_static_id=>'OFFICIAL_REMINDER_AR_DUE_2'
,p_subject=>'2nd Reminder Action Required- Invoices Due'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <em><strong>#CUSTOMER_NAME#</strong></em>,</p>',
'<p>Greeting from Department of Culture and Tourism- Abu Dhabi.</p>',
'<p>This is to inform you that your account has PAST DUE for invoice/s mentioned below<br />We&rsquo;d like to bring the following invoice(s) to your immediate attention:</p>',
'<table width="593">',
'<tbody>',
'<tr>',
'<td width="101">',
'<p><strong>Date</strong></p>',
'</td>',
'<td width="132">',
'<p><strong>Invoice Number</strong></p>',
'</td>',
'<td width="132">',
'<p><strong>Amount </strong></p>',
'</td>',
'<td width="228">',
'<p><strong>Description</strong></p>',
'</td>',
'</tr>',
'<tr>',
'<td width="101">',
'<p>**/**/****</p>',
'</td>',
'<td width="132">',
'<p>*********</p>',
'</td>',
'<td width="132">',
'<p>*****</p>',
'</td>',
'<td width="228">',
'<p>***************</p>',
'</td>',
'</tr>',
'<tr>',
'<td width="101">',
'<p><strong>Total </strong></p>',
'</td>',
'<td width="132">',
'<p>&nbsp;</p>',
'</td>',
'<td width="132">',
'<p>*****</p>',
'</td>',
'<td width="228">',
'<p>&nbsp;</p>',
'</td>',
'</tr>',
'</tbody>',
'</table>',
'<p>&nbsp;</p>',
'<p>Please pay the due amount as soon as possible to avoid any legal consequences.</p>',
'<p>If you have any questions concerning the balance due on your account, Please contact:</p>',
'<p><a href="mailto:dctcollection@dctabudhabi.ae">dctcollection@dctabudhabi.ae</a></p>',
'<p>We will continue to reach you to resolve this matter.</p>',
'<p>Regards,</p>',
'<p><strong>Account Receivables</strong></p>',
'<p><strong>Finance Department </strong></p>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Accounts Receivable </h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #f5f5f5; text-align: left; color: black;">',
'<h4>Best Regards</h4>',
'<h5><em>MIS Team</em>,</h5>',
'ARTD0002',
'</div>'))
,p_comment=>'ARTD0002'
);
wwv_flow_api.component_end;
end;
/
