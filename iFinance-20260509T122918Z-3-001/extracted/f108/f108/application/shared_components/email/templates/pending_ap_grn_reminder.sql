prompt --application/shared_components/email/templates/pending_ap_grn_reminder
begin
--   Manifest
--     REPORT LAYOUT: PENDING AP GRN REMINDER
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
 p_id=>wwv_flow_api.id(2246622530652101)
,p_name=>'PENDING AP GRN REMINDER'
,p_static_id=>'PENDING_AP_GRN_REMINDER'
,p_subject=>'Reminder: Pending invoicing for PO Number #PO_NUMBER#'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Good Day,</p>',
'<p>&nbsp;</p>',
'<p>Kindly find the attached guide how to submit your invoice.</p>',
'<p>&nbsp;</p>',
'<p>Please submit it via the below link:</p>',
'<p>&nbsp;</p>',
'<p><a href="https://are01.safelinks.protection.outlook.com/?url=https%3A%2F%2Faderp.abudhabi.ae%2F&amp;data=04%7C01%7C%7Cf07eba1f092a4e27bdaf08d9b3d376b1%7C00d592b68b9449ea9d73d02f56b4e4c9%7C0%7C0%7C637738543201779591%7CUnknown%7CTWFpbGZsb3d8eyJWIjoi'
||'MC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=k%2BtAD%2BCpldUBF96lDERZLXFaliRh7dPC9Uv%2FQGaTJ9Q%3D&amp;reserved=0">https://aderp.abudhabi.ae</a></p>',
'<p>&nbsp;</p>',
'<p>If you don&rsquo;t have access to the above link please contact the below emails to obtain the access:</p>',
'<p><a href="mailto:helpdesk@dof.abudhabi.ae">helpdesk@dof.abudhabi.ae</a></p>',
'<p><a href="mailto:SRS@dgs.gov.ae">SRS@dgs.gov.ae</a></p>',
'<p>&nbsp;</p>',
'<p>Please make sure to submit your invoices before 15<sup>th</sup> of December 2021.</p>',
'<p>If you have any questions please contact (<a href="mailto:ajamus@dctabudhabi.ae">ajamus@dctabudhabi.ae</a>)</p>'))
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
