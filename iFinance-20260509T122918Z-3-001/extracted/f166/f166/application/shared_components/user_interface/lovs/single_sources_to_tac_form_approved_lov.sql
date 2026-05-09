prompt --application/shared_components/user_interface/lovs/single_sources_to_tac_form_approved_lov
begin
--   Manifest
--     SINGLE SOURCES TO TAC FORM APPROVED LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(26925090360942488)
,p_lov_name=>'SINGLE SOURCES TO TAC FORM APPROVED LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select s.id,',
'        s.requestor_person_id',
'       ,e.full_name_en name',
'       ,s.requestor_org_id',
'       ,s.request_number',
'       ,s.requested_amount',
'       ,s.project_name',
'       ,s.pr_fund_available',
'       ,s.scope_of_work',
'       ,s.currency',
'        ,s.currency  currency_name',
'       ,s.sector_id',
'       ,s.department_id',
'       ,s.cost_center',
'       ,s.approval_status',
'       ,s.project_duration',
'       ,s.duration_uom',
'from scm_singl_source s, employees_v e',
'where s.requestor_person_id = e.person_id',
'and s.approval_status = ''Approved'''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ID'
,p_display_column_name=>'REQUEST_NUMBER'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'REQUEST_NUMBER'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26929476669904287)
,p_query_column_name=>'ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26929825363904286)
,p_query_column_name=>'REQUEST_NUMBER'
,p_heading=>'Request Number'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26931071915904286)
,p_query_column_name=>'REQUESTOR_PERSON_ID'
,p_heading=>'Requestor Person Id'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26936136344805821)
,p_query_column_name=>'CURRENCY'
,p_heading=>'Currency'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26981151300376460)
,p_query_column_name=>'CURRENCY_NAME'
,p_heading=>'Currency Name'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(27102455988169962)
,p_query_column_name=>'APPROVAL_STATUS'
,p_heading=>'Approval Status'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(27971260449224929)
,p_query_column_name=>'PROJECT_DURATION'
,p_heading=>'Project Duration'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26930244260904286)
,p_query_column_name=>'REQUESTED_AMOUNT'
,p_heading=>'Requested Amount'
,p_display_sequence=>20
,p_data_type=>'NUMBER'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26931472540904286)
,p_query_column_name=>'REQUESTOR_ORG_ID'
,p_heading=>'Requestor Org Id'
,p_display_sequence=>20
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26936525259805821)
,p_query_column_name=>'SECTOR_ID'
,p_heading=>'Sector Id'
,p_display_sequence=>20
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(27971647621224929)
,p_query_column_name=>'DURATION_UOM'
,p_heading=>'Duration Uom'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26930672457904286)
,p_query_column_name=>'PROJECT_NAME'
,p_heading=>'Project Name'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26931883730904286)
,p_query_column_name=>'PR_FUND_AVAILABLE'
,p_heading=>'Pr Fund Available'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26936975951805820)
,p_query_column_name=>'DEPARTMENT_ID'
,p_heading=>'Department Id'
,p_display_sequence=>30
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26937366826805820)
,p_query_column_name=>'COST_CENTER'
,p_heading=>'Cost Center'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26948080804612591)
,p_query_column_name=>'NAME'
,p_heading=>'Name'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26932262015904285)
,p_query_column_name=>'SCOPE_OF_WORK'
,p_heading=>'Scope Of Work'
,p_display_sequence=>50
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.component_end;
end;
/
