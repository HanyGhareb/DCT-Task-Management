prompt --application/pages/page_00037
begin
--   Manifest
--     PAGE: 00037
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>37
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Add My Signature'
,p_alias=>'ADD-MY-SIGNATURE'
,p_step_title=>'Add My Signature'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210522175813'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(32801476036539605)
,p_plug_name=>'Add my signature'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'PLUGIN_DE.DANIELH.APEXSIGNATURE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'500'
,p_attribute_02=>'350'
,p_attribute_03=>'2.5'
,p_attribute_04=>'2.5'
,p_attribute_05=>'rgba(0,0,0,0)'
,p_attribute_06=>'blue'
,p_attribute_07=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  --',
'  l_collection_name VARCHAR2(100);',
'  l_clob            CLOB;',
'  l_blob            BLOB;',
'  l_filename        VARCHAR2(100);',
'  l_mime_type       VARCHAR2(100);',
'  l_token           VARCHAR2(32000);',
'  --',
'BEGIN',
'  -- get defaults',
'  l_filename  := :EMP_NAME || ''-'' ||',
'                 to_char(SYSDATE,',
'                         ''YYYYMMDDHH24MISS'') || ''.png'';',
'  l_mime_type := ''image/png'';',
'  -- build CLOB from f01 30k Array',
'  dbms_lob.createtemporary(l_clob,',
'                           FALSE,',
'                           dbms_lob.session);',
'',
'  FOR i IN 1 .. apex_application.g_f01.count LOOP',
'    l_token := wwv_flow.g_f01(i);',
'  ',
'    IF length(l_token) > 0 THEN',
'      dbms_lob.writeappend(l_clob,',
'                           length(l_token),',
'                           l_token);',
'    END IF;',
'  END LOOP;',
'  --',
'  -- convert base64 CLOB to BLOB (mimetype: image/png)',
'  l_blob := apex_web_service.clobbase642blob(p_clob => l_clob);',
'  --',
'  -- create own collection (here starts custom part (for example a Insert statement))',
'  -- collection name',
'  l_collection_name := ''APEX_SIGNATURE'';',
'  -- check if exist',
'  IF NOT',
'      apex_collection.collection_exists(p_collection_name => l_collection_name) THEN',
'    apex_collection.create_collection(l_collection_name);',
'  END IF;',
'  -- add collection member (only if BLOB not null)',
'  IF dbms_lob.getlength(lob_loc => l_blob) IS NOT NULL THEN',
'    apex_collection.add_member(p_collection_name => l_collection_name,',
'                               p_c001            => l_filename, -- filename',
'                               p_c002            => l_mime_type, -- mime_type',
'                               p_d001            => SYSDATE, -- date created',
'                               p_blob001         => l_blob); -- BLOB img content',
'                               ',
'',
'                               ',
'  END IF;',
'  --',
'  update dct_employees_signatures',
'    set status = ''N''',
'    where person_id = :PERSON_ID;',
'',
'    -- Insert in EMPLOYEES_SIGNATURES',
'    INSERT INTO dct_employees_signatures (',
'                                        person_id,',
'                                        signature_blob,',
'                                        signature_clob,',
'                                        signature_filename,',
'                                        signature_mimetype,',
'                                        status',
'                                    ) VALUES (',
'                                        :PERSON_ID,',
'                                        l_blob,',
'                                        l_clob,',
'                                        l_filename,',
'                                        l_mime_type,',
'                                        ''Y''',
'                                    );',
'  ',
'END;'))
,p_attribute_08=>'false'
,p_attribute_09=>'#clear'
,p_attribute_10=>'#save'
,p_attribute_11=>'Signature must have a value'
,p_attribute_12=>'false'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(32801633987539607)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(32801476036539605)
,p_button_name=>'save'
,p_button_static_id=>'save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(32801744792539608)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(32801476036539605)
,p_button_name=>'clear'
,p_button_static_id=>'clear'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Clear'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-rotate-left'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(32801926255539610)
,p_branch_name=>'Go To 36'
,p_branch_action=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.component_end;
end;
/
