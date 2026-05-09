prompt --application/shared_components/email/templates/resubmit_mpr
begin
--   Manifest
--     REPORT LAYOUT: Resubmit MPR
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
 p_id=>wwv_flow_api.id(22345794192498142)
,p_name=>'Resubmit MPR'
,p_static_id=>'RESUBMIT_MPR'
,p_subject=>'Your Manual PR #REQUEST_NUMBER# Needs to Re-Submitted on Oracle ADERP'
,p_html_body=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Hi <b><span style="color: #0e6654;"><i>#REQUESTED_PERSON_NAME#,</i></span></b>',
'<br>',
'<br>',
'Since the budget are now available on Oracle, please resubmit your Manual PR# <span style="color: #0e6654;"><i><b>#REQUEST_NUMBER#</b></i></span> on Oracle as per normal process.'))
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #0e6654; padding: 8px; text-align: center; color:white"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Manual PR Management </h2>',
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
