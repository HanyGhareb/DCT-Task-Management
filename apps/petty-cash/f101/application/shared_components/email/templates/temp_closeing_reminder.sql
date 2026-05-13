prompt --application/shared_components/email/templates/temp_closeing_reminder
begin
--   Manifest
--     REPORT LAYOUT: PETTY CASH CLOSEING REMINDER
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_email_template(
 p_id=>wwv_flow_api.id(145528344635981710)
,p_name=>'PETTY CASH CLOSEING REMINDER'
,p_static_id=>'TEMP_CLOSEING_REMINDER'
,p_subject=>'Action Required -'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dear <em>#EMP_NAME#</em></p>',
'<p>Greeting from Finance Team.</p>',
'<p>We need to remind you that the deadline for your <span style="color: #ff0000;"><strong>#TYPE#</strong></span> petty cash <strong><span style="color: #ff0000;">#TYPE_DESC#</span></strong> request in i-Finance system is approaching on <span style="c'
||'olor: #ff0000;"><strong>10<sup>th</sup> of Dec</strong></span>.</p>',
'<p>Please submit it before the deadline. If you need any assistance or have any questions, please don''t hesitate to contact us on <a href="mailto:APInquiry@dctabudhabi.ae" target="_blank">AP Inquiry</a>. or <a href="mailto:IMaharmeh@dctabudhabi.ae" t'
||'arget="_blank">Mrs. Israa Imad</a>.</p>',
'<p>Thanks</p>'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color: white;">',
'<h1><em>i-finance </em></h1>',
'<h2>Petty Cash Management</h2>',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
