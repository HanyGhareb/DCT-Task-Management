prompt --application/shared_components/email/templates/friendly_reminder_ar_due_1
begin
--   Manifest
--     REPORT LAYOUT: Friendly Reminder AR DUE 1
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
 p_id=>wwv_flow_api.id(123784646143471414)
,p_name=>'Friendly Reminder AR DUE 1'
,p_static_id=>'FRIENDLY_REMINDER_AR_DUE_1'
,p_subject=>'Action Required- Invoices Due'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <strong>#CUSTOMER_NAME#</strong>,</p>',
'<p>Greeting from Department of Culture and Tourism- Abu Dhabi.</p>',
'<p>&nbsp;</p>',
'<p>Kindly find the attached <strong>#INV_COUNT#</strong> invoices, amounted to&nbsp; <strong>#AMOUNT#</strong> <strong>AED ******</strong>.<br />Hope to pay the amount of this invoice as soon as possible to our bank account , and provide us with a sc'
||'an copy of the payment slip / remittance advice:</p>',
'<p>#RESULT!RAW#</p>',
'<p>If you have any questions concerning the balance due on your account, Please contact:</p>',
'<p><a href="mailto:dctcollection@dctabudhabi.ae">dctcollection@dctabudhabi.ae</a></p>',
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
'ARTD0001',
'</div>'))
,p_comment=>'ARTD0001'
);
wwv_flow_api.component_end;
end;
/
