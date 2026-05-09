prompt --application/shared_components/email/templates/pending_standard_po_reminder
begin
--   Manifest
--     REPORT LAYOUT: PENDING STANDARD PO REMINDER
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(3867244712308036)
,p_name=>'PENDING STANDARD PO REMINDER'
,p_static_id=>'PENDING_STANDARD_PO_REMINDER'
,p_subject=>'Reminder: Pending PO #PO_NUMBER#, Amount: #AMOUNT#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Hi <strong>#REQUESTER#</strong></p>',
'<p>you have pending PO Number <strong><span style="color: #ff0000;">#PO_NUMBER#</span></strong>, with Amount <span style="color: #ff0000;"><strong>#AMOUNT#</strong></span> AED for <span style="color: #ff0000;"><strong>#SUPPLIER#</strong></span>.</p>',
'<ul>',
'<li>Once the goods are received, follow-up with Accounts Payable team (Ahmad Mohamad Abou Jamus <a href="mailto:AJamus@dctabudhabi.ae">AJamus@dctabudhabi.ae</a> )to check on the payment status.</li>',
'<li>If you have any payments that will be paid in advance before receiving the service please make sure to ask the supplier to submit Advanced bank guarantee( Contact Muneer Zakarneh <a href="mailto:muneer.zakarneh@dctabudhabi.ae">muneer.zakarneh@dct'
||'abudhabi.ae</a> ) for the official template approved by DCT.</li>',
'</ul>',
'<p>&nbsp;</p>',
'<p>Please make sure to clear all the pending and follow up with Finance <strong><u>before 5<sup>th</sup> of December 2021.</u></strong></p>',
'<p>&nbsp;</p>',
'<p>For any technical issues, or PO amendments, cancellation, kindly reach out to <a href="mailto:CSekhar@dctabudhabi.ae">@Chandra Sekhar</a> to assist you on resolving it.</p>',
'<p>&nbsp;</p>',
'<p>#NOTES#</p>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Procurment Department</h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #F5F5F5; text-align: left; color:black"> ',
'<h4>Best Regards</h4>',
'<h5><i>MIS Team</i>,</h5>',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
