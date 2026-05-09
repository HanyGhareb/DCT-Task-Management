prompt --application/pages/page_00062
begin
--   Manifest
--     PAGE: 00062
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>62
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Duty Travel Cancel '
,p_alias=>'DUTY-TRAVEL-CANCEL'
,p_page_mode=>'MODAL'
,p_step_title=>'Duty Travel Cancel '
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function delete_rec(p_val, p_row) {',
'    var rec = $(p_val).closest(''tr'');',
'    apex.server.process(',
'        ''Delete From Line'', // Process or AJAX Callback name',
'    {',
'        x01: p_row',
'    }, // Parameter "x01"',
'    {',
'        beforeSend: function () {',
'            alert(''Are you sure want to delete this line'' + p_row);',
'            rec.removeClass(''vikas'');',
'            rec.removeClass(''pandey'');',
'            rec.children().hover(function () {',
'                rec.children().animate({',
'                    ''backgroundColor'': ''#71e817''',
'                }, 300);',
'            },',
'                function () {',
'                rec.children().animate({',
'                    ''backgroundColor'': ''#71e817''',
'                }, 300);',
'            });',
'            rec.children().animate({',
'                ''backgroundColor'': ''#71e817''',
'            }, 300);',
'        },',
'',
'        success: function (pData) {',
'',
'            // Success Javascript',
'            rec.children().wrapInner(''<div>'').children().fadeOut(500,',
'                function () {',
'                rec.remove(); // visually remove the row from the report',
'            });',
'        },',
'        dataType: "text" // Response type (here: plain text)',
'',
'    });',
'	',
'	//apex.submit( ''DELETE'' );',
'    apex.submit(''remove_line'');',
'}'))
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231115141158'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(314944069996829990)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12872392429762094)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(314953363949704536)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(93936113326346615)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(314944069996829990)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(93936520527346616)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(314944069996829990)
,p_button_name=>'Cancel'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Yes, Cancel Request'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P62_ACTION'
,p_button_condition2=>'Cancel'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-stop-circle-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(93960364364346666)
,p_branch_name=>'Go to 3'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(93938379495346617)
,p_name=>'P62_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(314953363949704536)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(93938797325346618)
,p_name=>'P62_ACTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(314953363949704536)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(93940001070346619)
,p_name=>'P62_ROLE_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(314953363949704536)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(93940727366346620)
,p_name=>'P62_COMMENT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(314953363949704536)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(93957020279346664)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(93936113326346615)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(93957478729346664)
,p_event_id=>wwv_flow_api.id(93957020279346664)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(93957921348346665)
,p_name=>'show allocation DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P62_ALLOCATE_BY'
,p_condition_element=>'P62_ALLOCATE_BY'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'P'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(93956592029346664)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'cancel Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P62_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Cancel this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'MISSION_WORKFLOW.CANCEL(:P62_REQUEST_ID, :PERSON_ID, :P62_COMMENT, ''S'');',
'',
'End if;',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Cancelled Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(93954588296346663)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete From Line'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DELETE FROM mission_distributions',
'  WHERE ID =  apex_application.g_x01;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
