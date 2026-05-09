prompt --application/pages/page_00038
begin
--   Manifest
--     PAGE: 00038
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
 p_id=>38
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'MPR Approve / Reject Action'
,p_alias=>'MPR-APPROVE-REJECT-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'MPR Approve / Reject Action'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230131034836'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92938141607788216)
,p_plug_name=>'MPR Approve / Reject Action'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92569326021569749)
,p_name=>'P38_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(92938141607788216)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92569389138569750)
,p_name=>'P38_MPR_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(92938141607788216)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92569564491569751)
,p_name=>'P38_STEP_NO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(92938141607788216)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
