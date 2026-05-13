prompt --application/pages/page_00061
begin
--   Manifest
--     PAGE: 00061
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>61
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash Not Available'
,p_alias=>'PETTY-CASH-NOT-AVAILABLE'
,p_page_mode=>'MODAL'
,p_step_title=>'Petty Cash Not Available'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20211220074751'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(16283603335544344)
,p_plug_name=>'Petty cash not available'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<html>',
'<body>',
'',
'<p style="color:red;"><b>Creation of new Petty cash, Clearing or Reimbursements are not available current now, you will be able to create new requests starting from new year once new budget is available.</b></p>',
'<p>Happy new year.</p>',
'',
'<h4>For any help, please contact:</h4>',
'<dl>',
'  <dd>- <b><a href="mailto:HSleiman@dctabudhabi.ae"> Mrs. Hiba Hassan (Finance Department)</a></b></dd>',
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
