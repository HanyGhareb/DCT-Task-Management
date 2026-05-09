prompt --application/pages/page_00015
begin
--   Manifest
--     PAGE: 00015
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>15
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'MPR Unavailable'
,p_alias=>'MPR-UNAVAILABLE'
,p_page_mode=>'MODAL'
,p_step_title=>'new Manual PR not available now'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240129090442'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24200322036422359)
,p_plug_name=>'new Manual PR not available now'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<html>',
'<body>',
'',
'<p style="color: red;"><strong>Creation of new Manual PRs are on-hold as budgets are being uploaded on Oracle, you will be able to create PRs on Oracle soon.</strong></p>',
'<h4>For any help, please contact:</h4>',
'<dl>',
'<dd>- <strong><a href="mailto:CSekhar@dctabudhabi.ae">Chandra Sekhar</a></strong></dd>',
'<dd>- <strong><a href="mailto:SMohamed@dctabudhabi.ae">Sherin Mohamed</a></strong></dd>',
'</dl>',
'',
'</body>',
'</html>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.component_end;
end;
/
