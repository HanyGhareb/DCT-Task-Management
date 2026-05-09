prompt --application/shared_components/email/templates/pending_standard_pr_reminder
begin
--   Manifest
--     REPORT LAYOUT: PENDING STANDARD PR REMINDER
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
 p_id=>wwv_flow_api.id(4771586934708068)
,p_name=>'PENDING STANDARD PR REMINDER'
,p_static_id=>'PENDING_STANDARD_PR_REMINDER'
,p_subject=>'Reminder: Pending PR #PR_NUMBER#, Amount: #AMOUNT#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Hi <strong>#REQUESTER#</strong></p>',
'<p>you have pending PR Number <strong><span style="color: #ff0000;">#PR_NUMBER#</span></strong>, with Amount <span style="color: #ff0000;"><strong>#AMOUNT#</strong></span> AED for <span style="color: #ff0000;"><strong>#DESC#</strong></span>.</p>',
'<p><span style="color: #000000;">you kindly requested to </span>Follow the steps as per the attached Document. To release the funds.</p>',
'',
'<p>For any technical issues, or PR PO amendments, cancellation, kindly reach out to <a href="mailto:CSekhar@dctabudhabi.ae">@Chandra Sekhar</a> <a href="mailto:fbp@dctabudhabi.ae">Finance Business Partners</a> to assist you on resolving it.</p>',
'<p>&nbsp;</p>',
'<p>#NOTES#</p>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Finance Department</h2>',
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
