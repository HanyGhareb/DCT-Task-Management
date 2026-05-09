prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(11217697745956116)
,p_name=>'Service Requests'
,p_alias=>'SERVICE-REQUESTS'
,p_step_title=>'Service Requests'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210215051558'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(43652735551823624)
,p_plug_name=>'Service Requests for Contract# &P10_CONTRACT_NUMBER.'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p style="color:rgb(255,0,0);">This Feature coming Soon,....so you can raise any service request related to is contract ....Stay tune  </p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(43755511518365194)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11142414762956053)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(11079053308956006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(11196517955956091)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(22491822093048389)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(43755511518365194)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_CONTRACT_NUMBER:&P10_CONTRACT_NUMBER.'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(22492505701048396)
,p_name=>'P10_CONTRACT_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(43652735551823624)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
