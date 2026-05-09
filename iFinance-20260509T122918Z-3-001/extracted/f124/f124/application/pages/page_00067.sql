prompt --application/pages/page_00067
begin
--   Manifest
--     PAGE: 00067
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>67
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Appendix D - Pricing Schedule Guideline'
,p_alias=>'APPENDIX-D-PRICING-SCHEDULE-GUIDELINE'
,p_page_mode=>'MODAL'
,p_step_title=>'Appendix D - Pricing Schedule Guideline'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230206165704'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2642364164162886)
,p_plug_name=>'General Guidance'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><span style="text-decoration: underline; color: #0000ff;"><strong>General Guidance</strong></span></p>',
'<p>&bull; This is the template that is created to obtain the pricing from the supplier. It should reflect the nature of the services and account for all of the deliverables you are requesting from the suppliers.</p>',
'<p>&bull; For consulting services you may also want the &ldquo;rates&rdquo; that the supplier is charging per hour/day for various personnel.</p>',
'<p>&bull; For complex services you may want to get a breakdown of the their income and expenditure for the contract and profit margins. You may also want to get a commentary against their pricing model as an explanation.</p>',
'<p>&bull; Where services are likely to change consider requesting information on how they will calculate the cost of any changes so this is transparent in the contract.</p>',
'<p>&bull; Try and get all potential costs submitted as part of the Bidders cost submission as negotiating them later as a contract change will be harder as you will have less leverage.</p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3011727100758539)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(127777381735449810)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3016925813773672)
,p_plug_name=>'Pricing Schedule Prompt Questions'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong><u>Pricing Schedule Prompt Questions</u></strong></p>',
'<ul>',
'<li><span style="color: #ff0000;">Your pricing schedule should reflect the services you require, how you want to incentivize performance by the supplier and how you wish to pay them.</span></li>',
'<li><span style="color: #ff0000;">What cost model do you want to use?</span></li>',
'<ul>',
'<li><span style="color: #ff0000;">Fixed Cost</span></li>',
'<li><span style="color: #ff0000;">Milestone payments</span></li>',
'<li><span style="color: #ff0000;">Payment by Results</span></li>',
'<li><span style="color: #ff0000;">Monthly Retainer</span></li>',
'<li><span style="color: #ff0000;">Schedule of Rates</span></li>',
'<li><span style="color: #ff0000;">Bill of Quantities</span></li>',
'<li><span style="color: #ff0000;">Other, please specify</span></li>',
'</ul>',
'<li><span style="color: #ff0000;">Will you have a maximum ceiling price that suppliers will be told (this price is likely to be where they cost their bid, so only use in conditions where you believe bids will exceed your budget)</span></li>',
'<li><span style="color: #ff0000;">Do you want to include any incentive mechanisms in the contract?</span></li>',
'<ul>',
'<li><span style="color: #ff0000;">Income % gain share model (e.g. success fee)</span></li>',
'<li><span style="color: #ff0000;">Savings % gain share model</span></li>',
'<li><span style="color: #ff0000;">Payment by Results (e.g. payment based on achieving certain outcomes)&nbsp;</span></li>',
'<li><span style="color: #ff0000;">Risk payment (e.g. % of retainer fee at risk and if any prescribed outcome is not delivered the % fee will be forfeited).</span></li>',
'<li><span style="color: #ff0000;">Other &ndash; please specify</span></li>',
'</ul>',
'<li><span style="color: #ff0000;">Do you need to request discounting on the pricing model</span></li>',
'<ul>',
'<li><span style="color: #ff0000;">Spend volume rebates</span></li>',
'<li><span style="color: #ff0000;">Duration discount rebates</span></li>',
'<li><span style="color: #ff0000;">Slab rates (e.g. discounts on block price depending on increasing quantity volumes)</span></li>',
'</ul>',
'<li><span style="color: #ff0000;">Will your contract include any annual inflation clauses? If so what index will you use &ndash; please specify</span></li>',
'</ul>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3011600837758538)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(3011727100758539)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3011773302758540)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3011600837758538)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3011925834758541)
,p_event_id=>wwv_flow_api.id(3011773302758540)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
