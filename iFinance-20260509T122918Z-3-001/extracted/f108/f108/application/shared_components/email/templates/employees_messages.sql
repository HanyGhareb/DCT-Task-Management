prompt --application/shared_components/email/templates/employees_messages
begin
--   Manifest
--     REPORT LAYOUT: Employees Messages
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
 p_id=>wwv_flow_api.id(56749325436710928)
,p_name=>'Employees Messages'
,p_static_id=>'EMPLOYEES_MESSAGES'
,p_subject=>unistr('Important: Receiving only through \201CTCA Common Receiver\201D responsibility.')
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <strong>#EMP_NAME#</strong>,</p>',
'<p>&nbsp;</p>',
'<p>Please note that receiving should be done through <span style="background-color: #ffff00;"><strong>&ldquo;TCA Common Receiver&rdquo;</strong></span> responsibility.</p>',
'<p>&nbsp;</p>',
'<p>The <span style="background-color: #ffff00;">&ldquo;TCA iProcurement Receiving&rdquo;</span> responsibility cannot be used for receiving and can be used only for correction and returns.</p>',
'<p>&nbsp;</p>',
'<p>While receiving using the <span style="background-color: #ffff00;">&ldquo;TCA Common Receiver&rdquo;</span> you will be asked to provide a rating of your satisfaction and experience working with the supplier. Once you submit the rating, the receiv'
||'ing will be routed to your line manager for confirmation and approval. Finance will be able to process payment only after the approval of the receiving.</p>',
'<p>&nbsp;</p>',
'<p>Please refer to the attached user guide on how to receive using the new responsibility.</p>',
'<p>&nbsp;</p>',
'<p>For each receiving, your line manager must approve the receiving and supplier rating done by you. Please forward the attached &lsquo;User Manual for Approver&rsquo; to the respective approver/ line manager to guide them through the process.</p>',
'<p>&nbsp;</p>',
'<p>In case of any issues or support, please get in touch with <a href="mailto:CSekhar@dctabudhabi.ae">Chandra Sekhar</a>, <a href="mailto:SMohamed@dctabudhabi.ae">Sherin Mohamed</a> and <a href="mailto:manzoor.channanath@dctabudhabi.ae">Manzoor Moidu'
||'tty Channanath</a>.</p>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Supply Management Department</h2>',
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
