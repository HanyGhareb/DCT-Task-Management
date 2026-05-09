prompt --application/shared_components/user_interface/lovs/mpr_delegations_lov_by_cost_center
begin
--   Manifest
--     MPR DELEGATIONS LOV BY COST CENTER
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(26097129265947753)
,p_lov_name=>'MPR DELEGATIONS LOV BY COST CENTER'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select m.id , m.request_number || ''-'' || e.full_name_en || '' ('' ',
'        || trim(to_char(m.requested_amount , ''99,999,999,999.99''))',
'        || '' '' || m.currency || '')''  MPR_NUMBER ',
'    , (select h.person_id',
'        from mpr_approval_history h',
'        where h.mpr_id =  m.id',
'        and h.status = ''Pending''',
'        and rownum = 1)requestor_id',
'from mpr m, employees_v e',
'where m.requestor_person_id = e.person_id',
'and m.cost_center in (select cost_center',
'from cost_centers_fbp',
'where person_id = :PERSON_ID',
'and status = ''A'')    '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ID'
,p_display_column_name=>'MPR_NUMBER'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'MPR_NUMBER'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26097765567945255)
,p_query_column_name=>'ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26098173039945255)
,p_query_column_name=>'MPR_NUMBER'
,p_heading=>'Mpr Number'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(26098578343945255)
,p_query_column_name=>'REQUESTOR_ID'
,p_heading=>'Requestor Id'
,p_display_sequence=>30
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.component_end;
end;
/
