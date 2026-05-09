prompt --application/shared_components/email/templates/hotels_pl
begin
--   Manifest
--     REPORT LAYOUT: Hotels PL
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
 p_id=>wwv_flow_api.id(169461291133455223)
,p_name=>'Hotels PL'
,p_static_id=>'HOTELS_PL'
,p_subject=>'Request-Yearly P&L Statement Analysis 2022'
,p_html_body=>'#EMAIL_TEMPLATE!RAW#'
,p_html_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #FF7F50; padding: 8px; text-align: center; color:#000005"> ',
'    <h1><i>i-finance </i></h1>',
'    <h2>Accounts Receivable </h2>',
'</div>'))
,p_html_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="background-color: #f5f5f5; text-align: left; color: black;">',
'<h4>Best Regards</h4>',
'<h5><em>MIS Team</em>,</h5>',
'ARTD0006',
'</div>'))
);
wwv_flow_api.component_end;
end;
/
